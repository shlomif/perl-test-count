package Test::Count::FileMutator::ByFileType::Lib;

use strict;
use warnings;

use parent 'Test::Count::Base';
use Test::Count::FileMutator ();

=encoding utf8

=head1 NAME

Test::Count::FileMutator::ByFileType::Lib - API to mutate files in place.

=head1 SYNOPSIS

    my $obj = Test::Count::FileMutator::ByFileType::Lib->new(
        {
            filename => "./t/test.t",
            filetype => "perl",
        }
    );

    $obj->run;

=head1 FUNCTIONS

=head2 run()

Runs the mutation process;

=cut

sub _ft_params
{
    my $self = shift;

    if (@_)
    {
        $self->{_ft_params} = shift;
    }

    return $self->{_ft_params};
}

sub _filename
{
    my $self = shift;

    if (@_)
    {
        $self->{_filename} = shift;
    }

    return $self->{_filename};
}

sub _init
{
    my ( $self, $args ) = @_;

    my $filetype = $args->{filetype};
    my $filename = $args->{filename};

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
        'cc'     => "c",
        'cpp'    => "c",
        'cxx'    => "c",
        'p6'     => "perl",
        'pl'     => "perl",
        'py'     => "python",
        'scheme' => "lisp",
        't'      => "perl",
    );

    if ( !defined($filetype) )
    {
        ($filetype) = $filename =~ m#\.([^\./\\]+)\z#
            or die "Cannot determine extension from filename '$filename'!";
    }
    $filetype = exists( $aliases{$filetype} ) ? $aliases{$filetype} : $filetype;
    my $ft_params = exists( $params{$filetype} ) ? $params{$filetype} : +{};
    $self->{_filename}  = $filename;
    $self->{_ft_params} = $ft_params;

    return;
}

sub run
{
    my ($self) = @_;
    my $mutator = Test::Count::FileMutator->new(
        {
            filename => $self->_filename,
            %{ $self->_ft_params },
        }
    );

    $mutator->modify();

    return;
}

1;

__END__

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .


=head1 SEE ALSO

L<Test::Count>, L<Test::Count::Parser>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

This module is free software, available under the MIT X11 Licence:

L<http://www.opensource.org/licenses/mit-license.php>

Copyright by Shlomi Fish, 2009.

=cut

