{"global":[],"global_start_line":null,"dispatch":[{"domain":"google.com","ruleset_id":null},{"domain":"bing.com","ruleset_id":null},{"domain":"yahoo.com","ruleset_id":null},{"domain":"cnn.com","ruleset_id":null},{"domain":"facebook.com","ruleset_id":null},{"domain":"google.co.uk","ruleset_id":null},{"domain":"google.com.pk","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"after","args":[{"val":"selector","type":"var"},{"val":"content","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[],"name":"google_search_insert","start_col":5,"emit":"if(window.OPTINI_WatchSet){ } else {  \tKOBJ.watchDOM(\"#rso\",function(){  \t\tdelete KOBJ['a93x6'].pendingClosure; KOBJ['a93x6'].dataLoaded = false;alert(\"hello World\"); \t\t\t\twindow.OPTINI_WatchSet = true;  \t});  }                            ","state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"^http://www.google.com.*","legacy":1,"type":"prim_event","vars":["notneeded","term"],"op":"pageview"},"foreach":[]},"start_line":16}],"meta_start_col":5,"meta":{"keys":{"errorstack":"521b680b0f92a3237b8f419342e3c620"},"logging":"on","name":"zipweb2","meta_start_line":2,"meta_start_col":5},"dispatch_start_line":7,"global_start_col":null,"ruleset_name":"a93x6"}