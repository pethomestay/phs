$ ->
  CalendarData = flight.component ->
    @attributes
      guestAvailabilityURL: '/guest/calendar/availability'
      hostAvailabilityURL:  '/host/calendar/availability'
      createUnavailableDateURL: '/unavailable_dates'

    @getCalendarAvailability = (e, data) ->
      if window.location.pathname.toLowerCase().indexOf('guest') > -1 # pathname contains substring 'host'
        @get
          xhr:
            url: @attr.guestAvailabilityURL
            data:
              start: data.start # YYYY-MM-DD
              end:   data.end   # YYYY-MM-DD
          events:
            done: 'dataCalendarAvailability'
      else if window.location.pathname.toLowerCase().indexOf('host') > -1
        @get
          xhr:
            url: @attr.hostAvailabilityURL
            data:
              start: data.start # YYYY-MM-DD
              end:   data.end   # YYYY-MM-DD
          events:
            done: 'dataCalendarAvailability'

    @getHomestayAvailability = (e, data) ->
      @get
        xhr:
          url: @attr.hostAvailabilityURL
          data:
            start: data.start # YYYY-MM-DD
            end:   data.end   # YYYY-MM-DD
            user_id: data.user_id # user's id
        events:
          done: 'dataHomestayAvailability'

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
          url: "#{@attr.createUnavailableDateURL}/#{payload.unavailable_date_id}"
          data: {}
        events:
          done: 'dataUnavailableDateDestroyed'
        meta:
          date: payload.date

    @after 'initialize', ->
      @on 'uiNeedsCalendarAvailability', @getCalendarAvailability
      @on 'uiNeedsHomestayAvailability', @getHomestayAvailability
      @on 'uiCreateUnavailableDate',  @createUnavailableDate
      @on 'uiDestroyUnavailableDate', @destroyUnavailableDate

  , ajaxMixin


  CalendarData.attachTo document
