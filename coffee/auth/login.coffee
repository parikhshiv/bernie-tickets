React = require('react')
Router = require('react-router')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [Router.Navigation]

  statics:
    attemptedTransition: null
    willTransitionTo: (transition) ->
      return unless FirebaseUtils.loggedIn()
      attemptedTransition = transition
      transition.redirect('admin')

  getInitialState: ->
    {
      error: false
    }

  login: (e) ->
    e.preventDefault()

    FirebaseUtils.login (user, error) =>
      if error
        @setState(error: error)
      else if @constructor.attemptedTransition
        transition = @constructor.attemptedTransition
        @constructor.attemptedTransition = null
        transition.retry()
      else
        @transitionTo('admin')

  render: ->
    <div className={'forms-admin'}>
      <form onSubmit={@handleSubmit}>
        <a href={'#'} className={'btn'} onClick={@login}>
          Login
        </a>
        {if @state.error
          <p className={'errors'}>Error on Login</p>
        }
      </form>
    </div>
