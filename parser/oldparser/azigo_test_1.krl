{"global":[{"emit":"var url_prefix = \"http://frag.kobj.net/clients/1024/images/\";\n \nvar link_text = {\n  \"aaa\": \"<div style='padding-top: 13px'>AAA</div>\",\n  \"aarp\": \"<div style='padding-top: 13px'>AARP</div>\",\n  \"amex\": \"<div style='padding-top: 5px'>American<br/>Express</div>\",\n  \"bcc\": \"<img style='padding-top: 5px' src='\" + url_prefix + \"bcc_logo_34.png' border='0'>\",\n  \"ebates\": \"<div style='padding-top: 13px'>eBates</div>\",\n  \"ebates_img\": \"<img style='padding-top: 7px' src='\" + url_prefix + \"ebates_logo_34.png' border='0'>\",\n  \"mod_text\": \"<div style='padding-top: 13px'>MoD</div>\",\n  \"mod\": \"<img style='padding-top: 3px' src='\" + url_prefix + \"mod_logo_34.png' border='0' >\",\n  \"sadv\": \"<img style='padding-top: 3px' src='\" + url_prefix + \"sadv_logo_34.png' border='0' >\",\n  \"sadv_txt\": \"<div style='padding-top: 7px'>Student<br/>Advantage</div>\",\n  \"upromise\": \"<div style='padding-top: 13px'>UPromise</div>\",\n  \"sep\": \"<div style='padding-top: 13px'>|</div>\"\n};\n\nfunction get_host(s) {\n var h = \"\";\n try {\n   h = s.match(/^(?:\\w+:\\/\\/)?([\\w.]+)/)[1];\n } catch(err) {\n }\n return h;\n}\n\nfunction pick (o) {\n    if (o) {\n        return o[Math.floor(Math.random()*o.length)];\n    } else {\n        return o;\n    }\n}\n\nfunction mk_list_item(i) {\n  return $K(\"<li class='KOBJ_item'>\").css(\n          {\"float\": \"left\",\n\t   \"margin\": \"0\",\n\t   \"vertical-align\": \"middle\",\n\t   \"padding-left\": \"4px\",\n\t   \"color\": \"#CCC\",\n\t   \"white-space\": \"nowrap\",\n           \"text-align\": \"center\"\n          }).append(i);\n}\n\nfunction mk_rm_div (anchor) {\n  var logo_item = mk_list_item(anchor);\n  var logo_list = $K('<ul>').css(\n          {\"margin\": \"0\",\n           \"padding\": \"0\",\n           \"list-style\": \"none\"\n          }).attr(\"id\", \"KOBJ_logo_list\").append(logo_item);\n  var inner_div = $K('<div>').css(\n          {\"float\": \"left\",\n           \"display\": \"inline\",\n           \"height\": \"40px\",\n           \"margin-left\": \"46px\",\n           \"padding-right\": \"15px\",\n           \"background-image\": \"url(\" + url_prefix + \"remindme_bar40_r.png)\",\n           \"background-repeat\": \"no-repeat\",\n           \"background-position\": \"right top\"\n          }).append(logo_list);\n  var rm_div = $K('<div>').css(\n          {\"float\": \"right\",\n           \"width\": \"auto\",\n           \"height\": \"40px\",\n           \"font-size\": \"12px\",\n           \"line-height\": \"normal\",\n           \"font-family\": \"Verdana, Geneva, sans-serif\",\n           \"background-image\": \"url(\"+ url_prefix + \"remindme_bar40_l.png)\", \n           \"background-repeat\": \"no-repeat\",\n           \"background-position\": \"left top\"\n\t   }).append(inner_div);\n  return rm_div;\n}\n\nfunction mk_anchor (o, key) {\n   return $K('<a href=' + o.link + '/>').attr(\n            {\"class\": 'KOBJ_'+key,\n     \t     \"title\": o.text || \"Click here for discounts!\"\n   \t    }).html(link_text[key]);\n}\n\nfunction insert_div(obj, selector, contents) {\n   if($K(obj).find('#KOBJ_logo_list li').is('.KOBJ_item')) {\n      $K(obj).find('#KOBJ_logo_list').append(mk_list_item(link_text['sep'])).append(mk_list_item(contents));\n   } else {\n      $K(obj).find(selector).prepend(mk_rm_div(contents));\n   }\n}\n\nvar google_search_re = new RegExp(\"^/search\");\nvar google_search = location.pathname.match(google_search_re);\n\nfunction insert_div_google (key, obj) {\n   var host = get_host($K(obj).find(\"cite\").text());\n   var d = KOBJ[key];\n   var o = pick(d[host]);\n   var f = function(){insert_div(obj, 'div.s', mk_anchor(o,key));};\n   if(o) {\n      if(!google_search && location.hash) {\n         setTimeout(\"f()\",2000);\n      } else {\n         f();\n      }\n   }\n};\n\n\nfunction insert_div_yahoo (key, obj) {\n   var host = get_host($K(obj).find(\"span.url\").text());\n   var d = KOBJ[key];\n   var o = pick(d[host]);\n   if(o) {\n      insert_div(obj, \"div.abstr\", mk_anchor(o,key));\n   }\n};\n\n"}],"global_start_line":4,"dispatch":[],"dispatch_start_col":null,"meta_start_line":null,"rules":[{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"aaa","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li.g\").each(function() {\n insert_div_google('aaa',this);\n});\n\n    "}],"post":null,"pre":[],"name":"aaa_google","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_aaa","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":135},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"aaa","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li div.res\").each(function() { \n insert_div_yahoo('aaa',this);\n})\n\n    "}],"post":null,"pre":[],"name":"aaa_yahoo","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_aaa","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":163},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"aarp","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li.g\").each(function() {\n insert_div_google('aarp',this);\n});\n\n    "}],"post":null,"pre":[],"name":"aarp_google","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_aarp","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":193},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"aarp","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li div.res\").each(function() { \n insert_div_yahoo('aarp',this);\n})\n\n    "}],"post":null,"pre":[],"name":"aarp_yahoo","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_aarp","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":221},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"amex","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li.g\").each(function() {\n insert_div_google('amex',this);\n});\n\n    "}],"post":null,"pre":[],"name":"amex_google","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_amex","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":252},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"amex","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li div.res\").each(function() { \n insert_div_yahoo('amex',this);\n})\n\n    "}],"post":null,"pre":[],"name":"amex_yahoo","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_amex","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":280},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"ebates","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li.g\").each(function() {\n insert_div_google('ebates',this);\n});\n\n    "}],"post":null,"pre":[],"name":"ebates_google","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_ebates","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":311},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"ebates","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li div.res\").each(function() { \n insert_div_yahoo('ebates',this);\n})\n\n    "}],"post":null,"pre":[],"name":"ebates_yahoo","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_ebates","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":339},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"mod","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li.g\").each(function() { \n insert_div_google('mod',this);\n});\n\n      "}],"post":null,"pre":[],"name":"mod_google","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_mod","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":371},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"mod","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li div.res\").each(function() { \n insert_div_yahoo('mod',this);\n});\n\n    "}],"post":null,"pre":[],"name":"mod_yahoo","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_mod","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":397},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"sadv","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li.g\").each(function() { \n insert_div_google('sadv',this);\n});\n\n      "}],"post":null,"pre":[],"name":"sadv_google","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_sadv","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":428},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"sadv","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li div.res\").each(function() { \n insert_div_yahoo('sadv',this);\n});\n\n    "}],"post":null,"pre":[],"name":"sadv_yahoo","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_sadv","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":454},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"upromise","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li.g\").each(function() { \n insert_div_google('upromise',this);\n});\n\n      "}],"post":null,"pre":[],"name":"upromise_google","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_upromise","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":484},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"upromise","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"li div.res\").each(function() { \n insert_div_yahoo('upromise',this);\n});\n\n    "}],"post":null,"pre":[],"name":"upromise_yahoo","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_upromise","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":510},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"bcc","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"var KOBJ_bcc_html = function(bcc_data, container_tag) { \n   var bcc_html = $K('<img>').attr(\n      {\"src\": \"http://frag.kobj.net/clients/15/images/BCC_logo.png\",\n       \"border\": \"0\",\n       \"align\": \"left\",\n       \"valign\": \"middle\"\n       });\n\n   if(bcc_data.link) {\n     bcc_html = $K('<a>').attr(\n       {\"class\": \"KOBJ_bcc\",\n        \"href\": bcc_data.link,\n\t\"title\": bcc_data.text\n\t}).append(bcc_html);\n   }\n\n   var td1 = $K('<td>').append(bcc_html);\n   var td2 = $K('<td>').attr(\n                {\"bgcolor\": '#ccffcc'\n\t\t}).text(bcc_data.text);\n\n   bcc_html = $K('<table>').css('padding','10px').append(\n                    $K('<tr>').append(td1).append(td2)\n\t\t    );\n\n   return $K(container_tag).append(bcc_html);\n};\n\n\nvar KOBJ_bcc_googlemaps_ol= function() { \n $K(\"div.local div.res div.one\").each(function() { \n   var pn = $K(this).find(\"span#sxphone\").text().replace(/\\(|\\)|-|\\.|\\s/g,'');\n   var o = KOBJ.pick(KOBJ.bcc[pn]);\n   if(o)  {\n     $K(this).find(\"div.sa\").after(KOBJ_bcc_html(o, '<div>'));\n   };\n\n });\n return true;\n};\n$K(\"form#q_form\").submit(function(e){\n  setTimeout(\"(KOBJ_bcc_googlemaps_ol());\",2000);\n});\n\n    "}],"post":null,"pre":[],"name":"bcc_googlemaps","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_bcc","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://maps.google.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":544},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"bcc","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"var KOBJ_bcc_html = function(bcc_data, container_tag) { \n   var bcc_html = $K('<img>').attr(\n      {\"src\": \"http://frag.kobj.net/clients/15/images/BCC_logo.png\",\n       \"border\": \"0\",\n       \"align\": \"left\",\n       \"valign\": \"middle\"\n       });\n\n   if(bcc_data.link) {\n     bcc_html = $K('<a>').attr(\n       {\"class\": \"KOBJ_bcc\",\n        \"href\": bcc_data.link,\n\t\"title\": bcc_data.text\n\t}).append(bcc_html);\n   }\n\n   var td1 = $K('<td>').append(bcc_html);\n   var td2 = $K('<td>').attr(\n                {\"bgcolor\": '#ccffcc'\n\t\t}).text(bcc_data.text);\n\n   bcc_html = $K('<table>').css('padding','10px').append(\n                    $K('<tr>').append(td1).append(td2)\n\t\t    );\n\n   return $K(container_tag).append(bcc_html);\n};\n\n\n$K(\"#yls-results tbody\").each(function() { \n var pn = $K(this).find(\"span.tel\").text().replace(/\\(|\\)|-|\\.|\\s/g,'');\n var o = KOBJ.pick(KOBJ.bcc[pn]);\n if(o)  {\n   $K(this).find(\"td.yls-rs-bizinfo\").append(KOBJ_bcc_html(o, '<div>'));\n }\n});\n\n    "}],"post":null,"pre":[],"name":"bcc_yahoo_local","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_bcc","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://local.yahoo.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":613},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"bcc","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"var KOBJ_bcc_html = function(bcc_data, container_tag) { \n   var bcc_html = $K('<img>').attr(\n      {\"src\": \"http://frag.kobj.net/clients/15/images/BCC_logo.png\",\n       \"border\": \"0\",\n       \"align\": \"left\",\n       \"valign\": \"middle\"\n       });\n\n   if(bcc_data.link) {\n     bcc_html = $K('<a>').attr(\n       {\"class\": \"KOBJ_bcc\",\n        \"href\": bcc_data.link,\n\t\"title\": bcc_data.text\n\t}).append(bcc_html);\n   }\n\n   var td1 = $K('<td>').append(bcc_html);\n   var td2 = $K('<td>').attr(\n                {\"bgcolor\": '#ccffcc'\n\t\t}).text(bcc_data.text);\n\n   bcc_html = $K('<table>').css('padding','10px').append(\n                    $K('<tr>').append(td1).append(td2)\n\t\t    );\n\n   return $K(container_tag).append(bcc_html);\n};\n\n$K(\"ul.listingLayout ol.linklist > li\").each(function() { \n var pn = $K(this).find(\"ul.linklistNoBullets li:eq(1)\").text().split(\"|\").pop();\n pn = pn.replace(/\\(|\\)|-|\\.|\\s/g,'');\n var o = KOBJ.pick(KOBJ.bcc[pn]);\n if(o)  {\n   $K(this).find(\"ul.linklistNoBullets\").append(KOBJ_bcc_html(o, '<li>'));\n }\n\n});\n\n\n    "}],"post":null,"pre":[],"name":"bcc_boston_search","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_bcc","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://search.boston.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":672},{"cond":{"args":[{"source":"page","predicate":"env","args":[{"val":"datasets","type":"str"}],"type":"qualified"},{"val":"bcc","type":"str"}],"type":"ineq","op":"like"},"blocktype":"every","actions":[{"label":null,"emit":"var KOBJ_bcc_html = function(bcc_data, container_tag) { \n   var bcc_html = $K('<img>').attr(\n      {\"src\": \"http://frag.kobj.net/clients/15/images/BCC_logo.png\",\n       \"border\": \"0\",\n       \"align\": \"left\",\n       \"valign\": \"middle\"\n       });\n\n   if(bcc_data.link) {\n     bcc_html = $K('<a>').attr(\n       {\"class\": \"KOBJ_bcc\",\n        \"href\": bcc_data.link,\n\t\"title\": bcc_data.text\n\t}).append(bcc_html);\n   }\n\n   var td1 = $K('<td>').append(bcc_html);\n   var td2 = $K('<td>').attr(\n                {\"bgcolor\": '#ccffcc'\n\t\t}).text(bcc_data.text);\n\n   bcc_html = $K('<table>').css('padding','10px').append(\n                    $K('<tr>').append(td1).append(td2)\n\t\t    );\n\n   return $K(container_tag).append(bcc_html);\n};\n\nvar KOBJ_insert_bcc_ol= function(rlist_selector, phone_selector) { \n  $K(rlist_selector).each(function() { \n   var pn = $K(this).find(phone_selector).text().replace(/\\(|\\)|-|\\.|\\s/g,'');\n   var o = KOBJ.pick(KOBJ.bcc[pn]);\n   if(o)  {\n     $K(this).append(KOBJ_bcc_html(o, '<div>'));\n   }\n  });\n  return true;\n};\n\nvar KOBJ_bcc_yelp_binder = function() {\n  $K(\"#searchLayoutFilters li\").click(function(e){\n    setTimeout(\n    \"KOBJ_insert_bcc_ol('#businessresults div.businessresult','div.phone');KOBJ_bcc_yelp_binder();\",\n    5000);\n  });\n};\n\nKOBJ_insert_bcc_ol('#businessresults div.businessresult','div.phone');\nKOBJ_bcc_yelp_binder();\n    "}],"post":null,"pre":[],"name":"bcc_yelp","start_col":3,"emit":null,"state":"active","callbacks":{"success":[{"attribute":"class","trigger":null,"value":"KOBJ_bcc","type":"click"}],"failure":null},"pagetype":{"event_expr":{"pattern":"^http://www.yelp.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":734}],"meta_start_col":null,"meta":{},"dispatch_start_line":null,"global_start_col":3,"ruleset_name":"azigo_test_1"}