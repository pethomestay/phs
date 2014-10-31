$ ->
  UserCalendarUI = flight.component ->
    @attributes
      bodySelector:  'tbody'
      datesSelector: 'td[data-date]'
      todaySelector: "td[data-date='#{moment().format('YYYY-MM-DD')}']"

    @highlightDates = (e, data) ->
      for d in data
        $date = $("td[data-date='#{d.date}']")
        if d.status == 'booked'
          $date.addClass 'booked'
        else if d.status == 'unavailable'
          $date.addClass 'unavailable'
          $date.data 'unavailable-date-id', d.unavailable_date_id

    @highlightToday = ->
      $today = @select('todaySelector')
      $today.addClass 'today' unless $today.hasClass('ignored')

    @darkenUnavailableDate = (e, data, meta) ->
      @$node.find("td[data-date=#{meta.date}]").removeClass 'unavailable'

    @highlightUnavailableDate = (e, data, meta) ->
      d = @$node.find("td[data-date=#{meta.date}]")
      d.data 'unavailable-date-id', data.id
      d.addClass 'unavailable'

    @updateAvailableDate = (e) ->
      return if window.location.pathname.toLowerCase().indexOf('guest') > -1
      # Note e.target is often span, so we need to get its parent when this happens
      if e.target.tagName == 'SPAN'
        $date = $(e.target).parent()
      else if e.target.tagName == 'TD'
        $date = $(e.target)
      return if $date.hasClass('ignored') or $date.hasClass('booked') or $date.hasClass('today')
      if $date.hasClass 'unavailable'
        @trigger 'uiDestroyUnavailableDate',
          date: $date.data('date')
          unavailable_date_id: $date.data('unavailable-date-id')
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
      start = d.subtract(6, 'weeks').format('YYYY-MM-DD')
      end   = d.add(41, 'days').format('YYYY-MM-DD')
      @trigger 'uiNeedsCalendarAvailability',
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
      @on document, 'dataCalendarAvailability', @highlightDates
      @on document, 'dataUnavailableDateCreated',   @highlightUnavailableDate
      @on document, 'dataUnavailableDateDestroyed', @darkenUnavailableDate


  UserCalendarUI.attachTo '.right-panel .calendar'
