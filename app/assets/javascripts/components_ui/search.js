$(document).ready(function() {

  var checkIn = $('#search_check_in_date');
  var checkOut = $('#search_check_out_date');

  var checkInPicker = checkIn.datepicker({
    autoclose: true,
    format: 'dd.mm.yy',
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
    format: 'dd.mm.yy',
    orientation: 'bottom right',
    startDate: '0d',
    todayHighlight: true
  }).on('show', function(e) {
    checkOut.closest('.input-group').addClass('active');
  }).on('hide', function(e) {
    checkOut.closest('.input-group').removeClass('active');
  }).data('datepicker');

});
