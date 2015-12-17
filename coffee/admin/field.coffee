React = require('react')
ReactFireMixin = require('reactfire')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [ReactFireMixin]
  displayName: 'AdminFormField'

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    {
      field: null
    }

  update: (field, e) ->
    @firebaseRefs['field'].child(field).set(e.target.value)

  remove: (field, e) ->
    e.preventDefault()
    @firebaseRefs['field'].remove()

  componentWillMount: ->
    ref = FirebaseUtils.fb("forms/#{@context.router.getCurrentParams().slug}/fields/#{@props.id}")
    @bindAsObject(ref, 'field')

  render: ->
    <div className={'field'}>
      <input type={'text'} value={@state.field.title if @state.field} onChange={@update.bind(null, 'title')} />
      <select value={@state.field.type if @state.field} onChange={@update.bind(null, 'type')}>
        <option value={'text'}>Text</option>
        <option value={'checkbox'}>Checkbox</option>
      </select>
      <a href={'#'} onClick={@remove.bind(null, @state.field['.key'] if @state.field)}>X</a>
    </div>
