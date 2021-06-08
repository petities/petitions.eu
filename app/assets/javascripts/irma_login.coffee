$ ->
  loginTag = $('#login_with_irma')
  loginTag.on 'click', ->
    irmap = irma.newPopup
      'debugging': true
      'session':
        'url': loginTag.data('irmaUrl')
        'start': 
          'method': 'POST'
          'body': loginTag.data('irmaJwt')
          'headers': { 'Content-Type': 'text/plain' }
        'result': # make sure the server sends us a signed result (i.e. JWT)
          'url': (o, {sessionPtr, sessionToken}) => "#{o.url}/session/#{sessionToken}/result-jwt"
          # instead of r.json(), we do r.text(), because the JWT is not json.
          'parseResponse': (r) => r.text() 
    irmap.start()
      .then (jwt) -> 
        # jwt holds the user's disclosed email address,
        # which we'll send to the server via the #user_irma_email hidden input
        $('#user_irma_email').val(jwt)
        
        # Submit the form #new_user
        $('#new_user').submit()
      .catch((error) -> console.error("Irma disclosure failed", error))

