$ ->
  SubNavUI = flight.component ->
    @attributes
      guestPillSelector: '.pill-guest'
      hostPillSelector:  '.pill-host'

    @mark_active = ->
      if window.location.pathname.match('guest')
        @select('guestPillSelector').addClass 'active'
      else if window.location.pathname.match('host')
        @select('hostPillSelector').addClass 'active'

    @after 'initialize', ->
      @mark_active()


  SubNavUI.attachTo '.sub-nav'
