$(document).ready(function() {


// $('#demo-main-wz').bootstrapWizard({
//       tabClass    : 'wz-steps',
//       nextSelector  : '.next',
//       previousSelector  : '.previous',
//       onTabClick: function(tab, navigation, index) {  
//          return false;
//       },
//       onInit : function(){
//          $('#demo-main-wz').find('.finish').hide().prop('disabled', true);
//       },
//       onTabShow: function(tab, navigation, index) {
//          var $total = navigation.find('li').length;
//          var $current = index+1;
//          var $percent = ($current/$total) * 100;
//          var wdt = 100/$total;
//          var lft = wdt*index;
         
//          $('#demo-main-wz').find('.progress-bar').css({width:wdt+'%',left:lft+"%", 'position':'relative', 'transition':'all .5s'});
         
         
//          // If it's the last tab then hide the last button and show the finish instead
//          if($current >= $total) {
//             $('#demo-main-wz').find('.next').hide();
//             $('#demo-main-wz').find('.finish').show();
//             $('#demo-main-wz').find('.finish').prop('disabled', false);
//          } else {
//             $('#demo-main-wz').find('.next').show();
//             $('#demo-main-wz').find('.finish').hide().prop('disabled', true);
//          }    
//       }
//   });

   // With Bootstrap Validator
   // =================================================================
   $('#demo-bv-wz').bootstrapWizard({
      tabClass    : 'wz-steps',
      nextSelector   : '.next',
      previousSelector  : '.previous',
      onTabClick: function(tab, navigation, index) {  
         return true;
      },
      onInit : function(){
         $('#demo-bv-wz').find('.createMyListing').hide().prop('disabled', true);
      },
      onTabShow: function(tab, navigation, index) {
         var $total = navigation.find('li').length;
         var $current = index+1;
         var $percent = (index/$total) * 100;
         var wdt = 100/$total;
         var lft = wdt*index;
         $('#demo-submit-wz').find('.progress-bar').css({width:wdt+'%',left:lft+"%", 'position':'relative', 'transition':'all .5s'});
         
         navigation.find('li:eq('+index+') a').trigger('focus');

         
         // If it's the last tab then hide the last button and show the finish instead
         if($current == 1) {
            $('#demo-bv-wz').find('.previous').hide();
         } else {
            $('#demo-bv-wz').find('.previous').show();
         }   
         if($current >= $total) {
             $('#demo-bv-wz').find('.next').hide();
             $('.createMyListing').show().prop('disabled', false);
         } else {
             $('#demo-bv-wz').find('.next').show();
             $('.createMyListing').hide().prop('disabled', true);
         }    
      },
      onNext: function(){
        isValid = null;
         $('#demo-bv-wz-form').bootstrapValidator('validate');
      
     
         if(isValid === false)return false;
      }
   });

   
   
   
   var isValid;
   $('#demo-bv-wz-form').bootstrapValidator({   
      message: 'This value is not valid',
      feedbackIcons: {
         valid: 'fa fa-check-circle fa-lg text-success',
         invalid: 'fa fa-times-circle fa-lg',
         validating: 'fa fa-refresh'
      },
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
         }
      }
   }).on('success.field.bv', function(e, data) {       
      // $(e.target)  --> The field element
      // data.bv      --> The BootstrapValidator instance
      // data.field   --> The field name
      // data.element --> The field element
      
      var $parent = data.element.parents('.form-group');
      
      // Remove the has-success class
      $parent.removeClass('has-success');
      
      
      // Hide the success icon
      //$parent.find('.form-control-feedback[data-bv-icon-for="' + data.field + '"]').hide();
   }).on('error.form.bv', function(e) {
      isValid = false;
   });


});


