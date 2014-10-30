$ ->
  # Hero carousel
  $('.homestay-show #hero').owlCarousel
    navigation: true
    navigationText: [
      "<i class='fa fa-chevron-left'></i>",
      "<i class='fa fa-chevron-right'></i>"
    ]
    autoHeight : true
    stopOnHover: true
    slideSpeed : 300
    paginationSpeed : 400
    singleItem: true

  # Map on the right
  $map = $('.homestay-show #map')
  map = new GMaps
    div: '#map'
    lat: $map.data('lat')
    lng: $map.data('lng')
    minZoom: 10
    maxZoom: 14
    disableDefaultUI: true
    scrollwheel: false
    draggable: false
  map.addMarker
    lat: $map.data('lat')
    lng: $map.data('lng')
    icon: 'http://res.cloudinary.com/hxnfgf9c2/image/upload/v1414374978/map_marker.png'
  $('.homestay-show #map').mouseenter (evt) ->
    if !map.hover
      map.hover = true
      map.setOptions
        panControl: true
        zoomControl: true
        zoomControlOptions:
          style: google.maps.ZoomControlStyle.LARGE
  $('body').mouseover (evt) ->
    if map.hover
      if $(evt.target).closest('.homestay-show #map').length == 0
        map.hover = false
        map.setOptions
          panControl: false
          zoomControl: false

  # Collapse descriptions that are too long
  $('.homestay-show .readmore').readmore
    moreLink: '<a href="#"><i class="fa fa-caret-down"></i> Read more</a>'
    lessLink: '<a href="#"><i class="fa fa-caret-up"></i> Collapse</a>'
    sectionCSS: 'display: block; width: 100%; margin-bottom: 20px;'
    maxHeight: 170
  # Collapse reviews that are too long
  $('.homestay-show .review .readmore').readmore
    moreLink: '<a href="#"><i class="fa fa-caret-down"></i> Read more</a>'
    lessLink: '<a href="#"><i class="fa fa-caret-up"></i> Collapse</a>'
    sectionCSS: 'display: block; width: 100%; margin-bottom: 20px;'
    maxHeight: 108
