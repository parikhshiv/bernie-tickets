Firebase = require('firebase')
ref = new Firebase('https://bernie-tickets.firebaseio.com')
cachedUser = null

module.exports = 
  login: (cb) ->
    ref.authWithOAuthPopup('google', (error, authData) ->
      error = true if authData.google.email.indexOf('@berniesanders.com') is -1
      cachedUser = authData unless error
      cb(cachedUser, error)
    , {
      scope: 'email'
    })

  loggedIn: ->
    cachedUser || ref.getAuth()

  logout: ->
    ref.unauth()
    cachedUser = null

  currentUser: ->
    cachedUser || ref.getAuth()

  fb: (path) ->
    new Firebase("https://bernie-tickets.firebaseio.com/#{path}")
