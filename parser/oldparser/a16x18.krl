{"global":[{"source":"http://search.twitter.com/search.json?show_user=true&rpp=3","name":"twitter_search","type":"datasource","datatype":"JSON","cachable":0}],"global_start_line":12,"dispatch":[{"domain":"www.equifax.com","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"notify","args":[{"val":"Hello World","type":"str"},{"val":"Just a note to say hello","type":"str"}],"modifiers":[{"value":{"val":"true","type":"bool"},"name":"sticky"}],"vars":null},"label":null}],"post":null,"pre":null,"name":"helloworld","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"www.equifax.com","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":15},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"after","args":[{"val":"#header","type":"str"},{"val":"twit_res","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"source":"datasource","predicate":"twitter_search","args":[{"val":"&q=equifax","type":"str"}],"type":"qualified"},"lhs":"tweets","type":"expr"},{"rhs":{"obj":{"val":"tweets","type":"var"},"args":[{"val":"$..results[0].text","type":"str"}],"name":"pick","type":"operator"},"lhs":"res","type":"expr"},{"rhs":{"obj":{"val":"tweets","type":"var"},"args":[{"val":"$..results[0].profile_image_url","type":"str"}],"name":"pick","type":"operator"},"lhs":"img","type":"expr"},{"rhs":"<div style=\"background-color: #FF9;height:80px;padding:3px\">  From Twitter:<br/>  <div style=\"margin-top:5px;float:left;padding:3px\"><img src=\"#{img}\"> </div>  #{res}  </div>    \n ","lhs":"twit_res","type":"here_doc"}],"name":"twitequifax","start_col":5,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"www.equifax.com/home","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":22}],"meta_start_col":5,"meta":{"logging":"off","name":"Equifax Demo","meta_start_line":2,"description":"This is a demo   \n","meta_start_col":5},"dispatch_start_line":9,"global_start_col":5,"ruleset_name":"a16x18"}