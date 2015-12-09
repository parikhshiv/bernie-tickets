React = require('react')
Link = require('react-router').Link
ReactFireMixin = require('reactfire')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [ReactFireMixin]
  displayName: 'AdminForm'

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    {
      form: null
      fields: []
    }

  update: (e) ->
    @firebaseRefs['form'].set(title: e.target.value)

  addField: (e) ->
    e.preventDefault()
    @firebaseRefs['fields'].push(title: 'New Field')

  updateField: (key, field, e) ->
    @firebaseRefs['fields'].child(key).child(field).set(e.target.value)

  componentWillMount: ->
    ref = FirebaseUtils.fb("#{FirebaseUtils.currentUser().uid}/forms/#{@context.router.getCurrentParams().formId}")
    @bindAsObject(ref, 'form')
    @bindAsArray(ref.child('fields'), 'fields')

  render: ->
    <div>
      <input type={'text'} value={@state.form.title if @state.form} onChange={@update} />

      <div className={'fields'}>
        {for field in @state.fields
          <div className={'field'} key={field['.key']}>
            <input type={'text'} value={field.title} onChange={@updateField.bind(null, field['.key'], 'title')} />
            <select value={field.type} onChange={@updateField.bind(null, field['.key'], 'type')}>
              <option value={'text'}>Text</option>
              <option value={'checkbox'}>Checkbox</option>
            </select>
          </div>
        }
      </div>

      <a href={'#'} onClick={@addField}>Add Field</a>
    </div>
