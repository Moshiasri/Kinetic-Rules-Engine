package Kynetx::Rules;
# file: Kynetx/Rules.pm
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
use strict;
use warnings;


use Data::UUID;
use Log::Log4perl qw(get_logger :levels);
use JSON::XS;

use Kynetx::Parser qw(:all);
use Kynetx::PrettyPrinter qw(:all);
use Kynetx::JavaScript;
use Kynetx::Expressions ;
use Kynetx::Json qw(:all);
use Kynetx::Util qw(:all);
use Kynetx::Memcached qw(:all);
use Kynetx::Datasets qw(:all);
use Kynetx::Session qw(:all);
use Kynetx::Modules qw(:all);
use Kynetx::Actions;
use Kynetx::Authz;
use Kynetx::Events;
use Kynetx::Log qw(:all);
use Kynetx::Request qw(:all);
use Kynetx::Repository;
use Kynetx::Environments qw(:all);
use Kynetx::Directives ;
use Kynetx::Postlude;

use Kynetx::JavaScript::AST qw/:all/;

use Kynetx::Actions::LetItSnow;
use Kynetx::Actions::JQueryUI;
use Kynetx::Actions::FlippyLoo;

use Data::Dumper;
$Data::Dumper::Indent = 1;


use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);

our %EXPORT_TAGS = (all => [ 
qw(
process_rules
eval_rule
eval_globals
get_rule_set 
) ]);
our @EXPORT_OK   =(@{ $EXPORT_TAGS{'all'} }) ;



sub process_rules {
    my ($r, $method, $rids, $eid) = @_;

    my $logger = get_logger();

    $r->subprocess_env(START_TIME => Time::HiRes::time);

    if(Kynetx::Configure::get_config('RUN_MODE') eq 'development') {
	# WARNING: THIS CHANGES THE USER'S IP NUMBER FOR TESTING!!
	my $test_ip = Kynetx::Configure::get_config('TEST_IP');
	 $r->connection->remote_ip($test_ip);
	$logger->debug("In development mode using IP address ", $r->connection->remote_ip());
    } 


    # get a session
    my $session = process_session($r);

    my $req_info = Kynetx::Request::build_request_env($r, $method, $rids);
    $req_info->{'eid'} = $eid;

    # initialization
    my $js = '';


    my $rule_env = mk_initial_env();
    
    my @rids = split(/;/, $rids);
    # if we sort @rids we change ruleset priority
    foreach my $rid (@rids) {
	Log::Log4perl::MDC->put('site', $rid);
# 	my $rule_list = mk_rule_list($req_info, $rid);
# 	$js .= eval { process_ruleset($r, 
# 				      $rule_list, 
# 				      $rule_env, 
# 				      $session, 
# 				      $rid
# 				     ) 
# 		    }; 
	my $schedule = mk_schedule($req_info, $rid);
	$js .= eval {
	  process_schedule($r, $schedule, $session, $eid);
	};
	if ($@) {
	  $logger->error("Ruleset $rid failed: ", $@);
	}
    }

    # put this in the logging DB
    log_rule_fire($r, 
		  $req_info, 
		  $session
	);

    session_cleanup($session);

    # return the JS load to the client
    $logger->info("Ruleset processing finished");
    $logger->debug("__FLUSH__");

    # this is where we return the JS
    if ($req_info->{'understands_javascript'}) {
      $logger->debug("Returning javascript from evaluation");
      print $js;
    } else {
      $logger->debug("Returning directives from evaluation");


      print Kynetx::Directives::gen_directive_document($req_info);

    }

}


sub process_schedule {
  my ($r, $schedule, $session, $eid) = @_;

  my $logger = get_logger();

  my $init_rule_env = Kynetx::Rules::mk_initial_env();

  my $ast = Kynetx::JavaScript::AST->new($eid);
  my($req_info, $ruleset, $mjs, $gjs, $rule_env, $rid);

  my $current_rid = '';
  while (my $task = $schedule->next()) {

#    $logger->debug("[task] ", sub { Dumper($task) });

    $rid = $task-> {'rid'};
    unless ($rid eq $current_rid) {
      #context switch
      # we only do this when there's a new RID

      # save info from last context

      $ast->add_resources($current_rid, $req_info->{'resources'});

      # set up new context
      $ruleset = $task->{'ruleset'};

      if (($ruleset->{'meta'}->{'logging'} && 
	   $ruleset->{'meta'}->{'logging'} eq "on")) {
	turn_on_logging();
      } else {
	turn_off_logging();
      }

      Log::Log4perl::MDC->put('site', $rid);
      $logger->info("Processing rules for site " . $rid);

      $req_info = $task->{'req_info'};
      $req_info->{'rid'} = $rid;
      # we use this to modify the schedule on-the-fly
      $req_info->{'schedule'} = $schedule;


      # generate JS for meta
      $mjs = eval_meta($req_info, $ruleset, $init_rule_env);

      # handle globals, start js build, extend $rule_env
      ($gjs, $rule_env) = eval_globals($req_info, $ruleset, $init_rule_env, $session);
#      $logger->debug("Rule env after globals: ", Dumper $rule_env);
#    $logger->debug("Global JS: ", $gjs);

      $ast->add_rid_js($rid, $mjs, $gjs, $ruleset, $req_info->{'txn_id'});

      $req_info->{'rule_count'} = 0;
      $req_info->{'selected_rules'} = [];

      $current_rid = $rid;
    } # done with context

    my $rule = $task->{'rule'};
    my $rule_name = $rule->{'name'};

    Log::Log4perl::MDC->put('rule', $rule_name);


    $logger->trace("[rules] foreach pre: ", sub { Dumper($rule->{'pre'}) });
    # set by eval_control_statement in Actions.pm
    last if $req_info->{$req_info->{'rid'}.':__KOBJ_EXEC_LAST'};


    my $this_rule_env;
    $logger->debug("Rule $rule_name is " . $rule->{'state'});
    if($rule->{'state'} eq 'active' || 
       ($rule->{'state'} eq 'test' && 
	$req_info->{'mode'} && 
	$req_info->{'mode'} eq 'test' )) {  # optimize??

      $req_info->{'rule_count'}++;


      $logger->debug("[selected] $rule->{'name'} ");
#      $logger->trace("[rules] ", sub { Dumper($rule) });

      push @{ $req_info->{'selected_rules'} }, $rule->{'name'};

      my $select_vars = $task->{'vars'};
      my $captured_vals = $task->{'vals'};

      # store the captured values from the precondition to the env
      my $cap = 0;
      my $sjs = '';
      foreach my $var (@{ $select_vars } ) {
	$var =~ s/^\s*(.+)\s*/$1/; # trim whitspace
	$logger->debug("[select var] $var -> $captured_vals->[$cap]");
	$this_rule_env->{$var} = $captured_vals->[$cap];
	$sjs .= Kynetx::JavaScript::gen_js_var($var,
  	           Kynetx::JavaScript::gen_js_expr(
		      Kynetx::Expressions::exp_to_den($captured_vals->[$cap])));

	$cap++
      }

      my $new_req_info = Kynetx::Request::merge_req_env($req_info, $task->{'req_info'});

      my $js;
      if (Kynetx::Authz::is_authorized($rid,$ruleset,$session)) {

	$js = eval {eval_rule($r, 
			      $req_info,
			      extend_rule_env($this_rule_env, $rule_env),
			      $session, 
			      $rule,
			      $sjs  # pass in the select JS to be inside rule
			     );
		 };

	if ($@) {
	  $logger->error("Ruleset $rid failed: ", $@);
	}

      } else {

	$logger->debug("Sending activation notice for $rid");
	$js = eval {
	  Kynetx::Authz::authorize_message($task->{'req_info'}, $session, $ruleset)
	};
	if ($@) {
	  $logger->error("Authorization failed for $rid: ", $@);
	}
	# Since this RID isn't auhtorized yet, skip the rest...
	$schedule->delete_rid($rid);

      }
      $ast->add_rule_js($rid, $js);

    } else {
      $logger->debug("[not selected] $rule->{'name'} ");
    }

  }

  # process for final context
  $ast->add_resources($current_rid, $req_info->{'resources'});

  $logger->debug("Finished processing rules for " . $rid);
  return $ast->generate_js();

}



sub eval_meta {
    my($req_info,$ruleset, $rule_env) = @_;

    my $logger = get_logger();
    my $js = "";

    my $rid = $req_info->{'rid'};

    $req_info->{"$rid:ruleset_name"} = $ruleset->{'ruleset_name'};
    $req_info->{"$rid:name"} = $ruleset->{'meta'}->{'name'};
    $req_info->{"$rid:author"} = $ruleset->{'meta'}->{'author'};
    $req_info->{"$rid:description"} = $ruleset->{'meta'}->{'description'};

    if($ruleset->{'meta'}->{'keys'}) {

      $js .= KOBJ_ruleset_obj($ruleset->{'ruleset_name'}) . " =  " . KOBJ_ruleset_obj($ruleset->{'ruleset_name'}) . " || {};\n";

      $js .= KOBJ_ruleset_obj($ruleset->{'ruleset_name'}) .  ".keys = " . KOBJ_ruleset_obj($ruleset->{'ruleset_name'}) . ".keys || {};\n";

      $logger->debug("Found keys; generating JS");
      foreach my $k (keys %{ $ruleset->{'meta'}->{'keys'} }) {
	if ($k eq 'twitter') {
	  $req_info->{$rid.':key:twitter'} = $ruleset->{'meta'}->{'keys'}->{$k};
	} elsif ($k eq 'amazon') {
	  $req_info->{$rid.':key:amazon'} = $ruleset->{'meta'}->{'keys'}->{$k};    	  
	} else { # googleanalytics, errorstack
	  $js .= KOBJ_ruleset_obj($ruleset->{'ruleset_name'}). ".keys.$k = '" . 
	    $ruleset->{'meta'}->{'keys'}->{$k} . "';\n";
	}
      }
    }

    if ($ruleset->{'meta'}->{'use'}) {
      $js .= eval_use($req_info, $ruleset, $rule_env, $ruleset->{'meta'}->{'use'});
    }

    return $js;
}

sub eval_use {
  my($req_info,$ruleset, $rule_env, $use) = @_;

  my $logger = get_logger();
  my $js = "";

  my $rid = $req_info->{'rid'};
  $logger->debug("Processing 'use' pragmas");
  
  foreach my $u (@{$use}) {
    # just put resources in $req_info and mk_registered_resources will grab them
    if ($u->{'type'} eq 'resource') {
      $logger->debug("Adding resource ", $u->{'resource'}->{'location'});
      $req_info->{'resources'}->{$u->{'resource'}->{'location'}} = 
		  {'type' => $u->{'resource_type'}};
    } else {
      $logger->error("Unknown type for 'use': ", $u->{'type'});
    }
  }

#   $js .= "KOBJ.registerExternalResources(\"$rid\"," .
#             Kynetx::Json::astToJson($resources) .
# 	  ');';

  return $js;
}

sub eval_globals {
    my($req_info,$ruleset, $rule_env, $session) = @_;
    my $logger = get_logger();

    my $js = "";
    if($ruleset->{'global'}) {

#    $logger->debug("Here's the globals: ", Dumper $ruleset->{'global'});

      # make this act like let* not let
      my @vars;
      foreach my $g (@{ $ruleset->{'global'} }) {
	$g->{'lhs'} = $g->{'name'} unless(defined $g->{'lhs'});
	if (defined $g->{'lhs'}) {
	  if (defined $g->{'type'} && $g->{'type'} eq 'datasource') {
	    push @vars, 'datasource:'.$g->{'lhs'};
	  } else {
	    push @vars, $g->{'lhs'};
	  }
	}
      }

      my @empty_vals = map {''} @vars;
      $rule_env = extend_rule_env(\@vars, \@empty_vals, $rule_env);

      $logger->debug("Global vars: ", join(", ", @vars));

      foreach my $g (@{ $ruleset->{'global'} }) {
	my $this_js = '';
	my $var = '';
	my $val = 0;
	if($g->{'emit'}) { # emit
	  $this_js = Kynetx::Expressions::eval_emit($g->{'emit'}) . "\n";
	} elsif(defined $g->{'type'} && $g->{'type'} eq 'dataset') { 
	    my $new_ds = Kynetx::Datasets->new($g);
	  if (! $new_ds->is_global()) {
	      $new_ds->load($req_info);
	      $new_ds->unmarshal();
	      $this_js = $new_ds->make_javascript();
	      $var = $new_ds->name;
	      if (defined $new_ds->json) {
	          $val = $new_ds->json;
	      } else {
	          $val = $new_ds->sourcedata;
	      }
	    #($this_js, $var, $val) = mk_dataset_js($g, $req_info, $rule_env);
	    # yes, this is cheating and breaking the abstraction, but it's fast
	    $rule_env->{$var} = $val;
	  }
	} elsif(defined $g->{'type'} && $g->{'type'} eq 'css') { 
	  $this_js = "KOBJ.css(" . Kynetx::JavaScript::mk_js_str($g->{'content'}) . ");\n";
	} elsif(defined $g->{'type'} && $g->{'type'} eq 'datasource') {
	  $rule_env->{'datasource:'.$g->{'lhs'}} = $g;
	} elsif(defined $g->{'type'} && 
		($g->{'type'} eq 'expr' || $g->{'type'} eq 'here_doc')) {
	  $this_js = Kynetx::Expressions::eval_one_decl($req_info, $rule_env, $ruleset->{'lhs'}, $session, $g);
	}
	$js .= $this_js;
      }
    }
#    $logger->debug(" rule_env: ", Dumper($rule_env));

    return ($js, $rule_env);
   
}

sub eval_rule {
    my($r, $req_info, $rule_env, $session, $rule, $initial_js) = @_;

    Log::Log4perl::MDC->put('rule', $rule->{'name'});

    my $logger = get_logger();

    $logger->debug("------------------- begin rule execution: $rule->{'name'} ------------------------");

    my $js = '';

#    $logger->info($rule->{'name'}, " selected...");

# uncomment to print out all the session keys.  With events there's a lot
#     foreach my $var (@{ session_keys($req_info->{'rid'}, $session) } ) {
# 	next if($var =~ m/_created$/);
# 	$logger->debug("[Session] $var has value ". 
# 		       session_get($req_info->{'rid'}, $session, $var));
#     }

    # keep track of these for each rule
    $req_info->{'actions'} = [];
    $req_info->{'labels'} = [];
    $req_info->{'tags'} = [];
    
    # assume the rule doesn't fire.  We will change this if it EVER fires in this eval
    $req_info->{$rule->{'name'}.'_result'} = 'notfired';

    if ($rule->{'pre'} &&
	! ($rule->{'inner_pre'} || $rule->{'outer_pre'})) {
	  $logger->debug("Rule not pre optimized...");
	  optimize_pre($rule);
    }

    my $outer_tentative_js = '';


    # this loads the rule_env.  
    ($outer_tentative_js,$rule_env) = 
      Kynetx::Expressions::eval_prelude($req_info, 
					$rule_env, 
					$rule->{'name'}, 
					$session, 
					$rule->{'outer_pre'});

    $rule->{'pagetype'}->{'foreach'} = [] 
      unless defined $rule->{'pagetype'}->{'foreach'};

    $js .= eval_foreach($r, 
			$req_info, 
			$rule_env, 
			$session, 
			$rule,
			@{ $rule->{'pagetype'}->{'foreach'} });

    # save things for logging
    push(@{ $req_info->{'results'} }, $req_info->{$rule->{'name'}.'_result'});
    push(@{ $req_info->{'names'} }, $req_info->{'rid'}.':'.$rule->{'name'});
    push(@{ $req_info->{'all_actions'} }, $req_info->{'actions'});
    push(@{ $req_info->{'all_labels'} }, $req_info->{'labels'});
    push(@{ $req_info->{'all_tags'} }, $req_info->{'tags'});

    # combine JS and wrap in a closure if rule fired
    $js = mk_turtle($initial_js . $outer_tentative_js . $js) if $js;

    return $js;

}

# recursive function on foreach list.
sub eval_foreach {
  my($r, $req_info, $rule_env, $session, $rule, @foreach_list) = @_;

  my $logger = get_logger();

  my $fjs = '';

  # $logger->debug("In foreach with " . Dumper(@foreach_list));

  if (@foreach_list == 0) {

    $fjs =  eval_rule_body($r, 
			    $req_info, 
			    $rule_env, 
			    $session, 
			    $rule);

  } else {

    # expr has to result in array of prims
    my $valarray = 
         Kynetx::Expressions::eval_expr($foreach_list[0]->{'expr'}, 
					$rule_env, 
					$rule->{'name'}, 
					$req_info, 
					$session);

    
    my $vars = $foreach_list[0]->{'var'};

    # loop below expects array of arrays
    if ($valarray->{'type'} eq 'array') {
      # array of single value arrays
      $valarray = [map {[Kynetx::Expressions::den_to_exp($_)]} @{$valarray->{'val'}}];
    } elsif ($valarray->{'type'} eq 'hash') {
      # turn hash into array of two element arrays
      my @va;
      foreach my $k (keys %{$valarray->{'val'}}) {
	push @va, [$k, Kynetx::Expressions::den_to_exp($valarray->{'val'}->{$k})];
      }
      $valarray = \@va;
      $logger->debug("Valarray ", sub {Dumper $valarray});
    } else {
      $logger->debug("Foreach expression does not yield array or hash; creating array from singleton") ;
      # make an array of arrays
      $valarray = [[Kynetx::Expressions::den_to_exp($valarray)]];
    }

#    $logger->debug("Valarray ", sub {Dumper $valarray});



    foreach my $val (@{ $valarray}) {

#      $logger->debug("Evaluating rule body with " . Dumper($val));

      my $vjs = 
	Kynetx::JavaScript::gen_js_var_list($vars, 
		[map {Kynetx::JavaScript::gen_js_expr(
		       Kynetx::Expressions::typed_value($_))} @{$val}]);


      $logger->debug("Vars ", sub {Dumper $vars});
      $logger->debug("Vals ", sub {Dumper $val});

      # we recurse in side this loop to handle nested foreach statements
      $fjs .= mk_turtle(
		$vjs .
  	        eval_foreach($r, 
			     $req_info, 
			     extend_rule_env($vars,
					     $val,
					     $rule_env), 
			     $session, 
			     $rule,
			     cdr(@foreach_list)
			    ));
    }
  }

  return $fjs;
}

sub eval_rule_body {
  my($r, $req_info, $rule_env, $session, $rule) = @_;

  my $logger = get_logger();

  my $inner_tentative_js;
  ($inner_tentative_js,$rule_env) = 
    Kynetx::Expressions::eval_prelude($req_info, 
				      $rule_env, $rule->{'name'}, 
				      $session, $rule->{'inner_pre'});



  # if the condition is undefined, it's true.  
  $rule->{'cond'} ||= mk_expr_node('bool','true');


  my $pred_value = 
    Kynetx::Expressions::den_to_exp(
       Kynetx::Expressions::eval_expr ($rule->{'cond'}, $rule_env, $rule->{'name'},$req_info, $session));


  my $js = '';

    
  my $fired = 0;
  if ($pred_value) {

    $logger->info("fired");

    # this is the main event.  The browser has asked for a
    # chunk of Javascrip and this is where we deliver... 

    # combine the inner_tentive JS, with the generated JS and wrap in a closure
    $js = $inner_tentative_js .
          Kynetx::Actions::build_js_load($rule, 
					 $req_info, 
					 $rule_env, 
					 $session);
	
    $fired = 1;
    # change the 'fired' flag to indicate this rule fired.  
    $req_info->{$rule->{'name'}.'_result'} = 'fired';
#    push(@{ $req_info->{'results'} }, 'fired');


  } else {
    $logger->info("did not fire");

    $fired = 0;

# don't do anything since we already assume no fire; 
#    $req_info->{$rule->{'name'}.'_result'} = 'notfired';
#    push(@{ $req_info->{'results'} }, 'notfired');

  }

  $js .= Kynetx::Postlude::eval_post_expr($rule, $session, $req_info, $rule_env, $fired);

  return $js;
}


# this returns the right rules for the caller and site
sub get_rule_set {
    my ($req_info, $localparsing) = @_;

    my $caller = $req_info->{'caller'};
    my $rid = $req_info->{'rid'};


    
    my $logger = get_logger();
    $logger->debug("Getting ruleset $rid for $caller");

    # cached the ruleset in the req_info and use it if we can
    my $ruleset;
    if (defined $req_info->{$rid}->{'ruleset'}) {
      $ruleset = $req_info->{$rid}->{'ruleset'};
    } else {
      $ruleset = Kynetx::Repository::get_rules_from_repository($rid, $req_info, $localparsing);
      $req_info->{$rid}->{'ruleset'} = $ruleset;
    }

    if (($ruleset->{'meta'}->{'logging'} && 
	 $ruleset->{'meta'}->{'logging'} eq "on")) {
      turn_on_logging();
    } else {
      turn_off_logging();
    }
    
    $logger->debug("Found " . @{ $ruleset->{'rules'} } . " rules for RID $rid" );

    return $ruleset;

}

sub select_rule {
    my($caller, $rule) = @_;

    my $logger = get_logger();

    # test the pattern, captured values are stored in @captures

    my $pattern_regexp = Kynetx::Actions::get_precondition_test($rule);
    $logger->debug("Selection pattern: $rule->{'name'} ", $pattern_regexp);

    my $captures = [];
    if(@{$captures} = $caller =~ $pattern_regexp) {
	return (1, $captures);
    } else {
	return (0, $captures);
    }
}


sub optimize_ruleset {
    my ($ruleset) = @_;

    my $logger = get_logger();

    $logger->debug("Optimizing rules for ", $ruleset->{'ruleset_name'});

    foreach my $rule ( @{ $ruleset->{'rules'} } ) {
      optimize_rule($rule);
    }

    $ruleset->{'optimization_version'} = get_optimization_version();

#    $logger->debug("Optimized ruleset ", sub { Dumper $ruleset });
    
    return $ruleset;
}

# incrementing the number here will force cache reloads of rulesets with lower #'s
sub get_optimization_version {
  my $version = 3;
  return $version;
}


sub optimize_rule {
  my ($rule) = @_;

  my $logger = get_logger();

  # fix up old syntax, if needed
  if ($rule->{'pagetype'}->{'pattern'}) {
    $logger->debug("Fixing select for ", $rule->{'name'});

    $rule->{'pagetype'}->{'event_expr'}->{'pattern'}  = 
      $rule->{'pagetype'}->{'pattern'} ;
    $rule->{'pagetype'}->{'event_expr'}->{'vars'}  = 
      $rule->{'pagetype'}->{'vars'} ;
    $rule->{'pagetype'}->{'event_expr'}->{'op'}  = 'pageview';
    $rule->{'pagetype'}->{'event_expr'}->{'type'}  = 'prim_event';
    $rule->{'pagetype'}->{'event_expr'}->{'legacy'}  = 1;
  }

  # precompile pattern regexp
  if (defined $rule->{'pagetype'}->{'event_expr'}->{'op'}) {
    $logger->debug("Optimizing ", $rule->{'name'});
    $rule->{'event_sm'} = Kynetx::Events::compile_event_expr($rule->{'pagetype'}->{'event_expr'});
#     $rule->{'pagetype'}->{'event_expr'}->{'pattern'} = 
#       qr!$rule->{'pagetype'}->{'event_expr'}->{'pattern'}!;
  } else { # deprecated syntax...
#     $rule->{'pagetype'}->{'pattern'} = 
#       qr!$rule->{'pagetype'}->{'pattern'}!;
  }

  # break up pre, if needed
  optimize_pre($rule);

  return $rule;
}

sub optimize_pre {
  my ($rule) = @_;
  my $logger = get_logger();
  my @varlist = map {$_->{'var'}} @{ $rule->{'pagetype'}->{'foreach'} };
# don't need this, but I love it.
# 	  my %is_var;
# 	  # create a hash for testing whether a var is defined or not
# 	  @is_var{@vars} = (1) x @vars;

  my @vars;
  foreach my $v (@varlist) {
    push @vars, @{$v};
  }

  $logger->debug("[rules::optimize_pre] foreach vars: ", sub {Dumper(@vars)});

    foreach my $decl (@{$rule->{'pre'}}) {
      # check if any of the vars occur free in the rhs
      $logger->trace("[rules::optimize_pre] decl: ", sub {Dumper($decl)});
      my $dependent = 0;
      foreach my $v (@vars) {
#	$logger->debug("Checking if $v is free in expr");
	if ($decl->{'type'} eq 'expr' &&
	    Kynetx::Expressions::var_free_in_expr($v, $decl->{'rhs'})) {
	  $dependent = 1;
	} elsif ($decl->{'type'} eq 'here_doc' &&
	    Kynetx::Expressions::var_free_in_expr($v, $decl)) {
	  $dependent = 1;
	}
      }
      if ($dependent) {
	push(@{$rule->{'inner_pre'}}, $decl);
	push(@vars, $decl->{'lhs'}); # collect new var
      } else {
	push(@{$rule->{'outer_pre'}}, $decl);
      }
    }
#    $logger->debug("Dependent vars in optimization: ", @vars);

}




sub mk_initial_env {
 my $rule_env = empty_rule_env();

 # define initial environment to have a truth function
 $rule_env = extend_rule_env({'truth' =>
			      Kynetx::Expressions::mk_closure({'vars' => [],
							       'decls' => [],
							       'expr' => mk_expr_node('num', 1),
							      }, 
							      $rule_env)},
			     $rule_env);
 return $rule_env;
}

# sub mk_rule_list {
#   # third param is optional and not used in production--testing
#   my ($req_info, $rid, $ruleset) = @_;

#   my $logger = get_logger();

#   $req_info->{'rid'} = $rid; # override with the one we're working on

#   $logger->info("Processing rules for site " . $req_info->{'rid'});

#   $ruleset = get_rule_set($req_info) unless defined $ruleset;

#   my $rl = {'ruleset' => $ruleset,
# 	    'rules' => [],
# 	    'req_info' => $req_info
# 	   };


#   foreach my $rule (@{$ruleset->{'rules'}}) {

#     # test and capture here
#     my($selected, $vals) = select_rule($req_info->{'caller'}, $rule);


#     if ($selected) {

# 	push @{$rl->{'rules'}}, $rule;

# 	my $vars = Kynetx::Actions::get_precondition_vars($rule);
# 	$rl->{$rule->{'name'}} = {'req_info' => {},
# 				  'vars' => $vars,
# 				  'vals' => $vals
# 				 };
#     }
#   }

#  $logger->debug("Rule List: ", sub {Dumper $rl->{'rules'}});


#   return $rl;

# }

sub mk_schedule {
  # third param is optional and not used in production--testing
  my ($req_info, $rid, $ruleset) = @_;

  my $logger = get_logger();

  my $schedule = Kynetx::Scheduler->new();

  $req_info->{'rid'} = $rid; # override with the one we're working on
  
  $logger->info("Processing rules for site " . $req_info->{'rid'});

  $ruleset = get_rule_set($req_info) unless defined $ruleset;


  foreach my $rule (@{$ruleset->{'rules'}}) {


    # test and capture here
    my($selected, $vals) = select_rule($req_info->{'caller'}, $rule);

    if ($selected) {

      my $rulename = $rule->{'name'};

      $schedule->add($rid,$rule,$ruleset,$req_info);

      my $vars = Kynetx::Actions::get_precondition_vars($rule);

      $schedule->annotate_task($rid,$rulename,'vars',$vars);
      $schedule->annotate_task($rid,$rulename,'vals',$vals);

      
    }
  }

#  $logger->debug("Schedule: ", sub {Dumper $schedule});


  return $schedule;

}


1;
