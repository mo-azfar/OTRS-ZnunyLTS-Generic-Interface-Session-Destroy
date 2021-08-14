#!/usr/bin/perl -w
# --
use strict;
use warnings;
use utf8;

## nofilter(TidyAll::Plugin::OTRS::Perl::Dumper)

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use JSON;
use REST::Client;
use Data::Dumper;

## ---
# Delete a session based on session id
# Method: DELETE
# Endpoint: /SessionEnd/$SessionID
# OTRS Route Mapping: /SessionEnd/:SessionID

my $SessionID = "TgeztcfZZeZJ1nDxhL1O8Qd2QLstrMKs";

## This is the HOST for the web service the format is:
## <HTTP_TYPE>:://<OTRS_FQDN>/nph-genericinterface.pl
my $Host = "http://192.168.17.140:81/otrs-devel/nph-genericinterface.pl";

my $RestClient = REST::Client->new(
    {
        host => $Host,
    }
);

my $ControllerAndRequest3 = "/Webservice/GenericSessionConnectorREST/SessionEnd/$SessionID";   
my @RequestParam3;   
@RequestParam3 = (
  $ControllerAndRequest3
);   

$RestClient->DELETE(@RequestParam3);
 
 ## If the host isn't reachable, wrong configured or couldn't serve the requested page:
my $ResponseCode3 = $RestClient->responseCode();
if ( $ResponseCode3 ne '200' ) {
    print "Request failed, response code was: $ResponseCode3\n";
    exit;
}

# If the request was answered correctly, we receive a JSON string here.
my $ResponseContent3 = $RestClient->responseContent();

my $Data3 = decode_json $ResponseContent3;

## Just to print out the returned Data structure:
print "Update Response was:\n";
print Dumper($Data3);
 
 