# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


Mailcheck.defaultDomains.push('uva.nl', 'petities.nl', 'xs4all.nl', 'gmail.com', 'hotmail.com', 'deds.nl', 'dds.nl', ) # // extend existing domains
#Mailcheck.defaultSecondLevelDomains.push('domain', 'yetanotherdomain') // extend existing SLDs
Mailcheck.defaultTopLevelDomains.push('be', 'nl', 'de')

sugestion_id = '.signature-form-sugestion'
tip_id = '.didyoumean'

suggested = (element, sugestion) ->
  #console.log(sugestion)
  sugElement = $(sugestion_id) 
  #sugElement.addClass "signaturesuggestbutton"
  sugElement.html sugestion.full     
  tipElement = $(tip_id) 
  tipElement.show()

empty = (element) ->
  #console.log("no sugestion")
  sugElement = $(sugestion_id) 
  #sugElement.removeClass "signaturesuggestbutton"
  $(sugestion_id).html "" 
  tipElement = $(tip_id) 
  tipElement.hide()

# on focusing to the next form check the mail field
# and do a sugestion
$ ->
  #$('#signature_person_email').bind 'blur', ->
  $('[id$=_email]').bind 'blur', ->
    # console.log("heeeey..!!")
    $(this).mailcheck suggested: suggested, empty: empty


# replace content of email form when clicked.
# and remove the sugestion
$ ->
  $(sugestion_id).on "click", ->
    $("[id$=_email]").val $(this).html()
    #$(this).removeClass "signaturesuggestbutton"
    $(this).html ""
    tipElement = $(tip_id) 
    tipElement.hide()

