(function($) {
    
    var Slideshow = function($elem) {
        var interval;
        
        function next() {
            $elem.find("li").first().hide().appendTo($elem);
            $elem.find("li").first().show();

        }
        
        function play(event) {
            if (!interval) {
                interval = setInterval(next, 3000);
            }
        }
        
        // function pause(event) {
        //     if (interval) {
        //         clearInterval(interval);
        //         interval = null;
        //     }
        // }
        
        // listeners
        play();
    }
    
    $.fn.slideshow = function() {
        return this.each(function(idx, elem) {
            new Slideshow($(elem));
        });
    };
})(jQuery);
$(".timeline").slideshow();
