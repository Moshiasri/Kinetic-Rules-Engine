{"global":[],"global_start_line":null,"dispatch":[{"domain":"bing.com","ruleset_id":null},{"domain":"cnn.com","ruleset_id":null},{"domain":"google.com","ruleset_id":null},{"domain":"facebook.com","ruleset_id":null}],"dispatch_start_col":3,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"prepend","args":[{"val":"#medium_rectangle","type":"str"},{"val":"content","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"source":"math","predicate":"random","args":[{"val":999999999999,"type":"num"}],"type":"qualified"},"lhs":"cb","type":"expr"},{"rhs":"<div id='Optini_Logo'>  <div id='Optini_Ad' align=\"center\">  <script>  var m3_u = document.location.protocol + \"//\" + \"vue.us.vucdn.com/x282/www/delivery/ajs.php\";  var m3_r = Math.floor(Math.random()*99999999999);  var zone = \"351\";   if( !document.MAX_used ) {   document.MAX_used = ',';  }    var src = \"?zoneid=\"+ zone + '&cb=' + m3_r;    if( document.MAX_used != ',' ) {   src += \"&exclude=\" + document.MAX_used;  }  \t\t\t  src += document.charset ? '&charset='+document.charset : (document.characterSet ? '&charset='+document.characterSet : '');  \t\t  src += \"&loc=\" + escape(window.location);  \t\t  if(document.referrer) {   src += \"&referer=\" + escape(document.referrer);  }    if(document.context) {   src += \"&context=\" + escape(document.context);  }    if(document.mmm_fo) {   src += \"&mmm_fo=1\";  }    src += \"&url=\" + escape(m3_u);  src = \"http:\\/\\/vuliquid.optini.com/x282/www/delivery/bridge.php\" + src;    jQuery('<scr'+'ipt/>').attr('src', src).appendTo('#Optini_Ad');    </script>  </div>  </div>    \r\n ","lhs":"content","type":"here_doc"}],"name":"cnn_com_homepage","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"http://www.cnn.com/|http://www.cnn.com/?.*","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":23},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"prepend","args":[{"val":"#footer","type":"str"},{"val":"content","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"source":"math","predicate":"random","args":[{"val":999999999999,"type":"num"}],"type":"qualified"},"lhs":"cb","type":"expr"},{"rhs":"<div id='Optini_Logo'>\r\n<div id='Optini_Ad'></div>\r\n</div>\r\n\r\n<script>\r\nvar m3_u = document.location.protocol + \"//\" + \"vue.us.vucdn.com/x282/www/delivery/ajs.php\";\r\nvar m3_r = Math.floor(Math.random()*99999999999);\r\nvar zone = \"353\"; // Enter VuLiquid ZoneID here\r\n\r\nif( !document.MAX_used ) {\r\n document.MAX_used = ',';\r\n}\r\n\r\nvar src = \"?zoneid=\"+ zone + '&cb=' + m3_r;\r\n\r\nif( document.MAX_used != ',' ) {\r\n src += \"&exclude=\" + document.MAX_used;\r\n}\r\n\t\t\t\r\nsrc += document.charset ? '&charset='+document.charset : (document.characterSet ? '&charset='+document.characterSet : '');\r\n\t\t\r\nsrc += \"&loc=\" + escape(window.location);\r\n\t\t\r\nif(document.referrer) {\r\n src += \"&referer=\" + escape(document.referrer);\r\n}\r\n\r\nif(document.context) {\r\n src += \"&context=\" + escape(document.context);\r\n}\r\n\r\nif(document.mmm_fo) {\r\n src += \"&mmm_fo=1\";\r\n}\r\n\r\nsrc += \"&url=\" + escape(m3_u);\r\nsrc = \"http:\\/\\/vuliquid.optini.com/x282/www/delivery/bridge.php\" + src;\r\n\r\njQuery('<scr'+'ipt/>').attr('src', src).appendTo('#Optini_Ad');\r\n\r\n</script>\r\n\r\n ","lhs":"content","type":"here_doc"}],"name":"google_com_homepage","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"^http://www.google.co.*/$","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":38},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"prepend","args":[{"val":"#results_area","type":"str"},{"val":"content","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"source":"math","predicate":"random","args":[{"val":999999999999,"type":"num"}],"type":"qualified"},"lhs":"cb","type":"expr"},{"rhs":"<div id='Optini_Ad' align=\"center\">  <script>  var m3_u = document.location.protocol + \"//\" + \"vue.us.vucdn.com/x282/www/delivery/ajs.php\";  var m3_r = Math.floor(Math.random()*99999999999);  var zone = \"350\";   if( !document.MAX_used ) {   document.MAX_used = ',';  }    var src = \"?zoneid=\"+ zone + '&cb=' + m3_r;    if( document.MAX_used != ',' ) {   src += \"&exclude=\" + document.MAX_used;  }  \t\t\t  src += document.charset ? '&charset='+document.charset : (document.characterSet ? '&charset='+document.characterSet : '');  \t\t  src += \"&loc=\" + escape(window.location);  \t\t  if(document.referrer) {   src += \"&referer=\" + escape(document.referrer);  }    if(document.context) {   src += \"&context=\" + escape(document.context);  }    if(document.mmm_fo) {   src += \"&mmm_fo=1\";  }    src += \"&url=\" + escape(m3_u);  src = \"http:\\/\\/vuliquid.optini.com/x282/www/delivery/bridge.php\" + src;    jQuery('<scr'+'ipt/>').attr('src', src).appendTo('#Optini_Ad');    </script>  </div>  \r\n ","lhs":"content","type":"here_doc"}],"name":"bing_com_search_results","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"^http://www.bing.com/.*q=.*&.*","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":94},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"prepend","args":[{"val":"#rightCol","type":"str"},{"val":"content","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"source":"math","predicate":"random","args":[{"val":999999999999,"type":"num"}],"type":"qualified"},"lhs":"cb","type":"expr"},{"rhs":"<div id='Optini_Logo'>    <div id='Optini_Ad'></div>    </div>        <script>    var m3_u = document.location.protocol + \"//\" + \"vue.us.vucdn.com/x282/www/delivery/ajs.php\";    var m3_r = Math.floor(Math.random()*99999999999);    var zone = \"352\";       if( !document.MAX_used ) {     document.MAX_used = ',';    }        var src = \"?zoneid=\"+ zone + '&cb=' + m3_r;        if( document.MAX_used != ',' ) {     src += \"&exclude=\" + document.MAX_used;    }    \t\t\t    src += document.charset ? '&charset='+document.charset : (document.characterSet ? '&charset='+document.characterSet : '');    \t\t    src += \"&loc=\" + escape(window.location);    \t\t    if(document.referrer) {     src += \"&referer=\" + escape(document.referrer);    }        if(document.context) {     src += \"&context=\" + escape(document.context);    }        if(document.mmm_fo) {     src += \"&mmm_fo=1\";    }        src += \"&url=\" + escape(m3_u);    src = \"http:\\/\\/mehshan.dev.optini.com/bridge.php\" + src;        if( document.getElementById('Optini_Ad_Content') )    {        }    else    {      jQuery('<scr'+'ipt/>').attr('src', src).appendTo('#Optini_Ad');    }        </script>        \r\n ","lhs":"content","type":"here_doc"}],"name":"facebook_com_members","start_col":5,"emit":"if(window.OPTINI_WatchSet){ } else {    \tKOBJ.watchDOM(\"#rso\",function(){            var app = KOBJ.get_application(\"a661x29\");            app.reload();     \t\twindow.OPTINI_WatchSet = true;    \t});    }                ","state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"facebook.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":109}],"meta_start_col":3,"meta":{"logging":"off","name":"YoungLiving","meta_start_line":2,"author":"","description":"","meta_start_col":3},"dispatch_start_line":13,"global_start_col":null,"ruleset_name":"a661x29"}
