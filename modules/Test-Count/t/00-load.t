#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'Test::Count' );
	use_ok( 'Test::Count::Parser' );
}

diag( "Testing Test::Count $Test::Count::VERSION, Perl $], $^X" );
