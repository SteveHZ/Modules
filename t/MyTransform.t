
#	MyTransform.t 07/12/15

use strict;
use warnings;
use Test::More;
use v5.10;
use MyTransform qw (:All);

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

=head2
say "\nUnsorted array :";
say $_ for @unsorted;
say "\nSorted by length :";
say $_ for @by_length;
say "\nSorted by surname :";
say $_ for @by_surname;
=cut

print "\n";
for my $i (0...$#unsorted) {
	is ( $by_length [$i], $unsorted [$expect{by_length} [$i]], "Tested by_length element $i [ ".$by_length [$i]." ]" );
}
print "\n";
for my $i (0...$#unsorted) {
	is ( $by_surname [$i], $unsorted [$expect{by_surname} [$i]], "Tested by_surname element $i [ ".$by_surname [$i]." ]" );
}
print "\n";

done_testing ();
