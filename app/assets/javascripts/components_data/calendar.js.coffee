$ ->
  CalendarData = flight.component ->
    @attributes
      guestAvailabilityURL: '/guest/calendar/availability'
      hostAvailabilityURL:  '/host/calendar/availability'
      createUnavailableDateURL: '/unavailable_dates'
      destroyBookingUnavailableDateURL: '/unavailable_dates/destroy_unavailable_booking_date'

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
            host_id: data.host_id # user id of homestay owner
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
          data:
            unavailable_date:
              date: payload.date
        events:
          done: 'dataUnavailableDateDestroyed'
        meta:
          date: payload.date

    @destroyUnavailableBookedDate = (e, payload) ->
      @delete
        xhr:
          url: "#{@attr.destroyBookingUnavailableDateURL}/#{payload.date}"
          data:
            unavailable_date:
              date: payload.date
        events:
          done: 'dataUnavailableBookedDateDestroyed'
        meta:
          date: payload.date

    @createUnavailableBookedDate = (e, payload) ->
      @post
        xhr:
          url: @attr.createUnavailableDateURL
          data:
            unavailable_date:
              date: payload.date
        events:
          done: 'dataUnavailableBookedDateCreated'
        meta:
          date: payload.date

    @after 'initialize', ->
      @on 'uiNeedsCalendarAvailability', @getCalendarAvailability
      @on 'uiNeedsHomestayAvailability', @getHomestayAvailability
      @on 'uiCreateUnavailableDate',  @createUnavailableDate
      @on 'uiDestroyUnavailableDate', @destroyUnavailableDate
      @on 'uiDestroyUnavailableBookedDate', @destroyUnavailableDate
      @on 'uiCestroyUnavailableBookedDate', @createUnavailableDate

  , ajaxMixin


  CalendarData.attachTo document
