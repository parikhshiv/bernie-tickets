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
      url: ''
    }

  setText: (e) ->
    @setState(text: e.target.value)

  setURL: (e) ->
    @setState(url: e.target.value)

  create: (e) ->
    e.preventDefault()
    unless @state.text && @state.text.trim().length isnt 0
      alert 'Name cannot be blank'
      return
    unless @state.url && @state.url.trim().length isnt 0
      alert 'URL cannot be blank'
      return 
    unless (new RegExp('^[a-zA-Z0-9_-]+$')).test(@state.url)
      alert 'URL can only contain letters, numbers, dashes, and underscores'
      return
    @firebaseRefs['forms'].child(@state.url).set(title: @state.text, fields: [], user_id: "#{FirebaseUtils.currentUser().uid}")
    @setState(text: '', url: '')

  componentWillMount: ->
    ref = FirebaseUtils.fb("forms")

    @bindAsArray(ref, 'forms')

  formPage: (slug) ->
    @transitionTo('adminForm', {slug: slug})

  render: ->
    forms = @state.forms.filter( (form) -> form.user_id == FirebaseUtils.currentUser().uid)

    <div>
      <table className={'forms'}>
        <thead>
          <tr>
            <th>Your Customized Forms</th>
          </tr>
        </thead>
        <tbody>
          {for form in forms
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
        <br />
        <input placeholder={"New Form URL"} onChange={@setURL} value={@state.url} />
        <br />
        <br />
        <button>Create New Form</button>
      </form>
    </div>
