$(document).ready(function() {

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
         $('#demo-bv-wz').find('.progress-bar').css({width:wdt+'%',left:lft+"%", 'position':'relative', 'transition':'all .5s'});
         
         navigation.find('li:eq('+index+') a').trigger('focus');

         
         // If it's the last tab then hide the last button and show the finish instead
         if($current == 1) {
            $('#demo-bv-wz').find('.previous').hide();
         } else {
            $('#demo-bv-wz').find('.previous').show();
         }   
         if($current >= $total) {
             $('#demo-bv-wz').find('.next').hide();
             $('#demo-submit-wz').find('.createMyListing').show().prop('disabled', false);
         } else {
             $('#demo-bv-wz').find('.next').show();
             $('#demo-submit-wz').find('.createMyListing').hide().prop('disabled', true);
         }
      },
      onNext: function(e){
         if ($("#demo-main-tab1").hasClass('active')) {
            if ($('#mobile_number_field').val() === "" || $('#addressField').val() === "" || $('#addressField').val === null)   {
               $("html, body").animate({ scrollTop: 0 }, 500);
               return false;
            }
         } else if ($("#demo-main-tab2").hasClass('active')) {
            if ($('#homestay_cost_per_night').val() === "" || $('#homestay_cost_per_night').val() === null) {
               $("html, body").animate({ scrollTop: 0 }, 500);
               e.preventDefault;
               return false;
            }
         }

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
      var $parent = data.element.parents('.form-group');
      
      $parent.removeClass('has-success');
      
   }).on('error.form.bv', function(e) {
      isValid = false;
   });


   // Enquiry modal  
   $('#enquiry-modal-wizard').bootstrapWizard({
      tabClass    : 'wz-steps',
      nextSelector   : '.next',
      previousSelector  : '.previous',
      onTabClick: function(tab, navigation, index) {  
         return true;
      },
      onInit : function(){
         $('#enquiry-modal-wizard').find('.submitEnquiry').hide().prop('disabled', true);
         $("#enq_fields").show();
         $("#pet-info-tab").hide();
      },
      onTabShow: function(tab, navigation, index) {
         var $total = navigation.find('li').length;
         var $current = index+1;
         var $percent = (index/$total) * 100;
         var wdt = 100/$total;
         var lft = wdt*index;
         $('#enquiry-modal-wizard').find('.progress-bar').css({width:wdt+'%',left:lft+"%", 'position':'relative', 'transition':'all .5s'});
         
         navigation.find('li:eq('+index+') a').trigger('focus');

         
         // If it's the last tab then hide the last button and show the finish instead
         if($current == 1) {
            $('#enquiry-modal-wizard').find('.previous').hide();
            $("#enq_fields").fadeIn(400);
            $("#pet-info-tab").hide();
         } else {
            $('#enquiry-modal-wizard').find('.previous').show();
            $("#enq_fields").hide();
            $("#pet-info-tab").fadeIn(400);
         }   
         if($current >= $total) {
             $('#enquiry-modal-wizard').find('.next').hide();
             $('#enquiry-modal-wz').find('.submitEnquiry').show().prop('disabled', false);
         } else {
             $('#enquiry-modal-wizard').find('.next').show();
             $('#enquiry-modal-wz').find('.submitEnquiry').hide().prop('disabled', true);
         }
      },
      onNext: function(e){
         if ($("#enquiry-info-tab").hasClass('active')) {
            $("#enq_fields").fadeIn(400);
            $("#pet-info-tab").hide();
         } else if ($("#pet-info-tab").hasClass('active')) {
            $("#enq_fields").hide();
            $("#pet-info-tab").fadeIn(400);
         }

        isValid = null;
         $('#enquiry-modal-wizard-form').bootstrapValidator('validate');
         if(isValid === false)return false;
      }
   });

   
   
   
   var isValid;
   $('#enquiry-modal-wizard-form').bootstrapValidator({   
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
                  message: 'Please enter a mobile number to allow guests to contact you.'
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


