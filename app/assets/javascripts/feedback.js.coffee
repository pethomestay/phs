$ ->
  $stars = $('.rater i')
  $stars.each ->
    rating = $(this).index() + 1
    tip_message = (if rating == 1 then "Give 1 star" else "Give #{rating} stars")
    $(this).tooltip
      title: tip_message
    $(this).hover ->
      $stars.removeClass('fa-star-o fa-star')
      $stars.slice(0, rating).addClass('fa-star')
      $stars.slice(rating).addClass('fa-star-o')
    , ->
      $stars.removeClass("fa-star").removeClass("fa-star-o")
      current = $('#feedback_rating').val()
      $stars.slice(0, current).addClass('fa-star')
      $stars.slice(current).addClass('fa-star-o')
    $(this).click ->
      $('#feedback_rating').val(rating)
