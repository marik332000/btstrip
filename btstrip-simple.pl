#!/usr/bin/perl

# Strips optional parameters from a .torrent file on STDIN, and sets
# the announce URL to the first command line argument or the dummy
# entry http://127.0.0.1/. Edited .torrent file goes to STDOUT.

use warnings;
use strict;
use Bencode qw( bencode bdecode );

my $decoded = bdecode do { local $/; <STDIN> };
$$decoded{'announce'} = $ARGV[0] || "http://127.0.0.1/";
delete $$decoded{'announce-list'};
delete $$decoded{'comment'};
delete $$decoded{'created by'};
print( bencode $decoded );
