$ ->
  $('.pet-type select').live 'change', ->
    pet_type = $(this).val()
    $fields = $(this).parents('.pet-fields')
    $fields.find('.specific').hide()
    if pet_type
      $fields.find(".specific.#{pet_type}").show()
  .change()

  $('.dislikes input').live 'change', ->
    if $('.dislikes input:checked').length > 0
      $('.explain-dislikes').removeClass 'hide'
    else
      $('.explain-dislikes').addClass 'hide'
  .change()

  $('.unactivated').one 'click', ->
    $(this).removeClass('unactivated')

  $.fn.reset = ->
    $(this).find('input, select').val('')
    $(this).find('.specific').hide()

  exitingPetRowTemplate = Handlebars.compile($('#existing-pet-template').html())

  window.addPet = ->
    $('.existing-pets').removeClass('hide')
    newPetIndex = $('.existing-pets').data('count')
    name = $('.pet-fields').last().find(".name input").val()
    name = 'Unnamed' if name == ''
    newRow = exitingPetRowTemplate
      index: newPetIndex
      name: name
    $newFields = $('<div class="pet-fields">' + $('.pet-fields').first().html().replace(/attributes_0/g, "attributes_#{newPetIndex}").replace(/\[pets_attributes\]\[0\]/g, "[pets_attributes][#{newPetIndex}]") + '</div>')
    $newFields.reset()
    $('.existing-pets').data('count', newPetIndex + 1)
    $('.add-pet').before($newFields)
    $('.pet-fields').addClass('hide')
    $('.pet-fields').last().removeClass('hide')
    $('.existing-pets table').append newRow
  
  $('.pet-fields').first().removeClass('hide')
  $('.existing-pets').removeClass('hide') if $('.existing-pets').data('count') > 1

  window.switchPet = (i) ->
    $('.pet-fields').addClass('hide')
    $(".pet-fields:eq(#{i})").removeClass('hide')
