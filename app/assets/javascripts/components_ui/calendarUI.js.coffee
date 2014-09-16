$ ->
  CalendarUI = flight.component ->
    @attributes
      bodySelector:  'tbody'
      todaySelector: "td[data-date='#{moment().format('YYYY-MM-DD')}']"

    @highlight_info = (dates) ->
      for date in dates
        if date.title == 'Unavailable'
          $("td[data-date='#{date.start}']").addClass 'unavailable'
        else if date.title == 'Booked'
          $("td[data-date='#{date.start}']").addClass 'booked'

    @highlight_today = ->
      $today = @select('todaySelector')
      $today.addClass 'today' unless $today.hasClass('ignored')

    @draw = (current) ->
      $body = @select('bodySelector')
      # Clear existing calendar
      $body.html('')
      # Move to the first entry of calendar
      d = moment(current).date(1)
      d.subtract d.day(), 'days'
      # Draw 6 line>
      today = moment()
      for _ in [1..6]
        week = ''
        for __ in [1..7]
          if d.month() != current.month() or d.isBefore(today, 'day')
            week += "<td class='ignored' data-date='#{d.format('YYYY-MM-DD')}'><span>#{d.date()}</span></td>"
          else
            week += "<td data-date='#{d.format('YYYY-MM-DD')}'><span>#{d.date()}</span></td>"
          d.add 1, 'days'
        $body.append "<tr class='week'>#{week}</tr>"
      # Highlight today
      @highlight_today()
      # Request calendar info
      start = d.subtract(6, 'weeks').unix()
      end   = d.add(41, 'days').unix()
      @trigger 'uiNeedsCalendarInfo', {
        start: start
        end:   end
      }

    @after 'initialize', ->
      current = moment()
      @draw current
      @on 'uiShowPrevMonth', ->
        current.subtract 1, 'months'
        @draw current
      @on 'uiShowNextMonth', ->
        current.add 1, 'months'
        @draw current
      @on document, 'dataCalendarInfo', (e, data) ->
        @highlight_info(data)

  CalendarUI.attachTo '.right-panel .calendar'
