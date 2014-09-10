$ ->
  CalendarUI = flight.component ->
    @attributes
      bodySelector:  'tbody'
      todaySelector: "td[data-date='#{moment().format('YYYY-MM-DD')}']"

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
          if d.month() != (month-1)
            week += "<td class='ignored' data-date='#{d.format('YYYY-MM-DD')}'><span>#{d.date()}</span></td>"
          else
            week += "<td data-date='#{d.format('YYYY-MM-DD')}'><span>#{d.date()}</span></td>"
          d.add 1, 'days'
        $body.append "<tr class='week'>#{week}</tr>"
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
