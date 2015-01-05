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
         $('#demo-bv-wz').find('.finish').hide().prop('disabled', true);
      },
      onTabShow: function(tab, navigation, index) {
         var $total = navigation.find('li').length;
         var $current = index+1;
         var $percent = (index/$total) * 100;
         var margin = (100/$total)/2;
         $('#demo-bv-wz').find('.progress-bar').css({width:$percent+'%', 'margin': 0 + 'px ' + margin + '%'});
         
         navigation.find('li:eq('+index+') a').trigger('focus');

         
         // If it's the last tab then hide the last button and show the finish instead
         if($current >= $total) {
             $('#demo-bv-wz').find('.next').hide();
             $('#demo-bv-wz').find('.finish').show();
             $('#demo-bv-wz').find('.finish').prop('disabled', false);
         } else {
             $('#demo-bv-wz').find('.next').show();
             $('#demo-bv-wz').find('.finish').hide().prop('disabled', true);
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
         homestay_address: {
            message: 'The username is not valid',
            validators: {
               notEmpty: {
                  message: 'The username is required.'
               }
            }
         },
         email: {
            validators: {
               notEmpty: {
                  message: 'The email address is required and can\'t be empty'
               },
               emailAddress: {
                  message: 'The input is not a valid email address'
               }
            }
         },
         firstName: {
           validators: {
               notEmpty: {
                  message: 'The first name is required and cannot be empty'
               },
               regexp: {
                  regexp: /^[A-Z\s]+$/i,
                  message: 'The first name can only consist of alphabetical characters and spaces'
               }
            }
         },
         lastName: {
            validators: {
               notEmpty: {
                  message: 'The last name is required and cannot be empty'
               },
               regexp: {
                  regexp: /^[A-Z\s]+$/i,
                  message: 'The last name can only consist of alphabetical characters and spaces'
               }
            }
         },
         phoneNumber: {
            validators: {
               notEmpty: {
                  message: 'The phone number is required and cannot be empty'
               },        
               digits: {
                  message: 'The value can contain only digits'
               }
            }
         },
         address: {
            validators: {
               notEmpty: {
                  message: 'The address is required'
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


