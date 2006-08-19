#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Test::Count::Parser;

{
    my $parser = Test::Count::Parser->new();
    # TEST
    ok ($parser, "Checking for parser initialization.");
}

{
    my $parser = Test::Count::Parser->new();
    # TEST
    $parser->update_assignments(
        {
            text => q{$NUM_ITERS=5;$TESTS_PER_ITER=7}
        },
    );
    $parser->update_count(
        {
            text => q{$NUM_ITERS*$TESTS_PER_ITER}
        },
    );
    is ($parser->get_count(), 35, "Checking for correct calculation");
}
