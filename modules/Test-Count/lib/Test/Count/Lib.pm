package Test::Count::Lib;

use strict;
use warnings;

sub perl_plan_prefix_regex
{
    return qr{(?:(?:use Test.*\btests)|(?:\s*plan tests))\s*=>\s*};
}

1;

=encoding utf8

=head1 NAME

Test::Count::Lib - various commonly used routines.

=head1 FUNCTIONS

=head2 perl_plan_prefix_regex()

The regex for the perl plan. (B<Internal use.>)

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=head1 SEE ALSO

L<Test::Count>, L<Test::Count::Parser>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2011 Shlomi Fish.

This program is released under the following license: MIT X11.

=cut

1;    # End of Test::Count::Lib
