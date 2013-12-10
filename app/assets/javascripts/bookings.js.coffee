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

  $('.datepicker').datetimepicker({ language: 'en', pickTime: false, format: 'dd/MM/yyyy' }).on 'changeDate', (event) ->
    $(this).children("input").val new XDate(event.date).toString('dd/MM/yyyy')

  $('.timepicker').datetimepicker({ language: 'en', pickSeconds: false, pickDate: false, pick12HourFormat: true })

  $("#EPS_RESULTURL").val($("#EPS_RESULTURL").val() + $('[name="csrf-token"]').attr("content"))

  $('#booking-tooltip').tooltip()