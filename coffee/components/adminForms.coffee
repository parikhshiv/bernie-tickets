React = require('react')
History = require('react-router').History
ReactFireMixin = require('reactfire')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [ReactFireMixin, History]
  displayName: 'AdminForms'

  getInitialState: ->
    {
      forms: []
      text: ''
      url: ''
      textError: false
      urlError: false
    }

  set: (field, e) ->
    fields = {}
    fields[field] = e.target.value
    @setState(fields)

  create: (e) ->
    e.preventDefault()

    textError = @state.text is null || @state.text.trim().length is 0
    urlError = @state.url is null || @state.url.trim().length is 0 || !(new RegExp('^[a-zA-Z0-9_-]+$')).test(@state.url)

    if textError || urlError
      @setState(textError: textError, urlError: urlError)
    else
      @firebaseRefs['forms'].child(@state.url).set(title: @state.text, fields: [], user_id: "#{FirebaseUtils.currentUser().uid}")
      @setState(text: '', url: '', textError: false, urlError: false)

  componentWillMount: ->
    ref = FirebaseUtils.fb("forms")

    @bindAsArray(ref, 'forms')

  formPage: (slug) ->
    @history.pushState(null, "/admin/forms/#{slug}")

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
        <input placeholder={'New Form Name'} onChange={@set.bind(null, 'text')} value={@state.text} className={'error' if @state.textError} />
        <br />
        <input placeholder={'New Form URL'} onChange={@set.bind(null, 'url')} value={@state.url} className={'error' if @state.urlError} />
        <br />
        <br />
        <button>Create New Form</button>
      </form>
    </div>
