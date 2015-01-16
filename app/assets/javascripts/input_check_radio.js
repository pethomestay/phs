$(document).ready(function() {

  checkRadioValues();
  checkCheckBoxValues();


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

      if( !$(this).hasClass("active") ) {
          $( this ).parent().parent().children().children().removeClass( "active" );
          $( this ).parent().parent().children().children().attr( "checked", false );
          console.log($(this).parent().parent());
          $(this).addClass( "active" );
          $(this).attr("checked", true);
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