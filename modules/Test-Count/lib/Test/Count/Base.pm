package Test::Count::Base;

=encoding utf8

=head1 NAME

Test::Count::Base - Base Class for Test::Count.

=cut

use strict;
use warnings;

=head1 FUNCTIONS

=head2 Test::Count::Base->new({ 'param1' => $value1, 'param2' => $value2});

Initialises Test::Count::Base using the _init() abstract method.

=cut

sub new
{
    my $class = shift;
    my $self  = {};

    bless $self, $class;
    $self->_init(@_);

    return $self;
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

