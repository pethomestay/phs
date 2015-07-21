$(document).ready(function () {


  $('#pet_pet_type_id_1').prop("checked");
  $('#pet_icon_demo_1').css("color", "#ec5c3b");
  $('chosen-select').show();
  $('#other_pet_type_text_id').hide();

  	var addProfilePhotoBtn = $('#pet_profile_photo_btn');
  	var addExtraPhotosBtn = $('#pet_extra_photo_btn');
	
	var extraPhotoDropzone = $('#pet_extra_photo_space');
	var addProfilePhotoDropzone = $('#pet_profile_photo_space');	
	
	extraPhotoDropzone.hide();
	addProfilePhotoDropzone.hide();

	addExtraPhotosBtn.click(function() {
		if(addExtraPhotosBtn.hasClass('active'))
		{ 
			addExtraPhotosBtn.removeClass('active');
			extraPhotoDropzone.slideUp(150);
		} else 
		{
			addExtraPhotosBtn.addClass('active');
			extraPhotoDropzone.slideDown(150);
		}
	});

	addProfilePhotoBtn.click(function() {
		if(addProfilePhotoBtn.hasClass('active'))
		{ 
			addProfilePhotoBtn.removeClass('active');
			addProfilePhotoDropzone.slideUp(150);
		} else 
		{
			addProfilePhotoBtn.addClass('active');
			addProfilePhotoDropzone.slideDown(150);
		}
	});

  $('#pet_pet_type_id_1').click(function() {
    $('#pet_pet_type_id_1').prop("checked");   
    $('.pet_breed').show();
    $('#other_pet_type_text_id').hide();
  });
  $('#pet_pet_type_id_2').click(function() {
    $('#pet_pet_type_id_2').prop("checked"); 
    $('.pet_breed').hide();
    $('#other_pet_type_text_id').hide();
  });
  $('#pet_pet_type_id_5').click(function() {
    $('#pet_pet_type_id_5').prop("checked");
    $('.pet_breed').hide();
    $('#other_pet_type_text_id').show();
  });

  $( ".feedback-body" ).hide();
  $( ".feedback-head" ).click(function(event) {
    var head = $(this).children();
    var icon = $(this).find(".feedback-icon").children();
    var body = $(this).parent().find(".feedback-body");
    if( body.is(":hidden") ) {
      icon.addClass("phs-rotate");
      icon.removeClass("phs-reset");
      head.removeClass("phs-title"); 
      head.addClass("phs-title-active");
      body.slideDown();
    } else {
      icon.removeClass("phs-rotate"); 
      icon.addClass("phs-reset");
      head.removeClass("phs-title-active"); 
      head.addClass("phs-title");
      body.slideUp();
    }
  });


  // $("a.remove_pet_profile_photo").click(function(event) {
  //   event.preventDefault();
  //   if($(this).attr("data-id") != "" && $(this).attr("data-model-id") != "" && $(this).attr("data-model-type") != "" && confirm('Are you sure?')) {
  //     photo_id = $(this).attr("data-id");
  //     $.ajax({
  //       url: '/remove_uploads',
  //       type: 'DELETE',
  //       data: "id=" + $(this).attr("data-id") +
  //             "&model_type=" + $(this).attr("data-model-type") +
  //             "&model_id=" + $(this).attr("data-model-id") +
  //             "&scope=" + $(this).attr("data-scope"),
  //       success: function(result) {
  //         if(result.status == "success"){
  //           $("div#pet_profile_photo_box_" + photo_id ).remove();
  //         } else {
  //           alert("Sorry Something went wrong!")
  //         }
  //       }
  //     });
  //   }
  // });

  // $("a.remove_pet_extra_photos").click(function(event) {
  //   event.preventDefault();
  //   if($(this).attr("data-id") != "" && $(this).attr("data-model-id") != "" && $(this).attr("data-model-type") != "" && confirm('Are you sure?')) {
  //     photo_id = $(this).attr("data-id");
  //     $.ajax({
  //       url: '/remove_uploads',
  //       type: 'DELETE',
  //       data: "id=" + $(this).attr("data-id") +
  //             "&model_type=" + $(this).attr("data-model-type") +
  //             "&model_id=" + $(this).attr("data-model-id") +
  //             "&scope=" + $(this).attr("data-scope"),
  //       success: function(result) {
  //         if(result.status == "success"){
  //           $("div#pet_extra_photos_box_" + photo_id ).remove();
  //         } else {
  //           alert("Sorry Something went wrong!")
  //         }
  //       }
  //     });
  //   }
  // });

  // var profile_photo = [];
  // $(document).ready(function () {
  //   $("#pet_profile_photo_dropzone").dropzone({
  //     url: "/photo_uploads",
  //     paramName: "photo",
  //     acceptedFiles: 'image/*',
  //     maxFilesize: 2,
  //     maxFiles: 1,
  //     addRemoveLinks: true,
  //     maxfilesexceeded: function () {
  //     $("#pet_dropzone_profile_photo_message").show();
  //       alert('Max File updloaded');
  //     },
  //     sending: function (file, xhr, formData) {
  //     $("#pet_dropzone_profile_photo_message").hide();
  //       formData.append("authenticity_token", "#{form_authenticity_token}");
  //       formData.append("attachinariable_type", "#{@pet.class.name}");
  //       formData.append("attachinariable_id", "#{@pet.id}");
  //       formData.append("attachinary_scope", "profile_photo");
  //     },
  //     success: function (file, response) {
  //     $("#pet_dropzone_profile_photo_message").hide();
  //       profile_photo = [response]
  //       #{{ "$('#pet_profile_photo').val(JSON.stringify(profile_photo));" if @pet.new_record? }}
  //       file.previewElement.classList.add("dz-success");
  //       file.previewElement.classList.add("public_id" + response.public_id);
  //     },
  //     removedfile: function(file) {
  //       classes = file.previewElement.classList;
  //       for(i = 0; i < classes.length; i++){
  //         if( classes[i].match("public_id") == "public_id" ){
  //           file_id = classes[i].replace("public_id", "");
  //           for(j=0; j<profile_photo.length; j++){
  //             if(file_id == profile_photo[j].public_id){
  //               profile_photo.splice(j, 1);
  //               #{{ "$('#pet_profile_photo').val(JSON.stringify(profile_photo));" if @pet.new_record? }}
  //               break;
  //             }
  //           }
  //           $.ajax({
  //             url: '/remove_uploads_with_public_id',
  //             type: 'DELETE',
  //             data: "public_id=" + file_id,
  //             success: function(result) {}
  //           });
  //           var _ref;
  //           if ((_ref = file.previewElement) != null) {
  //             _ref.parentNode.removeChild(file.previewElement);
  //           }
  //           return this._updateMaxFilesReachedClass();
  //           break;
  //         }
  //       }
  //     }
  //   });
  // });
  
  // var extra_photos = [];
  // $(document).ready(function () {
  //   $("#pet_extra_photos_dropzone").dropzone({
  //     url: "/photo_uploads",
  //     paramName: "photo",
  //     acceptedFiles: 'image/*',
  //     maxFilesize: 2,
  //     maxFiles: 10,
  //     addRemoveLinks: true,
  //     maxfilesexceeded: function () {
  //       $("#pet_dropzone_extra_photo_message").show();
  //       alert('Max File updloaded');
  //     },
  //     sending: function (file, xhr, formData) {
  //       $("#pet_dropzone_extra_photo_message").hide();
  //       formData.append("authenticity_token", "#{form_authenticity_token}");
  //       formData.append("attachinariable_type", "#{@pet.class.name}");
  //       formData.append("attachinariable_id", "#{@pet.id}");
  //       formData.append("attachinary_scope", "extra_photos");
  //     },
  //     success: function (file, response) {
  //       $("#pet_dropzone_extra_photo_message").hide();
  //       extra_photos.push(response)
  //       #{{ "$('#pet_extra_photos_').val(JSON.stringify(extra_photos));" if @pet.new_record? }}
  //       file.previewElement.classList.add("dz-success");
  //       file.previewElement.classList.add("public_id" + response.public_id);
  //     },
  //     removedfile: function(file) {
  //       classes = file.previewElement.classList;
  //       for(i = 0; i < classes.length; i++){
  //         if( classes[i].match("public_id") == "public_id" ){
  //           file_id = classes[i].replace("public_id", "");
  //           for(j=0; j<extra_photos.length; j++){
  //             if(file_id == extra_photos[j].public_id){
  //               extra_photos.splice(j, 1);
  //               #{{ "$('#pet_extra_photos_').val(JSON.stringify(extra_photos));" if @pet.new_record? }}
  //               break;
  //             }
  //           }
  //           $.ajax({
  //             url: '/remove_uploads_with_public_id',
  //             type: 'DELETE',
  //             data: "public_id=" + file_id,
  //             success: function(result) {}
  //           });
  //           var _ref;
  //           if ((_ref = file.previewElement) != null) {
  //             _ref.parentNode.removeChild(file.previewElement);
  //           }
  //           return this._updateMaxFilesReachedClass();
  //           break;
  //         }
  //       }
  //     }
  //   });
  // });
});