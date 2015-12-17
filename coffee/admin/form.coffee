React = require('react')
Link = require('react-router').Link
ReactFireMixin = require('reactfire')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

Field = require('./field.coffee')

module.exports = React.createClass
  mixins: [ReactFireMixin]
  displayName: 'AdminForm'

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    {
      form: null
      fields: [],
    }

  updateTitle: (e) ->
    @firebaseRefs['form'].update(title: e.target.value)

  addField: (e) ->
    e.preventDefault()
    @firebaseRefs['fields'].push(title: 'New Field')

  componentWillMount: ->
    ref = FirebaseUtils.fb("forms/#{@context.router.getCurrentParams().slug}")
    @bindAsObject(ref, 'form')
    @bindAsArray(ref.child('fields'), 'fields')

  render: ->
    <div className={'form-fields'}>
      <label>Form Name: </label>
      <input type={'text'} value={@state.form.title if @state.form} onChange={@updateTitle} />
      <br />

      <div className={'fields'}>
        {for field in @state.fields
          <Field id={field['.key']} key={field['.key']} />
        }
      </div>

      <button onClick={@addField}>Add A Custom Field</button>
      <br/>
      <br/>

      {if @state.form
        <Link to={'form'} params={slug: @state.form['.key']} className={'view'}>See How It Looks! -></Link>
      }
    </div>
