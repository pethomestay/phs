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

  update_transaction_from_server = (number_of_nights_input) ->
    url = window.location.origin + "/bookings/update_transaction"
    $.ajax url,
      data:
        number_of_nights: number_of_nights_input.val(),
        booking_id: $('[name="booking[id]"]').val(),
      success: (data) ->
        $('[name="booking[subtotal]"]').val(data["booking_subtotal"])
        $('[name="booking[amount]"]').val(data["booking_amount"])
        $('[name="EPS_TIMESTAMP"]').val(data["transaction_time_stamp"])
        $('[name="EPS_AMOUNT"]').val(data["transaction_actual_amount"])
        $('[name="EPS_FINGERPRINT"]').val(data["transaction_merchant_fingerprint"])

  set_number_of_nights = ->
    number_of_nights_input = $('[name="booking[number_of_nights]"]')
    check_in_date = new Date($('input.checkin', 'div.datepicker').val().split("/").reverse().join("-"))
    check_out_date = new Date($('input.checkout', 'div.datepicker').val().split("/").reverse().join("-"))
    time_difference = Math.abs(check_out_date.getTime() - check_in_date.getTime())
    number_of_nights = Math.ceil(time_difference / (1000 * 3600 * 24))
    if (number_of_nights <= 0)
      number_of_nights = 1
    if parseInt(number_of_nights_input.val()) != parseInt(number_of_nights)
      number_of_nights_input.val(number_of_nights)
      update_transaction_from_server(number_of_nights_input)


  $('.datepicker').datetimepicker({ language: 'en', pickTime: false, format: 'dd/MM/yyyy' }).on 'changeDate', (event) ->
    $(this).children("input").val new XDate(event.date).toString('dd/MM/yyyy')
    if $('[name="booking[number_of_nights]"]') != undefined
      set_number_of_nights()

  $('input', 'div.datepicker').on 'click', ->
    $(this).siblings("span").click()

  $('.timepicker').datetimepicker({ language: 'en', pickSeconds: false, pickDate: false, pick12HourFormat: true })

  $('input', 'div.timepicker').on 'click', ->
    $(this).siblings("span").click()

  $("#EPS_RESULTURL").val($("#EPS_RESULTURL").val() + $('[name="csrf-token"]').attr("content"))

  $('#booking-tooltip').tooltip()