{"global":[],"global_start_line":null,"dispatch":[{"domain":"refresheverything.com","ruleset_id":null}],"dispatch_start_col":5,"meta_start_line":2,"rules":[{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"notify","args":[{"val":"Password","type":"str"},{"val":"frmPwd","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"val":"email","type":"var"},"lhs":"frmEmail","type":"expr"},{"rhs":{"val":"password","type":"var"},"lhs":"frmPwd","type":"expr"}],"name":"form_login","start_col":5,"emit":"if ($K(\"#user-login\")) {      $K(\"input#emailAddress\").val(frmEmail);      $K(\"input#password\").val(frmPwd);      $K(\"input#httpReferer\").val(\"\");      $K(\"#user-login\").find(\"input[type='submit']\").trigger(\"click\");    }                ","state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"/index/login.*(?:&email|\\?email)=([^&]*).*(?:&password|\\?password)=([^&]*)","legacy":1,"type":"prim_event","vars":["email","password"],"op":"pageview"},"foreach":[]},"start_line":12},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"notify","args":[{"val":"Going to","type":"str"},{"val":"Dashboard","type":"str"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":null,"name":"go_dashboard","start_col":5,"emit":"if ($K(\"#profile-pcna\").text()==\"Your Profile\") {          window.location=\"/dashboard\";    };            ","state":"inactive","callbacks":null,"pagetype":{"event_expr":{"pattern":"/index/login.*","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":23},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"notify","args":[{"val":"Password","type":"str"},{"val":"frmPwd","type":"var"}],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":[{"rhs":{"val":"fname","type":"var"},"lhs":"frmFname","type":"expr"},{"rhs":{"val":"lname","type":"var"},"lhs":"frmLname","type":"expr"},{"rhs":{"val":"email","type":"var"},"lhs":"frmEmail","type":"expr"},{"rhs":{"val":"password","type":"var"},"lhs":"frmPwd","type":"expr"},{"rhs":{"val":"dobMonth","type":"var"},"lhs":"frmDOBMonth","type":"expr"},{"rhs":{"val":"dobDay","type":"var"},"lhs":"frmDOBDay","type":"expr"},{"rhs":{"val":"dobYear","type":"var"},"lhs":"frmDOBYear","type":"expr"}],"name":"light_registration","start_col":5,"emit":"if ($K(\"#register\")) {      $K(\"input#firstName\").val(frmFname );      $K(\"input#lastName\").val(frmLname );      $K(\"input#emailAddress\").val(frmEmail);      $K(\"input#password\").val(frmPwd);      $K(\"input#passwordCheck\").val(frmPwd);      $K(\"#dobMonth\").val(frmDOBMonth);      $K(\"#dobDay\").append('<option value=\"'+ frmDOBDay + '\" selected=\"selected\">' + frmDOBDay + '</option>');      $K(\"#dobYear\").val(frmDOBYear);      $K(\"input#httpReferer\").val(\"\");      $K(\"input#captchaText\").focus();    }                ","state":"active","callbacks":null,"pagetype":{"event_expr":{"pattern":"/light-registration.*(?:&fname|\\?fname)=([^&]*).*(?:&lname|\\?lname)=([^&]*).*(?:&email|\\?email)=([^&]*).*(?:&password|\\?password)=([^&]*).*(?:&dobMonth|\\?dobMonth)=([^&]*).*(?:&dobDay|\\?dobDay)=([^&]*).*(?:&dobYear|\\?dobYear)=([^&]*)","legacy":1,"type":"prim_event","vars":["fname","lname","email","password","dobMonth","dobDay","dobYear"],"op":"pageview"},"foreach":[]},"start_line":30},{"cond":{"val":"true","type":"bool"},"blocktype":"every","actions":[{"action":{"source":null,"name":"noop","args":[],"modifiers":null,"vars":null},"label":null}],"post":null,"pre":null,"name":"dashboard","start_col":5,"emit":null,"state":"inactive","callbacks":null,"pagetype":{"event_expr":{"pattern":"","legacy":1,"type":"prim_event","vars":[],"op":"pageview"},"foreach":[]},"start_line":46}],"meta_start_col":5,"meta":{"logging":"on","name":"pepsi light","meta_start_line":2,"description":"Pepsi Refresh Login     \n","meta_start_col":5},"dispatch_start_line":9,"global_start_col":null,"ruleset_name":"a694x1"}
