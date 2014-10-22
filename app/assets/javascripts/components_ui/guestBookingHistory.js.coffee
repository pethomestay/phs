$ ->
  BookingHistoryUI = flight.component ->
    @attributes
      headerSelector: '.header'
      bookingsSelector: '.booking'
      chevronSelector: '.fa.chevron'

    @toggleBookings = ->
      @select('chevronSelector').toggleClass 'fa-chevron-down'
      @select('chevronSelector').toggleClass 'fa-chevron-up'
      @select('bookingsSelector').slideToggle 'fast'
      @$node.toggleClass 'expanded'

    @after 'initialize', ->
      @on @select('headerSelector'), 'click', @toggleBookings


  BookingHistoryUI.attachTo '.favorites-panel .host'
