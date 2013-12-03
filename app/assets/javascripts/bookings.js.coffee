
$ ->
  # Pet stuff
  console.log("here i am")
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

  $('.datepicker').datepicker()

  $("#EPS_RESULTURL").val($("#EPS_RESULTURL").val() + $('[name="csrf-token"]').attr("content"))