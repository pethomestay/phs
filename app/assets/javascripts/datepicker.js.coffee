$(document).ready ->
  nowTemp = new Date()
  now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0)

  checkin_l  = $("#drop-off input")
  checkout_l = $("#pick-up input")
  checkin_icon_l  = $("#drop-off .input-group-addon")
  checkout_icon_l = $("#pick-up .input-group-addon")

  # Top
  top_checkin = checkin_l.eq(0).datepicker(
    format: "DD, d MM, yyyy"
    startDate: now
  ).on("changeDate", (ev) ->
    newDate = new Date(ev.date)
    top_checkout.setDate newDate
    top_checkout.startDate = newDate
    top_checkout.update()
    top_checkin.hide()
    checkout_l[0].focus()
    return
  ).data("datepicker")
  top_checkout = checkout_l.eq(0).datepicker(
    format: "DD, d MM, yyyy"
    startDate: checkin_l.eq(0).val() || now
  ).on("changeDate", (ev) ->
    top_checkout.hide()
    return
  ).data("datepicker")

  checkin_icon_l.eq(0).on('click', (e) ->
    e.preventDefault
    top_checkin.show()
    top_checkout.hide()
  )
  checkout_icon_l.eq(0).on('click', (e) ->
    e.preventDefault
    top_checkin.hide()
    top_checkout.show()
  )

  # Bottom
  bottom_checkin = checkin_l.eq(1).datepicker(
    format: "DD, d MM, yyyy"
    startDate: now
  ).on("changeDate", (ev) ->
    newDate = new Date(ev.date)
    bottom_checkout.setDate newDate
    bottom_checkout.startDate = newDate
    bottom_checkout.update()
    bottom_checkin.hide()
    checkout_l[1].focus()
    return
  ).data("datepicker")
  bottom_checkout = checkout_l.eq(1).datepicker(
    format: "DD, d MM, yyyy"
    startDate: checkin_l.eq(1).val() || now
  ).on("changeDate", (ev) ->
    bottom_checkout.hide()
    return
  ).data("datepicker")

  checkin_icon_l.eq(1).on('click', (e) ->
    e.preventDefault
    bottom_checkin.show()
    bottom_checkout.hide()
  )
  checkout_icon_l.eq(1).on('click', (e) ->
    e.preventDefault
    bottom_checkin.hide()
    bottom_checkout.show()
  )
