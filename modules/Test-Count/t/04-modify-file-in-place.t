#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use File::Spec;
use File::Copy;

use Test::Count::FileMutator;
use IO::Scalar;

sub calc_fn
{
    my $basename = shift;

    return File::Spec->catfile(File::Spec->curdir(),
        qw(t sample-data test-scripts),
        $basename,
    );
}

{

    my $orig_fn = calc_fn("with-include.t");
    my $fn = calc_fn("with-include-temp.t");

    copy($orig_fn, $fn)
        or die "Copy failed: $!";

    my $mutator = Test::Count::FileMutator->new(
        {
            filename => $fn,
        }
    );

    $mutator->modify();

    open my $in, "<", $fn
        or die "Could not open '$fn' - $!.";

    my $found = 0;
    LINES_LOOP:
    while (my $l = <$in>)
    {
        chomp($l);
        if ($l eq "use Test::More tests => 3;")
        {
            $found = 1;
            last LINES_LOOP;
        }
    }

    close($in);

    # TEST
    ok ($found, "The appropriate line was found - 3 tests.");

    unlink($fn);
}

