React = require('react')
History = require('react-router').History
Link = require('react-router').Link
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [History]
  displayName: 'Admin'

  getInitialState: ->
    {
      loggedIn: FirebaseUtils.loggedIn()
    }

  componentWillMount: ->
    unless @state.loggedIn
      @history.pushState(null, '/login')

  logout: (e) ->
    e.preventDefault()
    FirebaseUtils.logout()
    @history.pushState(null, '/')

  render: ->
    <div className={'forms-admin'}>
      <a href={'#'} className={'btn logout'} onClick={@logout}>Logout</a>
      <Link to={'/admin/forms'} className={'btn forms-link'}>All Forms</Link>
      {React.cloneElement(@props.children, { loginRedirect: !@state.loggedIn })}
    </div>
