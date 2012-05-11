$ ->
  $('.navbar .login-dropdown .dropdown-menu').find('label, input').click (e) ->
    e.stopImmediatePropagation()
