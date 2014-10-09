$ ->
  PetFormUI = flight.component ->
    @attributes
      typesSelector:      '.pet_pet_type_id'
      dogTypeSelector:    '#pet_pet_type_id_1'
      otherTypeSelector:  '#pet_pet_type_id_5'
      dogBreedsSelector:  '.pet_breed'
      typeDetailSelector: '.pet_other_pet_type'
      uploadBtnSelector:  '.file-container input'

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

    @updateUploadBtn = (e) ->
      $icon = $(e.target).parent().find('i')
      $icon.removeClass 'fa-upload'
      $icon.addClass 'fa-image'
      $span = $(e.target).parent().find('span')
      $span.text 'Selected'

    @after 'initialize', ->
      @toggleBreeds()
      @toggleTypeDetail()
      @on @select('typesSelector'), 'change', ->
        @toggleBreeds()
        @toggleTypeDetail()
      @on 'nested:fieldAdded:pictures', ->
        @on @select('uploadBtnSelector'), 'change', @updateUploadBtn

  PetFormUI.attachTo '.pet-panel form'
