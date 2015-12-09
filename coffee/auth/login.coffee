React = require('react')
Router = require('react-router')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [Router.Navigation]

  statics:
    attemptedTransition: null

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
        <a href={'#'} onClick={@login}>
          Login
        </a>
        {if @state.error
          <p>Error on Login</p>
        }
      </form>
    </div>
