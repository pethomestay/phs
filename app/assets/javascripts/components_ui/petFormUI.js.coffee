$ ->
  PetFormUI = flight.component ->
    @attributes
      typesSelector:      '.pet_pet_type_id'
      dogTypeSelector:    '#pet_pet_type_id_1'
      otherTypeSelector:  '#pet_pet_type_id_5'
      dogBreedsSelector:  '.dog.breeds'
      typeDetailSelector: '.pet_other_pet_type'

    @toggleTypeDetail = ->
      $typeDetail = @select('typeDetailSelector')
      if @select('otherTypeSelector').is ':checked'
        $typeDetail.show()
      else
        $typeDetail.hide()

    @toggleBreeds = ->
      $dogBreeds   = @select('dogBreedsSelector')
      if @select('dogTypeSelector').is ':checked'
        $dogBreeds.show()
      else
        $dogBreeds.hide()
        $dogBreeds.find('select').val []

    @after 'initialize', ->
      @toggleBreeds()
      @toggleTypeDetail()
      @on @select('typesSelector'), 'change', ->
        @toggleBreeds()
        @toggleTypeDetail()

  PetFormUI.attachTo '.pet-panel form'
