function _guaLt(e) {

    /* If GA is blocked or not loaded, or not main|middle|touch click then don't track */
    if (!{$GlobalName}.hasOwnProperty("loaded") || 1 != {$GlobalName}.loaded || (e.which != 1 && e.which != 2)) {
        return;
    }

    var el = e.srcElement || e.target;

    /* Loop through parent elements if clicked element is not contained in a link */
    while (el && (typeof el.tagName == "undefined" || el.tagName.toLowerCase() != "a" || !el.href)) {
        el = el.parentNode;
    }

    if (el && el.href) {
        var dl = document.location;
        var l = dl.pathname + dl.search; /* event label = referer */
        var h = el.href; /* event link */
        var a = h; /* clone link for processing */
        var c = !1; /* event category */
        var t = (el.target && !el.target.match(/^_(self|parent|top)$/i)) ? el.target : !1; /* link target */

        /* Assume a target if (Ctrl|shift|meta)-click */
        if (e.ctrlKey || e.shiftKey || e.metaKey || e.which == 2) {
            t = "_blank";
        }

        /* telephone links */
        if (h.match(/^tel\\:/i)) {
            c = "{$PhoneCategory}";
            a = h.replace(/\D/g,"");
        }

        /* email links */
        else if (h.match(/^mailto\\:/i)) {
            c = "{$EmailCategory}";
            a = h.slice(7);
        }

        /* if external (and not JS) link then track event as "Outgoing Links" */
        else if (h.indexOf(location.host) == -1 && !h.match(/^javascript\\:/i)) {
            c = "{$LinkCategory}";
        }

        /* else if /assets/ (not images) track as "Downloads" */
        else if (h.match(/\\/assets\\//) && !h.match(/\\.(jpe?g|bmp|png|gif|tiff?)$/i)) {
            c = "{$DownloadsCategory}";
            a = h.match(/\\/assets\\/(.*)/)[1];
        }

        if (c) {

            if (t) {
                /* link opens a new window already - just track */
                $NonCallbackTrackers
            } else {
                /* link opens in same window & requires callback */

                /* Prevent click */
                e.preventDefault ? e.preventDefault() : e.returnValue = !1;

                var hbrun = false; /* tracker has not yet run */

                /* hitCallback function for GA */
                var hb = function() {
                    /* run once only */
                    if(hbrun) return;
                    hbrun = true;
                    window.location.href = h;
                };

                /* Add GA tracker(s) */
                $CallbackTrackers

                /* Run hitCallback function if GA takes too long */
                setTimeout(hb,1000);

            }
        }
    }
}

/* Attach the event to all clicks in the document after page has loaded */
var _w = window;
/* Use "click" if touchscreen device, else "mousedown" */
var _gaLtEvt = ("ontouchstart" in _w) ? "click" : "mousedown";
/* Attach the event to all clicks in the document after page has loaded */
_w.addEventListener ? _w.addEventListener("load", function(){document.body.addEventListener(_gaLtEvt, _guaLt, !1)}, !1)
 : _w.attachEvent && _w.attachEvent("onload", function(){document.body.attachEvent("on" + _gaLtEvt, _guaLt)});