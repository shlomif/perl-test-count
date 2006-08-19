package Test::Count::Base;

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
    my $self = {};

    bless $self, $class;
    $self->_init(@_);
    
    return $self;
}

1;
