$ ->
  FavoriteUI = flight.component ->
    @attributes
      removeBtnSelector: '.remove-from-favourites'

    @remove = ->
      homestayID = @$node.data('homestay-id')
      $.get "/homestays/#{homestayID}/non_favourite"
      @$node.remove()
      # TODO: display a message when all favorites are gone

    @after 'initialize', ->
      @on @select('removeBtnSelector'), 'click', @remove


  FavoriteUI.attachTo '.favorite-host'
