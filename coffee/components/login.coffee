React = require('react')
History = require('react-router').History
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [History]
  displayName: 'Login'

  getInitialState: ->
    {
      error: false
    }

  login: (e) ->
    e.preventDefault()

    FirebaseUtils.login (user, error) =>
      if error
        @setState(error: error)
      else
        @history.pushState(null, '/admin')

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
