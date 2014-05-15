$ ->
  #calendar to show hosts availablity
  $("#calendar").fullCalendar
    viewDisplay: (view) ->
      $('.fc-view').find('td').css('cursor', 'auto')
      $('.fc-today').css('cursor', 'pointer')
      $('.fc-today').nextAll('td').css('cursor', 'pointer')
      $('.fc-today').closest('tr').nextAll('tr').find('td').css('cursor', 'pointer')

    events: "/availability/booking_info"

    dayClick: (date, allDay, jsEvent, view) ->
      return false if date < new Date().setHours(0,0,0,0)
      cal_event = ""
      $('#calendar').fullCalendar('clientEvents', (calEvent) ->
        if(isSameDate(date, calEvent.start))
          cal_event = calEvent 
      )
      alert(cal_event.id)
      if !cal_event.id
        create_unavailable_date(cal_event)
      else
        destroy_unavailable_date(cal_event)

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
