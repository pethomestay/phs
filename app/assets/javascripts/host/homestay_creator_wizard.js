$(document).ready(function() {

   $('#homestay_creator_wizard').bootstrapWizard({
      tabClass    : 'wz-steps',
      nextSelector   : '.next',
      previousSelector  : '.previous',
      onTabClick: function(tab, navigation, index) {  
         return true;
      },
      onInit : function(){
         $('#homestay_creator_wizard').find('.createMyListing').hide().prop('disabled', true);
      },
      onTabShow: function(tab, navigation, index) {
         var $total = navigation.find('li').length;
         var $current = index+1;
         var $percent = (index/$total) * 100;
         var wdt = 100/$total;
         var lft = wdt*index;
         $('#homestay_creator_wizard').find('.progress-bar').css({width:wdt+'%',left:lft+"%", 'position':'relative', 'transition':'all .5s'});
         
         navigation.find('li:eq('+index+') a').trigger('focus');

         
         // If it's the last tab then hide the last button and show the finish instead
         if($current == 1) {
            $('#homestay_creator_wizard').find('.previous').hide();
         } else {
            $('#homestay_creator_wizard').find('.previous').show();
         }   
         if($current >= $total) {
             $('#homestay_creator_wizard').find('.next').hide();
             $('#demo-submit-wz').find('.createMyListing').show().prop('disabled', false);
         } else {
             $('#homestay_creator_wizard').find('.next').show();
             $('#demo-submit-wz').find('.createMyListing').hide().prop('disabled', true);
         }
      },
      onNext: function(e){
        isValid = null;
         $('#homestay_creator_wizard_form').bootstrapValidator('validate');
         
         if(isValid === false)return false;
      }
   });

   
   
   
   var isValid;
   $('#homestay_creator_wizard_form').bootstrapValidator({   
      message: 'This value is not valid',
      fields: {
         mobile_number: {
           validators: {
               notEmpty: {
                  message: 'Please enter a mobile number to allow guests to contact you'
               },
               digits: {
                  message: 'This field can contain only digits'
               }
            }
         },
         homestay_address: {
            validators: {
               notEmpty: {
                  message: 'Please enter a valid address - required for showing up in search listings'
               }
            }  
         }
      }
   }).on('success.field.bv', function(e, data) {          
      var $parent = data.element.parents('.form-group');
      
      $parent.removeClass('has-success');
      
   }).on('error.form.bv', function(e) {
      isValid = false;
   });

   var charityHosts = $('#homestay_for_charity');
   var wildFireBadge = $('#homestay_wildfire_badge');

   var phs_legacy_cb = $('.legacy_cb');
   var phs_container_cb = $('.cb_container');
   
   
   // phs_legacy_cb.each( function( index ) 
   // {
   //    if( $( this ).prop('checked') == true) 
   //    {  
   //       $( this ).parent().parent().parent().parent().addClass('active');
   //       $( this ).parent().parent().parent().parent().find('.design_cb').prop('checked', true);
   //       // $( this ).parent().parent().find('.design_cb').prop('checked', true);
   //       // this.parent().find('.design_cb').addClass('active')
   //    } else if( $( this ).prop('checked') == false) 
   //    {
   //       $( this ).parent().parent().parent().parent().removeClass('active');
   //       $( this ).parent().parent().parent().parent().find('.design_cb').prop('checked', false);
   //    }
      
   // });
   
   // phs_container_cb.click(function() 
   // {  
   //    if( $( this ).find('.design_cb').prop('checked') == true ) 
   //    {  
   //       $( this ).find('.design_cb').prop('checked', false); 
   //       $( this ).removeClass('active');
   //       $( this ).find('.legacy_cb').prop('checked', false);  
   //    } else if( $( this ).find('.design_cb').prop('checked') == false )  {
   //       $( this ).find('.design_cb').prop('checked', true); 
   //       $( this ).addClass('active');
   //       $( this ).find('.legacy_cb').prop('checked', true);  
   //    }

   // });   

});


