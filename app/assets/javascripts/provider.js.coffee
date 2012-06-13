$ ->
  window.showSignIn = (e) ->
    $("#sign-up").fadeOut()
    $("#sign-in").fadeIn()

  window.showSignUp = (e) ->
    $("#sign-in").fadeOut()
    $("#sign-up").fadeIn()

  $("a[href=#sign-in]").click showSignIn
  $("a[href=#join-us]").click showSignUp

  $stars = $('.rater i')
  $stars.each ->
    rating = $(this).index() + 1
    tip_message = (if rating == 1 then "Give 1 star" else "Give #{rating} stars")
    $(this).tooltip
      title: tip_message
    $(this).hover ->
      $stars.removeClass('icon-star-empty icon-star')
      $stars.slice(0, rating).addClass('icon-star')
      $stars.slice(rating).addClass('icon-star-empty')
    , ->
      $stars.removeClass("icon-star").addClass("icon-star-empty")
    $(this).click ->
      $('#review-modal').modal('show')
