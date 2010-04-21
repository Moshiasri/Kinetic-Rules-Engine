KOBJ.proto = function() {
    return (("https:" == KOBJ.location('protocol')) ? "https://" : "http://")
};

//this method is overridden in sandboxed environments
KOBJ.require = function(url) {
    var r = document.createElement("script");
    r.src = url;
    r.type = "text/javascript";
    r.onload = r.onreadystatechange = KOBJ.url_loaded_callback;
    //  console.log("Requiring " + url);
    var body = document.getElementsByTagName("body")[0] ||
               document.getElementsByTagName("frameset")[0];
    body.appendChild(r);

};

//this method is overridden in sandboxed environments
KOBJ.getwithimage = function(url) {
    var i = document.createElement("img");
    i.setAttribute("src", url);
    document.body.appendChild(i);
};


/* Sets up the call backs for "click" and "change" events */
KOBJ.obs = function(type, attr, txn_id, name, sense, rule, rid) {
    var elem;
    if (attr == 'class') {
        elem = '.' + name;
    } else if (attr == 'id') {
        elem = '#' + name;
    } else {
        elem = name;
    }
    if (type == 'click') {
        $K(elem).click(function(e1) {
            var tgt = $K(this);
            var b = tgt.attr('href') || '';
            KOBJ.logger("click",
                    txn_id,
                    name,
                    b,
                    sense,
                    rule,
                    rid
                    );
            if (b) {
                tgt.attr('href', '#KOBJ');
            }  // # gets replaced by redirect
        });

    } else if (type == 'change') {
        $K(elem).change(function(e1) {
            KOBJ.logger("change",
                    txn_id,
                    name,
                    '',
                    sense,
                    rule,
                    rid
                    );
        });
    }

};


/* Injects a javascript fragment into the page */
KOBJ.fragment = function(base_url) {
    var e = KOBJ.document.createElement("script");
    e.src = base_url;
    var body = KOBJ.document.getElementsByTagName("body")[0];
    body.appendChild(e);
};

/* Replaces the html contents of an element */
KOBJ.update_elements = function (params) {
    for (var mykey in params) {
        $K("#kobj_" + mykey).html(params[mykey]);
    }
};

// wrap some effects for use in embedded HTML
KOBJ.Fade = function (id) {
    $K(id).fadeOut();
};

KOBJ.BlindDown = function (id) {
    $K(id).slideDown();
};

KOBJ.BlindUp = function (id) {
    $K(id).slideUp();
};

KOBJ.BlindUp = function (id, speed) {
    $K(id).slideUp(speed);
};

KOBJ.hide = function (id) {
    $K(id).hide();
};

KOBJ.letitsnow = function(config) {
    $K(KOBJ.document).snowfall();
};

//new jessie actions


KOBJ.createPopIn = function(config, content) {

    var defaults = {
        "position": "left-center",
        "imageLocation": "http://k-misc.s3.amazonaws.com/actions/pop_in_feedback.jpg",
        "bg_color": "#FFFFFF",
        "link_color": "#FF0000",
        "overlay_color": "#000000"
    };
    if (typeof config === 'object') {
        jQuery.extend(defaults, config);
    }

    var side1;
    var side2;
    var distance;

    switch (defaults["position"])
    {
        case "top-left":
            side1 = "top";
            side2 = "left";
            distance = "10%";
            break;
        case "top-center":
            side1 = "top";
            side2 = "left";
            distance = "45%";
            break;
        case "top-right":
            side1 = "top";
            side2 = "right";
            distance = "10%";
            break;
        case "bottom-left":
            side1 = "bottom";
            side2 = "left";
            distance = "10%";
            break;
        case "bottom-center":
            side1 = "bottom";
            side2 = "left";
            distance = "45%";
            break;
        case "bottom-right":
            side1 = "bottom";
            side2 = "right";
            distance = "10%";
            break;
        case "left-top":
            side1 = "left";
            side2 = "top";
            distance = "10%";
            break;
        case "left-center":
            side1 = "left";
            side2 = "top";
            distance = "45%";
            break;
        case "left-bottom":
            side1 = "left";
            side2 = "bottom";
            distance = "10%";
            break;
        case "right-top":
            side1 = "right";
            side2 = "top";
            distance = "10%";
            break;
        case "right-center":
            side1 = "right";
            side2 = "top";
            distance = "45%";
            break;
        case "right-bottom":
            side1 = "right";
            side2 = "bottom";
            distance = "10%";
            break;
        default:
            side1 = "left";
            side2 = "top";
            distance = "45%";
            break;
    }

    $K('body').append('<div id="KOBJ_PopIn_Link" style="' + side1 + ': 0; ' + side2 + ':' + distance + '; -moz-border-radius-bottomright: 12px; -moz-border-radius-topright: 12px; background-color:' + defaults["link_color"] + '; display:block; margin-top:-45px; position: fixed;  z-index:100001;"><a href="javascript:KOBJ_create_pop_in()"><img src="' + defaults["imageLocation"] + '" alt="KOBJ_pop_in" border="none" /></a>');
    KOBJ_create_pop_in = function() {
        var OverlayPresent = $K('#KOBJ_PopIn_Overlay').length;
        var ContentPresent = $K('#KOBJ_PopIn_Dialog').length;

        if (OverlayPresent) {
            $K('#KOBJ_PopIn_Overlay').fadeIn('slow');
        }
        if (ContentPresent) {
            $K('#KOBJ_PopIn_Dialog').fadeIn('slow');
        }
        if (!OverlayPresent) {
            $K('body').append('<div id="KOBJ_PopIn_Overlay" style="display: block; position: fixed; background-color: ' + defaults["overlay_color"] + '; height: 100%; width: 100%; left: 0; filter:alpha(opacity=70); opacity: 0.7; top: 0; z-index: 100002; display: none;" />');
            $K('#KOBJ_PopIn_Overlay').fadeIn('slow');
        }
        if (!ContentPresent) {

            // TODO: Display is overridden remove which one?
            $K('body').append('<div id="KOBJ_PopIn_Dialog" style="top: 45%; right: 40%; -moz-border-radius: 5px; display: block; height: auto; width: 20%; position: fixed; margin: 0 auto; text-align: center; z-index: 100003; display: none; background: ' + defaults["bg_color"] + '; filter:alpha(opacity=85); opacity: .85; "><div class="close" id="KOBJ_Close" style="cursor: pointer; float: right; font-weight: bold; margin-right: 8px; margin-top: 5px;">x</div><div id="KOBJ_PopIn_Content" style="padding: 10px; ">' + content + '</div></div>');
            $K("#KOBJ_Close").click(function() {
                KOBJ_close_pop_in();
            });
            $K('#KOBJ_PopIn_Dialog').fadeIn('slow');
        }

    };

    KOBJ_close_pop_in = function() {

        $K('#KOBJ_PopIn_Overlay').fadeOut('slow');
        $K('#KOBJ_PopIn_Dialog').fadeOut('slow');

    };

};


KOBJ.statusbar = function(config, content) {

    var defaults = {


        "sticky": false,
        "width": "98.5%",
        "height": "30px",
        "id": "KOBJ_status_bar",
        "bg_color": "#222222",
        "delay": 3000,
        "position": "bottom",
        "opacity": ".8",
        "color": "#ffffff"

    };
    if (typeof config === 'object') {
        if (config["sticky"] === true) {
            config["delay"] = false;
        }
        jQuery.extend(defaults, config);

    }
    var side = "";
    var corners = "";
    var direction = "";

    switch (defaults["position"]) {
        case "top":
            side = "top";
            corners = "bottom";
            direction = "down";
            break;
        case "bottom":
            side = "bottom";
            corners = "top";
            direction = "up";
            break;
        default:
            side = "bottom";
            corners = "top";
            direction = "up";
            break;
    }


    $K('body').append('<div id="' + defaults["id"] + '_wrapper" style="display: none; position: fixed; ' + side + ': 0; width: 100%; height: ' + defaults["height"] + ';"><div id="' + defaults["id"] + '" style="color: ' + defaults["color"] + '; height: ' + defaults["height"] + '; background: ' + defaults["bg_color"] + '; opacity: ' + defaults["opacity"] + '; -moz-border-radius-' + corners + 'right: 5px; -moz-border-radius-' + corners + 'left: 5px; margin-left: 12px; margin-right: 30px;"><div class="close" style="float: right; font-weight: bold; font-size: 20px; cursor: pointer; margin-right: 10px; margin-top: 5px;">x</div><div class="KOBJ_statusbar_content" style="color: ' + defaults["color"] + ';">' + content + '</div></div>');
    $K('#' + defaults["id"] + '>.close').click(function() {
        KOBJ.statusbar_close(defaults["id"]);
    });
    $K('#' + defaults["id"] + '_wrapper').slideDown('slow');
    if (defaults["sticky"] === false) {
        setTimeout(function() {
            KOBJ.statusbar_close(defaults["id"]);
        }, defaults["delay"]);
    }


};

KOBJ.statusbar_close = function(id) {
    $K('#' + id).fadeOut('slow');
};

//end new jessie actions


// helper functions used by float
KOBJ.buildDiv = function (uniq, pos, top, side) {
    var vert = top.split(/\s*:\s*/);
    var horz = side.split(/\s*:\s*/);
    var div_style = {
        position: pos,
        zIndex: '9999',
        opacity: 0.999999,
        display: 'none'
    };
    div_style[vert[0]] = vert[1];
    div_style[horz[0]] = horz[1];
    var id_str = 'kobj_' + uniq;
    var div = KOBJ.document.createElement('div');
    return $K(div).attr({'id': id_str}).css(div_style);
};

// return the host portion of a URL
KOBJ.get_host = function(s) {
    var h = "";
    try {
        h = s.match(/^(?:\w+:\/\/)?([\w-.]+)/)[1];
    } catch(err) {
    }
    return h;
};

// randomly pick a member of a list
KOBJ.pick = function(o) {
    if (o) {
        return o[Math.floor(Math.random() * o.length)];
    } else {
        return o;
    }
};

// attach a close event to an element inside a notification
KOBJ.close_notification = function(s) {
    $K(s).bind("click.kGrowl",
            function(e) {
                $K(this).unbind('click.kGrowl');
                $K(s).parents(".kGrowl-notification").trigger('kGrowl.beforeClose').animate({opacity: 'hide'}, "normal", "swing", function() {
                    $K(this).trigger('kGrowl.close').remove();
                });
            });
};


/*
 Called when one of our script is loaded including css links
 */
KOBJ.url_loaded_callback = function() {

    var done = false;
    if (!done && (!this.readyState || this.readyState === "loaded" || this.readyState === "complete"))
    {
        done = true;
        var url = null;
        if (typeof(this.src) != "undefined")
        {
            url = this.src;
        }
        else
        {
            url = this.href;
        }
        if (url == null)
        {
            return;
        }
//        alert("Go callback for " + url);

        if (KOBJ.external_resources[url] != null)
        {
//            alert("Found a resource and letting it know");
            KOBJ.external_resources[url].did_load();
        }
//        alert("Done letting everyone know");

        this.onload = this.onreadystatechange = null;
    }
};

/*
 Search all the stylesheets on the page and see if the url matches. If it does it was loaded

 url = URL to stylesheet
 selector = The selector must be fully qualified so if in the CSS it looks like ".tab span { }" then the selector
 here  must be ".tab span"

 */
KOBJ.did_stylesheet_load = function(url, selector) {

    var found_style = false;
    $K.each(document.styleSheets, function(sheet_index, style_sheet) {
        // We have the stylesheet
        if (style_sheet.href != null) {
            if (style_sheet.href == url) {
                // Look for the selector
                //                                if (style_sheet.rules != null)
                //                                {
                //                                    $K.each(style_sheet.rules, function(rule_index, rule) {
                //                                        if (rule.selectorText == selector) {
                //                                            KOBJ.log("Also found the selector");
                //                                            found_style = true;
                //                                            // Return false to break out of the each loop.
                //                                            return false;
                //                                        }
                //                                    });
                //                                }
                found_style = true;
                return false;
            }
        }
    });
    return found_style;
};

/*
 Add a link tag to the head of the document
 url = URL to stylesheet
 */
KOBJ.load_style_sheet_link = function(url) {
    var head = KOBJ.document.getElementsByTagName('head')[0];
    var new_style_sheet = document.createElement("link");
    new_style_sheet.href = url;
    new_style_sheet.rel = "stylesheet";
    new_style_sheet.type = "text/css";
    new_style_sheet.onload = new_style_sheet.onreadystatechange = KOBJ.url_loaded_callback;
    head.appendChild(new_style_sheet);
};


KOBJ.siteIds = function()
{
    var siteid = [];
    $K.each(KOBJ.applications, function(index, app) {
        siteid[index] = app.app_id;
    });
    return siteid.join(";");
};

KOBJ.errorstack_submit = function(key, e) {
    // No key the ignore.
    if (key == null) {
        return;
    }
    var txt = "_s=" + key + "&_r=img";
    txt += "&Msg=" + escape(e.message ? e.message : e);
    txt += "&URL=" + escape(e.fileName ? e.fileName : "");
    txt += "&Line=" + (e.lineNumber ? e.lineNumber : 0);
    txt += "&name=" + escape(e.name ? e.name : e);
    txt += "&Platform=" + escape(navigator.platform);
    txt += "&UserAgent=" + escape(navigator.userAgent);
    txt += "&stack=" + escape(e.stack ? e.stack : "");
    var i = document.createElement("img");
    i.setAttribute("src", "http://www.errorstack.com/submit?" + txt);
    document.body.appendChild(i);
    //KOBJ.getwithimage("http://www.errorstack.com/submit?" + txt);
};


KOBJ.location = function(part) {
    if (part == "href") return KOBJ.locationHref || KOBJ.document.location.href;
    if (part == "host") return KOBJ.locationHost || KOBJ.document.location.host;
    if (part == "protocol") return KOBJ.locationProtocol || KOBJ.document.location.protocol;
};

/* Hook to log data to the server */
KOBJ.logger = function(type, txn_id, element, url, sense, rule, rid) {
    var logger_url = KOBJ.callback_url + "?type=" +
                     type + "&txn_id=" + txn_id + "&element=" +
                     element + "&sense=" + sense + "&url=" + escape(url) + "&rule=" + rule;

    if (rid) logger_url += "&rid=" + rid;

    KOBJ.require(logger_url);
};

/* Inject requested CSS via a style tag */
KOBJ.css = function(css) {
    var head = KOBJ.document.getElementsByTagName('head')[0];
    var style = KOBJ.document.createElement('style');
    var rules = KOBJ.document.createTextNode(css);

    style.type = 'text/css';
    style.id = 'KOBJ_stylesheet';

    var KOBJstyle = KOBJ.document.getElementById('KOBJ_stylesheet');
    if (KOBJstyle == null) {
        if (style.styleSheet) {
            style.styleSheet.cssText = rules.nodeValue;
        } else {
            style.appendChild(rules);
        }
        head.appendChild(style);
    } else {
        if (KOBJstyle.styleSheet) {
            KOBJstyle.styleSheet.cssText += rules.nodeValue;
        } else {
            KOBJstyle.appendChild(rules);
        }
    }
};

/* Logs data to the browsers windows console */
KOBJ.log = function(msg) {
    /* TODO: Remove this as it is not used  not sure why it is here */
    KOBJ._log.push({'ts':new Date(),'msg':msg});
    if (window.console != undefined && console.log != undefined) {
        console.log(msg);
    }
};

KOBJ.run_when_ready = function() {
    //see if page is already loaded (ex: tags planted AFTER dom ready) to know if we should wait for document onReady
    //this code block is adapted from swfObject code used for the same purpose
    if (typeof KOBJSandboxEnvironment === "undefined" || KOBJSandboxEnvironment !== true) { //sandbox bootstrap prevention
        if ((typeof document.readyState != "undefined" && document.readyState == "complete") ||
            ( typeof document.readyState == "undefined" && (document.getElementsByTagName("body")[0] || document.body))) {
            KOBJ.runit(); //dom ready
        } else {
            $K(KOBJ.runit); //dom not ready
        }
    }
};