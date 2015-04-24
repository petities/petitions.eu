# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->
  $(".countit").keyup (e) ->
    cmax = $("#rem_" + $(this).attr("id")).attr("title")
    if $(this).val().length >= cmax
      $(this).val($(this).val().substr(0, cmax));
    $("#rem_" + $(this).attr("id")).text(cmax - $(this).val().length);
