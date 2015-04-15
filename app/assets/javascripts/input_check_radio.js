$(document).ready(function() {

  checkRadioValues();
  checkCheckBoxValues();

  var hash = source();
  console.log(hash);
  


  function source(){
    if (document.referrer.search('https?://(.*)google.([^/?]*)') === 0) {
      return 'Google';
    } else if (document.referrer.search('https?://(.*)bing.([^/?]*)') === 0) {
      return 'Bing';
    } else if (document.referrer.search('https?://(.*)yahoo.([^/?]*)') === 0) {
      return 'Yahoo';
    } else if (document.referrer.search('https?://(.*)facebook.([^/?]*)') === 0) {
      return 'Facebook';
    } else if (document.referrer.search('https?://(.*)twitter.([^/?]*)') === 0) {
      return 'Twitter';
    } else {
      return 'Other';
    }
  }

  function checkRadioValues() {
    $('.collection_rb').each(function(){
      if( $(this).prop( "checked" ) == true ){
           $(this).addClass( "active" );
      } else {
         $(this).removeClass( "active" );
      }
    });

    $('.boolean_rb').each(function(){
      if($(this).prop( "checked" ) == true){
           $(this).addClass( "active" );
      } else {
         $(this).removeClass( "active" );
      }
    });

  }

  function checkCheckBoxValues() {
    $('.collection_cb').each(function(){
      if( $(this).prop( "checked" ) == true ){
           $(this).addClass( "active" );
      } else {
         $(this).removeClass( "active" );
      }
    });

    $('.boolean_cb').each(function(){
      if($(this).prop( "checked" ) == true){
           $(this).addClass( "active" );
      } else {
         $(this).removeClass( "active" );
      }
    });

  }
    
    $( ".collection_rb" ).click(function() { 
      if( $(this).hasClass("active") ) {
          
        } else if( !$(this).hasClass("active") ){
          $( this ).parent().parent().children().children().removeClass( "active" );    
          $(this).addClass( "active" );
          $(this).prop("checked", true); 
        }  
      
    }); 


    $( ".collection_cb" ).click(function() { 
      if( $(this).hasClass("active") ) {
          $(this).removeClass( "active" );
          $(this).attr("checked", false); 
        } else if( !$(this).hasClass("active") ){
          $(this).addClass( "active" );
          $(this).prop("checked", true); 
        }  
    });

    $( ".boolean_cb" ).click(function() { 
      if( $(this).hasClass("active")) {
          $(this).removeClass( "active" );
          $(this).prop('checked', false);  
        } else if( !$(this).hasClass("active")) {
          $(this).addClass( "active" )
          $(this).prop("checked"); 
        } 
     
    });  

});    