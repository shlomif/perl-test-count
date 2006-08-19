package Test::Count;

use warnings;
use strict;

use base 'Test::Count::Base';

use Test::Count::Parser;

sub _in_fh
{
    my $self = shift;
    if (@_)
    {
        $self->{'_in_fh'} = shift;
    }
    return $self->{'_in_fh'};
}

sub _init
{
    my $self = shift;
    my $args = shift;

    my $in = $args->{'input_fh'};

    $self->_in_fh($in);

    return 0;
}
=head1 NAME

Test::Count - Module for keeping track of the number of tests in a Test Script.

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    $ cat "t/mytest.t" | perl -MTest::Count::Filter -e 'filter()'


=head1 FUNCTIONS

=head2 $counter->process({ 'input_fh' => \*MYFILEHANDLE});

Process the filehandle specified in 'input_fh', and return a
hash ref with the following keys:

=over 4

=item * tests_count

The count of the test.

=item * lines

The lines of the stream as is.

=back

=cut

sub process
{
    my $self = shift;

    my $parser = Test::Count::Parser->new();

    my @file_lines;
    while (my $line = readline($self->_in_fh()))
    {
        push @file_lines, $line;

        chomp($line);
        if ($line =~ /# TEST:(.*)$/)
        {
            $parser->update_assignments(
                {
                    'text' => $1,
                }
            );
        }
        elsif ($line =~ /# TEST((?:[+*].*)?)$/)
        {
            my $s = $1;
            $parser->update_count(
                {
                    'text' => (($s eq "") ? 1 : substr($s,1)),
                }
            );
        }
    }

    return { 'tests_count' => $parser->get_count(), 'lines' => \@file_lines,};
}


=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-test-count at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test::Count>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Count

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test::Count>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test::Count>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test::Count>

=item * Search CPAN

L<http://search.cpan.org/dist/Test::Count>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Shlomi Fish, all rights reserved.

This program is released under the following license: bsd

=cut

1; # End of Test::Count
