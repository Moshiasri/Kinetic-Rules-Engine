{"global":[{"emit":"KOBJ.watchDOM(\"#dnb_member_mark\",addMemberClickFunctionality);    function addMemberClickFunctionality() {    $K(\"#dnb_member_mark\").click(function() {      KOBJ.log(\"clicked\");    });    clearInterval(KOBJ.watcherRunning);    }                "},{"rhs":{"val":[{"rhs":{"val":[{"rhs":{"val":"http://dl.dropbox.com/u/1446072/Business%20Information%20Report%20with%20Auto-Refresh-20100115152714.html","type":"str"},"lhs":"pageLocation"}],"type":"hashraw"},"lhs":"www.acxiom.com"},{"rhs":{"val":[{"rhs":{"val":"http://dl.dropbox.com/u/1446072/Business%20Information%20Report%20with%20Auto-Refresh-20100115152714.html","type":"str"},"lhs":"pageLocation"}],"type":"hashraw"},"lhs":"www.dnb.com"}],"type":"hashraw"},"lhs":"DNB","type":"expr"},{"content":"#KOBJ_PopIn_Dialog {    \tleft: 50%;    \tmargin-top: -25%;    \tmargin-left: -25%;    \twidth: 50%;    }    ","type":"css"}],"global_start_line":11,"dispatch":[{"domain":"acxiom.com","ruleset_id":null},{"domain":"dnb.com","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"side_tab","args":[{"val":"msg","type":"var"}],"modifiers":[{"value":{"val":"right-top","type":"str"},"name":"position"},{"value":{"val":"http://dl.dropbox.com/u/1446072/dnb_duns_reg_click_english_110x36_animation_gif.gif","type":"str"},"name":"imageLocation"},{"value":{"val":"transparent","type":"str"},"name":"link_color"}],"vars":null},"label":null},{"label":null,"emit":"setInterval(function() {      $K(\"#KOBJ_PopIn_Dialog\").css(\"left\", \"50%\");      $K(\"#KOBJ_PopIn_Dialog\").css(\"margin-right\", \"-25%\");      $K(\"#KOBJ_PopIn_Dialog\").css(\"margin-left\", \"-25%\");      $K(\"#KOBJ_PopIn_Dialog\").width(\"50%\");      $K(\"#KOBJ_PopIn_Dialog\").css(\"top\", \"20%\");      $K(\"#KOBJ_PopIn_Dialog\").height(\"60%\");      var heightToBe = $K(\"#KOBJ_PopIn_Dialog\").height() - 35;      $K(\"#KOBJ_PopIn_Content > iframe\").height(heightToBe);      $K(\"#KOBJ_Close\").css(\"font-size\", \"14pt\");    },  500);                 "}],"post":null,"pre":[{"rhs":{"source":"page","predicate":"url","args":[{"val":"hostname","type":"str"}],"type":"qualified"},"lhs":"hostName","type":"expr"},{"rhs":"<iframe src=\"#{DNB[hostName].pageLocation}\" width=\"100%\" height=\"0\" />  \t\n ","lhs":"msg","type":"here_doc"}],"name":"mark_member_","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":".","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":16}],"meta_start_col":5,"meta":{"logging":"on","name":"Dun and Bradstreet Community","meta_start_line":2,"author":"Mike Grace","meta_start_col":5},"dispatch_start_line":7,"global_start_col":5,"ruleset_name":"a60x113"}