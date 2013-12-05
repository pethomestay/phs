
$ ->
  # Pet stuff
  $(".payment_form").validate
    rules:
      EPS_CCV:
        minlength: 3,
        maxlength: 4,
        digits: true
      EPS_CARDNUMBER:
        minlength: 13,
        maxlength: 16,
        digits: true

  $('.datepicker').datepicker({startDate: new Date(), date: new Date(), format: 'dd/mm/yyyy'}).on 'changeDate', (event) ->
    $(this).children("input").val new XDate(event.date).toString('dd/MM/yyyy')

  $("#EPS_RESULTURL").val($("#EPS_RESULTURL").val() + $('[name="csrf-token"]').attr("content"))

  $('#booking-tooltip').tooltip()