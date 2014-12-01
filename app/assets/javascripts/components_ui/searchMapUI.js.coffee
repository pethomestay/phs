$ ->
  SearchMapUI = flight.component ->
    @attributes
      zoomLevel: 12
      maxZoomLevel: 12
      mapSelector: '#search-map'

    @initMap = ->
      map = new GMaps
        div: @attr.mapSelector
        lat: gon.search.latitude
        lng: gon.search.longitude
        zoom: @attr.zoomLevel
        maxZoom: @attr.maxZoomLevel
        disableDefaultUI: true
        scrollwheel: false
      for homestay in gon.homestays
        map.addMarker
          homestayID: homestay.id
          lat: homestay.latitude
          lng: homestay.longitude
          icon: 'https://res.cloudinary.com/hxnfgf9c2/image/upload/v1414374978/map_marker.png'
          click: (e) ->
            $homestay = $("[data-listing=#{e.homestayID}]")
            $('html, body').animate
              scrollTop: $homestay.offset().top
            , 500, ->
              $homestay.addClass 'animated flash'

    @after 'initialize', ->
      @initMap()

  SearchMapUI.attachTo '.homestay-index #search-map'
