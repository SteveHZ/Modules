#!	C:/Strawberry/perl/bin

#	MyJSON.t 06/01/16

use strict;
use warnings;
use Test::More;
use MyJSON qw (:All);

my $test_file = "json/test.json";

my $array1 = [
	"Alex Lifeson",
	"Jon Anderson",
	"Geddy Lee",
	"Pete Trewavas",
	"Mikael Akerfeldt",
	"Mark Shreeve",
];

write_json ($test_file, $array1);

my $array2 = read_json ($test_file);

print "\n";

for my $i (0...(scalar (@$array2) - 1)) {
	ok ( @$array1 [$i] eq @$array2 [$i], "checked element $i is ".@$array2 [$i] );
}
print "\n";

done_testing ();
