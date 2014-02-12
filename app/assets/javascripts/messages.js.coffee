$ ->
  $('.ask-question-mailbox').on 'click', ->
    $('.message-text-mailbox').slideToggle()
    $(this).attr('disabled', true)

  $('.message-mailbox-cancel').on 'click', ->
    $('.message-text-mailbox').slideToggle()
    $('.ask-question-mailbox').attr('disabled', false)
