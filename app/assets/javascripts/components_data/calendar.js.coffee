$ ->
  CalendarData = flight.component ->
    @attributes
      infoURL: '/availability/booking_info'
      createUnavailableDateURL: '/unavailable_dates'

    @fetchCalendarInfo = (e, data) ->
      @get
        xhr:
          url: @attr.infoURL
          data:
            start: data.start
            end:   data.end
        events:
          done: 'dataCalendarInfo'

    @createUnavailableDate = (e, payload) ->
      @post
        xhr:
          url: @attr.createUnavailableDateURL
          data:
            unavailable_date:
              date: payload.date
        events:
          done: 'dataUnavailableDateCreated'
        meta:
          date: payload.date

    @destroyUnavailableDate = (e, payload) ->
      @delete
        xhr:
          url: "#{@attr.createUnavailableDateURL}/#{payload.unavailability_id}"
          data: {}
        events:
          done: 'dataUnavailableDateDestroyed'
        meta:
          date: payload.date

    @after 'initialize', ->
      @on 'uiNeedsCalendarInfo', @fetchCalendarInfo
      @on 'uiCreateUnavailableDate',  @createUnavailableDate
      @on 'uiDestroyUnavailableDate', @destroyUnavailableDate

  , ajaxMixin


  CalendarData.attachTo document
