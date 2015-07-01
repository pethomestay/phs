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


});