$ ->
  SwitcherUI = flight.component ->
    @attributes
      leftChevronSelector: 'i.left'
      rightChevronSelector: 'i.right'
      currentMonthSelector: '.current-month'

    @updateHeader = (current) ->
      $currentMonth = @select('currentMonthSelector')
      $currentMonth.text(current.format('MMMM YYYY'))

    @after 'initialize', ->
      current = moment()
      @updateHeader(current)
      leftChevron = @select('leftChevronSelector')
      rightChevron = @select('rightChevronSelector')
      @on leftChevron, 'click', ->
        current.subtract 1, 'months'
        @updateHeader(current)
        @trigger '.right-panel .calendar', 'uiShowPrevMonth'
        leftChevron.css('visibility', 'hidden') if current.month() == moment().month()
      @on rightChevron, 'click', ->
        current.add 1, 'months'
        @updateHeader(current)
        @trigger '.right-panel .calendar', 'uiShowNextMonth'
        leftChevron.css('visibility', 'visible')


  SwitcherUI.attachTo '.right-panel .switcher'
