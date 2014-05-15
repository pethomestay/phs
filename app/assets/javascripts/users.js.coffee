$ ->
  # Pet stuff
  $(document).on 'change', '.pet-type select', ->
    pet_type = $(this).find('option:selected').text().toLowerCase()
    $fields = $(this).parents('.pet-fields')
    $fields.find('.specific').hide().find('input, select').attr('disabled', 'disabled')
    if pet_type
      $fields.find(".specific.#{pet_type}").show().find('input, select').removeAttr('disabled')

  $(document).on 'change', '.dislikes input', ->
    if $('.dislikes input:checked').length > 0
      $('.explain-dislikes').removeClass 'hide'
    else
      $('.explain-dislikes').addClass 'hide'

  $('.dislikes input').trigger('change')
  $('.pet-type select').trigger('change')
  $(".breed.dog select").chosen()

  $('[name="user[homestay_attributes][is_homestay]"], [name="user[homestay_attributes][is_sitter]"], [name="user[homestay_attributes][is_services]"], [name="homestay[is_homestay]"], [name="homestay[is_sitter]"], [name="homestay[is_services]"]').change ->
    $('.homestay-form .specific').hide()
    $(".specific.homestay").show() if $('[name="user[homestay_attributes][is_homestay]"]:checked, [name="homestay[is_homestay]"]:checked').length > 0
    $(".specific.sitter").show() if $('[name="user[homestay_attributes][is_sitter]"]:checked, [name="homestay[is_sitter]"]:checked').length > 0
    $(".specific.services").show() if $('[name="user[homestay_attributes][is_services]"]:checked, [name="homestay[is_services]"]:checked').length > 0

  $('[name="user[homestay_attributes][is_homestay]"], [name="user[homestay_attributes][is_sitter]"], [name="user[homestay_attributes][is_services]"], [name="homestay[is_homestay]"], [name="homestay[is_sitter]"], [name="homestay[is_services]"]').trigger('change')

  $('form').nestedFields(containerSelector: '.homestay-pictures tbody');

  $('a.enquiry-update-submit').on 'click', ->
    $(this).closest('form').submit()

  if window.location.href.match('my-account')
    $('.account', 'ul.nav.nav-pills').addClass('active')
  else if window.location.href.match('favourites')
    $('.favourites', 'ul.nav.nav-pills').addClass('active')
  else if window.location.href.match('trips')
    $('.trips', 'ul.nav.nav-pills').addClass('active')
  else if window.location.href.match('bookings')
    $('.bookings', 'ul.nav.nav-pills').addClass('active')
  else if window.location.href.match('mailbox')
    $('.messages', 'ul.nav.nav-pills').addClass('active')

  if window.location.href.match('users/edit')
    $('.personal', 'ul.nav.nav-tabs.nav-stacked').addClass('active')
  else if window.location.href.match('pets')
    $('.pet', 'ul.nav.nav-tabs.nav-stacked').addClass('active')
  else if window.location.href.match('homestays')
    $('.homestay-listing', 'ul.nav.nav-tabs.nav-stacked').addClass('active')
  else if window.location.href.match('accounts')
    $('.payout-details', 'ul.nav.nav-tabs.nav-stacked').addClass('active')

  rootLocation = window.location.protocol + '//' + window.location.hostname;
  if $('div.alert').val() != undefined
    if $('div.alert').text().match("A message with a confirmation link has been sent to your email address. Please open the link to activate your account.") && typeof(ga) != "undefined"
      ga 'set', 'location', rootLocation + "/users/sign_up/send_email"
      ga 'send', 'pageview',
        'page': '/users/sign_up/send_email',
        'title': 'Sign Up Successful'

    if $('div.alert').text().match("Your account was successfully confirmed. You are now signed in.")
      if (typeof(ga) != "undefined")
        ga 'set', 'location', rootLocation + '/users/sign_up/email_confirmation'
        ga 'send', 'pageview',
          'page': '/users/sign_up/email_confirmation',
          'title': 'SignUp Email confirmation'

  $( "#ask_host_a_question" ).click ->
    if (typeof(ga) != "undefined")
      ga 'set', 'location', rootLocation + '/homestays/ask_host_a_question'
      ga 'send', 'pageview',
        'page': '/homestays/ask_host_a_question',
        'title': 'Ask Host a Question'

  $( "#ask_host_a_question_submit" ).click (e) ->
    e.preventDefault()
    if (typeof(ga) != "undefined")
      ga 'set', 'location', rootLocation + '/homestays/ask_host_a_question/submit'
      ga 'send', 'pageview',
        'page': '/homestays/ask_host_a_question/submit',
        'title': 'Ask Host a Question Submit'

    $(this).closest('form').submit()

  $("#booking_confirm_by_host").click (e) ->
    e.preventDefault()
    $this = $(this)
    if $('[name="booking[response_id]"]:checked').val() == "5" && typeof(ga) != "undefined"
      ga 'set', 'location', rootLocation + '/bookings/confirmation'
      ga 'send', 'pageview',
        'page': '/bookings/confirmation',
        'title': 'Confirm a Booking'
    $this.closest('form').submit()
