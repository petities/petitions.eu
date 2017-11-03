#= require active_admin/base

$ ->
  $('[data-behavior~=selectable]').click ->
    $(this).select()
