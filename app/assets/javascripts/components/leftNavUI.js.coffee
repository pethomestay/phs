$ ->
  LeftNavUI = flight.component ->
    @attributes
      itemsSelector: 'li'
      calendarItemSelector: 'li.calendar'

    @hide = ->
      @$node.addClass 'hidden-xs'

    @calendarItemClicked = (e) ->
      e.preventDefault()
      @trigger '.main-panel',  'calendarItemClicked'
      @trigger '.right-panel', 'calendarItemClicked'
      if $('#xs-indicator').is ':visible'
        @hide()
      else
        # Mark calendarItem active
        @select('itemsSelector').removeClass 'active'
        @select('calendarItemSelector').addClass 'active'

    @after 'initialize', ->
      calendarItem = @select('calendarItemSelector')
      @on calendarItem, 'click', @calendarItemClicked


  LeftNavUI.attachTo '.left-nav'
