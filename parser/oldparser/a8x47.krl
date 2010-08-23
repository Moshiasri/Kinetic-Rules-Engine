{"global":[{"source":"http://ws.geonames.org/findNearbyWikipediaJSON","name":"placearticles","type":"datasource","datatype":"JSON","cachable":0}],"global_start_line":18,"dispatch":[{"domain":"wikipedia.org","ruleset_id":null}],"dispatch_start_col":3,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"append","args":[{"val":"#siteNotice","type":"str"},{"val":"form","type":"var"}],"modifiers":null,"vars":null},"label":null},{"action":{"source":null,"name":"watch","args":[{"val":"#nearmeform","type":"str"},{"val":"submit","type":"str"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":"<div id=\"my_div\">\n          <form id=\"nearmeform\" onsubmit=\"return false\" style=\"display:none;\">\n            <input type=\"text\" name=\"lat\" id=\"nearmelat\"/>\n            <input type=\"text\" name=\"lon\" id=\"nearmelon\"/>\n            <input type=\"submit\" value=\"Submit\" />\n          </form>\n          <div id=\"nearmelinks\" style=\"text-align:left;\">\n            <h2>Nearby Links</h2>\n          </div>\n        </div>\n      ","lhs":"form","type":"here_doc"}],"name":"getlocation","start_col":3,"emit":"navigator.geolocation.getCurrentPosition(function(position){\n      $K(\"#nearmelat\").val(position.coords.latitude);\n      $K(\"#nearmelon\").val(position.coords.longitude);\n      $K(\"#nearmeform\").submit();\n      //alert(\"lat: \" + position.coords.latitude + \" lon: \" + position.coords.longitude);\n    });\n    ","state":"active","callbacks":null,"pagetype":{"event_expr":{"domain":null,"pattern":"/wiki/","type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":22},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"append","args":[{"val":"#nearmelinks","type":"str"},{"val":"<a href='http://#{link}'>#{title}</a><br/>","type":"str"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"obj":{"val":"item","type":"var"},"args":[{"val":"$..title","type":"str"}],"name":"pick","type":"operator"},"lhs":"title","type":"expr"},{"rhs":{"obj":{"val":"item","type":"var"},"args":[{"val":"$..wikipediaUrl","type":"str"}],"name":"pick","type":"operator"},"lhs":"link","type":"expr"}],"name":"shownearby","start_col":3,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"on":null,"domain":"web","type":"prim_event","vars":null,"op":"submit","element":"#nearmeform"},"foreach":[{"expr":{"obj":{"source":"datasource","predicate":"placearticles","args":[{"val":[{"rhs":{"source":"page","predicate":"param","args":[{"val":"lat","type":"str"}],"type":"qualified"},"lhs":"lat"},{"rhs":{"source":"page","predicate":"param","args":[{"val":"lon","type":"str"}],"type":"qualified"},"lhs":"lng"},{"rhs":{"val":"full","type":"str"},"lhs":"style"},{"rhs":{"val":"true","type":"str"},"lhs":"formatted"}],"type":"hashraw"}],"type":"qualified"},"args":[{"val":"$..geonames","type":"str"}],"name":"pick","type":"operator"},"var":["item"]}]},"start_line":53}],"meta_start_col":3,"meta":{"logging":"on","name":"WikiNearMe","meta_start_line":2,"author":"TubTeam","description":"Shows Wikipedia content near the user.\n    ","meta_start_col":3},"dispatch_start_line":13,"global_start_col":3,"ruleset_name":"a8x47"}