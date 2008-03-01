#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use File::Spec;
use IO::Scalar;

use Test::Count;

{
    open my $in, "<", File::Spec->catfile("t", "sample-data", "test-scripts", "01-parser.t");
    
    my $counter = Test::Count->new(
        {
            'input_fh' => $in,
        }
    );

    my $ret = $counter->process();

    # TEST
    is ($ret->{'tests_count'}, 5, "Testing for 01-parser.t");

    close($in);
}

{
    open my $in, "<", 
        File::Spec->catfile(
            "t", "sample-data", "test-scripts","arithmetics.t"
        );
    
    my $counter = Test::Count->new(
        {
            'input_fh' => $in,
        }
    );

    my $ret = $counter->process();

    # TEST
    is ($ret->{'tests_count'}, 18, "Testing for arithmetics.t");

    close($in);
}

{
    my $buffer = "# T" . "EST        \n".
    "ok (1, 'Everything is OK');\n";
    my $in = IO::Scalar->new(\$buffer);
    
    my $counter = Test::Count->new(
        {
            'input_fh' => $in,
        }
    );

    my $ret = $counter->process();

    # TEST
    is ($ret->{'tests_count'}, 1, "Correctly handling trailing whitespace");

    close($in);
}
