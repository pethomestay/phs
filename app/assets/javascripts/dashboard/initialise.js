
$(document).ready(function(){




  $(".dropdown-button").click(function(e) {

    //initialise close all dropdown

    $others = $(".dropdown-button").not(this);
    $others.siblings(".dropdown-menu").removeClass("show-menu");
    $others.find(".rotate").removeClass("down");

    e.stopPropagation();
    var $button, $menu, $arrow;
    $button = $(this);
    $menu = $button.siblings(".dropdown-menu");
    $menu.toggleClass("show-menu");
    $arrow = $button.find(".rotate")
    $arrow.toggleClass("down");
    $menu.children("li").click(function() {
      $menu.removeClass("show-menu");
    });

    $(document).click(function() {
      $(".dropdown-menu").removeClass("show-menu");
      $(".rotate").removeClass("down");
    });
  });





  $(".datepicker").datepicker({
    firstDay: 1,
    prevText: "<i class='icon ion-arrow-left-b'></i>",
    nextText: "<i class='icon ion-arrow-right-b'></i>",
    dayNamesMin: ["S","M","T","W","T","F","S"],
    beforeShowDay: function(date) {
      var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input1").val());
      var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input2").val());
      return [true, date1 && ((date.getTime() == date1.getTime()) || (date2 && date >= date1 && date <= date2)) ? "dp-highlight" : ""];
    },
    onSelect: function(dateText, inst) {
      var date1 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input1").val());
      var date2 = $.datepicker.parseDate($.datepicker._defaults.dateFormat, $("#input2").val());
      if (!date1 || date2) {
        $("#input1").val(dateText);
        $("#input2").val("");
              $(this).datepicker();
      } else {
        $("#input2").val(dateText);
              $(this).datepicker();
      }
    }
  });

  $('.slider').slick({
    arrows: false,
    dots: true,
    edgeFriction:0
  });
});