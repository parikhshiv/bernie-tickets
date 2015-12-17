React = require('react')
Router = require('react-router')
Link = require('react-router').Link
ReactFireMixin = require('reactfire')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [ReactFireMixin, Router.Navigation]
  displayName: 'AdminForms'

  getInitialState: ->
    {
      forms: []
      text: ''
    }

  setText: (e) ->
    @setState(text: e.target.value)

  create: (e) ->
    e.preventDefault()
    return unless @state.text && @state.text.trim().length isnt 0
    @firebaseRefs['forms'].push(title: @state.text, fields: [])
    @setState(text: '')

  componentWillMount: ->
    ref = FirebaseUtils.fb("#{FirebaseUtils.currentUser().uid}/forms")
    @bindAsArray(ref, 'forms')

  formPage: (formId) ->
    @transitionTo('adminForm', {formId: formId})

  render: ->
    <div>
      <table className={'forms'}>
        <thead>
          <tr>
            <th>Your Customized Forms</th>
          </tr>
        </thead>
        <tbody>
          {for form in @state.forms
            <tr key={form['.key']} onClick={@formPage.bind(null, form['.key'])}>
              <td>
                <span>
                  { form.title }
                </span>
              </td>
            </tr>
          }
        </tbody>
      </table>
      <form onSubmit={@create} className={'new-form'}>
        <input placeholder={"New Form Name"} onChange={@setText} value={@state.text} />
        <button>Create New Form</button>
      </form>
    </div>
