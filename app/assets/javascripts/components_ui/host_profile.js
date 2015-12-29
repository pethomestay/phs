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

    if(window.location.hash == '#request-modal-add-pet') {
      $('#request-modal-add-pet').modal('show');
    }
    if(window.location.hash == '#request-modal') {
      $('#request-modal').modal('show');
    }
    if(window.location.hash == '#confirm-modal') {
      $('#confirm-modal').modal('show');
    }

    $('[data-toggle="tooltip"]').tooltip();

    var check_in = $('#enquiry_check_in_date');
    var check_in_picker = check_in.datepicker({
      format: 'dd/mm/yyyy',
      startDate: '0d',
      autoclose: true
    }).on('changeDate', function(e) {
      var inDate = new Date(e.date);
      check_out_picker.setDate(inDate);
      check_out_picker.startDate = inDate;
      check_out_picker.update();
      check_out.focus();
    }).data('datepicker');

    var check_out = $('#enquiry_check_out_date');
    var check_out_picker = check_out.datepicker({
      format: 'dd/mm/yyyy',
      startDate: '0d',
      autoclose: true
    }).data('datepicker');

    $('.enquiry_check_in_date .input-group-addon').on('click', function(e) {
      e.preventDefault();
      check_out_picker.hide();
      check_in_picker.show();
    });
    $('.enquiry_check_out_date .input-group-addon'). on('click', function(e) {
      e.preventDefault();
      check_in_picker.hide();
      check_out_picker.show();
    });

    $('.chosen-select').chosen({
      max_selected_options: 1
    });

    $('.chosen-select').chosen({
      allow_single_deselect: true,
      no_results_text: 'No results matched',
      width: '200px'
    });

    goSticky();
  }
});
