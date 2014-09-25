$ ->
  ConversationUI = flight.component ->
    @attributes
      headerSelector:  '.header:first-child'
      chevronSelector: '.header:first-child .fa'
      replyBtnSelector: 'a.reply.btn'
      newMsgFormContainerSelector: '.new-msg-form-container'
      newMsgFormSelector: '.new-msg-form-container form'

    @toggleChevron = ->
      $chevron = @select('chevronSelector')
      $chevron.toggleClass('fa-chevron-up')
      $chevron.toggleClass('fa-chevron-down')

    @toggleConversation = ->
      if @$node.hasClass 'unread'
        id = @$node.data('id')
        @trigger 'uiMarkConversationRead', id
        @$node.removeClass('unread')
      @$node.children().slice(1).not(@attr.newMsgFormContainerSelector).slideToggle()
      @toggleChevron()
      @$node.toggleClass 'expanded'

    @showNewMsgForm = ->
      @select('replyBtnSelector').addClass 'disabled'
      @select('newMsgFormContainerSelector').slideDown()

    @sendMsg = (e) ->
      # TODO: prevent sending empty messages
      e.preventDefault()
      $form = @select('newMsgFormSelector')
      $form.find('button').addClass 'disabled'
      message =
        id: @$node.data('id') # Conversation ID
        message_text: $form.find('textarea').val()
      @trigger 'uiSendMessage', message

    @msgSentCallback = (e, xhr, meta) ->
      if meta.id == @$node.data('id')
        # TODO: add new message without refreshing
        $.growl 'Message sent. Refresh to view the new message.',
          type: 'success'
        @select('newMsgFormContainerSelector').slideUp()
        $form = @select('newMsgFormSelector')
        $form.find('textarea').val ''
        $form.find('button').removeClass 'disabled'
        @select('replyBtnSelector').removeClass 'disabled'

    @msgFailedCallback = (e, xhr, meta) ->
      if meta.id == @$node.data('id')
        $.growl 'Failed to send message. Please check network connection.',
          type: 'danger'
        @select('newMsgFormSelector').find('button').removeClass 'disabled'

    @after 'initialize', ->
      @on @select('headerSelector'),     'click',  @toggleConversation
      @on @select('replyBtnSelector'),   'click',  @showNewMsgForm
      @on @select('newMsgFormSelector'), 'submit', @sendMsg
      @on document, 'dataMessageSent',   @msgSentCallback
      @on document, 'dataMessageFailed', @msgFailedCallback


  ConversationUI.attachTo '.messages-panel .conversation'
