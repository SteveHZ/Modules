#!	C:/Strawberry/perl/bin

#	MyCombs.t 04/10/16

use strict;
use warnings;
use Test::More tests => 5;

use MyCombs;
my $c = MyCombs->new ();

subtest 'simple' => sub {
	plan tests => 3;
	ok ( $c->singles ( [ 1.54 ]) == 1.54, "singles" );
	ok ( $c->doubles ( [ 1.54, 2.06 ], 2) == 6.34, "doubles" );
	ok ( $c->trebles ( [ 1.54, 2.06, 1.8 ], 2) == 11.42, "trebles" );
};

subtest 'trixie' => sub {
	plan tests => 1;
	my $wins = $c->trixie  ( [1.55,1.25,1.85] );
	is ($wins, 2.68, "check results");
};

subtest 'patent' => sub {
	plan tests => 1;
	my $wins = $c->patent  ( [1.55,1.25,1.85], 1.12 );
	is ($wins, 2.46, "check results");
};

subtest 'yankee' => sub {
	plan tests => 1;
	my $wins = $c->yankee  ( [1.55,1.25,1.85, 2.4], 1.10 );
	is ($wins, 4.75, "check results");
};

subtest 'lucky_15' => sub {
	plan tests => 1;
	my $wins = $c->lucky_15  ( [1.55,1.25,1.85, 2.4], 1.50 );
	is ($wins, 5.46, "check results");
};
