React = require('react')
Link = require('react-router').Link
ReactFireMixin = require('reactfire')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [ReactFireMixin]
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

  render: ->
    <div>
      <table className="forms">
        <thead>
          <tr>
            <th>Form Name</th>
          </tr>
        </thead>
        <tbody>
          {for form in @state.forms
            <tr key={form['.key']}>
              <td>
                <Link to={'adminForm'} params={formId: form['.key']}>
                  { form.title }
                </Link>
              </td>
            </tr>
          }
        </tbody>
      </table>
      <form onSubmit={@create} className="new-form">
        <input placeholder={"New form name"} onChange={@setText} value={@state.text} />
        <button>Add Form</button>
      </form>
    </div>
