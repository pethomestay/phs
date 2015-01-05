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
         return false;
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
         if($current >= $total) {
             $('#demo-bv-wz').find('.next').hide();
             $('#demo-submit-wz').find('.createMyListing').show().prop('disabled', false);
         } else {
             $('#demo-bv-wz').find('.next').show();
             $('#demo-submit-wz').find('.createMyListing').hide().prop('disabled', true);
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
         },
         cost_per_night_field: {
            validators: {
               notEmpty: {
                  message: 'Please enter a HomeStay price - must 10 dollars of greater'
               },
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 10,
                   message: 'Please enter a value greater than $10'
               }
            }
         },
         remote_price_field: {
            validators: {
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 0,
                   message: 'Please enter a value greater than $0'
               }
            }
         },
         pet_walking_field: {
            validators: {
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 0,
                   message: 'Please enter a value greater than $0'
               }
            }
         },
         pet_grooming_field: {
            validators: {
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 0,
                   message: 'Please enter a value greater than $0'
               }
            }
         },
         visits_price_field: {
            validators: {
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 0,
                   message: 'Please enter a value greater than $0'
               }
            }
         },
         visits_radius_field: {
            validators: {
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 0,
                   message: 'Please enter a value greater than 0'
               }
            }
         },
         delivery_price_field: {
            validators: {
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 0,
                   message: 'Please enter a value greater than $0'
               }
            }
         },
         delivery_radius_field: {
            validators: {
               digits: {
                  message: 'This field can contain only digits'
               },
               greaterThan: {
                   value: 0,
                   message: 'Please enter a value greater than 0'
               }
            }
         }, 
         pet_homestay_title: {
            validators: {
               stringLength: {
                   min: 1,
                   max: 50,
                   message: 'Please enter a title of upto 50 characters long'
               }
            }
         },
         pet_homestay_desc: {
            validators: {
               notEmpty: {
                  message: 'Please enter a HomeStay Description for your listing'
               }
            }
         },
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


