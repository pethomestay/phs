$ ->
  CalendarUI = flight.component ->
    @attributes
      bodySelector:  'tbody'
      datesSelector: 'td[data-date]'
      todaySelector: "td[data-date='#{moment().format('YYYY-MM-DD')}']"

    @highlightInfo = (e, dates) ->
      for date in dates
        d = $("td[data-date='#{date.start}']")
        if date.title == 'Unavailable'
          d.data 'unavailability-id', date.id
          d.addClass 'unavailable'
        else if date.title == 'Booked'
          d.addClass 'booked'

    @highlightToday = ->
      $today = @select('todaySelector')
      $today.addClass 'today' unless $today.hasClass('ignored')

    @darkenUnavailableDate = (e, data, meta) ->
      @$node.find("td[data-date=#{meta.date}]").removeClass 'unavailable'

    @highlightUnavailableDate = (e, data, meta) ->
      d = @$node.find("td[data-date=#{meta.date}]")
      d.data 'unavailability-id', data.id
      d.addClass 'unavailable'

    @updateAvailableDate = (e) ->
      # Note e.target is often span, so we need to get its parent when this happens
      if e.target.tagName == 'SPAN'
        $date = $(e.target).parent()
      else if e.target.tagName == 'TD'
        $date = $(e.target)
      return if $date.hasClass('ignored') or $date.hasClass('booked') or $date.hasClass('today')
      if $date.hasClass 'unavailable'
        @trigger 'uiDestroyUnavailableDate',
          date: $date.data('date')
          unavailability_id: $date.data('unavailability-id')
      else
        @trigger 'uiCreateUnavailableDate',
          date: $date.data('date')

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
      @highlightToday()
      # Request calendar info
      start = d.subtract(6, 'weeks').unix()
      end   = d.add(41, 'days').unix()
      @trigger 'uiNeedsCalendarInfo',
        start: start
        end:   end
      @on @select('datesSelector'), 'click', @updateAvailableDate

    @after 'initialize', ->
      current = moment()
      @draw current
      @on 'uiShowPrevMonth', ->
        current.subtract 1, 'months'
        @draw current
      @on 'uiShowNextMonth', ->
        current.add 1, 'months'
        @draw current
      @on document, 'dataCalendarInfo', @highlightInfo
      @on document, 'dataUnavailableDateCreated',   @highlightUnavailableDate
      @on document, 'dataUnavailableDateDestroyed', @darkenUnavailableDate


  CalendarUI.attachTo '.right-panel .calendar'
