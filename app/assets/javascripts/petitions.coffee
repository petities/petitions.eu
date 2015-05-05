# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

# for elements with the counit class lookup the maximum
# content length defind as cmax.
# determin how many characters are left and put that count
# in the #rem (remaining) div inside the help block
$ ->
  $(".countit").keyup (e) ->
    cmax = $("#rem_" + $(this).attr("id")).attr("title")
    if $(this).val().length >= cmax
      $(this).val($(this).val().substr(0, cmax));
    $("#rem_" + $(this).attr("id")).text(cmax - $(this).val().length);

#
# TODO
# Make vote an ajax event!
#
#
