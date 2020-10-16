package Test::Count::Filter::ByFileType::App;

use strict;
use warnings;

use Test::Count::Filter ();
use Getopt::Long qw/ GetOptions /;

use parent 'Exporter';

our @EXPORT = (qw(run));

=encoding utf8

=head1 NAME

Test::Count::Filter::ByFileType::App - a standalone command line application
that filters according to the filetype.

=head1 SYNOPSIS

    # To filter C code
    $ perl -MTest::Count::Filter::ByFileType::App -e 'run()' --ft=c

    # To filter Perl 5 code
    $ perl -MTest::Count::Filter::ByFileType::App -e 'run()'

=head1 FUNCTIONS

=head2 run()

Runs the program.

=cut

sub run
{
    my $filetype = "perl";
    GetOptions( 'ft=s' => \$filetype );

    my %params = (
        'lisp' => {
            assert_prefix_regex => qr{; TEST},
            plan_prefix_regex   => qr{\(plan\s+},
        },
        'c' => {
            assert_prefix_regex => qr{/[/\*]\s+TEST},
            plan_prefix_regex   => qr{\s*plan_tests\s*\(\s*},
        },
        'python' => {
            plan_prefix_regex => qr{plan\s*\(\s*},
        },
    );

    my %aliases = (
        'arc'    => "lisp",
        'scheme' => "lisp",
        'cpp'    => "c",
    );

    $filetype = exists( $aliases{$filetype} ) ? $aliases{$filetype} : $filetype;
    my $ft_params = exists( $params{$filetype} ) ? $params{$filetype} : +{};

    my $filter = Test::Count::Filter->new( { %{$ft_params}, } );

    $filter->process();

    return 0;
}

1;

__END__

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .


=head1 SEE ALSO

L<Test::Count>, L<Test::Count::Parser>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Shlomi Fish.

This program is released under the following license: MIT X11.

=cut

