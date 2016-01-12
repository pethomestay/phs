$(document).ready(function() {

  var checkIn = $('#search_check_in_date');
  var checkOut = $('#search_check_out_date');

  var checkInPicker = checkIn.datepicker({
    autoclose: true,
    format: 'dd/mm/yyyy',
    maxViewMode: 'days',
    minViewMode: 'days',
    orientation: 'bottom right',
    startDate: '0d',
    todayHighlight: true
  }).on('show', function(e) {
    checkIn.closest('.input-group').addClass('active');
  }).on('hide', function(e) {
    checkIn.closest('.input-group').removeClass('active');
  }).on('changeDate', function(e) {
    inDate = new Date(e.date);
    checkOutPicker.setDate(inDate);
    checkOutPicker.startDate = inDate;
    checkOutPicker.update();
    checkOut.focus();
  }).data('datepicker');

  var checkOutPicker = checkOut.datepicker({
    autoclose: true,
    format: 'dd/mm/yyyy',
    orientation: 'bottom right',
    startDate: '0d',
    todayHighlight: true
  }).on('show', function(e) {
    checkOut.closest('.input-group').addClass('active');
  }).on('hide', function(e) {
    checkOut.closest('.input-group').removeClass('active');
  }).data('datepicker');

  $('ul.homestays li.homestay').on('click', function(e) {
    var el = $(this);
    var target = $(e.target);
    if(target.hasClass('fa-chevron-left') || target.hasClass('fa-chevron-right') || target.hasClass('nav')) {
      // Do nothing.
     } else {
       document.location = el.data('path');
     }
  });

  $('.reviews .public-reviews').slick({
    prevArrow: '<span class="nav prev"><i class="fa fa-chevron-left"></i></span>',
    nextArrow: '<span class="nav next"><i class="fa fa-chevron-right"></i></span>'
  });

});
