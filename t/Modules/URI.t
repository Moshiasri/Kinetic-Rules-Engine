#!/usr/bin/perl -w 
#
# This file is part of the Kinetic Rules Engine (KRE)
# Copyright (C) 2007-2011 Kynetx, Inc. 
#
# KRE is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
# MA 02111-1307 USA
#
use lib qw(/web/lib/perl);
use strict;
use warnings;

use Test::More;
use Test::LongString;

use Apache::Session::Memcached;
use DateTime;
use APR::URI;
use APR::Pool ();
use Cache::Memcached;


# most Kyentx modules require this
use Log::Log4perl qw(get_logger :levels);
Log::Log4perl->easy_init($INFO);
#Log::Log4perl->easy_init($DEBUG);

use Kynetx::Test qw/:all/;
use Kynetx::Modules::URI qw/:all/;
use Kynetx::Modules qw/:all/;
use Kynetx::Environments qw/:all/;
use Kynetx::Session qw/:all/;
use Kynetx::Configure qw/:all/;


use Kynetx::FakeReq qw/:all/;


use Data::Dumper;
$Data::Dumper::Indent = 1;



my $preds = Kynetx::Modules::URI::get_predicates();
my @pnames = keys (%{ $preds } );



my $r = Kynetx::Test::configure();

my $rid = 'cs_test';

# test choose_action and args

my $my_req_info = Kynetx::Test::gen_req_info($rid);

my $rule_name = 'foo';

my $rule_env = Kynetx::Test::gen_rule_env();

my $session = Kynetx::Test::gen_session($r, $rid);

my $test_count = 0;


# check that predicates at least run without error
my @dummy_arg = (0);
foreach my $pn (@pnames) {
    ok(&{$preds->{$pn}}($my_req_info, $rule_env,\@dummy_arg) ? 1 : 1, "$pn runs");
    $test_count++;
}

my $source = 'uri';
my ($result,$args);

$args = ['http://www.windley.com/archives?foo=bar'];
$result = Kynetx::Expressions::den_to_exp(
            Kynetx::Modules::eval_module($my_req_info, 
				       $rule_env, 
				       $session, 
				       $rule_name, 
				       $source, 
				       'escape', 
				       $args
				      ));


is($result,
   'http%3A%2F%2Fwww.windley.com%2Farchives%3Ffoo%3Dbar', 
   'uri:escape');
$test_count++;

# now we reverse it
$args = [$result];
$result = Kynetx::Expressions::den_to_exp(
            Kynetx::Modules::eval_module($my_req_info, 
				       $rule_env, 
				       $session, 
				       $rule_name, 
				       $source, 
				       'unescape', 
				       $args
				      ));


is($result,
   'http://www.windley.com/archives?foo=bar', 
   'uri:unescape (reverse last result)');
$test_count++;


done_testing($test_count);



1;


