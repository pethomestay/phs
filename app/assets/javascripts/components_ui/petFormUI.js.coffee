$ ->
  PetFormUI = flight.component ->
    @attributes
      typesSelector:      '.pet_pet_type_id'
      otherTypeSelector:  '#pet_pet_type_id_5'
      typeDetailSelector: '.pet_other_pet_type'

    @toggleTypeDetail = ->
      $typeDetail = @select('typeDetailSelector')
      if @select('otherTypeSelector').is ':checked'
        $typeDetail.show()
      else
        $typeDetail.hide()

    @after 'initialize', ->
      @toggleTypeDetail()
      @on @select('typesSelector'), 'change', @toggleTypeDetail

  PetFormUI.attachTo '.pet-panel form'
