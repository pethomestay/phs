$ ->
  HostSearchForm = flight.component ->
    @attributes
      locationInputSelector: 'input[name="search[location]"]'

    @validateNotEmpty = (e) ->
      locationInput = @select('locationInputSelector')
      if not locationInput.val()
        locationInput.popover('show')
        setTimeout ->
          locationInput.popover('hide')
        , 8000
        e.preventDefault()

    @after 'initialize', ->
      @on 'submit', @validateNotEmpty


  HostSearchForm.attachTo '.search-form'
