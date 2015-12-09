React = require('react')
Link = require('react-router').Link
RouteHandler = require('react-router').RouteHandler
Login = require('../auth/login.coffee')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  displayName: 'Admin'

  statics:
    willTransitionTo: (transition) ->
      return if FirebaseUtils.loggedIn()
      Login.attemptedTransition = transition
      transition.redirect('login')

  render: ->
    <div className={'forms-admin'}>
      <Link to={'logout'}>Logout</Link>
      <RouteHandler />
    </div>
