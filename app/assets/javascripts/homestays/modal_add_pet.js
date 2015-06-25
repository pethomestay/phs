  $(document).ready(function () {
    
    // Species radio buttons hidden
    var dogType = $('#pet_pet_type_id_1');
    var catType = $('#pet_pet_type_id_2');
    var otherType = $('#pet_pet_type_id_5');

    // Corresponding Buttons
    var dogBtn = $('#modal_dog_btn');
    var catBtn = $('#modal_cat_btn');
    var otherBtn = $('#modal_other_btn');

    // Sex radio buttons hidden
    var maleDesexed = $('#pet_sex_id_1');
    var femaleDesexed = $('#pet_sex_id_2');
    var maleNormal = $('#pet_sex_id_3');
    var femaleNormal = $('#pet_sex_id_4');

    // Corresponding Buttons
    var maleDesexedBtn = $('#modal_male_desex');
    var femaleDesexedBtn = $('#modal_female_desex');

    // Checkbox user selects
    var normalSex= $('#modal_pet_normal_sex');


    maleDesexed.prop('checked', true);
    maleDesexedBtn.addClass('active');
    // Default values 
    dogBtn.addClass('active');
    dogType.prop("checked");
    $('chosen-select').show();
    $('#other_pet_type_text_id').hide();
    $('.pet_other_pet_type').hide();

    // Click Handlers - for species type 
    dogBtn.click(function() {
      dogBtn.addClass('active');
      catBtn.removeClass('active');
      otherBtn.removeClass('active');
      dogType.prop("checked");  
      $('.pet_breed').show();
      $('#other_pet_type_text_id').hide();
      $('.pet_other_pet_type').hide();
    });

    catBtn.click(function() {
      catBtn.addClass('active');
      dogBtn.removeClass('active');
      otherBtn.removeClass('active');
      dogType.prop("checked");
      $('.pet_breed').hide();
      $('#other_pet_type_text_id').hide();
      $('.pet_other_pet_type').hide();
    });

    otherBtn.click(function() {
      otherBtn.addClass('active');
      catBtn.removeClass('active');
      dogBtn.removeClass('active');
      otherType.prop("checked");
      $('.pet_breed').hide();
      $('#other_pet_type_text_id').show();
      $('.pet_other_pet_type').show();
    });

       // Click Handlers - for sex type
    maleDesexedBtn.click(function() {
      
      maleDesexedBtn.addClass('active');
      femaleDesexedBtn.removeClass('active');
      
      if( normalSex.parent().hasClass('active')) {
        maleNormal.prop('checked', true);  
      } else {
        maleDesexed.prop('checked', true); 
      }
    });  


    femaleDesexedBtn.click(function() {
      
      femaleDesexedBtn.addClass('active');
      maleDesexedBtn.removeClass('active');
      
      if( normalSex.parent().hasClass('active') ) {
        femaleNormal.prop("checked", true);  
      } else {
        femaleDesexed.prop("checked", true); 
      }
    });

    // This checkbox decides whether pets are normal or desexed.
    normalSex.click(function() {
      // If checked - uncheck it making them desexed
      if( normalSex.parent().hasClass('active')) {
        normalSex.parent().removeClass('active');
        normalSex.prop('checked', false);
        
        if( maleNormal.prop("checked") ) {
          maleDesexed.click();
        } 

        if( femaleNormal.prop("checked") ) {
          femaleDesexed.click();
        } 
     // else make pets normal   
      } else {
        normalSex.parent().addClass('active');
        normalSex.prop('checked', true);

        if( maleDesexed.prop("checked") ) {
          maleNormal.prop("checked", true);
        } 

        if( femaleDesexed.prop("checked") ) {
          femaleNormal.prop("checked", true);
        }   
      }
    });

  var profile_photo = [];
  $("#pet_modal_profile_photo_dropzone").dropzone({
    url: "/photo_uploads",
    paramName: "photo",
    acceptedFiles: 'image/*',
    maxFilesize: 2,
    maxFiles: 1,
    addRemoveLinks: true,
    maxfilesexceeded: function () {
      $("#modal_image_ul").show();
      alert('Max File updloaded');
    },
    sending: function (file, xhr, formData) {
      $("#modal_image_ul").hide();
      formData.append("authenticity_token", $('#auth_token').val());
    },
    success: function (file, response) {
      profile_photo = [response]
      $("#modal_image_ul").hide();
      $('#pet_profile_photo').val(JSON.stringify(profile_photo));
      file.previewElement.classList.add("dz-success");
      file.previewElement.classList.add("public_id" + response.public_id);
    },
    removedfile: function(file) {
      $("#modal_image_ul").show();
      classes = file.previewElement.classList;
      for(i = 0; i < classes.length; i++){
        if( classes[i].match("public_id") == "public_id" ){
          file_id = classes[i].replace("public_id", "");
          $('#pet_profile_photo').val('');
          $.ajax({
            url: '/remove_uploads_with_public_id',
            type: 'DELETE',
            data: "public_id=" + file_id,
            success: function(result) {}
          });
          var _ref;
          if ((_ref = file.previewElement) != null) {
            _ref.parentNode.removeChild(file.previewElement);
          }
          return this._updateMaxFilesReachedClass();
          break;
        }
      }
    }
  });
    

});      