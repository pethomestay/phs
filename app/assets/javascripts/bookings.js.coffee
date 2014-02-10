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

  fractionalPart = (value) ->
    stringValue = value.toString()
    if stringValue.split('.').length == 1
      return ".00"
    else
      if stringValue.split('.')[1].length == 1
        return "." + stringValue.split('.')[1] + "0"
      else
        return "." + stringValue.split('.')[1]

  updateTransactionFromServer = (number_of_nights_input) ->
    url = window.location.origin + "/bookings/update_transaction"
    $.ajax url,
      data:
        number_of_nights: number_of_nights_input.val(),
        booking_id: $('[name="booking[id]"]').val(),
        check_in_date: $('[name="booking[check_in_date]"]').val(),
        check_out_date: $('[name="booking[check_out_date]"]').val(),
      success: (data) ->
        $('[name="booking[subtotal]"]').val(parseInt(data["booking_subtotal"]))
        $('[name="booking[subtotal]"]').next().html(fractionalPart(data["booking_subtotal"]))
        $('[name="booking[amount]"]').val(parseInt(data["booking_amount"]))
        $('[name="booking[amount]"]').next().html(fractionalPart(data["booking_amount"]))
        $('[name="booking[fees]"]').val(parseInt(data["transaction_fee"]))
        $('[name="booking[fees]"]').next().html(fractionalPart(data["transaction_fee"]))

        $('[name="EPS_TIMESTAMP"]').val(data["transaction_time_stamp"])
        $('[name="EPS_AMOUNT"]').val(data["transaction_actual_amount"])
        $('[name="EPS_FINGERPRINT"]').val(data["transaction_merchant_fingerprint"])

  setNumberOfNights = ->
    number_of_nights_input = $('[name="booking[number_of_nights]"]')
    check_in_date = new Date($('input.checkin', 'div.datepicker').val().split("/").reverse().join("-"))
    check_out_date = new Date($('input.checkout', 'div.datepicker').val().split("/").reverse().join("-"))
    time_difference = Math.abs(check_out_date.getTime() - check_in_date.getTime())
    number_of_nights = Math.ceil(time_difference / (1000 * 3600 * 24))
    if parseInt(number_of_nights) <= 0
      number_of_nights = 1
    if parseInt(number_of_nights_input.val()) != parseInt(number_of_nights)
      number_of_nights_input.val(number_of_nights)
      updateTransactionFromServer(number_of_nights_input)

#  $('.datepicker').datetimepicker({ language: 'en', pickTime: false, format: 'dd/MM/yyyy' }).on 'changeDate', (event) ->
#    $(this).children("input").val new XDate(event.date).toString('dd/MM/yyyy')
#    if $('[name="booking[number_of_nights]"]').val() != undefined
#      setNumberOfNights()

  nowTemp = new Date()
  now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
  nowTemp.setDate nowTemp.getDate() + 1
  secondPickerDate = nowTemp.getDate()
  secondPickerMonth = nowTemp.getMonth()
  secondPickerYear = nowTemp.getFullYear()
  #tempDate
  checkin = $("#xdpd1").datetimepicker(
    language: "en"
    pickTime: false
    format: "dd/MM/yyyy"
    startDate: new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0)
  ).on("changeDate", (ev) ->
    eventTarget = jQuery(ev.target)
    picker = eventTarget.data("datetimepicker")
    tempDate = new Date(picker.getLocalDate())
    tempDate.setDate tempDate.getDate() + 1
    if $("#xdpd2").length isnt 0
      $("#xdpd2").datetimepicker "destroy"
      $("#xdpd2").children("input").val new XDate(tempDate).toString("dd/MM/yyyy")
      tempDate.setDate tempDate.getDate() + 1
      checkout = $("#xdpd2").datetimepicker(
        language: "en"
        pickTime: false
        format: "dd/MM/yyyy"
        startDate: new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), 0, 0)
      ).on("changeDate", (ev) ->
        $(this).children("input").val new XDate(ev.date).toString("dd/MM/yyyy")
        return
      ).data("datepicker")
    return
  ).data("datepicker")



  $('input', 'div.datepicker').on 'click', ->
    $(this).siblings("span").click()

  $('input', 'div.datepicker').css('cursor', 'default')
  $('input', 'div.timepicker').css('cursor', 'default')

  $('.timepicker').datetimepicker({ language: 'en', pickSeconds: false, pickDate: false, pick12HourFormat: true })

  $('input', 'div.timepicker').on 'click', ->
    $(this).siblings("span").click()

  set_eps_result_url = ->
    if $("#EPS_RESULTURL").val() != undefined
      string = $("#EPS_RESULTURL").val().split("=")[0] + "=" + $('[name="csrf-token"]').attr("content")
      $("#EPS_RESULTURL").val("")
      $("#EPS_RESULTURL").val(string)

  $('#booking-tooltip').tooltip()

  $('[type="submit"]').on 'click', (e) ->
    if $('[name="booking[id]"]').val() != undefined
      e.preventDefault()
      url = window.location.origin + "/bookings/update_message"
      $.ajax url,
        data:
          booking_id: $('[name="booking[id]"]').val(),
          message: $('[name="booking[message]"]').val()
        success: (data) ->
          set_eps_result_url()
          $(".payment_form").submit()

  $('[name="transaction[store_card]"]').on 'change', ->
    if $(this).prop('checked') == true
      $('[name="EPS_STORE"]').removeAttr('disabled')
      $('[name="EPS_STORETYPE"]').removeAttr('disabled')
      $('[name="EPS_PAYOR"]').removeAttr('disabled')
    else
      $('[name="EPS_STORE"]').attr('disabled', 'disabled')
      $('[name="EPS_STORETYPE"]').attr('disabled', 'disabled')
      $('[name="EPS_PAYOR"]').attr('disabled', 'disabled')
  if $('[name="transaction[store_card]"]').prop('checked') == true
    $('[name="EPS_STORE"]').removeAttr('disabled')
    $('[name="EPS_STORETYPE"]').removeAttr('disabled')
    $('[name="EPS_PAYOR"]').removeAttr('disabled')
  else
    $('[name="EPS_STORE"]').attr('disabled', 'disabled')
    $('[name="EPS_STORETYPE"]').attr('disabled', 'disabled')
    $('[name="EPS_PAYOR"]').attr('disabled', 'disabled')

  if $('[name="stored_card_transaction_action"]').val() != undefined
    $('[name="stored_card_transaction_action"]').val($(".payment_form").attr("action"))
  $('[name="transaction[use_stored_card]"]').on 'change', ->
    $('div.credit_card_fields').slideToggle()
    if $(this).prop('checked') == true
      $(".payment_form").attr("action", $('[name="stored_card_transaction_action"]').val())
    else
      $(".payment_form").attr("action", $('[name="securepay_transaction_action"]').val())
