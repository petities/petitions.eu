# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


Mailcheck.defaultDomains.push('uva.nl', 'petities.nl', 'xs4all.nl', 'gmail.com', 'hotmail.com', 'deds.nl', 'dds.nl', ) # // extend existing domains
#Mailcheck.defaultSecondLevelDomains.push('domain', 'yetanotherdomain') // extend existing SLDs
Mailcheck.defaultTopLevelDomains.push('be', 'nl', 'de')

suggested = (element, sugestion) ->
  console.log(sugestion)
  tip_id = '#didyoumean_' + element[0].id
  console.log(tip_id)
  sugestion_id = '#suggest_' + element[0].id
  console.log(sugestion_id)
  sugElement = $(sugestion_id) 
  sugElement.html sugestion.full     
  tipElement = $(tip_id) 
  tipElement.show()

empty = (elements, suggestion) ->
  tip_id = '#didyoumean_' + elements[0].id
  sugestion_id = '#suggest_' + elements[0].id
  sugElement = $(sugestion_id) 
  $(sugestion_id).html "" 
  tipElement = $(tip_id) 
  tipElement.hide()



delay = ( 
  timer = 0
  (callback, ms) ->
    clearTimeout(timer)
    setTimeout(callback, ms)
  )


# while typing email form check the email field with a little delay
$ ->
  $('[id$=_email]').keyup(->
    input = this
    delay(->
      $(input).mailcheck suggested: suggested, empty: empty 
    , 800)) 
   

# on focusing to the next form check the mail field
# and do a sugestion
#$ ->
#  #$('#signature_person_email').bind 'blur', ->
#  $('[id$=_email]').bind 'blur', ->
#    $(this).mailcheck suggested: suggested, empty: empty


# replace content of email form when clicked.
# and remove the sugestion
$ ->
  $('[id^=suggest_]').on "click", ->
    console.log('yes')
    # find email element
    id = $(this)[0].id
    input_id = id.split('suggest_')[1]
    element = $('#' + input_id)
    # set value to suggested
    element.val $(this).html()
    # empty suggestion box
    $(this).html ""
    # hide the tip box
    tip_id = '#didyoumean_' + input_id
    console.log(tip_id)
    tipElement = $(tip_id) 
    tipElement.hide()

