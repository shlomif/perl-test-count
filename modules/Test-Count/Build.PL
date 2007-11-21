use strict;
use warnings;

use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "inc");

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    module_name         => 'Test::Count',
    license             => 'bsd',
    dist_abstract        => "A Module to keep track of the number of tests in a script.",
    dist_author         => 'Shlomi Fish <shlomif@cpan.org>',
    dist_version_from   => 'lib/Test/Count.pm',
    requires => {
        'Parse::RecDescent' => 0,
        'base' => 0,
        'perl' => 5.006,
    },
    build_requires => {
        'Test::More' => 0,
        'IO::Scalar' => 0,
    },
    add_to_cleanup      => [ 'Test::Count-*' ],
    create_makefile_pl => "passthrough",
);

$builder->create_build_script();

