use strict;
use warnings;

use Test::More tests => 1;
use Test::Deep;
use MyLib qw(multi_array);

my @first = (1,2,3,4);
my @second = qw(Steve Linda Izzy Julie);
my @third = qw(Geddy Alex Neil Fish);

my @expect = (
	[ qw (1 Steve Geddy)],
	[ qw (2 Linda Alex) ],
	[ qw (3 Izzy Neil)  ],
	[ qw (4 Julie Fish) ],
);

subtest 'multi_array' => sub {
	plan tests => 4;
	my $iterator = multi_array (\@first, \@second, \@third);
	my $idx = 0;
	while (my ($id1, $id2, $id3) = $iterator->()) {
		cmp_deeply (
			[ $id1, $id2,$id3 ],
			[ map { $_->[0], $_->[1], $_->[2] } $expect[$idx++] ],
#			 map { $_->[0], $_->[1], $_->[2] } $expect[$idx],
#			[ $expect[$idx]->[0], $expect[$idx]->[1], $expect[$idx++]->[2] ],
			"loop number $idx"
		);
	}
};
