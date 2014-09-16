$ ->
  CalendarUI = flight.component ->
    @attributes
      bodySelector:  'tbody'
      todaySelector: "td[data-date='#{moment().format('YYYY-MM-DD')}']"

    @mark_dates = (end) ->
      # Set start and end dates
      start = moment(end.format('YYYY-MM-DD'), 'YYYY-MM-DD')
      start.subtract 6, 'weeks'
      end.subtract 1, 'days'
      # Retrive status
      $.get '/availability/booking_info',
        start: start.unix()
        end: end.unix()
        (dates) ->
          for date in dates
            if date.title == 'Unavailable'
              $("td[data-date='#{date.start}']").addClass 'unavailable'
            else if date.title == 'Booked'
              $("td[data-date='#{date.start}']").addClass 'booked'

    @mark_today = ->
      $today = @select('todaySelector')
      $today.addClass 'today' unless $today.hasClass('ignored')

    @draw = (current) ->
      year  = current.year()
      month = current.month() + 1
      $body = @select('bodySelector')
      # Clear existing calendar
      $body.html('')
      # Move to the first entry of calendar
      d = moment("#{year}-#{month}-01", 'YYYY-MM-DD')
      d.subtract d.day(), 'days'
      # Draw 6 line>
      for _ in [1..6]
        week = ''
        for __ in [1..7]
          if d.month() != (month-1) or d.isBefore(moment(), 'day')
            week += "<td class='ignored' data-date='#{d.format('YYYY-MM-DD')}'><span>#{d.date()}</span></td>"
          else
            week += "<td data-date='#{d.format('YYYY-MM-DD')}'><span>#{d.date()}</span></td>"
          d.add 1, 'days'
        $body.append "<tr class='week'>#{week}</tr>"

      @mark_dates(d)
      @mark_today()

    @after 'initialize', ->
      current = moment()
      @draw current
      @on 'moveToPreviousMonth', ->
        current.subtract 1, 'months'
        @draw current
      @on 'moveToNextMonth', ->
        current.add 1, 'months'
        @draw current

  CalendarUI.attachTo '.right-panel .calendar'
