package Test::Count::Parser;

use warnings;
use strict;

use base 'Test::Count::Base';

use Parse::RecDescent;

=head1 NAME

Test::Count::Parser - A Parser for Test::Count. 

=cut

our $VERSION = '0.01';

sub _get_grammar
{
    return <<'EOF';
update_count: expression            {$thisparser->{count} += $item[1]}

assignments:    assignment ';' assignments
              | assignment

statement:    assignment
              | expression               {$item [1]}

assignment:    variable '=' statement   {$thisparser->{vars}->{$item [1]} = $item [3]}

expression:     term '+' expression      {$item [1] + $item [3]}
              | term '-' expression      {$item [1] - $item [3]}
              | term

term:           factor '*' term          {$item [1] * $item [3]}
              | factor '/' term          {$item [1] / $item [3]}
              | factor

factor:         number
              | variable                 {$thisparser->{vars}->{$item [1]} || do { die "Undefined variable \"$item[1]\""; } }
              | '+' factor               {$item [2]}
              | '-' factor               {$item [2] * -1}
              | '(' statement ')'        {$item [2]}

number:         /\d+/                    {$item [1]}

variable:       /\$[a-z_]\w*/i
EOF
}

sub _calc_parser
{
    my $self = shift;

    my $parser = Parse::RecDescent->new($self->_get_grammar());

    $parser->{vars} = {};
    $parser->{count} = 0;

    return $parser;
}

sub _parser
{
    my $self = shift;
    if (@_)
    {
        $self->{'_parser'} = shift;
    }
    return $self->{'_parser'};
}

sub _init
{
    my $self = shift;

    $self->_parser($self->_calc_parser());

    return 0;
}

=head1 SYNOPSIS

    use Test::Count::Parser;

    my $parser = Test::Count::Parser->new();

    $parser->update_assignments($string);

    $parser->update_count($string);

    my $value = $parser->get_count();

=head1 FUNCTIONS

=head2 $parser->update_assignments({'text' => $mytext,)

Updates the parser's state based on the assignments in C<$mytext>. For
example if C<$mytext> is:

     $myvar=500;$another_var=8+$myvar

Then at the end C<$myvar> would be 500 and C<$another_var> would be 508.

=cut

sub update_assignments
{
    my ($self, $args) = @_;

    return $self->_parser()->assignments($args->{text});
}

=head2 $parser->update_count({'text' => $mytext,)

Adds the expression inside C<$mytext> to the internal counter of the
module. This is in order to count the tests.

=cut

sub update_count
{
    my ($self, $args) = @_;

    return $self->_parser()->update_count($args->{text});    
}

=head2 my $count = $parser->get_count()

Get the total number of tests in the parser.

=cut

sub get_count
{
    my $self = shift;

    return $self->_parser()->{count};
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-test-count-parser at rt.cpan.org>, or through the web interface at
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

1; # End of Test::Count::Parser
