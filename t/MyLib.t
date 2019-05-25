use strict;
use warnings;

use Test::More tests => 4;
use Test::Deep;
use MyLib qw(multi_array is_empty_array is_empty_hash qk);

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
			[ $id1, $id2, $id3 ],
			[ map { $_->[0], $_->[1], $_->[2] } $expect[$idx++] ],
			"loop number $idx"
		);
	}
};

subtest 'is_empty_array' => sub {
	plan tests => 2;
	my @names = ();
	is (is_empty_array (\@names), 1, 'empty array ok');
	push @names, ('Steve', 'Linda', 'Zappa');
	is (is_empty_array (\@names), 0, 'items in array ok');
};

subtest 'is_empty_hash' => sub {
	plan tests => 2;
	my %names = ();
	is (is_empty_hash (\%names), 1, 'empty hash ok');
	$names{'Steve'} = 'Zappy';
	is (is_empty_hash (\%names), 0, 'items in hash ok');
};

subtest 'qk' => sub {
	plan tests => 1;
	my $keys = [ qw(Steve Zappa Linda Pilgrim) ];
	my $expect = { Steve => 2, Zappa => 2, Linda => 2, Pilgrim => 2 };
	my $hash = qk ($keys, 2);
	cmp_deeply ($hash, $expect, 'compare hash ok');
}
