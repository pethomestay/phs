// $(document).ready(function () {

//     $('#cancel-code-prompt').on('click', function(){
//         $.ajax({
//           url: "#{decline_coupon_users_path}",
//           type: 'POST'
//         });
//       });
//       window.fbAsyncInit = function() {
//         FB.init({
//           appId      : "#{ENV['APP_ID'] || '363405197161579' }",
//           cookie     : true,
//           status     : true,
//           xfbml      : true,
//           version    : 'v2.1'
//         });
//         $('.fb-share-btn').on('click', function() {
//           FB.ui(
//           {
//             method: 'feed',
//             link: "https://www.pethomestay.com.au",
//             picture: "https://d1nq2ztuzp3vk0.cloudfront.net/assets/home/three_features/feature_two-9d2ae9f999068089b39bc5bf09d22f72.png",
//             name: "Hey, I just joined PetHomeStay.com.au!",
//             caption: "Australia's no. 1 pet sitting community",
//             description: "With trusted local pet sitters throughout Australia, it's a better option for you and your pet. Come join me today!"
//           }, function(response) {
//               if (response && !response.error_code) {
//                 $('#user_coupon_code').val('SHARE5');
//                 $('.text-center.pad-btm.text-lg.text-thin').text("Thanks for sharing");
//                 $('form').hide();
//                 $('form').submit();
//               } else {
//                   alert('Failed to post...');
//               }
//             }
//           );
//           return false;
//         });
//       };

//       (function(d, s, id){
//          var js, fjs = d.getElementsByTagName(s)[0];
//          if (d.getElementById(id)) {return;}
//          js = d.createElement(s); js.id = id;
//          js.src = "//connect.facebook.net/en_US/sdk.js";
//          fjs.parentNode.insertBefore(js, fjs);
//        }(document, 'script', 'facebook-jssdk'));
//     #fb-root
//     - if cookies[:code].present?
//       javascript:
//         $('#user_coupon_code').val("#{cookies[:code]}");
//         $('form').submit();
        
// });        