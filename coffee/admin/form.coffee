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

  update: (e) ->
    @firebaseRefs['form'].update(title: e.target.value)

  addField: (e) ->
    e.preventDefault()
    @firebaseRefs['fields'].push(title: 'New Field')

  componentWillMount: ->
    ref = FirebaseUtils.fb("forms/#{@context.router.getCurrentParams().formId}")
    @bindAsObject(ref, 'form')
    @bindAsArray(ref.child('fields'), 'fields')

  render: ->
    <div className={'form-fields'}>
      <label>Form Name (click to edit): </label>
      <input type={'text'} value={@state.form.title if @state.form} onChange={@update} />

      <div className={'fields'}>
        {for field in @state.fields
          <Field id={field['.key']} key={field['.key']} />
        }
      </div>

      <button onClick={@addField}>Add A Custom Field</button>
      <br/>
      <br/>
      <a href="/#/forms/#{@context.router.getCurrentParams().formId}" className={'view'}>See How It Looks! -> </a>
    </div>
