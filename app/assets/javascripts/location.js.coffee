jQuery ->
  $('#event_rooms').parent().hide()
  rooms = $('#event_rooms').html()
  $('#event_location_id').change ->
    building = $('#event_location_id :selected').text()
    escaped_building = building.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(rooms).filter("optgroup[label=#{escaped_building}]").html()
    if options
      $('#event_rooms').html(options)
      $('#event_rooms').parent().show()
    else
      $('#event_rooms').empty()
      $('#event_rooms').parent().hide()
