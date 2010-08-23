{"global":[{"source":"https://k-misc.s3.amazonaws.com/random/localscaredata.js","name":"localsCareData","type":"dataset","datatype":"JSON","cachable":{"period":"minutes","value":"30"}},{"rhs":{"val":"https://kynetx-images.s3.amazonaws.com/localscareannotation.png","type":"str"},"lhs":"annotationImage","type":"expr"}],"global_start_line":17,"dispatch":[{"domain":"google.com","ruleset_id":null},{"domain":"bing.com","ruleset_id":null},{"domain":"yahoo.com","ruleset_id":null}],"dispatch_start_col":2,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"label":null,"emit":"if(!KOBJ.watching) {\n\t\t\t\t\tKOBJ.watchDOM(\"#res\", function() {\n\t\t\t\t\t\tKOBJ.get_application(\"a369x38\").app_vars = {\"domWatch\":\"true\"};\n\t\t\t\t\t\tKOBJ.get_application(\"a369x38\").reload();\n\t\t\t\t\t});\n\t\t\t\t\tKOBJ.watching = true;\n\t\t\t\t}\n\t\t\t"}],"post":null,"pre":null,"name":"init_watch","start_col":2,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"domain":null,"pattern":"^http://www.google.com/$","type":"prim_event","vars":null,"op":"pageview"},"foreach":[]},"start_line":23},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"label":null,"emit":"var siteSelectors = {\n\t\t\t\t\t\"www.google.com\" : {\n\t\t\t\t\t\t\"selector\" : \".m\",\n\t\t\t\t\t\t},\n\t\t\t\t\t\"www.bing.com\" : {\n\t\t\t\t\t\t\"selector\" : \".sb_tlst>h3\",\n\t\t\t\t\t\t},\n\t\t\t\t\t\"search.yahoo.com\" : {\n\t\t\t\t\t\t\"selector\" : \".div>h3yschttl.spt\",\n\t\t\t\t\t\t}\n\t\t\t\t};\n\n\t\t\t\tfunction localsCareSelector(current) {\n\t\t\t\t\tvar item = $K(current);\n\t\t\t\t\tvar itemDom = item.data(\"domain\");\n\t\t\t\t\tvar selData = siteSelectors[location.hostname];\n\t\t\t\t\tvar annCon = '<img src = \"'+annotationImage+'\" alt = \"locals really do care\" title = \"this business is a member of locals care\" style = \"position:absolute;right: 0px;top: 0px;\" />';\n\n\t\t\t\t\tif (data[itemDom]) {\n\t\t\t\t\t\titem.css({\n\t\t\t\t\t\t\t\"border\" : \"2px solid #00CCFF\",\n\t\t\t\t\t\t\t\"-moz-border-radius\" : \"3px\",\n\t\t\t\t\t\t\t\"-webkit-border-radius\" : \"3px\",\n\t\t\t\t\t\t\t\"position\" : \"relative\"\n\t\t\t\t\t\t});\n\n\t\t\t\t\t\titem.append(annCon);\n\n\t\t\t\t\t\treturn true;\n\t\t\t\t\t} else {\n\t\t\t\t\t\treturn false;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t"},{"action":{"source":null,"name":"percolate","args":[{"val":"localsCareSelector","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"val":"localsCareData","type":"var"},"lhs":"data","type":"expr"}],"name":"do_stuff","start_col":2,"emit":null,"state":"active","callbacks":null,"pagetype":{"event_expr":{"domain":null,"pattern":"^http://(?:www|search).(?:bing|google|yahoo).com/.*(?:search|#hl|webhp).*(?:&|\\?)(?:p|q)=(.*?)(?:&|$)","type":"prim_event","vars":["searchTerm"],"op":"pageview"},"foreach":[]},"start_line":38}],"meta_start_col":2,"meta":{"logging":"off","name":"Locals Care","meta_start_line":2,"author":"PJW + AKO","description":"locals care app\n\t\t\t","meta_start_col":2},"dispatch_start_line":11,"global_start_col":2,"ruleset_name":"a369x38"}