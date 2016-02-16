# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('#kiosk_room_id').parent().hide()
  rooms = $('#kiosk_room_id').html()
  $('#kiosk_location_id').change ->
    building = $('#kiosk_location_id :selected').text()
    escaped_building = building.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(rooms).filter("optgroup[label=#{escaped_building}]").html()
    if options
      $('#kiosk_room_id').html(options)
      $('#kiosk_room_id').parent().show()      
    else
      $('#kiosk_room_id').empty()
      $('#kiosk_room_id').parent().hide()