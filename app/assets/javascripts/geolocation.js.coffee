window.coordsToLocation = (lat, long, callback) ->
  $.getJSON "http://jsonp.jit.su/?url=http%3A%2F%2Fmaps.googleapis.com%2Fmaps%2Fapi%2Fgeocode%2Fjson%3Flatlng%3D#{lat}%2C#{long}%26sensor%3Dtrue", (body) ->
    locality = sublocality = ''
    if body.results && body.results[0] && body.results[0].address_components
      for address_component in body.results[0].address_components
        for type in address_component.types
          sublocality = address_component.long_name if type == 'sublocality'
          locality = address_component.long_name if type == 'locality'
    location = if sublocality then "#{sublocality}, #{locality}" else locality
    callback(location)

# TODO: Add fallback for browsers without geolocation support
window.getCoords = (callback) ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (data) ->
      callback data

window.getLocation = (callback) ->
  getCoords (geolocation) ->
    coords = geolocation.coords
    coordsToLocation coords.latitude, coords.longitude, callback

$ ->
  $("#geocomplete").geocomplete
    details: "form"
    detailsAttribute: "data-geocomplete"

  if $("#street_name, #street_number, #administrative_area_level_1, #locality, #sublocality").length == 5
    setInterval ->
      street_name = $("#street_name").val()
      street_number = $("#street_number").val()
      $('#user_address_1').val "#{street_number} #{street_name}"
      if $('#sublocality').val().length > 0
        $('#user_address_suburb').val $('#sublocality').val()
        $('#user_address_city').val $('#locality').val()
      else
        $('#user_address_suburb').val $('#locality').val()
        $('#user_address_city').val $('#administrative_area_level_1').val()
    , 200
