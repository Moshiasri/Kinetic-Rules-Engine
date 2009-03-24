package Kynetx::Datasets;
# file: Kynetx/Datasets.pm

use strict;
use warnings;

use Log::Log4perl qw(get_logger :levels);
use JSON::XS;

use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

use Kynetx::Memcached qw/:all/;

# FIXME: this ought to come out of configuration
use constant DATA_ROOT => '/web/data/client';

our $VERSION     = 1.00;
our @ISA         = qw(Exporter);

# put exported names inside the "qw"
our %EXPORT_TAGS = (all => [ 
qw(
cache_dataset_for
get_dataset
mk_dataset_js
) ]);

our @EXPORT_OK   =(@{ $EXPORT_TAGS{'all'} }) ;


  # 'datasets' => [
  #   {
  #     'source' => 'aaa.json',
  #     'name' => 'aaa',
  #     'cachable' => 0
  #   },
  #   {
  #     'source' => 'aarp.json',
  #     'name' => 'aarp',
  #     'cachable' => 0
  #   },
  #   {
  #     'source' => 'http://www.foo.com/data.json',
  #     'name' => 'fizz_data',
  #     'cachable' => 1
  #   },
  #   {
  #     'source' => 'http://www.foo.com/data.json',
  #     'name' => 'foo_data',
  #     'cachable' => {
  #       'period' => 'minutes',
  #       'value' => '20'
  #     }
  #   }
  # ],

sub get_dataset {
    my ($dataset, $req_info) = @_;

    my  ($perl_data, $json_data); 

    my $logger = get_logger();

    my $name = $dataset->{'name'};
    my $source_name = $dataset->{'source'};

    # for now, if it's not an HTTP url, assume it's a file.
    my $type = ($source_name =~ m#^http://#) ? "url" : "file";
    $logger->debug("retrieving dataset $name as $type");
    
    my $cache_for = cache_dataset_for($dataset);

    my $source;
    if($type eq 'file') {
	$source_name = join("/", (DATA_ROOT, $req_info->{'rid'}, $source_name));
	$logger->debug("retrieving file dataset from $source_name");
	$source = get_cached_file($source_name); # no expiration on 
    } else {
	$logger->debug("retrieving network dataset from $source_name");
	$source = get_remote_data($source_name, $cache_for);
    }

    return $source

}

sub cache_dataset_for {
    my ($d) = @_;
    my $logger = get_logger();

    my $cache_for = 0;

    my $name = $d->{'name'};

    if($d->{'cachable'}) {
	$cache_for = 24*60*60;  # in seconds, default to one day
    } 

    if (ref $d->{'cachable'} eq 'HASH') { 
	$cache_for = $d->{'cachable'}->{'value'};  
	if($d->{'cachable'}->{'period'} eq 'years') {
	    $cache_for = $cache_for * 60 * 60 * 24 * 365;
	} elsif($d->{'cachable'}->{'period'} eq 'months') {
	    $cache_for = $cache_for * 60 * 60 * 24 * 30;
	} elsif($d->{'cachable'}->{'period'} eq 'weeks') {
	    $cache_for = $cache_for * 60 * 60 * 24 * 7;
	} elsif($d->{'cachable'}->{'period'} eq 'days') {
	    $cache_for = $cache_for * 60 * 60 * 24;
	} elsif($d->{'cachable'}->{'period'} eq 'hours') {
	    $cache_for = $cache_for * 60 * 60;
	} elsif($d->{'cachable'}->{'period'} eq 'minutes') {
	    $cache_for = $cache_for * 60;
	} elsif($d->{'cachable'}->{'period'} eq 'seconds') {
	    $cache_for = $cache_for;
	} 
   } 

    $logger->debug("caching dataset $name for $cache_for seconds");
    return $cache_for;

}

# side-effects $rule_env
sub mk_dataset_js {
    my ($g, $req_info, $rule_env) = @_;
    my $logger = get_logger();
    
    my $source = get_dataset($g, $req_info);
    
    my $js = 'var ' . $g->{'name'} . ' = ';
    my $source_json;
    eval { $source_json = decode_json($source); };
    if ($@) {
	$logger->debug("seeing " . $g->{'name'} . " as string ", $@);
	$js .= '"' . $source . '"';
	$rule_env->{$g->{'name'}} = $source;
    } else { 
	$logger->debug("seeing " . $g->{'name'} . " as JSON ", $@);
	$js .= $source;
	$rule_env->{$g->{'name'}} = $source_json;
    }
    $js .= ";\n";

    return $js;

}

1;