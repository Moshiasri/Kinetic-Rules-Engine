{"global":[{"content":".highlighted {        \tbackground-color: #ffaaaa;        }        .modal {            \tleft: 0%;    \ttop: 0%;    \tz-index: 999;    \tposition: absolute;    \twidth: 100%;    \theight: 100%;    \tdisplay: none;    \tbackground-image: url('http:      }        ","type":"css"},{"emit":"function kNotifyDup(config, header, msg) {    \t        uniq = (Math.round(Math.random()*100000000)%100000000);    \t\t$K.kGrowl.defaults.header = header;    \t\tif(typeof config === 'object') {    \t\t\tjQuery.extend($K.kGrowl.defaults,config);    \t\t}    \t\t$K.kGrowl(msg);    \t\t\t    \t}                    "}],"global_start_line":13,"dispatch":[{"domain":"google.com","ruleset_id":null},{"domain":"windley.com","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"noop","args":[],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"val":"Jessie Morris","type":"str"},"lhs":"name","type":"expr"},{"rhs":"<p>Welcome, #{name}, to the Kynetx network. As part of Kynetx, you will now be able to access things which you weren't able to before. You can help us fulfill our goals; if you help us, you will be rewarded. Using this previously unavailable information, we can shut down Silo. Should we succeed, you'll recieve cheese</p>  \t<p>At various checkpoints, using Kynetx apps, you will be given clues and tools to find information in ways that break down barriers across the Internet and gives you, the user, the power to control the web!</p>  \t<p>You must be careful, however! Silo controls much of the web, and as such, we have to operate in secrecy. Secrecy is how they maintain power, and secrecy is how we'll take them down. One mistake could end this for us.</p>  \t<p>If you accept your mission and agree to help us, continue to <a href=\"http://www.technometria.com\">www.technometria.com</a> and search for Kynetx. Once there, a friend, Phil, will be there to help. Be patient, he'll want to be careful.</p>  \t\n ","lhs":"msg","type":"here_doc"}],"name":"first_info","start_col":5,"emit":"document.title = \"Kynetx\";  \t$K(\"#sd\").text(\"Kynetx\");  \t$K(\".j\").text(\"\");  \t$K(\".j:eq(0)\").html(msg);  \t            ","state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"www.google.com/kynetx","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":18},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"noop","args":[],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":null,"name":"technometria","start_col":5,"emit":"alert(\"Silo has detected your location and is currently on your trail!\");    var head = $K(\"h3:contains(I'll Send You a Card)\").html();  var body = $K(\"h3:contains(I'll Send You a Card) + p\").html();    $K(\"p:contains(Your search returned)\").append(\"<h3>\"+head+\"</h3><p>\"+body+\"</p>\");    $K(\"h3:contains(I'll Send You a Card)\").addClass(\"highlighted\");  $K(\"h3:contains(I'll Send You a Card) + p\").addClass(\"highlighted\");            ","state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"www.windley.com/.+search=[Kk]ynetx","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":31},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"notify","args":[{"val":"Hello!","type":"str"},{"val":"I'm Phil Windley, one of the creators of Kynetx. We believe in free information. Just one moment and I'll take care of those pesky Silos...","type":"str"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":null,"name":"sendacard","start_col":5,"emit":"$K('<div style=\\\"background-image: url(\\'http://www.artweaver.de/forum/files/thumbs/t_brick_wall_140.jpg\\');\\\">Firewall</div>').addClass(\"modal\").appendTo('body');        setTimeout(function() {  \t  \t$K(\".modal\").slideDown(\"slow\");    \tmsg = \"That should take care of those pesky punks. Where were we.... Oh! That's right, taking down Silo. Here, lets hide this firewall...\";    \tkNotifyDup({txn_id: 'C21CE5BA-5B86-11DE-8D16-C767F8606F2B',rule_name: 'sendacard','opacity':.95},'That\\'s better!',msg);    \tsetTimeout(function() {    \t\t$K(\".modal\").slideUp(\"slow\");  \t  \t},4000);    },6000);            ","state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"http://www.windley.com/archives/2009/04/ill_send_you_a_card_information_cards_in_the_wild.shtml","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":38}],"meta_start_col":5,"meta":{"logging":"off","name":"Treasure Hunt","meta_start_line":2,"description":"Going on a treasure hunt!   \n","meta_start_col":5},"dispatch_start_line":9,"global_start_col":5,"ruleset_name":"a41x43"}