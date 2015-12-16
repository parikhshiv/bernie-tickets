React = require('react')
Link = require('react-router').Link
MaskedInput = require('react-input-mask')
Mailcheck = require('mailcheck')
Fabric = require('fabric').fabric
FirebaseUtils = require('./utils/firebaseUtils.coffee')
ReactFireMixin = require('reactfire')
require('../node_modules/jquery-qrcode/dist/jquery.qrcode')

module.exports = React.createClass
  mixins: [ReactFireMixin]
  displayName: 'Form'

  contextTypes:
    router: React.PropTypes.func

  getInitialState: ->
    {
      view: 'FORM'
      phoneRequired: false
      suggestion: {}
      showSuggestion: false
      form: @context.router.getCurrentParams().formId
      fields: []
    }

  viewForm: ->
    @state.view is 'FORM'

  viewTicket: ->
    @state.view is 'TICKET'

  canTextChange: (e) ->
    @setState(phoneRequired: $(e.target).is(':checked'))

  checkEmail: (e) ->
    Mailcheck.run(
      email: $(e.target).val()
      suggested: (suggestion) =>
        @setState(suggestion: suggestion, showSuggestion: true)
      empty: =>
        @setState(suggestion: {}, showSuggestion: false)
    )

  acceptSuggestion: (e) ->
    return if $(e.target).is('.x')
    $('#email').val @state.suggestion.full
    @setState(suggestion: {}, showSuggestion: false)

  declineSuggestion: ->
    @setState(suggestion: {}, showSuggestion: false)

  componentWillMount: ->
    if @context.router.getCurrentParams().formId
      # how do i grab the ref without having to refer to currentUser?
      ref = FirebaseUtils.fb("#{FirebaseUtils.currentUser().uid}/forms/#{@context.router.getCurrentParams().formId}")
      @bindAsArray(ref.child('fields'), 'fields')

  makeId: (string) ->
    string = string.toLowerCase()
    string = string.replace(/[^a-zA-Z ]/g, "")
    string = string.split(" ").join("")

  submitForm: (e) ->
    e.preventDefault()

    data =
      first_name: $('#first_name').val()
      last_name: $('#last_name').val()
      phone: $('#phone').val()
      email: $('#email').val()
      zip: $('#zip').val()
      canText: $('#canText').prop('checked')

    for field in @state.fields
      if field.type
        data[field.title] = $("##{@makeId(field.title)}").prop('checked')
      else
        data[field.title] = $("##{@makeId(field.title)}").val()

    allFields = [
      'first_name'
      'last_name'
      'phone'
      'email'
      'zip'
      'canText'
    ].concat(@state.fields.map( (field) -> field.title ))

    # right now, this JSON string doesn't specify the key - could be a problem with extra columns
    string = JSON.stringify(allFields.map( (key) -> data[key] )).slice(1, -1)

    # Generate QR code
    $('#qr-img').qrcode
      render: 'image'
      text: string
      size: 375
      fill: '#147FD7'
      background: '#FFF'

    # Create canvas
    canvas = new Fabric.Canvas('qr')
    canvas.selection = false
    canvas.setBackgroundColor('#ffffff')

    # Add text to canvas
    text = new Fabric.Text('Bernie 2016', top: 15, left: 90, fontFamily: 'jubilat', fill: '#147FD7')
    canvas.add(text)
    text.set(evented: false)
    text = new Fabric.Text('Event Ticket', top: 462.5, left: 90, fontFamily: 'jubilat', fill: '#147FD7')
    canvas.add(text)
    text.set(evented: false)

    # Add img to canvas
    Fabric.Image.fromURL $('#qr-img img').attr('src'), (img) ->
      img.set(top: 72.5, left: 12.5, evented: false)
      canvas.add(img)

      # Dynamically set canvas size
      canvas.setWidth($('.canvas-container').width())
      canvas.setHeight($('.canvas-container').width() * 1.3)

      # Set save button to download the canvas
      $('#save').attr('href', canvas.toDataURL())

      # Set print button to print the canvas
      $('#print').on 'click', ->
        windowContent = "<html><body><img src='#{canvas.toDataURL()}' /></body></html>"
        printWin = window.open()
        printWin.document.open()
        printWin.document.write(windowContent)
        printWin.document.close()
        printWin.focus()
        printWin.print()
        printWin.close()

    @setState(view: 'TICKET')

  render: ->

    <div>
      <section className={"form #{'hidden' unless @viewForm()}"}>
        <h2>
          Event Registration
        </h2>
        <hr />
        <form className={'signup'}>
          <input className={'first_name'} type={'text'} id={'first_name'} placeholder={'First Name'} required={true} />
          <input className={'last_name'} type={'text'} id={'last_name'} placeholder={'Last Name'} required={true} />
          <MaskedInput className={'phone'} type={'tel'} id={'phone'} placeholder={'Cell Phone #'} mask={'(999) 999-9999'} required={@state.phoneRequired} />
          <input className={'email'} type={'email'} id={'email'} placeholder={'Email Address'} required={true} onBlur={@checkEmail} />
          { if @state.showSuggestion
            <div className={'email-suggestion'} onClick={@acceptSuggestion}>
              <span className={'suggestion'}>
                Did you mean {@state.suggestion.address}@<strong>{@state.suggestion.domain}</strong>?
              </span>
              <span className={'x'} onClick={@declineSuggestion}>X</span>
            </div>
          }

          <MaskedInput className={'zip'} id={'zip'} name={'zip'} placeholder={'Zip Code'} type={'tel'} required={true} mask={'99999'} />

          {for field, idx in @state.fields
            unless field.type
              <input className={'last_name'} key={idx} type={'text'} id={@makeId(field.title)} placeholder={field.title} required={true} />
          }

          <div className={'checkboxgroup'}>
            <input type={'checkbox'} id={'canText'} onChange={@canTextChange} />
            <label htmlFor={'canText'} className={'checkbox-label'}>
              Receive text msgs from Bernie 2016
              <span className={'disclaimer'}><br />Msg and data rates may apply</span>
            </label>
          </div>

          {for field, idx in @state.fields
              if field.type == "checkbox"
                <div className={'checkboxgroup'} key={idx}>
                  <input type={'checkbox'} id={@makeId(field.title)} />
                  <label className={'checkbox-label'}>
                    {field.title}
                  </label>
                </div>
          }

          <a href={'#'} className={'btn'} onClick={@submitForm}>Sign Up</a>
        </form>
      </section>

      <section className={"ticket #{'hidden' unless @viewTicket()}"}>
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
