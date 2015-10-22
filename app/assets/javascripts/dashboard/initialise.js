
$(document).ready(function(){
	$(".dropdown-button").click(function() {
	  var $button, $menu;
	  $button = $(this);
	  $menu = $button.siblings(".dropdown-menu");
	  $menu.toggleClass("show-menu");
	  $menu.children("li").click(function() {
	    $menu.removeClass("show-menu");
	  });
	});

	$(".datepicker").datepicker({
	  firstDay: 1,
	  prevText: "<i class='icon ion-arrow-left-b'></i>",
	  nextText: "<i class='icon ion-arrow-right-b'></i>",
	  dayNamesMin: ["S","M","T","W","T","F","S"]  
	});

	// $('.slider').slick();
});