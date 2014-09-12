$ ->
  LeftNavUI = flight.component ->
    @attributes
      calendarItemSelector: 'li.calendar'

    @hide = ->
      @$node.addClass 'hidden-xs'

    @calendarItemClicked = (e) ->
      e.preventDefault()
      @trigger '.main-panel',  'calendarItemClicked'
      @trigger '.right-panel', 'calendarItemClicked'
      @hide() if $('#xs-indicator').is ':visible'

    @after 'initialize', ->
      calendarItem = @select('calendarItemSelector')
      @on calendarItem, 'click', @calendarItemClicked


  LeftNavUI.attachTo '.left-nav'
