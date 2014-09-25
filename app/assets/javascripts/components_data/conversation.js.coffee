$ ->
  ConversationData = flight.component ->
    @attributes
      markReadURL: '/guest/conversation/mark_read'
      sendMsgURL:  '/guest/messages'

    @mark_read = (e, id) ->
      @post
        xhr:
          url: @attr.markReadURL
          data:
            id: id
        events: {}

    @send_msg = (e, message) ->
      @post
        xhr:
          url: @attr.sendMsgURL
          data: message
        events:
          done: 'dataMessageSent'
          fail: 'dataMessageFailed'
        meta:
          id: message.id

    @after 'initialize', ->
      @on 'uiMarkConversationRead', @mark_read
      @on 'uiSendMessage',          @send_msg

  , ajaxMixin

  ConversationData.attachTo document
