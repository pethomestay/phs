$ ->
  $(document).on 'change', '.pet-type select', ->
    pet_type = $(this).val()
    $fields = $(this).parents('.pet-fields')
    $fields.find('.specific').hide().find('input, select').attr('disabled', 'disabled')
    if pet_type
      $fields.find(".specific.#{pet_type}").show().find('input, select').removeAttr('disabled')
  .change()

  $(".breed.dog select").chosen()

  $('[name="user[homestay_attributes][is_homestay]"], [name="user[homestay_attributes][is_sitter]"], [name="user[homestay_attributes][is_services]"], [name="homestay[is_homestay]"], [name="homestay[is_sitter]"], [name="homestay[is_services]"]').change ->
    $('.homestay-form .specific').hide()
    $(".specific.homestay").show() if $('[name="user[homestay_attributes][is_homestay]"]:checked, [name="homestay[is_homestay]"]:checked').length > 0
    $(".specific.sitter").show() if $('[name="user[homestay_attributes][is_sitter]"]:checked, [name="homestay[is_sitter]"]:checked').length > 0
    $(".specific.services").show() if $('[name="user[homestay_attributes][is_services]"]:checked, [name="homestay[is_services]"]:checked').length > 0
  .change()

  $(document).on 'change', '.dislikes input', ->
    if $('.dislikes input:checked').length > 0
      $('.explain-dislikes').removeClass 'hide'
    else
      $('.explain-dislikes').addClass 'hide'
  .change()

  $('form').nestedFields(containerSelector: '.homestay-pictures tbody');
