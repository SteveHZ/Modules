#!	C:/Strawberry/perl/bin

#	MyBessel.t 08-14/08/17, 29/09/17, 06/10/17

use strict;
use warnings;
use lib '../../Football';

use Test::More tests => 2;
use Math::Round qw(nearest);

use MyMath qw(power);
use MyBessel qw(calc_besseliv);

my $team1 = 1.05;
my $team2 = 2.50;

my $expect = {
	-6 => 0.0141, -5 => 0.0357, -4 => 0.0774, -3 => 0.1388,
	-2 => 0.1991, -1 => 0.2176,  0 => 0.1706,  1 => 0.0914,
	 2 => 0.0351,  3 => 0.0103,  4 => 0.0024,  5 => 0.0005, 
	 6 => 0.0001,
};

my $constant = exp (-1 * ($team1 + $team2));
my $root_ratio = sqrt ($team1 / $team2);
my $harmonic_mean = sqrt ($team1 * $team2);

subtest 'Intermediate variables' => sub {
	plan tests => 3;
	is ( $constant, 0.0287246396542394, "constant = $constant");
	is ( $root_ratio, 0.648074069840786, "root_ratio = $root_ratio");
	is ( $harmonic_mean, 1.62018517460197, "harmonic_mean = $harmonic_mean");
};

subtest 'MyBessel Test' => sub {
	plan tests => 13;
	for my $aa (-6..6) {
		my $bb = nearest (0.00001, $constant * power ($root_ratio, $aa));
		my $val3 = nearest (0.0001, calc_besseliv ($aa, $bb, $harmonic_mean));
		is ( $val3, $expect->{$aa}, "bessel $aa = $val3");
	}
};
