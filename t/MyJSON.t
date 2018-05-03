#!	C:/Strawberry/perl/bin

#	MyJSON.t 06/01/16

use strict;
use warnings;
use Test::More tests => 1;
use MyJSON qw(:all);

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

subtest 'json_test_1' => sub {
	my $tests = scalar @$array2;
	plan tests => $tests;
	for my $i (0...$tests - 1) {
		ok ( @$array1 [$i] eq @$array2 [$i], "checked element $i is ".@$array2 [$i] );
	}
};
