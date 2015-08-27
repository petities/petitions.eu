# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


Mailcheck.defaultDomains.push('uva.nl', 'petities.nl', 'xs4all.nl', 'gmail.com', 'hotmail.com', 'deds.nl', 'dds.nl', ) # // extend existing domains
#Mailcheck.defaultSecondLevelDomains.push('domain', 'yetanotherdomain') // extend existing SLDs
Mailcheck.defaultTopLevelDomains.push('be', 'nl', 'de')


suggested = (element, suggestion) ->
  sugElement = $('#emailsuggestion') 
  sugElement.addClass "btn btn-warning"
  sugElement.html suggestion.full     

empty = (element) ->
  console.log("no suggestion")
  sugElement = $('#emailsuggestion') 
  sugElement.removeClass "btn btn-warning"
  $('#emailsuggestion').html "" 


# on focusing to the next form check the mail field
# and do a suggestion
$ ->
  #$('#signature_person_email').bind 'blur', ->
  $('[id$=_email]').bind 'blur', ->
    $(this).mailcheck suggested: suggested, empty: empty


# replace content of email form when clicked.
# and remove the suggestion
$ ->
  $("#emailsuggestion").on "click", ->
    $("[id$=_email]").val $(this).html()
    $(this).removeClass "btn btn-warning"
    $(this).html ""

