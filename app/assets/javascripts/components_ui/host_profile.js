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

  if($('body.host-profile').length > 0) {
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

    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) {return;}
      js = d.createElement(s); js.id = id;
      js.src = '//connect.facebook.net/en_US/sdk.js';
      fjs.parentNode.insertBefore(js, fjs);
    } (document, 'script', 'facebook-jssdk'));

    window.fbAsyncInit = function() {
      FB.init({
        appId: gon.fb_app_id,
        xfbml: false,
        version: 'v2.1'
      });

      $('a.social.facebook').on('click', function() {
        e.preventDefault();
        FB.ui({
          href: document.URL,
          method: 'share'
        }, function(response){});
      });
    };

    $('a.social.twitter').on('click', function(e) {
      e.preventDefault();
      window.open($(this).attr('href'), 'Tweet', "width=600,height=500");
    });

    goSticky();
  }
});
