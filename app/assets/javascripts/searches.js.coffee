$ ->
  if $('#search_location').length > 0
    if $('#search_location').attr('value') == ''
      getLocation (location) ->
        $('#search_location').attr 'value', location
