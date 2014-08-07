$ ->
  $('#new_homestay_modal').modal('show');
  $('.login-dropdown').popup().bind('popup:open', (event)->
    $('div.popup form input:first').focus()
  )

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
      $stars.removeClass("icon-star").removeClass("icon-star-empty")
      current = $('#feedback_rating').val()
      $stars.slice(0, current).addClass('icon-star')
      $stars.slice(current).addClass('icon-star-empty')
    $(this).click ->
      $('#feedback_rating').val(rating)

  $('.carousel').carousel()

  # listen for input file onchange
  $(document).on 'change', 'input:file', ->
    td = $(@).parent().parent().parent()
    # Try to resize image
    file = @files[0]
    reader = new FileReader()
    # callback: onprogress
    reader.onprogress = (e) ->
      console.log "Processing current image.."
    # callback: preview images
    set_preview = (data) ->
      img = $('#preview')
      if img.length
        img.attr 'src', data
      else
        img = $('<img id="preview" class="preview" alt="preview">')
        img.attr 'src', data
        img.appendTo td
    # callback: onload
    reader.onload = (e) ->
      Resample(
        e.target.result,
        null,
        300,
        set_preview,
      )
    # Fired if an error occur (i.e. security)
    reader.error = (e) ->
      td.html "Cannot load current image."
    # Read file
    reader.readAsDataURL(file);
