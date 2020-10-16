package Test::Count::FileMutator::ByFileType::App;

use strict;
use warnings;

use Test::Count::FileMutator::ByFileType::Lib ();
use Getopt::Long qw/ GetOptions /;

use parent 'Exporter';

our @EXPORT = (qw(run));

=encoding utf8

=head1 NAME

Test::Count::FileMutator::ByFileType::App - a standalone command line
application that modifies a file in place based on its type.

=head1 SYNOPSIS

    # To process C code
    $ perl -MTest::Count::FileMutator::ByFileType::App -e 'run()' --ft=c myfile.c

    # To process Perl 5 code
    $ perl -MTest::Count::Filter::ByFileType::App -e 'run()' myfile.pl

=head1 FUNCTIONS

=head2 run()

Runs the program.

=cut

sub run
{
    my $filetype;
    GetOptions( 'ft=s' => \$filetype );

    my $filename = shift(@ARGV);

    my $mutator = Test::Count::FileMutator::ByFileType::Lib->new(
        {
            filename => $filename,
            ( defined($filetype) ? ( filetype => $filetype, ) : () ),
        }
    );

    $mutator->run;

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

This module is free software, available under the MIT X11 Licence:

L<http://www.opensource.org/licenses/mit-license.php>

Copyright by Shlomi Fish, 2009.

=cut

