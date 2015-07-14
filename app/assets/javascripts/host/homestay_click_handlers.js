$(document).ready(function() {
   
   
   $(".checkbox").addClass('pad-lft');
   $(".radio").addClass('pad-lft');
  // $('.radio').each(function() {
  //     ($(this).addClass('pad-no form-radio form-icon form-text form-block'));
  //     if($(this).find('.radio_buttons').prop('checked') == false)
  //      {
  //           $(this).find('.radio_buttons').prop('checked', false);
  //           $(this).prop('checked', false);
  //           $(this).removeClass('active');
  //     } else {
  //           $(this).find('.radio_buttons').prop('checked', true);
  //           $(this).prop('checked', true);
  //           $(this).addClass('active');
  //     }

  //  });

  //  $('.radio').click(function() {
  //     if($(this).find('.radio_buttons').prop('checked') == false)
  //      {
  //           $(this).find('.radio_buttons').prop('checked', true);
  //           $(this).prop('checked', true);
  //           $(this).addClass('active');
  //           //check others
  //           $(this).siblings().find('.radio_buttons').prop('checked', false);
  //           $(this).siblings().prop('checked', true);
  //           $(this).siblings().removeClass('active');
  //     } 

  //  });

   // $('.checkbox').each(function() {
   //    $(this).addClass('pad-no form-checkbox form-icon form-text form-block');   
   //    if($(this).children().prop('checked') == true)
   //    {     
   //          $(this).prop('checked', false);
   //          $(this).children().prop('checked', false);
   //          $(this).removeClass('active');
                 
   //    } else {
   //          $(this).prop('checked', true);
   //          $(this).children().prop('checked', true);
   //          $(this).addClass('active');
   //    }

   // });
   // var isEven = 2;
   // $(".checkbox").on('click', function()  {
   //    if(isEven % 2 == 0)
   //    {
   //       if($(this).find('.legacy_col_cb').prop('checked') == true)
   //       {     
   //             console.log('hihi');
   //             $(this).prop('checked', false);
   //             $(this).find('.legacy_col_cb').prop('checked', false);
   //             $(this).removeClass('active');
                    
   //       } else if($(this).find('.legacy_col_cb').prop('checked') == false){
   //             console.log('biBi');
   //             $(this).prop('checked', true);
   //             $(this).find('.legacy_col_cb').prop('checked', true);
   //             $(this).addClass('active');      
   //       }
   //    }
   //    isEven++;
   // });   

});