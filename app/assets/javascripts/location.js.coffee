jQuery ->
  $('#event_room_numbers').parent().hide()
  rooms = $('#event_room_numbers').html()
  $('#event_location_id').change ->
    building = $('#event_location_id :selected').text()
    escaped_building = building.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(rooms).filter("optgroup[label=#{escaped_building}]").html()
    if options
      $('#event_room_numbers').html(options)
      $('#event_room_numbers').parent().show()      
    else
      $('#event_room_numbers').empty()
      $('#event_room_numbers').parent().hide()