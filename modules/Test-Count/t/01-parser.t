#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

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

{
    my $parser = Test::Count::Parser->new();
    $parser->update_assignments(
        {
            text => q{$NUM_ITERS=5;$TESTS_PER_ITER=7}
        },
    );
    $parser->update_assignments(
        {
            text => q{$myvar=$NUM_ITERS-2}
        },
    );
    
    $parser->update_count(
        {
            text => q{$myvar+$TESTS_PER_ITER}
        },
    );
    # TEST
    is ($parser->get_count(), 10, "Checking for correct calculation");
}
