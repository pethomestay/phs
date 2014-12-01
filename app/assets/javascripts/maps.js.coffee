window.initMap = (lat, lng, opts = {}) ->
  jQuery.extend opts, {lat: lat, lng: lng, div: '#map'}
  window.map = new GMaps(opts)

markerImage = ->
  new google.maps.MarkerImage 'https://res.cloudinary.com/hxnfgf9c2/image/upload/v1414374978/map_marker.png',
    new google.maps.Size(32,49),
    new google.maps.Point(0,0),
    new google.maps.Point(16,49)

markerShadow = ->
  new google.maps.MarkerImage 'https://res.cloudinary.com/hxnfgf9c2/image/upload/v1415156969/shadow.png',
    new google.maps.Size(60,49),
    new google.maps.Point(0,0),
    new google.maps.Point(16,49)

markerShape = ->
  {
    coord: [21,0,23,1,25,2,26,3,27,4,28,5,29,6,29,7,30,8,30,9,31,10,31,11,31,12,
            31,13,31,14,31,15,31,16,31,17,31,18,31,19,30,20,30,21,30,22,29,23,29,
            24,29,25,28,26,28,27,27,28,27,29,26,30,26,31,25,32,25,33,24,34,24,35,
            23,36,22,37,22,38,21,39,21,40,20,41,20,42,19,43,19,44,18,45,17,46,17,
            47,16,48,15,48,14,47,14,46,13,45,13,44,12,43,11,42,11,41,10,40,10,39,
            9,38,9,37,8,36,7,35,7,34,6,33,6,32,5,31,5,30,4,29,4,28,3,27,3,26,2,
            25,2,24,2,23,1,22,1,21,1,20,0,19,0,18,0,17,0,16,0,15,0,14,0,13,0,12,
            0,11,0,10,1,9,1,8,2,7,2,6,3,5,4,4,5,3,6,2,8,1,10,0,21,0]
    type: 'poly'
  }

window.setupDraggableMarker = (lat, long, title = "Your place") ->
  map.removeMarkers()
  map.addMarker
    lat: lat
    lng: long
    title: title
    icon: markerImage()
    shadow: markerShadow()
    shape: markerShape()
    draggable: true
    mouseup: (e, test) ->
      $('#hotel_latitude').val(e.position.$a)
      $('#hotel_longitude').val(e.position.ab)
  $('#hotel_latitude').val(lat)
  $('#hotel_longitude').val(long)

window.setupMarker = (lat, long, title = "Homestay", click = undefined) ->
  map.addMarker
    lat: lat
    lng: long
    title: title
    icon: markerImage()
    shadow: markerShadow()
    shape: markerShape()
    click: click
