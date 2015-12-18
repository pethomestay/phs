$(document).ready(function() {
  function goSticky() {
    var top = $(this).scrollTop();
    var threshold = $('.parallax-window').position().top + $('.parallax-window').outerHeight(true);
    if(top >= threshold) {
      $('body').addClass('sticky');
    } else {
      $('body').removeClass('sticky');
    }
  }

  $(window).on('scroll', function(e) {
    goSticky();
  });

  L.mapbox.accessToken = 'pk.eyJ1IjoiemVybzUxIiwiYSI6IkhUTmRWV0EifQ.Jlkqv_Yr3oK_g8Fp96s1oQ';
  var map = L.mapbox.map('map', 'zero51.odlddm5h', {
    infoControl: false,
    legendControl: false,
    shareControl: false,
    zoomControl: false
  }).setView([$('#map').data('lat'), $('#map').data('lon')], 14);

  goSticky();
});
