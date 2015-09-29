$(document).ready( function() {

    window.fbAsyncInit = function() {
        FB.init({
            appId: "#{ENV['APP_ID'] || '382802968555135' }",
            cookie: true,
            status: true,
            xfbml: true,
            version: 'v2.1'
        });

        $('.fb-share-btn.fb-host-to-guest-review').on('click', function() {
            var data = $(this).data();
            var fb_description = "Review: " + data.review
            FB.ui({
                method: 'feed',
                link: "https://www.pethomestay.com.au",
                name: data.title,
                caption: "Australia's no. 1 pet sitting community",
                description: fb_description
            }, function(response) {});
        });

        $('.fb-share-btn.fb-user-support').on('click', function() {
            var data = $(this).data();
            FB.ui({
                method: 'feed',
                link: data.url,
                name: "Please give me your support",
                caption: "Australia's no. 1 pet sitting community",
                description: "I could use a helping hand from friends. Please give me your support by clicking on this post and telling the community that I love pets!"
            }, function(response) {});
        });
    };

    (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) {
            return;
        }
        js = d.createElement(s);
        js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

});