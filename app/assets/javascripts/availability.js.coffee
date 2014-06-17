$ ->
  #calendar to show hosts availablity
  $("#calendar").fullCalendar
    height: 500
    header:
      left: 'prev',
      center: 'title',
      right: 'next'

    events: "/availability/booking_info"

    viewDisplay: (view) ->
      now = new Date()
      cal_date_string = view.start.getMonth()+'/'+view.start.getFullYear()
      cur_date_string = now.getMonth()+'/'+now.getFullYear()
      if(cal_date_string == cur_date_string)
        jQuery('.fc-button-prev').addClass("fc-state-disabled")
      else
        jQuery('.fc-button-prev').removeClass("fc-state-disabled")

    eventAfterRender: (event, element, monthView) ->
      dateString = $.fullCalendar.formatDate(event.start, 'yyyy-MM-dd')
      $cell = $("td[data-date=" + dateString + "]")
      if ($cell.hasClass("fc-past") || $cell.hasClass("fc-other-month fc-future"))
        element.css("opacity", $cell.css("opacity"))
      if (event.title.match(/unavailable/i) != null)
        $cell.addClass("unavailable")
      else if (event.title.match(/booked/i) != null)
        $cell.css("cursor", "auto")


    dayClick: (date, allDay, jsEvent, view) ->
      return false if date < new Date().setHours(0,0,0,0)
      cal_event = ""
      $('#calendar').fullCalendar('clientEvents', (calEvent) ->
        if(isSameDate(date, calEvent.start))
          cal_event = calEvent 
      )
      return false if cal_event.title.match(/booked/i) != null
      if !cal_event.id
        create_unavailable_date(cal_event)
      else
        destroy_unavailable_date(cal_event)
        $(this).removeClass("unavailable")

  $("#update-calendar-btn").on "click", ->
    $.ajax
      url: "/users/update_calendar"
      type: "Post"
      success: (data)->
        $("#calendar_update_alert").show()
        setTimeout( "$('#calendar_update_alert').hide();", 2000);
      error: (request, status, error) ->
        #TODO change error handling
        console.log(request.responseText)

  create_unavailable_date = (calEvent) ->
    $.ajax
      url: "/unavailable_dates"
      data:
        "unavailable_date":
          "date": calEvent.start
      type: "Post"
      success: (data) ->
        console.log(data)
        calEvent.title = "Unavailable"
        calEvent.id = data["id"]
        $('#calendar').fullCalendar('updateEvent', calEvent)
      error: (request, status, error) ->
        #TODO change error handling
        console.log(request.responseText)

  destroy_unavailable_date = (calEvent) ->
    $.ajax
      url: "/unavailable_dates/" + calEvent.id
      type: "DELETE"
      success: (data)->
        console.log(data)
        calEvent.title = "Available"
        calEvent.id = ""
        $('#calendar').fullCalendar('updateEvent', calEvent)
      error: (request, status, error) ->
        #TODO change error handling
        console.log(request.responseText)

  isSameDate = (date1, date2) ->
    return date1.getUTCFullYear() == date2.getUTCFullYear() &&
         date1.getUTCMonth() == date2.getUTCMonth() &&
         date1.getUTCDate() == date2.getUTCDate()
