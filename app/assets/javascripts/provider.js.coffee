$ ->
  $('#new_homestay_modal').modal('show');
  $('.login-dropdown').popup().bind('popup:open', (event)->
    $('div.popup form input:first').focus()
  )

  $stars = $('.rater i')
  $stars.each ->
    rating = $(this).index() + 1
    tip_message = (if rating == 1 then "Give 1 star" else "Give #{rating} stars")
    $(this).tooltip
      title: tip_message
    $(this).hover ->
      $stars.removeClass('icon-star-empty icon-star')
      $stars.slice(0, rating).addClass('icon-star')
      $stars.slice(rating).addClass('icon-star-empty')
    , ->
      $stars.removeClass("icon-star").removeClass("icon-star-empty")
      current = $('#feedback_rating').val()
      $stars.slice(0, current).addClass('icon-star')
      $stars.slice(current).addClass('icon-star-empty')
    $(this).click ->
      $('#feedback_rating').val(rating)

  $('.carousel').carousel()

  # Initialize address preview
  address_1 = $('#homestay_address_1').val()
  $('#address-preview-1').text(address_1)
  suburb = $('#homestay_address_suburb').val()
  state = $('#homestay_address_city').val()
  postcode = $('#homestay_address_postcode').val()
  $('#address-preview-2').text("#{suburb} #{state} #{postcode}")
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
    fillInAddress()
  )
  fillInAddress = ->
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
      $('#homestay_address_1').val("#{street_number} #{street_route}")
    else if street_route
      $('#homestay_address_1').val("#{street_route}")
    else
      $('#homestay_address_1').val('')
    $('#user_homestay_address_2').val('')
    $('#homestay_address_suburb').val(suburb)
    $('#homestay_address_city').val(state)
    $('#homestay_address_country').val('Australia')
    $('#homestay_address_postcode').val(postcode)
    # update address preview
    if street_number and street_route
      $('#address-preview-1').text("#{street_number} #{street_route}")
    else if street_route
      $('#address-preview-1').text("#{street_route}")
    else
      $('#address-preview-1').text('')
    $('#address-preview-2').text("#{suburb} #{state} #{postcode}")

  $(document).on 'change', ':file', ->
    if this.files[0].size >= (1024 * 500)
      alert "Please only upload files of 500KB and under."
      $(this).replaceWith($(this).parent().html())
