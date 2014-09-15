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
      leftChevron = @select('leftChevronSelector')
      leftChevron.css('visibility', 'hidden')
      @on leftChevron, 'click', ->
        current.subtract 1, 'months'
        @updateCurrentMonth(current)
        @trigger '.right-panel .calendar', 'moveToPreviousMonth'
        leftChevron.css('visibility', 'hidden') if current.month() == moment().month()
      @on @attr.rightChevronSelector, 'click', ->
        current.add 1, 'months'
        @updateCurrentMonth(current)
        @trigger '.right-panel .calendar', 'moveToNextMonth'
        leftChevron.css('visibility', 'visible')


  SwitcherUI.attachTo '.right-panel .switcher'
