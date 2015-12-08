React = require('react')
Link = require('react-router').Link

module.exports = React.createClass
  displayName: 'App'

  render: ->
    <div>
      <div className={'img-wrapper'}>
        <img className={'logo'} src={'img/logo.png'} alt={'Bernie 2016'} />
      </div>
      <div>
        {@props.children}
      </div>
      <div className={'footer-offset'}>
        <footer>
          <p className={'address'}>
            Bernie 2016<br />
            PO Box 905<br />
            Burlington, VT 05402
          </p>
          <p className={'site-title'}>
            Paid for by Bernie 2016
          </p>
          <span className={'billionaires'}>
            <svg width='200' height='40'>
              <image xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='img/billionaires.svg' width='200' height='40' x='0' />
            </svg>
            (not the billionaires)
          </span>
          <p>
            <span className={'copyright'}>
              &copy; Bernie 2016
            </span> | 
            <a href={'https://berniesanders.com/privacy-policy'}>
              Privacy Policy
            </a>
          </p>
        </footer>
      </div>
    </div>
