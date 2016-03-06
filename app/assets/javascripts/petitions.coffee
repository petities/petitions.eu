# content length defined as cmax.
# determine how many characters are left and put that count
# in the #rem (remaining) div inside the help block
# for elements with the countit class lookup the maximum

$ ->
  $(".countit").keyup (e) ->
    cmax = $("#rem_" + $(this).attr("id")).attr("title")
    if $(this).val().length >= cmax
      $(this).val($(this).val().substr(0, cmax))
    $("#rem_" + $(this).attr("id")).text(cmax - $(this).val().length)

