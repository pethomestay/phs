$ ->
  RightPanelUI = flight.component ->
    @attributes

    @show = ->
      @$node.removeClass 'hidden-sm'
      @$node.removeClass 'hidden-xs'

    @after 'initialize', ->
      @on 'calendarItemClicked', @show


  RightPanelUI.attachTo '.right-panel'
