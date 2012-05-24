$(document).ready ->
  $(".join-us").css "opacity", "0"
  $("a[href=#sign-in]").click ->
    $(".join-us").css "z-index", "-1"
    $(".sign-in").css "z-index", "1"
    $(".join-us").animate opacity: 0
    $(".sign-in").animate opacity: 1

  $("a[href=#join-us]").click ->
    $(".sign-in").animate opacity: 0
    $(".join-us").animate opacity: 1
    $(".sign-in").css "z-index", "-1"
    $(".join-us").css "z-index", "1"