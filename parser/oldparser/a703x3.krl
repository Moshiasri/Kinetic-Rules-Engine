{"global":[{"source":"http://www.drudgereportfeed.com/rss.xml","name":"feed_d","type":"dataset","datatype":"RSS","cachable":0},{"content":"#pmFacebook {\n          display: none;\n         }\n        ","type":"css"},{"rhs":"<div class='accordion-toggle accordian-toggle-active' id='pmDrudgeToggle'>\n\t         <span class='accTitle'>Drudge Report</span>\n\t         <span class='accArrow'>&nbsp;</span>\n          </div> ","lhs":"newDiv","type":"here_doc"},{"rhs":"<div style='height: 220px;visibility:visible;overflow-y: scroll' class='accordion-content' id='pmDrudge'> ","lhs":"hiddenDiv","type":"here_doc"}],"global_start_line":10,"dispatch":[{"domain":"cnn.com","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"prepend","args":[{"val":"#pmSlidebox","type":"str"},{"val":"hiddenDiv","type":"var"}],"modifiers":null,"vars":null},"label":null},{"action":{"source":null,"name":"prepend","args":[{"val":"#pmSlidebox","type":"str"},{"val":"newDiv","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":null,"name":"fappend","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":".*","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":27},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"append","args":[{"val":"#pmDrudge","type":"str"},{"val":"NotifyList","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"obj":{"val":"data","type":"var"},"args":[{"val":"$..title.$t","type":"str"}],"name":"pick","type":"operator"},"lhs":"StoryTitle","type":"expr"},{"rhs":{"obj":{"val":"data","type":"var"},"args":[{"val":"$..link.$t","type":"str"}],"name":"pick","type":"operator"},"lhs":"StoryLink","type":"expr"},{"rhs":{"args":[{"val":"<div style='background-color=#ffee8c;margin:3px'>\n        <a href='","type":"str"},{"args":[{"val":"StoryLink","type":"var"},{"args":[{"val":"'>\n           ","type":"str"},{"args":[{"val":"StoryTitle","type":"var"},{"val":"\n        </a>\n       </div>","type":"str"}],"type":"prim","op":"+"}],"type":"prim","op":"+"}],"type":"prim","op":"+"}],"type":"prim","op":"+"},"lhs":"NotifyList","type":"expr"}],"name":"populate","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":".*","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[{"expr":{"obj":{"val":"feed_d","type":"var"},"args":[{"val":"$..item","type":"str"}],"name":"pick","type":"operator"},"var":["data"]}]},"start_line":36},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"label":null,"emit":"$K(\"#pmFacebookToggle\").removeClass(\"accordion-toggle-active\");\n     $K(\"#pmDrudgeToggle\").addClass(\"accordion-toggle-active\");    \n    "}],"post":null,"pre":null,"name":"clickit","start_col":3,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":".*","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":55}],"meta_start_col":5,"meta":{"logging":"on","name":"CNN/Drudge Mashup","meta_start_line":2,"author":"brad odasso","meta_start_col":5},"dispatch_start_line":7,"global_start_col":5,"ruleset_name":"a703x3"}
