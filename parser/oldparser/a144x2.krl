{"global":[],"global_start_line":null,"dispatch":[{"domain":"wikipedia.org","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"args":[{"val":"wikitag","type":"var"},{"val":"Dwight_Schrute","type":"str"}],"type":"ineq","op":"eq"},"blocktype":"every","actions":[{"action":{"source":null,"name":"notify","args":[{"val":"Found!","type":"str"},{"val":"msg","type":"var"}],"modifiers":null,"vars":null},"label":null},{"label":null,"emit":"function doer(arg1,arg2) {  \talert(arg1 + \" \" + arg2.innerHTML);  \t\t  \t  \t  };  \t  function replacer() {                     $K(\"b:contains('Dwight')\").each(function(index,domElement){  \t\tdoer(index,domElement);  \t});                    };     replacer();                      "}],"post":null,"pre":[{"rhs":{"val":"wikitag","type":"var"},"lhs":"gl","type":"expr"},{"rhs":{"args":[{"val":"Schrute Me! ","type":"str"},{"val":"wikitag","type":"var"}],"type":"prim","op":"+"},"lhs":"msg","type":"expr"}],"name":"diapers","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"en.wikipedia.org/\\w+/(\\w+)","legacy":1,"type":"prim_event","vars":["wikitag"],"op":"pageview"},"foreach":[]},"start_line":9},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"notify","args":[{"val":"Found!","type":"str"},{"val":"msg","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"args":[{"val":"re-Schrute Me! -","type":"str"},{"args":[{"val":"gl","type":"var"},{"args":[{"val":"-","type":"str"},{"val":"newtag","type":"var"}],"type":"prim","op":"+"}],"type":"prim","op":"+"}],"type":"prim","op":"+"},"lhs":"msg","type":"expr"}],"name":"ptags","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"en.wikipedia.org/\\w+/(\\w+)","legacy":1,"type":"prim_event","vars":["newtag"],"op":"pageview"},"foreach":[]},"start_line":26}],"meta_start_col":5,"meta":{"logging":"off","name":"Schruter","meta_start_line":2,"meta_start_col":5},"dispatch_start_line":6,"global_start_col":null,"ruleset_name":"a144x2"}
