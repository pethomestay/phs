$(document).ready(function() {


  var num_times_marked = 0;
    $( ".collection_cb" ).click(function() { 
      if( $(this).hasClass("active") && num_times_marked == 0) {
          $(this).removeClass( "active" );
          $(this).attr('checked', false); 
        } else if( !$(this).hasClass("active") && num_times_marked == 0) {
          $(this).addClass( "active" );
          $(this).attr('checked', true); 
        } 
      num_times_marked++;
      if(num_times_marked == 2)
          num_times_marked = 0;   
    });

    $( ".boolean_cb" ).click(function() { 
      if( $(this).hasClass("active")) {
          $(this).removeClass( "active" );
          $(this).attr('checked', false);  
        } else if( !$(this).hasClass("active")) {
          $(this).addClass( "active" )
          $(this).attr('checked', true); 
        } 
     
    });  

});    