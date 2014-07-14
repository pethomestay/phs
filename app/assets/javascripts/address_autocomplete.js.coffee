$(document).ready ->
  MAP_BASE_URL = "https://www.google.com/maps/embed/v1/place?key=AIzaSyB2prETJyrdHZ1aO_pw3Z_43bdnb7Ucrqo&zoom=15&q="
  # If address presented
  if $('#homestay_address_1').val().length > 0
    # Retrive address
    address_1 = $('#homestay_address_1').val()
    suburb = $('#homestay_address_suburb').val()
    state = $('#homestay_address_city').val()
    postcode = $('#homestay_address_postcode').val()
    formatted_address = "#{address_1}, #{suburb} #{state} #{postcode}"
    # Set up address preview
    $('#address-preview').text(formatted_address)
    # Set up map preview
    $('#map-preview').attr('src', MAP_BASE_URL + formatted_address)
  # Address autocomplete
  # Initialize
  options =
    types: ['geocode'], # Geographical locations only
    componentRestrictions:
      country: 'au' # Australian addresses only
  input = $('#addressField')[0]
  # Create the autocomplete object, passing in input field and options
  autocomplete = new google.maps.places.Autocomplete(input, options)
  # When the user selects an address from the dropdown,
  # populate the address fields in the form.
  google.maps.event.addListener(autocomplete, 'place_changed', ->
    addressUpdate()
  )
  addressUpdate = ->
    # Get the place details from the autocomplete object
    place = autocomplete.getPlace()
    for component in place.address_components
      switch component.types[0]
        when 'street_number'
          street_number = component['long_name']
        when 'route'
          street_route  = component['long_name']
        when 'locality'
          suburb        = component['long_name'].toUpperCase()
        when 'administrative_area_level_1'
          state         = component['short_name']
        when 'postal_code'
          postcode      = component['short_name']
    # Populate hidden form
    if street_number and street_route
      address_1 = "#{street_number} #{street_route}"
    else if street_route
      address_1 = "#{street_route}"
    else
      address_1 = ""
    $('#homestay_address_1').val(address_1)
    $('#user_homestay_address_2').val('')
    $('#homestay_address_suburb').val(suburb)
    $('#homestay_address_city').val(state)
    $('#homestay_address_country').val('Australia')
    $('#homestay_address_postcode').val(postcode)
    # Update address preview
    $('#address-preview').text(place.formatted_address)
    # Update map preview
    $('#map-preview').attr('src', MAP_BASE_URL + place.formatted_address)
