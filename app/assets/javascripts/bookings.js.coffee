
$ ->
  # Pet stuff
  $(".payment_form").validate
    rules:
      EPS_CCV:
        minlength: 3,
        maxlength: 3,
        digits: true
      EPS_CARDNUMBER:
        minlength: 16,
        maxlength: 16,
        digits: true

  $('.icon-calendar').datepicker({startDate: new Date(),date: new Date()}).on 'changeDate', (event) ->
    $(this).parent().siblings(".datepicker").val new XDate(event.date).toString('dd/MM/yyyy')

  $("#EPS_RESULTURL").val($("#EPS_RESULTURL").val() + $('[name="csrf-token"]').attr("content"))