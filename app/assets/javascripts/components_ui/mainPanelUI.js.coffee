$ ->
  MainPanelUI = flight.component ->
    @attributes

    @hide = ->
      @$node.addClass 'hidden-sm'
      @$node.addClass 'hidden-xs'

    @after 'initialize', ->
      @on 'calendarItemClicked', @hide


  MainPanelUI.attachTo '.main-panel'
