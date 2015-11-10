
//  http://jsfiddle.net/yeLRw/2/
(function($) {
    
    var Slideshow = function($elem) {
        var interval;
        
        function next() {
            $elem.find("li").first().hide().appendTo($elem);
            $elem.find("li").first().show();
        }
        
        function play(event) {
            if (!interval) {
                clearInterval
                interval = setInterval(next, 1000);
            }
        }
        
        
        // listeners
    play();
    }
    
    $.fn.slideshow = function() {
        return this.each(function(idx, elem) {
            new Slideshow($(elem));
        });
    };
})(jQuery);