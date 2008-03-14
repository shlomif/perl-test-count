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

sub _assert_prefix_regex
{
    my $self = shift;
    if (@_)
    {
        $self->{'_assert_prefix_regex'} = shift;
    }
    return $self->{'_assert_prefix_regex'};
}

sub _init
{
    my $self = shift;
    my $args = shift;

    my $in = $args->{'input_fh'};

    $self->_in_fh($in);
    if (exists($args->{'assert_prefix_regex'}))
    {
        my $re = $args->{'assert_prefix_regex'};
        $self->_assert_prefix_regex((ref($re) eq "") ? qr{$re} : $re);
    }
    else
    {
        $self->_assert_prefix_regex(qr{# TEST});
    }

    return 0;
}
=head1 NAME

Test::Count - Module for keeping track of the number of tests in a test script.

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

    $ cat "t/mytest.t" | perl -MTest::Count::Filter -e 'filter()'

=head1 DESCRIPTION

Test::Count is a set of perl modules for keeping track of the number of tests
in a test file. It works by putting in comments of the form C<# TEST> 
(one test), C<# TEST*$EXPR> or C<# TEST+$EXPR> (both are multiple tests).
Test::Count count these tests throughout the fileand return all of their
results.

One can put any mathematical expressions (using parentheses, C<+>, C<->,
C<*>, C</> and C<%> there). Also one can assign variables using 
C<# TEST:$myvar=5+6;$second_var=$myvar+3> and later use them in the add
to count expressions.

One can find example test scripts under t/.

A simple Vim (L<http://www.vim.org/>) function to update the count of the
tests in the file is:

    function! Perl_Tests_Count()
        %!perl -MTest::Count::Filter -e 'Test::Count::Filter->new({})->process()'
    endfunction

=head1 FUNCTIONS

=head2 my $counter = Test::Count->new({'input_fh' => \*MYFILEHANDLE});

Creates a new Test::Count object that process the filehandle specified in 
C<'input_fh'>. Optional keys are:

=over 4

=item * 'assert_prefix_regex' => qr{; TEST}

A regular expression for specifying the prefix for a "TEST" assertion that
updates the grammar. Defaults to C<"# TEST">.

=back

=head2 $counter->process();

Process the filehandle specified in 'input_fh' in ->new(), and return a
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

    my $assert_re = $self->_assert_prefix_regex();

    my @file_lines;
    while (my $line = readline($self->_in_fh()))
    {
        push @file_lines, $line;

        chomp($line);
        if ($line =~ /${assert_re}:(.*)$/)
        {
            $parser->update_assignments(
                {
                    'text' => $1,
                }
            );
        }
        # The \s* is to handle trailing whitespace properly.
        elsif ($line =~ /${assert_re}((?:[+*].*)?)\s*$/)
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

This program is released under the following license: MIT X11.

=cut

1; # End of Test::Count
