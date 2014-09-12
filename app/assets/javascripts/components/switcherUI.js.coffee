$ ->
  SwitcherUI = flight.component ->
    @attributes
      leftChevronSelector: 'i.left'
      rightChevronSelector: 'i.right'
      currentMonthSelector: '.current-month'

    @updateCurrentMonth = (current) ->
      $currentMonth = @select('currentMonthSelector')
      $currentMonth.text(current.format('MMMM YYYY'))

    @after 'initialize', ->
      current = moment()
      @updateCurrentMonth(current)
      @on @attr.leftChevronSelector, 'click', ->
        current.subtract 1, 'months'
        @updateCurrentMonth(current)
        @trigger '.right-panel .calendar', 'moveToPreviousMonth'
      @on @attr.rightChevronSelector, 'click', ->
        current.add 1, 'months'
        @updateCurrentMonth(current)
        @trigger '.right-panel .calendar', 'moveToNextMonth'


  SwitcherUI.attachTo '.right-panel .switcher'
