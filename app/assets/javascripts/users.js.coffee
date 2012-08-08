$ ->
  $('.pet-type select').live 'change', ->
    pet_type = $(this).val()
    $fields = $(this).parents('.pet-fields')
    $fields.find('.specific').hide().find('input, select').attr('disabled', 'disabled')
    if pet_type
      $fields.find(".specific.#{pet_type}").show().find('input, select').removeAttr('disabled')
  .change()

  $('[name="user[homestay_attributes][is_homestay]"], [name="user[homestay_attributes][is_sitter]"], [name="user[homestay_attributes][is_services]"]').change ->
    $('.homestay-form .specific').hide()
    $(".specific.homestay").show() if $('[name="user[homestay_attributes][is_homestay]"]:checked').length > 0
    $(".specific.sitter").show() if $('[name="user[homestay_attributes][is_sitter]"]:checked').length > 0
    $(".specific.services").show() if $('[name="user[homestay_attributes][is_services]"]:checked').length > 0
  .change()

  $('.dislikes input').live 'change', ->
    if $('.dislikes input:checked').length > 0
      $('.explain-dislikes').removeClass 'hide'
    else
      $('.explain-dislikes').addClass 'hide'
  .change()

  $('.unactivated').one 'click', ->
    $(this).removeClass('unactivated')

  window.addPet = ->
    numberOfPets = $('.pets').data('count')    
    pet = petTemplate
      index: numberOfPets
      number: numberOfPets + 1
    $('.pets').data('count', numberOfPets + 1)
    $('.add-pet').before(pet)
    $('.pet-type select').change()
