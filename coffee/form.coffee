React = require('react')
Link = require('react-router').Link

module.exports = React.createClass
  displayName: 'Form'

  render: ->
    <div>
      <section className={'form'}>
        <h2>
          Event Registration
        </h2>
        <hr />
        <form className={'signup'}>
          <input className={'first_name'} type={'text'} id={'first_name'} placeholder={'First Name'} required={true} />
          <input className={'last_name'} type={'text'} id={'last_name'} placeholder={'Last Name'} required={true} />
          <input className={'phone'} type={'tel'} id={'phone'} placeholder={'Cell Phone #'} />
          <input className={'email'} type={'email'} id={'email'} placeholder={'Email Address'} required={true} />
          <div className={'email-suggestion'}>
            <span className={'suggestion'}></span>
            <span className={'x'}>X</span>
          </div>

          <input id={'zip'} name={'zip'} className={'zip'} placeholder={'Zip Code'} type={'tel'} required={true} />

          <div className={'checkboxgroup'}>
            <input type={'checkbox'} id={'canText'} />
            <label htmlFor={'canText'} className={'checkbox-label'}>
              Receive text msgs from Bernie 2016
              <span className={'disclaimer'}><br />Msg and data rates may apply</span>
            </label>
          </div>

          <a href={'#'} id={'submit-form'} className={'btn'}>
            Sign Up
          </a>
        </form>
      </section>

      <section className={'ticket'}>
        <div id={'qr-img'}></div>
        <canvas id={'qr'} width={'400'} height={'520'}></canvas>
        <a id={'print'} className={'btn'}>
          Print
        </a><br />
        <a id={'save'} download={'ticket.png'} className={'btn'}>
          Save
        </a>
      </section>
    </div>
