$ ->
  ConversationUI = flight.component ->
    @attributes
      headerSelector:  '.header:first-child'
      chevronSelector: '.header:first-child .fa'

    @toggleChevron = ->
      $chevron = @select('chevronSelector')
      $chevron.toggleClass('fa-chevron-up')
      $chevron.toggleClass('fa-chevron-down')

    @toggleConversation = ->
      if @$node.hasClass 'unread'
        id = @$node.data('id')
        @trigger 'uiMarkConversationRead', id
        @$node.removeClass('unread')
      @$node.children().slice(1).slideToggle()
      @toggleChevron()
      @$node.toggleClass 'expanded'

    @after 'initialize', ->
      $header = @select('headerSelector')
      @on $header, 'click', ->
        @toggleConversation()


  ConversationUI.attachTo '.messages-panel .conversation'
