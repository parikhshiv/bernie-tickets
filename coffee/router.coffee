ReactDOM = require('react-dom')
React = require('react')
Router = require('react-router')
Route = require('react-router').Route
DefaultRoute = require('react-router').DefaultRoute
FirebaseUtils = require('./utils/firebaseUtils.coffee')

window.jQuery = window.$ = require('jquery')

# Require route components.
App = require('./app.coffee')
Form = require('./form.coffee')
Login = require('./auth/login.coffee')
Logout = require('./auth/logout.coffee')
Admin = require('./admin/admin.coffee')
AdminForms = require('./admin/forms.coffee')
AdminForm = require('./admin/form.coffee')

routes = (
  <Route path='/' handler={App}>
    <DefaultRoute handler={Form} />

    <Route name='login' handler={Login} />
    <Route name='logout' handler={Logout} />

    <Route name='admin' handler={Admin}>
      <Route name='adminForm' path='/admin/forms/:formId' handler={AdminForm} />
      <Route name='adminForms' path='/admin/forms' handler={AdminForms} />
    </Route>

    <Route name='form' path='/forms/:formId' handler={Form} />
  </Route>
)

Router.run(routes, Router.HistoryLocation, (Handler) ->
  ReactDOM.render(<Handler/>, document.getElementById('app'))
)
