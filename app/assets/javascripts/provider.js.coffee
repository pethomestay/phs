$ ->
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
      url = "#{window.location.pathname}/rating"
      $.post url, {_method: 'PUT', "rating[stars]": rating}, (response) ->
        $('#review-modal').modal('show')
        setTimeout ->
          $('.rater').parent().html('Thanks for giving your input.')
        , 500

  $('#review-modal .submit-review').click ->
    url = "#{window.location.pathname}/rating"
    review = $('.review-text').val()
    $.post url, {_method: 'PUT', "rating[review]": review}, (response) ->
      $('#review-modal').modal('hide')
      setTimeout ->
        window.location.reload true
      , 500

  $('.enquire-datepicker').datepicker
    dateFormat: "yy-mm-dd"
    minDate: 0
    onSelect: (dateText, inst) ->
      $('#enquiry_date').val dateText

  $('.carousel').carousel()
