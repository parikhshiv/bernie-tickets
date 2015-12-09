React = require('react')
Router = require('react-router')
FirebaseUtils = require('../utils/firebaseUtils.coffee')

module.exports = React.createClass
  mixins: [Router.Navigation]

  componentDidMount: ->
    FirebaseUtils.logout()
    @transitionTo('/')

  render: ->
    <div />
