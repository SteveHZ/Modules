
#	MyTransform.t 07/12/15

use v5.10;
use strict;
use warnings;

use Test::More tests => 2;
use MyTransform qw (:all);

my @unsorted =	(
	"Alex Lifeson",
	"Jon Anderson",
	"Geddy Lee",
	"Pete Trewavas",
	"Mikael Akerfeldt",
	"Mark Shreeve",
);

my %expect = ( # indexes to @unsorted
	'by_length' => [2,0,1,5,3,4],
	'by_surname' => [4,1,2,0,5,3],
);

my @by_length = schwartzian_sort { length $_ } @unsorted;
my @by_surname = schwartzian_sort_cmp {
 		m/(.*?)\s*(\S+)$/; "$2 $1"
} @unsorted;

subtest 'by_length' => sub {
	plan tests => scalar @unsorted;
	print "\n";
	for my $i (0...$#unsorted) {
		is ( $by_length [$i], $unsorted [$expect{by_length} [$i]], "Tested by_length element $i [ ".$by_length [$i]." ]" );
	}
};

subtest 'by_surname' => sub {
	plan tests => scalar @unsorted;
	print "\n";
	for my $i (0...$#unsorted) {
		is ( $by_surname [$i], $unsorted [$expect{by_surname} [$i]], "Tested by_surname element $i [ ".$by_surname [$i]." ]" );
	}
};
