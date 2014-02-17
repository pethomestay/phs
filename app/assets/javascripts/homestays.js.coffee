$ ->
  $('.fa.fa-heart-o.favourite-unheart').on 'click', ->
    $this = $(this)
    $thisP = $(this).closest('p')
    favP = $('.fa.fa-heart.favourite-heart').closest('p')
    dataId = $this.closest('div').data('id')
    $.ajax "#{dataId}/favourite",
      success: ->
        $thisP.hide()
        favP.show()

  $('.fa.fa-heart.favourite-heart').on 'click', ->
    $this = $(this)
    $thisP = $(this).closest('p')
    nonFavP = $('.fa.fa-heart-o.favourite-unheart').closest('p')
    dataId = $this.closest('div').data('id')
    $.ajax "#{dataId}/non_favourite",
      success: ->
        $thisP.hide()
        nonFavP.show()

  $('a.fav-make-enquiry').on 'click', ->
    window.location = $(this).attr('href')

  $('a.remove-from-favourite').on 'click', ->
    $this = $(this)
    dataId = $this.closest('div').data('id')
    $.ajax "#{dataId}/non_favourite",
      success: ->
        $this.parent('div').parent().hide()
        if $this.parent('div').parent().siblings('div.well').length == 0
          $this.parent('div').parent().parent().append('<p>You have no favourites listing at the moment</p>')

  if window.location.href.match('homestays') && window.location.href.match('#enquiry')
    $('[data-toggle="modal"]').click()
