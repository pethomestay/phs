$(document).ready(function() {
  $('form#newsletter').on('submit', function(e) {
    var form = $(this);
    form.closest('div').find('h5.info').show();
    form.closest('div').find('h5.subscribed,h5.failed').hide();
    form.find('button').button('loading');
    $.ajax(form.attr('action'), {
      data: {
        email: form.find('input[type="email"]').val()
      },
      success: function(data) {
        if(data.ok) {
          form.find('input[type="email"]').val('');
          form.closest('div').find('h5').hide();
          form.closest('div').find('h5.subscribed').show();
        } else {
          form.closest('div').find('h5').hide();
          form.closest('div').find('h5.failed').show();
          form.closest('div').find('h5.failed:last').html(data.msg);
        }
        form.find('button').button('reset');
      },
      type: 'post'
    });
    e.preventDefault();
  });
});
