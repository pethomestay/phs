$ ->
  $('.fa.fa-star-o.favourite-unheart').on 'click', ->
    $this = $(this)
    $thisP = $(this).closest('p')
    favP = $('.fa.fa-star.favourite-heart').closest('p')
    dataId = $this.closest('div').data('id')
    $.ajax "#{dataId}/favourite",
      success: ->
        $thisP.hide()
        favP.show()

  $('.fa.fa-star.favourite-heart').on 'click', ->
    $this = $(this)
    $thisP = $(this).closest('p')
    nonFavP = $('.fa.fa-star-o.favourite-unheart').closest('p')
    dataId = $this.closest('div').data('id')
    $.ajax "#{dataId}/non_favourite",
      success: ->
        $thisP.hide()
        nonFavP.show()

  $('a.fav-make-enquiry').on 'click', ->
    window.location = $(this).attr('href')

  $('a.remove-from-favourite').on 'click', ->
    $this = $(this)
    dataId = $this.closest('div').data('id')
    $.ajax "#{dataId}/non_favourite",
      success: ->
        $this.parent('div').parent().hide()
        if $this.parent('div').parent().siblings('div.well').length == 0
          $this.parent('div').parent().parent().append('<p>You have no favourites listing at the moment</p>')

  if window.location.href.match('homestays') && window.location.href.match('#enquiry')
    $('[data-toggle="modal"]').click()


  homestay_id = $("#listing-calendar").data("homestay-id")
  $("#listing-calendar").fullCalendar
    header:
      left: 'prev',
      center: 'title',
      right: 'next'

    events: "/homestays/" + homestay_id + "/availability"

    viewDisplay: (view) ->
      now = new Date()
      cal_date_string = view.start.getMonth()+'/'+view.start.getFullYear()
      cur_date_string = now.getMonth()+'/'+now.getFullYear()
      if(cal_date_string == cur_date_string)
        jQuery('.fc-button-prev').addClass("fc-state-disabled")
      else
        jQuery('.fc-button-prev').removeClass("fc-state-disabled")

    eventAfterRender: (event, element, monthView) ->
     dateString = $.fullCalendar.formatDate(event.start, 'yyyy-MM-dd')
     $cell = $("td[data-date=" + dateString + "]")
     if (event.title.match(/unavailable/i) != null)
       $cell.addClass("unavailable")
       
       




