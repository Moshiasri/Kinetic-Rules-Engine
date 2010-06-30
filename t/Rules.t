#!/usr/bin/perl -w 

#
# Copyright 2007-2009, Kynetx Inc.  All rights reserved.
# 
# This Software is an unpublished, proprietary work of Kynetx Inc.
# Your access to it does not grant you any rights, including, but not
# limited to, the right to install, execute, copy, transcribe, reverse
# engineer, or transmit it by any means.  Use of this Software is
# governed by the terms of a Software License Agreement transmitted
# separately.
# 
# Any reproduction, redistribution, or reverse engineering of the
# Software not in accordance with the License Agreement is expressly
# prohibited by law, and may result in severe civil and criminal
# penalties. Violators will be prosecuted to the maximum extent
# possible.
# 
# Without limiting the foregoing, copying or reproduction of the
# Software to any other server or location for further reproduction or
# redistribution is expressly prohibited, unless such reproduction or
# redistribution is expressly permitted by the License Agreement
# accompanying this Software.
# 
# The Software is warranted, if at all, only according to the terms of
# the License Agreement. Except as warranted in the License Agreement,
# Kynetx Inc. hereby disclaims all warranties and conditions
# with regard to the software, including all warranties and conditions
# of merchantability, whether express, implied or statutory, fitness
# for a particular purpose, title and non-infringement.
# 
use lib qw(/web/lib/perl);
use strict;

use Test::More;
use Test::LongString;

use Apache::Session::Memcached;
use DateTime;
use Geo::IP;
use Cache::Memcached;
use LWP::Simple;
use LWP::UserAgent;
use JSON::XS;
use APR::Pool ();

use Kynetx::Test qw/:all/;
use Kynetx::Parser qw/:all/;
use Kynetx::PrettyPrinter qw/:all/;
use Kynetx::Json qw/:all/;
use Kynetx::Rules qw/:all/;
use Kynetx::Actions qw/:all/;
use Kynetx::Util qw/:all/;
use Kynetx::Memcached qw/:all/;
use Kynetx::Environments qw/:all/;
use Kynetx::Session qw/:all/;
use Kynetx::Configure qw/:all/;


use Kynetx::FakeReq;

use Log::Log4perl::Level;
#use Log::Log4perl::Appender::FileLogger;
use Log::Log4perl qw(get_logger :levels);
Log::Log4perl->easy_init($WARN);
#Log::Log4perl->easy_init($DEBUG);

use Data::Dumper;
$Data::Dumper::Indent = 1;


my $r = Kynetx::Test::configure();

# configure logging for production, development, etc.
#config_logging($r);
#Kynetx::Util::turn_off_logging();


my $rid = 'cs_test';

# test choose_action and args



my $rule_name = 'foo';

my $rule_env = Kynetx::Test::gen_rule_env();


my $session = Kynetx::Test::gen_session($r, $rid);


my $krl_src;
my $js;
my $test_count;
my $config;
my $config2;


sub gen_req_info {
  
  return Kynetx::Test::gen_req_info($rid, 
				    {'ip' =>  '72.21.203.1',
				     'txn_id' => 'txn_id',
				     'caller' => 'http://www.google.com/search',
				    });
}

my $dummy_final_req_info = undef;
my $final_req_info = {};


#diag Dumper gen_req_info();

# $Amazon_req_info->{'ip'} = '72.21.203.1'w; # Seattle (Amazon)
# $Amazon_req_info->{'rid'} = $rid;
# $Amazon_req_info->{'txn_id'} = 'txn_id';
# $Amazon_req_info->{'caller'} = 'http://www.google.com/search';

my (@test_cases, $json, $krl,$result);

sub add_testcase {
    my($str, $expected, $final_req_info, $diag) = @_;

#     if ($diag) {
#       Kynetx::Util::turn_on_logging();
#     } else {
#       Kynetx::Util::turn_off_logging();
#     }

    my $pt;
    my $type = '';
    if($str =~ m#^ruleset#) {
	$pt = Kynetx::Parser::parse_ruleset($str);
	$type = 'ruleset';
     } else {
	$pt = Kynetx::Parser::parse_rule($str);
	$type = 'rule';
     }

    if ($pt->{'error'}) {
      diag $str;
      diag $pt->{'error'};
    }



    chomp $str;
    diag("$str = ", Dumper($pt)) if $diag;
    

    push(@test_cases, {'expr' => $pt,
		       'val' => $expected,
		       'session' => $session,
		       'src' =>  $str,
		       'type' => $type,
		       'final_req_info' => $final_req_info,
		       'diag' => $diag
	 }
	 );
}


sub add_json_testcase {
    my($str, $expected, $final_req_info, $diag) = @_;
    my $val = Kynetx::Json::jsonToAst($str);
 
    chomp $str;
    diag("$str = ", Dumper($val)) if $diag;


    push(@test_cases, {'expr' => $val,
		       'val' => $expected,
		       'session' => $session,
		       'src' =>  $str,
		       'final_req_info' => $final_req_info,
		       'type' => 'rule',
	 }
	);
}


#
# note if the rules don't have unique names, you can get rule environment cross
# contamination
#

$krl_src = <<_KRL_;
rule test_1 is active {
  select using "/archives/" setting ()
  alert("testing");
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_1'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'testing'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );

$krl_src = <<_KRL_;
rule test_2 is active {
  select using "/archives/" setting ()
  pre { 
      c = location:city();
  }
  alert("testing " + c);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_2'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
var c = 'Seattle';
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,('testing' + c)));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_3 is active {
  select using "/archives/" setting ()
  pre { 
      c = location:city();
  }
  if demographics:urban() then
    alert("testing " + c);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_3'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$result = <<_JS_;
(function(){
var c = 'Seattle';
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,('testing' + c)));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_4 is active {
  select using "/archives/" setting ()
  pre { 
      c = location:city();
  }
  if demographics:urban() && location:city() eq "Seattle" then
    alert("testing " + c);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_4'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$result = <<_JS_;
(function(){
var c = 'Seattle';
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,('testing' + c)));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );

#
# entity vars
#

$krl_src = <<_KRL_;
rule test_flag_1 is active {
  select using "/archives/" setting ()

    if ent:my_flag then 
      alert("test");

    fired {
      clear ent:my_flag
    } else {
      set ent:my_flag
    }
  }
_KRL_

# empty because rule does fire.  It increments counter so next rule fires
$result = <<_JS_;
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


# should fire now!
$krl_src = <<_KRL_;
rule test_flag_1 is active {
  select using "/archives/" setting ()

    if ent:my_flag then 
      alert("test");

    fired {
      clear ent:my_flag
    } else {
      set ent:my_flag
    }
  }
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_flag_1'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );



# this shouldn't fire first time
$krl_src = <<_KRL_;
rule test_5 is active {
  select using "/archives/" setting ()

    pre {
      c = ent:archive_pages_now;
    }

    if ent:archive_pages_now > 2 then 
      alert("test");

    fired {
      clear ent:archive_pages_now; 
    } else {
      ent:archive_pages_now += 1 from 1;  
    }
  }
_KRL_


# empty because rule does fire.  It increments counter so next rule fires
$result = <<_JS_;
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );

# this should fire
$krl_src = <<_KRL_;
rule test_5a is active {
  select using "/archives/" setting ()

    pre {
      c = ent:archive_pages_now;
    }

    if ent:archive_pages_now > 2 then 
      alert("test");

    fired {
      clear ent:archive_pages_now; 
    } else {
      ent:archive_pages_now += 1 from 1;  
    }
  }
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_5a'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
var c = 3;
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


# use different counter since previous test clears it!
$krl_src = <<_KRL_;
rule test_6 is active {
  select using "/archives/" setting ()

    pre {
      c = ent:archive_pages_now2;
    }

    if ent:archive_pages_now2 > 2 within 2 days then 
      alert("test");

    fired {
      clear ent:archive_pages_now2; 
    } else {
      ent:archive_pages_now2 += 1 from 1;  
    }
  }
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_6'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$result = <<_JS_;
(function(){
var c = 3;
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_7 is active {
  select using "/archives/" setting ()

    pre {
      c = ent:archive_pages_old;
    }

    if ent:archive_pages_old > 2 within 2 days then 
      alert("test");

    fired {
      clear ent:archive_pages_old; 
    } else {
      ent:archive_pages_old += 1 from 1;  
    }
  }
_KRL_

# result is empty (rule shouldn't fire)
$result = <<_JS_;
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );

$krl_src = <<_KRL_;
rule test_trail_1 is active {
  select using "/archives/" setting ()

    if seen "windley.com" in ent:my_trail then 
      alert("test");

    fired {
      mark ent:my_trail
    } 
  }
_KRL_

#my $r = Kynetx::Parser::parse_rule($krl_src);
#diag Dumper($r);

$config = mk_config_string(
  [
   {"rule_name" => 'test_trail_1'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$result = <<_JS_;
(function(){
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_trail_2 is active {
  select using "/archives/" setting ()

    if seen "google.com" in ent:my_trail then 
      alert("test");

    fired {
      forget "google.com" in ent:my_trail
    } 
  }
_KRL_

#my $r = Kynetx::Parser::parse_rule($krl_src);
#diag Dumper($r);

$config = mk_config_string(
  [
   {"rule_name" => 'test_trail_2'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_trail_3 is active {
  select using "/archives/" setting ()

    if seen "google.com" in ent:my_trail then 
      alert("test");

    notfired {
      mark ent:my_trail with "amazon.com"
    } 
  }
_KRL_

##my $r = Kynetx::Parser::parse_rule($krl_src);
#diag Dumper($r);

$result = <<_JS_;
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_trail_4 is active {
  select using "/archives/" setting ()

    if seen "amazon.com" in ent:my_trail then 
      alert("test");

  }
_KRL_

#my $r = Kynetx::Parser::parse_rule($krl_src);
#diag Dumper($r);

$config = mk_config_string(
  [
   {"rule_name" => 'test_trail_4'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_trail_5 is active {
  select using "/archives/" setting ()

    if seen "amazon.com" after "windley.com" in ent:my_trail then 
      alert("test");

  }
_KRL_

#my $r = Kynetx::Parser::parse_rule($krl_src);
#diag Dumper($r);

$config = mk_config_string(
  [
   {"rule_name" => 'test_trail_5'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_trail_6 is active {
  select using "/archives/" setting ()

    if seen "amazon.com" before "windley.com" in ent:my_trail then 
      alert("test");

  }
_KRL_

#my $r = Kynetx::Parser::parse_rule($krl_src);
#diag Dumper($r);

# shouldn't fire
$result = <<_JS_;
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_trail_7 is active {
  select using "/archives/" setting ()

    if seen "amazon.com" in ent:my_trail within 1 minute then 
      alert("test");

  }
_KRL_

#my $r = Kynetx::Parser::parse_rule($krl_src);
#diag Dumper($r);

$config = mk_config_string(
  [
   {"rule_name" => 'test_trail_7'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
function callBacks () {};
(function(uniq, cb, config, msg) {alert(msg);cb();}
('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


#
# callbacks
#

$krl_src = <<_KRL_;
rule test_8 is inactive {
   select using "/identity-policy/" setting ()
   
   pre { }

   alert("test");

   callbacks {
      success {
        click id="rssfeed";
        click class="newsletter"
   } 

   failure {
      click id="close_rss"
   }
  }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'test_8'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$result = <<_JS_;
(function(){
function callBacks () {
  KOBJ.obs('click', 'id','txn_id','rssfeed','success','test_8', 'cs_test');
  KOBJ.obs('click', 'class','txn_id','newsletter','success','test_8', 'cs_test');
  KOBJ.obs('click', 'id','txn_id','close_rss','failure','test_8', 'cs_test');
};
(function(uniq, cb, config, msg) {alert(msg);cb();}
 ('%uniq%',callBacks,$config,'test'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule test_page_id is active {
   select using "/identity-policy/" setting ()
   
   pre {
       pt = page:id("product_name");
       
       html = <<
<p>This is the product title: #{pt}</p>       >>;

   }

   alert(html);

}
_KRL_


$config = mk_config_string(
  [
   {"rule_name" => 'test_page_id'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$result = <<_JS_;
(function(){
var pt = \$K('product_name').innerHTML;
var html = '<p>This is the product title: '+pt+'</p>';
function callBacks () {
};
(function(uniq, cb, config, msg) {alert(msg);cb();}
 ('%uniq%',callBacks,$config,html));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
    rule emit_test_0 is active {
        select using "/test/(.*).html" setting(pagename)
        pre {

	}     

        emit <<
pagename.replace(/-/, ' ');
>>
        alert(pagename);
    }
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'emit_test_0'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
pagename.replace(/-/, ' ');
function callBacks () {
};
(function(uniq, cb, config, msg) {alert(msg);cb();}
 ('%uniq%',callBacks,$config,pagename));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
    rule emit_test_1 is active {
        select using "/test/(.*).html" setting(pagename)
        pre {

	}     

        emit "pagename.replace(/-/, ' ');"

        alert(pagename);
    }
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'emit_test_1'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);



$result = <<_JS_;
(function(){
pagename.replace(/-/, ' ');
function callBacks () {
};
(function(uniq, cb, config, msg) {alert(msg);cb();}
 ('%uniq%',callBacks,$config,pagename));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


# tests booleans inference.  When false and true appear in string, it 
# should still be string.
$krl_src = <<_KRL_;
rule extended_quote_test is active {
   select using "/identity-policy/" setting ()
   
   pre {
     welcome = <<
Don't be false please!  Be true!     >>; 
   }
   alert(welcome);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'extended_quote_test'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);



$result = <<_JS_;
(function(){
var welcome = 'Don\\'t be false please! Be true!';
function callBacks () {
};
(function(uniq, cb, config, msg) {alert(msg);cb();}
 ('%uniq%',callBacks,$config,welcome));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule april2008 is active {
  select using "http://www.utahjudo.com\/2008\/(.*?)" setting (month)
  pre {
  }
  alert("Hello Tim");
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'april2008'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
function callBacks () {
};
(function(uniq, cb, config, msg) {alert(msg);cb();}
 ('%uniq%',callBacks,$config,'Hello Tim'));
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );



$krl_src = <<_KRL_;
rule emit_in_action is active {
  select using "http://www.utahjudo.com\/2008\/(.*?)" setting (month)
  pre {
  }
  if true then
     emit <<(function(){}())>>
}
_KRL_

$result = <<_JS_;
(function(){
function callBacks () {
};
(function(){}());
callBacks();
}());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


##
## foreach tests
##
$krl_src = <<_KRL_;
rule foreach_0 is active {
  select using "http://www.google.com" setting ()
   foreach [1,2,4] setting (x)
    pre {
    }
    alert(x);
}
_KRL_


$config = mk_config_string(
  [
   {"rule_name" => 'foreach_0'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$result = <<_JS_;
(function(){
 (function(){
   var x = 1;
   function callBacks () {
   };
   (function(uniq,cb,config,msg) {
      alert(msg);
      cb();
    }
    ('%uniq%',callBacks,$config,x));
   }());
 (function(){
   var x = 2;
   function callBacks () {
   };
   (function(uniq, cb, config, msg) {
      alert(msg);
     cb();
    }
    ('%uniq%',callBacks,$config,x));
   }());
 (function(){
   var x = 4;
   function callBacks () {
   };
   (function(uniq, cb, config, msg) {
      alert(msg);
      cb();
    }
    ('%uniq%',callBacks,$config,x));
  }());
 }());
_JS_

$krl_src = <<_KRL_;
rule foreach_01 is active {
  select using "http://www.google.com" setting ()
   foreach ["a","b"] setting (x)
    pre {
    }
    alert(x);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foreach_01'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$result = <<_JS_;
(function(){
 (function(){
   var x = 'a';
   function callBacks () {
   };
   (function(uniq,cb,config,msg) {
      alert(msg);
      cb();
    }
    ('%uniq%',callBacks,$config,x));
   }());
 (function(){
   var x = 'b';
   function callBacks () {
   };
   (function(uniq, cb, config, msg) {
      alert(msg);
     cb();
    }
    ('%uniq%',callBacks,$config,x));
   }());
 }());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );



$krl_src = <<_KRL_;
rule foreach_1 is active {
  select using "http://www.google.com" setting ()
   foreach [2,7] setting (x)
    pre {
      y = x + 1;
      z = 6
    }
    alert(x+y+z);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foreach_1'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);



$result = <<_JS_;
(function(){
 var z = 6;
 (function(){
   var x = 2;
   var y = 3;
   function callBacks () {
   };
   (function(uniq,cb,config,msg) {
      alert(msg);
      cb();
    }
    ('%uniq%',callBacks,$config,(x+(y+z))));
   }());
 (function(){
   var x = 7;
   var y = 8;
   function callBacks () {
   };
   (function(uniq, cb, config, msg) {
      alert(msg);
     cb();
    }
    ('%uniq%',callBacks,$config,(x+(y+z))));
   }());
 }());
_JS_

add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );



$krl_src = <<_KRL_;
rule foreach_2 is active {
  select using "http://www.google.com" setting ()
   foreach [2,7] setting (x)
   foreach [x+1,x+3] setting (z)
    pre {
      y = x + 1;
    }
    alert(x+y+z);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foreach_2'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$final_req_info = {
 'results' => ['fired'],
 'names' => [$rid.':foreach_2'],
 'all_actions' => [['alert','alert','alert','alert']],
 };

$result = <<_JS_;
(function(){
 (function(){
   var x = 2;
   (function(){
     var z = 3;
     var y = 3;
     function callBacks () {
     };
     (function(uniq,cb,config,msg) {
        alert(msg);
        cb();
      }
      ('%uniq%',callBacks,$config,(x+(y+z))));
    }());
   (function(){
     var z = 5;
     var y = 3;
     function callBacks () {
     };
     (function(uniq,cb,config,msg) {
        alert(msg);
        cb();
      }
      ('%uniq%',callBacks,$config,(x+(y+z))));
    }());
  }());
 (function(){
   var x = 7; 
   (function(){
     var z = 8;
     var y = 8;
     function callBacks () {
     };
     (function(uniq, cb, config, msg) {
        alert(msg);
       cb();
      }
      ('%uniq%',callBacks,$config,(x+(y+z))));
     }());
   (function(){
     var z = 10;
     var y = 8;
     function callBacks () {
     };
     (function(uniq, cb, config, msg) {
        alert(msg);
        cb();
      }
      ('%uniq%',callBacks,$config,(x+(y+z))));
     }());
   }());
 }());
_JS_

add_testcase(
    $krl_src,
    $result,
    $final_req_info,
    0
    );



$krl_src = <<_KRL_;
rule foreach_here is active {
  select using "http://www.google.com" setting ()
   foreach [2,7] setting (x)
    pre {
      y = <<
This is the number #{x}>>;
      z = 6;
      w = <<
This is another number #{z}>>;
    }
    alert(x+y+z);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foreach_here'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);



$result = <<_JS_;
(function(){
 var z = 6;
 var w = 'This is another number ' + z + '';
 (function(){
   var x = 2;
   var y = 'This is the number ' + x + '';
   function callBacks () {
   };
   (function(uniq,cb,config,msg) {
      alert(msg);
      cb();
    }
    ('%uniq%',callBacks,$config,(x+(y+z))));
   }());
 (function(){
   var x = 7;
   var y = 'This is the number ' + x + '';
   function callBacks () {
   };
   (function(uniq, cb, config, msg) {
      alert(msg);
     cb();
    }
    ('%uniq%',callBacks,$config,(x+(y+z))));
   }());
 }());
_JS_


add_testcase(
    $krl_src,
    $result,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
rule foreach_here is active {
  select using "http://www.google.com" setting ()
   foreach [2,7] setting (x)
    pre {
      p = x.pick("\$..foo");
      y = <<
This is the number #{p}>>;
      z = 6;
      w = <<
This is another number #{z}>>;
    }
    alert(x+y+z);
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foreach_here'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$final_req_info = {
 'results' => ['fired'],
 'names' => [$rid.':foreach_here'],
 'all_actions' => [['alert','alert']],
 };


$result = <<_JS_;
(function(){
 var z = 6;
 var w = 'This is another number ' + z + '';
 (function(){
   var x = 2;
   var p = [];
   var y = 'This is the number ' + p + '';
   function callBacks () {
   };
   (function(uniq,cb,config,msg) {
      alert(msg);
      cb();
    }
    ('%uniq%',callBacks,$config,(x+(y+z))));
   }());
 (function(){
   var x = 7;
   var p = [];
   var y = 'This is the number ' + p + '';
   function callBacks () {
   };
   (function(uniq, cb, config, msg) {
      alert(msg);
     cb();
    }
    ('%uniq%',callBacks,$config,(x+(y+z))));
   }());
 }());
_JS_


add_testcase(
    $krl_src,
    $result,
    $final_req_info
    );



##
## JSON test cases
##
$json = <<_KRL_;
{"blocktype":"every","actions":[{"action":{"name":"alert","args":[{"val":"Hello Tim","type":"str"}],"modifiers":[]},"label":""}],"name":"april2008","pagetype":{"vars":["month"],"pattern":"http:\/\/www.utahjudo.com\\\/2008\\\/(.*?)","foreach":[]},"state":"active"}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'april2008'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);



$result = <<_JS_;
(function(){
function callBacks () {
};
(function(uniq, cb, config, msg) {alert(msg);cb();}
 ('%uniq%',callBacks,$config,'Hello Tim'));
}());
_JS_

add_json_testcase(
    $json,
    $result,
    $dummy_final_req_info
    );


#
# global decls, no datasource
#

$krl_src = <<_KRL_;
ruleset global_expr_0 {
    global {
	x = 3;
    }
    rule foo is active {
     select using ".*"
     noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foo'},
   {"rid" => 'global_expr_0'},
   {"txn_id" => 'txn_id'},
  ]
);

my $global_expr_0 = <<_JS_;
(function(){
var x = 3;
(function(){
 function callBacks(){};
 (function(uniq,cb,config){cb();}
  ('%uniq%',callBacks,$config)); 
 }());
}());
_JS_

add_testcase(
    $krl_src,
    $global_expr_0,
    $dummy_final_req_info,
    0
    );


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    global {
	x = 3;
    }
    rule t0 is active {
      select using ".*" setting ()
      pre {
         y = 6;
      }
      noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 't0'},
   {"rid" => 'global_expr_1'},
   {"txn_id" => 'txn_id'},
  ]
);


$final_req_info = {
 'results' => ['fired'],
 'names' => ['global_expr_1:t0'],
 'all_actions' => [['noop']],
 };

my $global_expr_1 = <<_JS_;
(function(){
var x = 3;
(function(){
var y = 6;
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config));
}());
}());
_JS_

add_testcase(
    $krl_src,
    $global_expr_1,
    $final_req_info
    );



#
# meta blocks, use, etc.
#

$krl_src = <<_KRL_;
ruleset meta_0 {
    meta {
	use javascript resource "http://init-files.s3.amazonaws.com/kjs-frameworks/jquery_ui/1.8/jquery-ui-1.8.2.custom.js"
        use css resource "http://init-files.s3.amazonaws.com/kjs-frameworks/jquery_ui/1.8/css/kynetx_ui_darkness/jquery-ui-1.8.2.custom.css"
    }
    rule foo is active {
     select using ".*"
     noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foo'},
   {"rid" => 'meta_0'},
   {"txn_id" => 'txn_id'},
  ]
);

my $meta_0 = <<_JS_;
(function(){
KOBJ.registerExternalResources("meta_0",{
 "http://init-files.s3.amazonaws.com/kjs-frameworks/jquery_ui/1.8/jquery-ui-1.8.2.custom.js":{"type":"javascript"},
 "http://init-files.s3.amazonaws.com/kjs-frameworks/jquery_ui/1.8/css/kynetx_ui_darkness/jquery-ui-1.8.2.custom.css":{"type":"css"}
 });
(function(){
 function callBacks(){};
 (function(uniq,cb,config){cb();}
  ('%uniq%',callBacks,$config)); 
 }());
}());
_JS_

add_testcase(
     $krl_src,
     $meta_0,
     $dummy_final_req_info,
     0
     );


#
# control statements in rulesets
#
$krl_src = <<_KRL_;
ruleset two_rules_both_fire {
    rule t0 is active {
      select using ".*" setting ()
      pre {
      }
      noop();
    }
    rule t1 is active {
      select using ".*" setting ()
      pre {
      }
      noop();
    }
}
_KRL_


$config = mk_config_string(
  [
   {"rule_name" => 't0'},
   {"rid" => 'two_rules_both_fire'},
   {"txn_id" => 'txn_id'},
  ]
);


$config2 = mk_config_string(
  [
   {"rule_name" => 't1'},
   {"rid" => 'two_rules_both_fire'},
   {"txn_id" => 'txn_id'},
  ]
);


$js = <<_JS_;
(function(){
(function(){
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config));
}());
(function(){
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config2));
}());
}());
_JS_

add_testcase(
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );



$krl_src = <<_KRL_;
ruleset two_rules_first_fires {
    rule t0 is active {
      select using ".*" setting ()
      pre {
      }
      noop();
      fired {
        last;
      }
    }
    rule t1 is active {
      select using ".*" setting ()
      pre {
      }
      noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 't0'},
   {"rid" => 'two_rules_first_fires'},
   {"txn_id" => 'txn_id'},
  ]
);


$js = <<_JS_;
(function(){
(function(){
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config));
}());
}());
_JS_

add_testcase(
    $krl_src,
    $js,
    $dummy_final_req_info
    );


$krl_src = <<_KRL_;
ruleset two_rules_both_fire {
    rule t8 is active {
      select using ".*" setting ()
      pre {
        x = 3
      }
      noop();
      fired {
        last if(x==4)
      }
    }
    rule t9 is active {
      select using ".*" setting ()
      pre {
      }
      noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 't8'},
   {"rid" => 'two_rules_both_fire'},
   {"txn_id" => 'txn_id'},
  ]
);


$config2 = mk_config_string(
  [
   {"rule_name" => 't9'},
   {"rid" => 'two_rules_both_fire'},
   {"txn_id" => 'txn_id'},
  ]
);


$js = <<_JS_;
(function(){
(function(){
var x = 3;
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config));
}());
(function(){
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config2));
}());
}());
_JS_


add_testcase(
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );

$krl_src = <<_KRL_;
ruleset two_rules_both_fire {
    rule t10 is active {
      select using ".*" setting ()
      pre {
        x = 3
      }
      noop();
      fired {
        last if(x==3)
      }
    }
    rule t11 is active {
      select using ".*" setting ()
      pre {
      }
      noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 't10'},
   {"rid" => 'two_rules_both_fire'},
   {"txn_id" => 'txn_id'},
  ]
 );


$js = <<_JS_;
(function(){
(function(){
var x = 3;
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config));
}());
}());
_JS_


add_testcase(
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );

$krl_src = <<_KRL_;
ruleset two_rules_first_raises_second {
    rule t10 is active {
      select when pageview ".*"
      noop();
      fired {
        raise explicit event foo;
      }
    }
    rule t12 is active {
      select when explicit foo
      pre {
        x = 5;
      }
      noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 't10'},
   {"rid" => 'two_rules_first_raises_second'},
   {"txn_id" => 'txn_id'},
  ]
 );


$config2 = mk_config_string(
  [
   {"rule_name" => 't12'},
   {"rid" => 'two_rules_first_raises_second'},
   {"txn_id" => 'txn_id'},
  ]
 );


$js = <<_JS_;
(function(){
(function(){
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config));
}());
(function(){
var x = 5;
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config2));
}());
}());
_JS_

$krl_src = <<_KRL_;
ruleset two_rules_second_not_raised {
    rule t10 is active {
      select when pageview ".*"
      noop();
      fired {
        raise explicit event bar;
      }
    }
    rule t12 is active {
      select when explicit foo
      pre {
        x = 5;
      }
      noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 't10'},
   {"rid" => 'two_rules_second_not_raised'},
   {"txn_id" => 'txn_id'},
  ]
 );


$config2 = mk_config_string(
  [
   {"rule_name" => 't12'},
   {"rid" => 'two_rules_second_not_raised'},
   {"txn_id" => 'txn_id'},
  ]
 );


$js = <<_JS_;
(function(){
(function(){
function callBacks () {
};
(function(uniq, cb, config) {cb();}
 ('%uniq%',callBacks,$config));
}());
}());
_JS_


add_testcase(
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );


# now test each test case twice
foreach my $case (@test_cases) {

#   if ($case->{'diag'}) {
#     Kynetx::Util::turn_on_logging();
#   } else {
#     Kynetx::Util::turn_off_logging();
#   }

  my $ruleset_rid = $case->{'expr'}->{'ruleset_name'} || $rid;
  my $req_info = gen_req_info($ruleset_rid);
  $req_info->{'eventtype'} = 'pageview';
  $req_info->{'domain'} = 'web';
  

#  diag Dumper $req_info;

#   my $schedule = Kynetx::Rules::mk_schedule($req_info, $req_info->{'rid'},$case->{'expr'});



  if($case->{'type'} eq 'ruleset') {

    $req_info->{$ruleset_rid}->{'ruleset'} = 
      Kynetx::Rules::optimize_ruleset($case->{'expr'});

    my $ev = Kynetx::Events::mk_event($req_info);

#    $logger->debug("Processing events for $rids with event ", sub {Dumper $ev});

    my $schedule = Kynetx::Scheduler->new();


    Kynetx::Events::process_event_for_rid($ev,
					  $req_info,
					  $session,
					  $schedule,
					  $ruleset_rid
					 );
    
    $js = Kynetx::Rules::process_schedule($r, 
					  $schedule, 
					  $session, 
					  time
					 );

  } elsif($case->{'type'} eq 'rule') {

    $js = Kynetx::Rules::eval_rule($r,
				   $req_info, 
				   $rule_env, 
				   $case->{'session'}, 
				   $case->{'expr'},
				   '');

  } else {
    diag "WARNING: No test run! Case must be either rule or ruleset"
  }

  # reset the last flag for the next test
#  $case->{'req_info'}->{$rid.':last'} = 0;

  # remove whitespace
  $js = nows($js);

  diag "Eval result: $js" if $case->{'diag'};


  $case->{'val'} = mk_reg_exp($case->{'val'});

  if ($case->{'val'} eq '') {
    is($js, $case->{'val'}, "Evaling rule " . $case->{'src'});
    $test_count++;
  } else {

    my $re = qr/$case->{'val'}/;

    like($js,
	 $re,
	 "Evaling rule " . $case->{'src'});
    $test_count++;


  }

  # check the request env

  if (defined $case->{'final_req_info'}) {
    foreach my $k (keys %{ $final_req_info} ) {
      is_deeply($req_info->{$k}, $case->{'final_req_info'}->{$k}, "Checking $k");
      $test_count++;
    }
  }

}

#diag "Starting tests of global decls with data feeds";

#
# global decls with data sources
#

my $ua = LWP::UserAgent->new;
my $check_url = "http://frag.kobj.net/clients/cs_test/some_data.txt";
my $response = $ua->get($check_url);
my $no_server_available = (! $response->is_success);


sub test_datafeeds {
  my ($no_server_available, $src, $js, $log_results, $diag) = @_;

  my $req_info = gen_req_info();
 SKIP: {

    skip "No server available", 1 if ($no_server_available);
    my $krl = Kynetx::Parser::parse_ruleset($src);

    my $schedule = Kynetx::Rules::mk_schedule($req_info, 
					      $req_info->{'rid'},
					      $krl);

    my $val = Kynetx::Rules::process_schedule($r, 
					      $schedule, 
					      $session, 
					      time
					     );

    diag $val if $diag;

    $val = nows($val);

    $js = mk_reg_exp($js);
    my $re = qr/$js/;

    like($val,
	 $re,
	 "Evaling ruleset " . $src);
    $test_count++;



  }
}

$krl_src = <<_KRL_;
ruleset dataset0 {
    global {
	dataset global_decl_0 <- "aaa.json";
    }
    rule foo is active {
     select using ".*"
     noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foo'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$js = <<_JS_;
(function(){
KOBJ['data']['global_decl_0'] = {"www.barnesandnoble.com":[
	       {"link":"http://aaa.com/barnesandnoble",
		"text":"AAA members sav emoney!",
		"type":"AAA"}]
          };
(function(){
 function callBacks(){};
 (function(uniq,cb,config){cb();}
  ('%uniq%',callBacks,$config)); 
 }());
}());
_JS_

test_datafeeds(
    0, # this test can run without a server
    $krl_src,
    $js,
    $dummy_final_req_info,
    0);


$krl_src = <<_KRL_;
ruleset dataset0 {
    global {
	dataset global_decl_1 <- "test_data";
    }
    rule foo is active {
     select using ".*"
     noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foo'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$js = <<_JS_;
(function(){
KOBJ['data']['global_decl_1'] = 'here is some test data!\\n';
(function(){
 function callBacks(){};
 (function(uniq,cb,config){cb();}
  ('%uniq%',callBacks,$config)); 
 }());
}());
_JS_

test_datafeeds(
    $no_server_available,
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );


$krl_src = <<_KRL_;
ruleset dataset0 {
    global {
	dataset global_decl_2 <- "http://frag.kobj.net/clients/cs_test/aaa.json";
    }
    rule foo is active {
     select using ".*"
     noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foo'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$js = <<_JS_;
(function(){
KOBJ['data']['global_decl_2'] = {"www.barnesandnoble.com":[
	       {"link":"http://aaa.com/barnesandnoble",
		"text":"AAA members sav emoney!",
		"type":"AAA"}]
          };
(function(){
 function callBacks(){};
 (function(uniq,cb,config){cb();}
  ('%uniq%',callBacks,$config)); 
 }());
}());
_JS_

test_datafeeds(
    $no_server_available,
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );


$krl_src = <<_KRL_;
ruleset dataset0 {
    global {
	dataset global_decl_3 <- "http://frag.kobj.net/clients/cs_test/some_data.txt";
    }
    rule foo is active {
     select using ".*"
     noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foo'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);


$js = <<_JS_;
(function(){
KOBJ['data']['global_decl_3'] = 'Here is some test data!\\n';
(function(){
 function callBacks(){};
 (function(uniq,cb,config){cb();}
  ('%uniq%',callBacks,$config)); 
 }());
}());
_JS_

test_datafeeds(
    $no_server_available,
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );

$krl_src = <<_KRL_;
ruleset dataset0 {
    global {
       datasource twitter_search <- "http://search.twitter.com/search.json";
    }
}
_KRL_

$js = <<_JS_;
_JS_


test_datafeeds(
    $no_server_available,
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );



$krl_src = <<_KRL_;
ruleset dataset0 {
    global {
      dataset site_data <- "http://frag.kobj.net/clients/cs_test/aaa.json";
      type = site_data.pick("\$..type");
      css <<
.foo: 4
>>;
      x = type + " Rocks!";
      datasource sites <- "aaa.json";
    }
    rule foo is active {
     select using ".*"
     noop();
    }
}
_KRL_

$config = mk_config_string(
  [
   {"rule_name" => 'foo'},
   {"rid" => 'cs_test'},
   {"txn_id" => 'txn_id'},
  ]
);

$js = <<_JS_;
(function(){KOBJ['data']['site_data'] = {"www.barnesandnoble.com":[{"link":"http://aaa.com/barnesandnoble","text":"AAA members save money!","type":"AAA"}]} ;
 var type = 'AAA';
 KOBJ.css('.foo: 4\\n ');
 var x = 'AAA Rocks!';
(function(){
 function callBacks(){};
 (function(uniq,cb,config){cb();}
  ('%uniq%',callBacks,$config)); 
 }());
}());

_JS_

test_datafeeds(
    $no_server_available,
    $krl_src,
    $js,
    $dummy_final_req_info,
    0
    );



#
# rule_env_tests
#
#diag "Stating rule environment tests";

# contains_string(nows($global_decl_0),
# 		nows(encode_json(lookup_rule_env('global_decl_0',$rule_env))), 
# 		 "Global decl data set effects env");
# contains_string(nows($global_decl_1), 
# 		nows(lookup_rule_env('global_decl_1',$rule_env)),
# 		"Global decl data set effects env");
# contains_string(nows($global_decl_2), 
# 		nows(encode_json(lookup_rule_env('global_decl_2',$rule_env))),
# 		"Global decl data set effects env");
# contains_string(nows($global_decl_3), 
# 		nows(lookup_rule_env('global_decl_3',$rule_env)),
# 		"Global decl data set effects env");



#
# session tests
#
$test_count += 3;

is(session_get($rid,$session,'archive_pages_now'), undef, "Archive pages now reset");
is(session_get($rid,$session,'archive_pages_now2'), undef, "Archive pages now2 reset");
is(session_get($rid,$session,'archive_pages_old'), 4, "Archive pages old iterated");

session_delete($rid,$session,'archive_pages_old');
session_delete($rid,$session,'archive_pages_now');
session_delete($rid,$session,'archive_pages_now2');
session_delete($rid,$session,'my_flag');
session_delete($rid,$session,'my_trail');


#
# optimize tests
#

sub check_optimize {
  my($krl,$ip, $op, $desc, $diag) = @_;
  diag "============================================================"  if $diag;
  my $rst = Kynetx::Parser::parse_ruleset($krl);
#  diag "Unoptimized: ", Dumper($rst) if $diag;
  my $ost = Kynetx::Rules::optimize_ruleset($rst);
#  diag "Optimized: ", Dumper($ost) if $diag;

  diag "Inner pre: ", Dumper $ost->{'rules'}->[0]->{'inner_pre'}  if $diag;
  $test_count++;

  is_deeply($ost->{'rules'}->[0]->{'inner_pre'} || [], 
	    $ip, 
	    $desc . "(inner)");


  diag "Outer pre: ", Dumper $ost->{'rules'}->[0]->{'outer_pre'}  if $diag;
  $test_count++;
  is_deeply($ost->{'rules'}->[0]->{'outer_pre'} || [], 
	    $op, 
	    $desc . "(outer)");
}


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
       pre {
          y = 6;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [],
	       [{
		 'rhs' => {
			   'val' => '6',
			   'type' => 'num'
			  },
		 'lhs' => 'y',
		 'type' => 'expr'
		}], 
	       "No dependence");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
       pre {
          y = x + 6;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'x',
				       'type' => 'var'
				      },
				      {
				       'val' => '6',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'y',
		 'type' => 'expr'
		}], 
	       [],
	       "One dependence");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
       pre {
          z = 5;
          y = x + 6;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'x',
				       'type' => 'var'
				      },
				      {
				       'val' => '6',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'y',
		 'type' => 'expr'
		}], 
	       [{
		 'rhs' => {
			   'val' => '5',
			   'type' => 'num'
			  },
		 'lhs' => 'z',
		 'type' => 'expr'
		}], 
	       "One independent, one dependent");



$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
       pre {
          y = x + 6;
          z = 5;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'x',
				       'type' => 'var'
				      },
				      {
				       'val' => '6',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'y',
		 'type' => 'expr'
		}], 
	       [{
		 'rhs' => {
			   'val' => '5',
			   'type' => 'num'
			  },
		 'lhs' => 'z',
		 'type' => 'expr'
		}], 
	       "One independent, one dependent, order doesn't matter");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
       pre {
          y = x + 6;
          z = 5;
          w = 4 + y;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'x',
				       'type' => 'var'
				      },
				      {
				       'val' => '6',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'y',
		 'type' => 'expr'
		},
		{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => '4',
				       'type' => 'num'
				      },
				      {
				       'val' => 'y',
				       'type' => 'var'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'w',
		 'type' => 'expr'
		},
	       ], 
	       [{
		 'rhs' => {
			   'val' => '5',
			   'type' => 'num'
			  },
		 'lhs' => 'z',
		 'type' => 'expr'
		}], 
	       "One independent, two dependent");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
       pre {
          y = x + 6;
          z = 5;
          w = 4 + y;
          a = w;
          b = 7;
          c = a;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'x',
				       'type' => 'var'
				      },
				      {
				       'val' => '6',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'y',
		 'type' => 'expr'
		},
		{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => '4',
				       'type' => 'num'
				      },
				      {
				       'val' => 'y',
				       'type' => 'var'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'w',
		 'type' => 'expr'
		},
		{
		 'rhs' => {
			   'val' => 'w',
			   'type' => 'var'
			  },
		 'lhs' => 'a',
		 'type' => 'expr'
		},
		{
		 'rhs' => {
			   'val' => 'a',
			   'type' => 'var'
			  },
		 'lhs' => 'c',
		 'type' => 'expr'
		}
	       ], 
	       [{
		 'rhs' => {
			   'val' => '5',
			   'type' => 'num'
			  },
		 'lhs' => 'z',
		 'type' => 'expr'
		},
		{
		 'rhs' => {
			   'val' => '7',
			   'type' => 'num'
			  },
		 'lhs' => 'b',
		 'type' => 'expr'
		}
	       ], 
	       "Many dependent and independent mixed");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
         foreach ['a','b','c'] setting (y)
       pre {
          z = 6;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [],
	       [{
		 'rhs' => {
			   'val' => '6',
			   'type' => 'num'
			  },
		 'lhs' => 'z',
		 'type' => 'expr'
		}], 
	       "No dependence");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
         foreach ['a','b','c'] setting (y)
       pre {
          z = y + 6;
       }
       noop();
    }
}
_KRL_

check_optimize($krl_src,
	       [{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'y',
				       'type' => 'var'
				      },
				      {
				       'val' => '6',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'z',
		 'type' => 'expr'
		}], 
	       [],
	       "Two foreach, one dependence");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
    rule t0 is active {
      select using ".*" setting ()
       foreach [1,2,3] setting (x)
         foreach ['a','b','c'] setting (y)
       pre {
          w = x + 6;
          v = y + 7;
          z = 5;
       }
       noop();
    }
}
_KRL_



check_optimize($krl_src,
	       [{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'x',
				       'type' => 'var'
				      },
				      {
				       'val' => '6',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'w',
		 'type' => 'expr'
		},
		{
		 'rhs' => {
			   'args' => [
				      {
				       'val' => 'y',
				       'type' => 'var'
				      },
				      {
				       'val' => '7',
				       'type' => 'num'
				      }
				     ],
			   'type' => 'prim',
			   'op' => '+'
			  },
		 'lhs' => 'v',
		 'type' => 'expr'
		}], 
	       [{
		 'rhs' => {
			   'val' => '5',
			   'type' => 'num'
			  },
		 'lhs' => 'z',
		 'type' => 'expr'
		}], 
	       "Two foreach; One independent, one dependent, order doesn't matter");


$krl_src = <<_KRL_;
ruleset global_expr_1 {
 rule foreach_here is active {
  select using "http://www.google.com" setting ()
   foreach [2,7] setting (x)
    pre {
      tweetUser = x.pick("\$..foo");
      y = <<
This is the number #{tweetUser} and #{x}   >>;
      z = 6;
      w = <<
This is another number #{z}  >>;
    }
    alert(x+y+z);
 }
}
_KRL_

check_optimize($krl_src,
[{
     'rhs' => {
       'obj' => {
         'val' => 'x',
         'type' => 'var'
       },
       'args' => [
         {
           'val' => '$..foo',
           'type' => 'str'
         }
       ],
       'name' => 'pick',
       'type' => 'operator'
     },
     'lhs' => 'tweetUser',
     'type' => 'expr'
   },
   {
     'rhs' => 'This is the number #{tweetUser} and #{x}   ',
     'lhs' => 'y',
     'type' => 'here_doc'
   }
],[{
     'rhs' => {
       'val' => 6,
       'type' => 'num'
     },
     'lhs' => 'z',
     'type' => 'expr'
   },
   {
     'rhs' => 'This is another number #{z}  ',
     'lhs' => 'w',
     'type' => 'here_doc'
   }
], "Extended quotes", 0);

#diag "Test cases: " . int(@test_cases) . " and others: " . $test_count;

done_testing($test_count);

session_cleanup($session);

diag("Safe to ignore warnings about unintialized values & unrecognized escapes");

sub mk_reg_exp {
  my $val = shift;

  $val = nows($val);
	
  # quote special for RE
  $val =~ s/\\/\\\\/g;
  $val =~ s/\+/\\\+/g;
  $val =~ s/\(/\\\(/g;
  $val =~ s/\)/\\\)/g;
  $val =~ s/\[/\\\[/g;
  $val =~ s/\]/\\\]/g;
  $val =~ s/\{/\\\{/g;
  $val =~ s/\}/\\\}/g;
  $val =~ s/\^/\\\^/g;
  $val =~ s/\$/\\\$/g;
  $val =~ s/\|/\\\|/g;

  # now make RE substitutions
  $val =~ s/%uniq%/\\d+/g;

  $val =  $val ;

  return $val;
}

1;


