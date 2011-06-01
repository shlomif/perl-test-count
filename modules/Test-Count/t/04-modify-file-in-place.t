#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use File::Spec;
use File::Copy;
use File::Temp qw(tempdir);

use Test::Count::FileMutator;
use IO::Scalar;

{
    # We need to copy everything into a temporary directory because MS
    # Windows tester do not like us writing to tests in the working copy:
    #
    # http://www.cpantesters.org/cpan/report/4936c342-71bd-1014-a781-9481788a0512

    my $temp_dir = tempdir( CLEANUP => 1);
    my $temp_lib_dir = File::Spec->catdir($temp_dir, "lib");

    my $orig_dir = File::Spec->catdir(
        File::Spec->curdir(), qw(t sample-data test-scripts)
    );

    mkdir ($temp_lib_dir);

    copy (
        File::Spec->catfile($orig_dir, "lib", "MyMoreTests.pm"),
        File::Spec->catfile($temp_lib_dir, "MyMoreTests.pm")
    );

    my $orig_fn = File::Spec->catfile($orig_dir, "with-include.t");
    my $fn = File::Spec->catfile($temp_dir, "with-include-temp.t");

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

