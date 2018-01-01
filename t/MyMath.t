
#	MyMath.t 28/09/17, 17/11/17

use strict;
use warnings;

use Test::More tests => 2;
use Test::Deep;

use MyMath qw(:All);

subtest 'simple_tests' => sub {
	plan tests => 4;
	
	is (power (2,5), 32, "power 2x5 = 32");
	is (factorial (6), 720, "factorial 6 = 720");
	is (perms (3,5), 10, "perms 3 from 5 = 10");
	is (new_perms (3,5), 10, "new_perms 4 from 6 = 15");
};

subtest 'build_range' => sub {
	plan tests => 2;
	
	my $range = build_range (20,100,20);
	my $expect = [ qw(20 40 60 80 100) ];
	cmp_deeply ($range, $expect, "positive build_range ok");

	$range = build_range (100,25,-15);
	$expect = [ qw(100 85 70 55 40 25) ];
	cmp_deeply ($range, $expect, "negative build_range ok");
};
