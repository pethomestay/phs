$(document).ready(function() {
  $('a.external').on('click', function(e) {
    e.preventDefault();
    window.open($(this).attr('href'));
  });
});
