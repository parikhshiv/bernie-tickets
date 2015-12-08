ReactDOM = require('react-dom')
React = require('react')
Router = require('react-router').Router
Route = require('react-router').Route

# Require route components.
App = require('./app.coffee')
Form = require('./form.coffee')

ReactDOM.render(
  <Router>
    <Route component={App}>
      <Route path='/forms/:formId' component={Form} name='form' />
      <Route path='/' component={Form} />
    </Route>
  </Router>
, document.getElementById('app')) 
