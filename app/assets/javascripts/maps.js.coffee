window.initMap = (lat, lng, opts = {}) ->
  jQuery.extend opts, {lat: lat, lng: lng, div: '#map'}
  window.map = new GMaps(opts)

window.setupDraggableMarker = (lat, long, title = "Your place") ->
  map.removeMarkers()
  map.addMarker
    lat: lat
    lng: long
    title: title
    draggable: true
    mouseup: (e, test) ->
      $('#hotel_latitude').val(e.position.$a)
      $('#hotel_longitude').val(e.position.ab)
  $('#hotel_latitude').val(lat)
  $('#hotel_longitude').val(long)

window.setupMarker = (lat, long, title = "Your place") ->
  map.addMarker
    lat: lat
    lng: long
    title: title
