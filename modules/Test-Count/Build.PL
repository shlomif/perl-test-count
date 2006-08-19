use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::Count',
    license             => 'bsd',
    dist_abstract        => "A Module to keep track of the number of tests in a script.",
    dist_author         => 'Shlomi Fish <shlomif@cpan.org>',
    dist_version_from   => 'lib/Test/Count.pm',
    build_requires => {
        'Test::More' => 0,
        'Parse::RecDescent' => 0,
    },
    add_to_cleanup      => [ 'Test::Count-*' ],
);

$builder->create_build_script();
