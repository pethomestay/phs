$ ->
  $( "#distance-slider" ).slider
    value:20
    min: 10
    max: 100
    step: 5
    slide: (event, ui) ->
      $('#sitter_distance').val ui.value
      $('span.distance').text ui.value + 'km'
  $('#sitter_distance').val $( "#distance-slider" ).slider('value')
  $('span.distance').text $( "#distance-slider" ).slider('value') + 'km'
