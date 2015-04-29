$(document).ready(function() {
  !function(){var analytics=window.analytics=window.analytics||[];if(analytics.invoked)window.console&&console.error&&console.error("Segment snippet included twice.");else{analytics.invoked=!0;analytics.methods=["trackSubmit","trackClick","trackLink","trackForm","pageview","identify","group","track","ready","alias","page","once","off","on"];analytics.factory=function(t){return function(){var e=Array.prototype.slice.call(arguments);e.unshift(t);analytics.push(e);return analytics}};for(var t=0;t<analytics.methods.length;t++){var e=analytics.methods[t];analytics[e]=analytics.factory(e)}analytics.load=function(t){var e=document.createElement("script");e.type="text/javascript";e.async=!0;e.src=("https:"===document.location.protocol?"https://":"http://")+"cdn.segment.com/analytics.js/v1/"+t+"/analytics.min.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(e,n)};analytics.SNIPPET_VERSION="3.0.0";
  analytics.load("LxxkTXLXYph1SjMTSjyDOItgUh55ElPi");
  analytics.page()
  }}();

  var ref = source();
  // console.log(ref);

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
  analytics.track('Incoming Users', {
    event: 'User entered from',
    properties: ref
  });
});