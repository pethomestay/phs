$(document).ready(function() {
  $('a.external').on('click', function(e) {
    e.preventDefault();
    window.open($(this).attr('href'));
  });

  $('.referer').on('click', function(e) {
    var a = $(this).find('a');
    window.open(a.attr('href'));
  });
});
