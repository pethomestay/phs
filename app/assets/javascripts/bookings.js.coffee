$ ->
  # Pet stuff
  $('.payment_form').validate
    rules:
      EPS_CCV:
        minlength: 3,
        maxlength: 4,
        digits: true
      EPS_CARDNUMBER:
        minlength: 13,
        maxlength: 16,
        digits: true
    highlight: (element, error, valid) ->
      $(element).closest(".control-group").addClass("error").removeClass "success"
      return
    unhighlight: (element, error, valid) ->
      $(element).closest(".control-group").removeClass("error").addClass "success"
      return


  fractionalPart = (value) ->
    stringValue = value.toString()
    if stringValue.split('.').length == 1
      return '.00'
    else
      if stringValue.split('.')[1].length == 1
        return '.' + stringValue.split('.')[1] + '0'
      else
        return '.' + stringValue.split('.')[1]

  updateTransactionFromServer = (number_of_nights_input) ->
    $.ajax '/bookings/update_transaction',
      data:
        number_of_nights: number_of_nights_input.val(),
        booking_id: $('[name="booking[id]"]').val(),
        check_in_date: $('[name="booking[check_in_date]"]').val(),
        check_out_date: $('[name="booking[check_out_date]"]').val(),
      success: (data) ->
        $('[name="booking[subtotal]"]').val(parseInt(data['booking_subtotal']))
        $('[name="booking[subtotal]"]').next().html(fractionalPart(data['booking_subtotal']))
        $('[name="booking[amount]"]').val(parseInt(data['booking_amount']))
        $('[name="booking[amount]"]').next().html(fractionalPart(data['booking_amount']))
        $('[name="booking[fees]"]').val(parseInt(data['transaction_fee']))
        $('[name="booking[fees]"]').next().html(fractionalPart(data['transaction_fee']))

        $('[name="EPS_TIMESTAMP"]').val(data['transaction_time_stamp'])
        $('[name="EPS_AMOUNT"]').val(data['transaction_actual_amount'])
        $('[name="EPS_FINGERPRINT"]').val(data['transaction_merchant_fingerprint'])
        $("#datepicker-check-in-date, #datepicker-check-out-date").closest(".control-group").removeClass("error")
        $("#check_in_date_error").hide().text("")
      error: (data) ->
        error = $.parseJSON(data.responseText).error
        $("#datepicker-check-in-date, #datepicker-check-out-date").closest(".control-group").addClass("error").removeClass "success"
        $("#check_in_date_error").show().text(error)
        $("html, body").animate 
          scrollTop: $(".container.main").offset().top
          , 500
        event.stopPropagation

  setNumberOfNights = ->
    number_of_nights_input = $('[name="booking[number_of_nights]"]')
    check_in_date = new Date($('input.checkin').val().split('/').reverse().join('/'))
    check_out_date = new Date($('input.checkout').val().split('/').reverse().join('/'))
    time_difference = Math.abs(check_out_date.getTime() - check_in_date.getTime())
    number_of_nights = Math.ceil(time_difference / (1000 * 3600 * 24))
    if parseInt(number_of_nights) <= 0
      number_of_nights = 1
    number_of_nights_input.val(number_of_nights)
    updateTransactionFromServer(number_of_nights_input)

  if $('#datepicker-check-in-date').length is 0
    $('.date_picker').siblings('span').attr('disabled', 'disabled')
  else
    nowTemp = new Date()
    unavailable_dates = []
    if $("#unavailable_dates").length isnt 0
      unavailable_dates = (+new Date date for date in $("#unavailable_dates").data("unavailable-dates").split(","))

    checkin = $('#datepicker-check-in-date').datepicker(
      format: 'dd/mm/yyyy'
      startDate: new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0)
      beforeShowDay: (date) ->
        if ($.inArray(+date, unavailable_dates) != -1)
          prev_unavailable_date = new Date(date)
          prev_unavailable_date.setDate(prev_unavailable_date.getDate() - 1)
          if ($.inArray(+prev_unavailable_date, unavailable_dates) != -1)
            return enabled: false
    ).on('changeDate', (ev) ->
      newDate = new Date(ev.date)
      if checkout.date.getTime() < newDate.getTime()
        checkout.setDate newDate
      checkout.startDate = newDate
      checkout.update()
      checkin.hide()
      setNumberOfNights()
    ).data('datepicker')

    checkout = $('#datepicker-check-out-date').datepicker(
      format: 'dd/mm/yyyy'
      startDate: new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0)
      beforeShowDay: (date) ->
        if ($.inArray(+date, unavailable_dates) != -1)
          prev_unavailable_date = new Date(date)
          prev_unavailable_date.setDate(prev_unavailable_date.getDate() - 1)
          if ($.inArray(+prev_unavailable_date, unavailable_dates) != -1)
            return enabled: false
    ).on('changeDate', (ev) ->
      if $('[name="booking[number_of_nights]"]').val() != undefined
        setNumberOfNights()
      return
    ).data('datepicker')
    
    $(".booking_check_in_date span.add-on, .enquiry_check_in_date span.add-on").on('click', (e) ->
      e.preventDefault
      checkin.show()
      checkout.hide()
    )

    $(".booking_check_out_date span.add-on, .enquiry_check_out_date span.add-on").on('click', (e) ->
      e.preventDefault
      checkin.hide()
      checkout.show()
    )

  $('input', 'div.datepicker').css('cursor', 'default')
  $('input', 'div.timepicker').css('cursor', 'default')

  $('.timepicker').datetimepicker({ language: 'en', pickSeconds: false, pickDate: false, pick12HourFormat: true })

  $('input', 'div.timepicker').on 'click', ->
    $(this).siblings('span').click()

  set_eps_result_url = ->
    if $('#EPS_RESULTURL').val() != undefined
      string = $('#EPS_RESULTURL').val().split('=')[0] + '=' + $('[name="csrf-token"]').attr('content')
      $('#EPS_RESULTURL').val('')
      $('#EPS_RESULTURL').val(string)

  $('#booking-tooltip').tooltip()

  $('[type="submit"]').on 'click', (e) ->
    if $('[name="booking[id]"]').val() != undefined
      e.preventDefault()
      $.ajax '/bookings/update_message',
        data:
          booking_id: $('[name="booking[id]"]').val(),
          message: $('[name="booking[message]"]').val(),
          check_in_time: $('[name="booking[check_in_time]"]').val(),
          check_out_time: $('[name="booking[check_out_time]"]').val(),
          check_in_date: $('[name="booking[check_in_date]"]').val(),
          check_out_date: $('[name="booking[check_out_date]"]').val()
        success: () ->
          set_eps_result_url()
          $("#datepicker-check-in-date, #datepicker-check-out-date").closest(".control-group").removeClass("error")
          $("#check_in_date_error").hide().text("")
          $('.payment_form').submit()
        error: (data) ->
          error = $.parseJSON(data.responseText).error
          $("#datepicker-check-in-date, #datepicker-check-out-date").closest(".control-group").addClass("error").removeClass "success"
          $("#check_in_date_error").show().text(error)
          $("html, body").animate 
            scrollTop: $(".container.main").offset().top
            , 500
          event.stopPropagation

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
    $('[name="stored_card_transaction_action"]').val($('.payment_form').attr('action'))
  $('[name="transaction[use_stored_card]"]').on 'change', ->
    $('div.credit_card_fields').slideToggle()
    if $(this).prop('checked') == true
      $('.payment_form').attr('action', $('[name="stored_card_transaction_action"]').val())
    else
      $('.payment_form').attr('action', $('[name="securepay_transaction_action"]').val())

  $('input[type="radio"]:checked').parent().css('color', '#EA6E28')
  $('input[type="radio"]').on 'change', ->
    $('input[type="radio"]:unchecked').parent().css('color', 'black')
    $('input[type="radio"]:checked').parent().css('color', '#EA6E28')
