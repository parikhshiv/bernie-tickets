ReactDOM = require('react-dom')
React = require('react')
Router = require('react-router').Router
Route = require('react-router').Route
createBrowserHistory = require('history/lib/createBrowserHistory')
FirebaseUtils = require('./utils/firebaseUtils.coffee')

window.jQuery = window.$ = require('jquery')
window._ = require('lodash')

# Require route components.
App = require('./components/app.coffee')
Form = require('./components/form.coffee')
Login = require('./components/login.coffee')
Admin = require('./components/admin.coffee')
AdminForms = require('./components/adminForms.coffee')
AdminForm = require('./components/adminForm.coffee')

# Define up and render routes.
router = (
  <Router history={createBrowserHistory()}>
    <Route component={App}>
      <Route component={Admin}>
        <Route path='/admin/forms/:slug' component={AdminForm} />
        <Route path='/admin/forms' component={AdminForms} />
        <Route path='/admin' component={AdminForms} />
      </Route>

      <Route path='login' component={Login} />
      <Route path='/:slug' component={Form} />
      <Route path='/' component={Form} />
    </Route>
  </Router>
)
ReactDOM.render(router, document.getElementById('app'))
