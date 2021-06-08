$ ->
  # When one clicks on "Login with IRMA":
  loginTag = $('#login_with_irma')
  loginTag.on 'click', ->
    # 1.) first obtain a JWT from our backend to start the IRMA disclosure
    # (We obtain this JWT on demand, because it expires within 5 minutes.)
    jQuery.get("/irma-login-jwt", "", (loginJwt, status, jqxhr) ->
      if status!="success"
        throw "Failed to obtain IRMA login JWT from server"
      # 2.) then show an IRMA popup to the user with a QR-code:
      irmap = irma.newPopup
        'debugging': loginTag.data('irmaDebug')
        'session':
          'url': loginTag.data('irmaServerUrl')
          'start':
            'method': 'POST'
            ## This should, but does not work:
            #'url': (o) -> '/irma-login-jwt'
            'body': loginJwt #loginTag.data('irmaJwt')
            'headers': { 'Content-Type': 'text/plain' }
          'result': # make sure the server sends us a signed result (i.e. JWT)
            'url': (o, {sessionPtr, sessionToken}) => "#{o.url}/session/#{sessionToken}/result-jwt"
            # instead of r.json(), we do r.text(), because the JWT is not json.
            'parseResponse': (r) => r.text() 
      irmap.start()
        .then (jwt) ->
          # 3.) Finally put the disclosed email address of the user
          # into the hidden input #user_irma_email, and submit the form.
          $('#user_irma_email').val(jwt)
           
          # Submit the form #new_user
          $('#new_user').submit()
        .catch((error) -> console.error("Irma disclosure failed: ", error))
    )  #jQuery.get( ... )
