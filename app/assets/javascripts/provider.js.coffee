$ ->
  window.showSignIn = (e) ->
    $("#sign-up").fadeOut()
    $("#sign-in").fadeIn()

  window.showSignUp = (e) ->
    $("#sign-in").fadeOut()
    $("#sign-up").fadeIn()

  $("a[href=#sign-in]").click showSignIn
  $("a[href=#join-us]").click showSignUp
