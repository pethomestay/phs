$ ->
  ConversationData = flight.component ->
    @attributes
      markReadURL: '/guest/conversation/mark_read'

    @mark_read = (e, id) ->
      @post
        xhr:
          url: @attr.markReadURL
          data:
            id: id
        events: {}

    @after 'initialize', ->
      @on 'uiMarkConversationRead', @mark_read

  , ajaxMixin

  ConversationData.attachTo document
