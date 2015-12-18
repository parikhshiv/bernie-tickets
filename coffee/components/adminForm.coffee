React = require('react')
Link = require('react-router').Link
ReactFireMixin = require('reactfire')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

Field = require('./adminFormField.coffee')

module.exports = React.createClass
  mixins: [ReactFireMixin]
  displayName: 'AdminForm'

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    {
      form: null
      fields: []
      responses: []
    }

  updateTitle: (e) ->
    @firebaseRefs['form'].update(title: e.target.value)

  addField: (e) ->
    e.preventDefault()
    @firebaseRefs['fields'].push(title: 'New Field', type: 'text')

  download: (e) ->
    e.preventDefault()
    columns = ['First name', 'Last name', 'Phone', 'Email', 'Zip', 'Can text?']
    columns.push field.title for field in @state.fields

    data = [columns]

    for response in @state.responses
      row = [response.first_name, response.last_name, response.phone, response.email, response.zip, response.canText]
      row.push response[field.title] for field in @state.fields
      data.push row

    csvContent = 'data:text/csv;charset=utf-8,'

    for row, index in data
      csvContent += row.join(',')
      csvContent += "\n" if index < data.length

    window.open(encodeURI(csvContent))

  componentWillMount: ->
    ref = FirebaseUtils.fb("forms/#{@props.params.slug}")
    @bindAsObject(ref, 'form')
    @bindAsArray(ref.child('fields'), 'fields')
    @bindAsArray(ref.child('responses'), 'responses')

  render: ->
    <div>
      <div className={'admin-form-section'}>
        <label>Form Name: </label>
        <input type={'text'} value={@state.form.title if @state.form} onChange={@updateTitle} />
        <br />

        <div className={'fields'}>
          {for field in @state.fields
            <Field id={field['.key']} slug={@props.params.slug} key={field['.key']} />
          }
        </div>

        <button onClick={@addField}>Add A Custom Field</button>
        <br/>
        <br/>

        {if @state.form
          <Link to={"/#{@state.form['.key']}"} className={'view'}>See How It Looks! -></Link>
        }
      </div>

      <hr />

      <div className={'admin-form-section'}>
        <span>Responses: {@state.responses.length}</span>
        <br />
        <br />
        <a onClick={@download} className={'btn forms-link'}>Download</a>
      </div>
    </div>
