$(document).ready(function() {
  function goSticky() {
    if($('.parallax-window').length > 0) {
      var top = $(this).scrollTop();
      var threshold = $('.parallax-window').position().top + $('.parallax-window').outerHeight(true);
      if(top >= threshold) {
        $('body').addClass('sticky');
      } else {
        $('body').removeClass('sticky');
      }
    }
  }

  $(window).on('scroll', function(e) {
    goSticky();
  });

  $('.gallery ul li a').fluidbox({
    loader: true
  });

  if($('.parallax-window').length > 0) {
    L.mapbox.accessToken = 'pk.eyJ1IjoiemVybzUxIiwiYSI6IkhUTmRWV0EifQ.Jlkqv_Yr3oK_g8Fp96s1oQ';
    var radii = [];
    var radius = null;
    var location = [$('#map').data('lat'), $('#map').data('lon')];
    var deliveryRadius = $('#map').data('delivery');
    var visitsRadius = $('#map').data('visit');
    if(deliveryRadius) radii.push(deliveryRadius);
    if(visitsRadius) radii.push(visitsRadius);
    if(radii.length > 0) {
      radius = radii.sort(function(a,b) {
        return a - b;
      })[0];
    }

    var map = L.mapbox.map('map', 'zero51.odlddm5h', {
      infoControl: false,
      legendControl: false,
      maxZoom: 16,
      shareControl: false,
      zoomControl: false
    }).setView(location, 14);

    L.marker(location, {
      icon: L.divIcon({
        className: 'fa-icon',
        html: '<i class="fa fa-map-marker fa-3x"></i>',
        iconSize: [40, 40]
      })
    }).addTo(map);

    goSticky();
  }
});
