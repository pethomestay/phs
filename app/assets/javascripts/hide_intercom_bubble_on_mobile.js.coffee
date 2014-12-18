$ ->
  if $('#xs-indicator').is ':visible'
    window.onscroll = (e) ->
      if typeof(Intercom) != 'undefined'
        Intercom 'shutdown'
