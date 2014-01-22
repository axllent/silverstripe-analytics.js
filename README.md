# Google Universal Analytics tracking code for SilverStripe 3
Extension to add Google **Universal Analytics.js** tracking code (`ga()`) to your SilverStripe templates.
This requires an [upgrade of your Google Analytics account](https://developers.google.com/analytics/devguides/collection/upgrade/)
if it is still running with an older setup, and is **not** compatible with the older `_gaq` code (though you may run them simultaneously).

Please see the official [Google Universal Analytics](https://developers.google.com/analytics/devguides/collection/AnalyticsJS/)
site for more information.

It includes tracking for all external links & "assets" downloads using "events" in Google Analytics (optional).

## Features
* Google Universal Analytics `Analytics.js` code injected into `<head>` of page to prevent JavaScript conflicts due to loading order (if you are using
custom `ga()` functions in your other code).
* Automated `pageview` tracking for all configured accounts, including tracking of 404 & 500 page errors (tracked as "Page Not Found"
or "Page Error" events).
* Unobtrustive oubound & download links tracking - attaches to `document.body.onclick` and monitors all page clicks, rather than
on page load (ie: works with links including those generated by Ajax etc on the page after page load).
  * File downloads (all non-images in the assets folder) are tracked as "Downloads" events.
  * Outgoing links are tracked as "Outgoing Links" events.
  * Tracking for both outgoing links and downloads have built-in (500ms) delay if no target="_blank" is set to allow for GA tracking.
* Tracking codes are automatically changed to "UA-DEV-[1+]" if SS_ENVIRONMENT_TYPE is not live, or if page url matches ?flush=
to prevent bad data.

## Requirements
* SilverStripe 3+

## Usage
The extension is automatically loaded if you provide at least one tracking account in your `mysite/_config.php`
<pre>AnalyticsJS::add_ga('create', 'UA-1234567-1', 'auto');</pre>
The syntax is very similar to the official documentation, so things like secondary trackers or other
configurations can be passed as follows:
<pre>
// Add main tracker
AnalyticsJS::add_ga('create', 'UA-1234567-1', 'auto');

// Add a secondary tracker
AnalyticsJS::add_ga('create', 'UA-1237654-1', 'auto', array('name' => 'MyOtherTracker'));

// Require ecommerce extension
AnalyticsJS::add_ga('require', 'ecommerce', 'ecommerce.js');

// Force tracking to use SSL
AnalyticsJS::add_ga('set', 'forceSSL', true);

// Disable link tracking
AnalyticsJS::$track_links = false;
</pre>

To start live tracking, make sure your website is in `live` mode
<pre>define('SS_ENVIRONMENT_TYPE', 'live');</pre>