#!/usr/bin/perl

use warnings;
use strict;
use Bencode qw( bencode bdecode );
use Getopt::Std;

$main::VERSION = "1.0";
$Getopt::Std::STANDARD_HELP_VERSION = 1;

sub main::VERSION_MESSAGE {
    my $out = shift;
    print $out "$0 $main::VERSION\n";
}

sub main::HELP_MESSAGE {
    my $out = shift;
    print $out <<EOF;
Usage: $0 [OPTION]... [FILE]
  -i        Operate on file in-place
  -t URL    Use given URL for "announce" (default "http://127.0.0.1/")

$0 strips extra fields from a .torrent file, including all
tracker information. If no file is given, the .torrent is read from
stdin. If not operating on a file in-place, the edited torrent is sent
to stdout. Example,

  $0 < file.torrent > edited.torrent
EOF
}

## Read command line options
my %opts;
getopts( "it:", \%opts ) or exit(1);
my $file = $ARGV[0];

## Strip optional parameters (except "encoding" because it may be useful)
my $decoded = bdecode do { local $/; <> };
$$decoded{'announce'} = $opts{t} || "http://127.0.0.1/";
delete $$decoded{'announce-list'};
delete $$decoded{'comment'};
delete $$decoded{'created by'};
delete $$decoded{'creation date'};

## Write out edited torrent
if ( $opts{i} and $file ) {
    open( my $out, '>', $file ) or die "Could not open $file for writing.";
    print $out bencode $decoded;
}
else {
    print( bencode $decoded );
}
