(($) ->
  Popup = (holder) ->
    @holder = holder
    @trigger = holder.find(".behaviour-popup-trigger")
    @popup = holder.find(".popup")
    @trigger.click $.proxy(@showPopup, this)
    @popup.remove()
    @popupClicked = false
    @popup.click (event) =>
      @popupClicked = true
    $("body").append @popup
    holderOffset = @holder.offset()
    
    #This detection method relies on the browser type specific style being applied in the layout-ie7.css file
    if @popup.css("z-index") is "5"
      
      #IE7
      @popup.offset holderOffset
    else
      
      #All other browsers
      @popup.offset
        left: holderOffset.left - (@popup.width()/ 2)
        top: holderOffset.top + 40

  $.fn.popup = (options) ->
    @each ->
      new Popup($(this), options)


  Popup:: =
    showPopup: (event) ->
      @holder.addClass "active-popup"
      @popup.slideDown 100
      event.stopImmediatePropagation()
      $(document).click $.proxy(@hidePopup, this)
      $(document).keyup $.proxy(@hidePopupOnEscape, this)
      false

    hidePopupOnEscape: (event) ->
      @hidePopup()  if event.keyCode is 27

    hidePopup: ->
      unless @popupClicked
        @popup.slideUp 100
        @holder.removeClass "active-popup"
        $(document).unbind "click", @hidePopup
      @popupClicked = false
      true
) jQuery