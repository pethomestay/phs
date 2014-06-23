window.scrollToListing = (id) ->
  $('.listing').removeClass 'highlight'
  $element = $("[data-listing='#{id}']")
  if $element.length > 0
    $(window).scrollTop($element.offset().top - 47)
    $element.addClass 'highlight'

$ ->
  if $('#search_location').length > 0
    if $('#search_location').attr('value') == ''
      getLocation (location) ->
        $('#search_location').attr 'value', location
  $('#search_location').change ->
    $('#search_latitude').val('')
    $('#search_longitude').val('')

  $(".sidebar-search input[type='checkbox']").change ->
    $(this).closest('form')[0].submit()

  nowTemp = new Date()
  now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)
  
  checkout = $("#check_out_datepicker").datepicker(
    format: "DD, d MM, yyyy"
    startDate: $("#check_in_datepicker").val() || now
  ).on("changeDate", (ev) ->
    checkout.hide()
    return
  ).data("datepicker")

  checkin = $("#check_in_datepicker").datepicker(
    format: "DD, d MM, yyyy"
    startDate: now
  ).on("changeDate", (ev) ->
    newDate = new Date(ev.date)
    checkout.setDate newDate
    checkout.startDate = newDate
    checkout.update()
    checkin.hide()
    $("#check_out_datepicker")[0].focus()
    return
  ).data("datepicker")

  $(".check_in_calendar_icon").on('click', (e) ->
    e.preventDefault
    checkin.show()
    checkout.hide()
  )

  $(".check_out_calendar_icon").on('click', (e) ->
    e.preventDefault
    checkin.hide()
    checkout.show()
  )
