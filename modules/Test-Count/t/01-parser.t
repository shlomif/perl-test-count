#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::Count::Parser;

{
    my $parser = Test::Count::Parser->new();
    # TEST
    ok ($parser, "Checking for parser initialization.");
}
