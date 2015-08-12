  $(".nav-test").hide();  
  // fade in .navbar
  $(function () {
    $(window).scroll(function () {
            // set distance user needs to scroll before we fadeIn navbar
      if ($(this).scrollTop() > 150) {
        $('.nav-test').fadeIn();
      } else {
        $('.nav-test').fadeOut();
      }
    });
  });

  var sideBar = $('#sideScroll');
  var leftSideBar = $('#leftSideBar');
  var originalelpos = leftSideBar.offset().top; // take it where it originally is on the page
  var leftSideBarHeight = leftSideBar.outerHeight() ; // shouldnt be more then this
  var sideBarHeight = sideBar.outerHeight();
  
  //run on scroll
  $(window).scroll(function () {
      calcMovementForSideBar(true);  
  }); 

  $(window).on('resize', function(){
        calcMovementForSideBar(false);
  });

  if($(window).width() < 768) {
    sideBar.removeClass('sideScroll');
  } else {
    sideBar.addClass('sideScroll');
  }

  function calcMovementForSideBar(vertical){
      leftSideBarHeight = leftSideBar.outerHeight() ; // shouldnt be more then this
      sideBarHeight = sideBar.outerHeight();
      var finaldestination;
      if($(window).width() < 768) {
        finaldestination = originalelpos - 117;
        sideBar.removeClass('sideScroll');
      } else {
        sideBar.addClass('sideScroll');
        var windowpos = $(window).scrollTop();
        finaldestination = windowpos + originalelpos - 167;

        if(finaldestination <= 0) {
          finaldestination = 0;

        } else if(finaldestination + sideBarHeight > leftSideBarHeight) {
          finaldestination = leftSideBarHeight - sideBarHeight + 35;
        }
      }
      
      if(vertical){
        moveSideBar(finaldestination, 200);
      } else {
        moveSideBar(finaldestination, 0);
      }
    
  }

  function moveSideBar(finaldestination, speed) {

    sideBar.stop().animate({ 'top': finaldestination }, speed);

  }  


  $(function () {
    $('[data-toggle="tooltip"]').tooltip()
  })

  $('.phs_image_slider').slick({
      slidesToShow: 1,
      accessibility: false,
      autoplay: false,
      variableWidth: false,
      adaptiveHeight: true
  });
 
  // $(document).ready(function() {
  //   $('#imageGallery').lightSlider({
  //       item:1, 
  //   });
  // });
  
  
  $(function () {
      $('[data-toggle="tooltip"]').tooltip()
  });

  var $check_in, $check_out, $map, check_in_picker, check_out_picker, map;
  if (window.location.hash === '#request-modal-add-pet') {
    $('#request-modal-add-pet').modal('show');
  }
  if (window.location.hash === '#request-modal') {
    $('#request-modal').modal('show');
  }
  if (window.location.hash === '#confirm-modal') {
    $('#confirm-modal').modal('show');
  }

  $map = $('#map');
  map = new GMaps({
      div: '#map',
      lat: $map.data('lat'),
      lng: $map.data('lng'),
      minZoom: 10,
      maxZoom: 14,
      disableDefaultUI: true,
      scrollwheel: false,
      draggable: false
  });
  map.addMarker({
      lat: $map.data('lat'),
      lng: $map.data('lng'),
      icon: 'https://res.cloudinary.com/hxnfgf9c2/image/upload/v1414374978/map_marker.png'
   });
  $('#map').mouseenter(function(evt) {
    if (!map.hover) {
      map.hover = true;
      return map.setOptions({
        panControl: true,
        zoomControl: true,
        zoomControlOptions: {
          style: google.maps.ZoomControlStyle.LARGE
        }
      });
    }
  });
  $('body').mouseover(function(evt) {
    if (map.hover) {
      if ($(evt.target).closest('#map').length === 0) {
        map.hover = false;
        return map.setOptions({
          panControl: false,
          zoomControl: false
        });
      }
    }
  });
  
  $check_in = $('#enquiry_check_in_date');
  check_in_picker = $check_in.datepicker({
    format: 'dd/mm/yyyy',
    startDate: '0d',
    autoclose: true
  }).on('changeDate', function(evt) {
    var inDate;
    inDate = new Date(evt.date);
    check_out_picker.setDate(inDate);
    check_out_picker.startDate = inDate;
    check_out_picker.update();
    return $check_out.focus();
  }).data('datepicker');
  $check_out = $('#enquiry_check_out_date');
  check_out_picker = $check_out.datepicker({
    format: 'dd/mm/yyyy',
    startDate: '0d',
    autoclose: true
  }).data('datepicker');
  $('.enquiry_check_in_date .input-group-addon').on('click', function(evt) {
    evt.preventDefault();
    check_out_picker.hide();
    return check_in_picker.show();
  });
  $('.enquiry_check_out_date .input-group-addon').on('click', function(evt) {
    evt.preventDefault();
    check_in_picker.hide();
    return check_out_picker.show();
  });