$ ->
  if $('#search_location').length > 0
    if $('#search_location').attr('value') == ''
      getLocation (location) ->
        $('#search_location').attr 'value', location
  $('#search_location').change ->
    $('#search_latitude').val('')
    $('#search_longitude').val('')

  $(".sidebar-search input[type='checkbox']").change ->
    $(this).closest('form')[0].submit()
