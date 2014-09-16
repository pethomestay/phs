$ ->
  CalendarData = flight.component ->
    @attributes
      infoURL: '/availability/booking_info'

    @fetchCalendarInfo = (e, data) ->
      @get
        xhr:
          url: @attr.infoURL
          data:
            start: data.start
            end:   data.end
        events:
          done: 'dataCalendarInfo'

    @after 'initialize', ->
      @on 'uiNeedsCalendarInfo', @fetchCalendarInfo

  , ajaxMixin

  CalendarData.attachTo document
