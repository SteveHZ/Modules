use strict;
use warnings;

use Test::More tests => 6;
use Test::Deep;
use MyLib qw(multi_array is_empty_array is_empty_hash qk build_aoh partition);

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
	$names{'Steve'} = 'Zappa';
	is (is_empty_hash (\%names), 0, 'items in hash ok');
};

subtest 'qk' => sub {
	plan tests => 1;
	my $keys = [ qw(Steve Zappa Linda Pilgrim) ];
	my $expect = { Steve => 2, Zappa => 2, Linda => 2, Pilgrim => 2 };
	my $hash = qk ($keys, 2);
	cmp_deeply ($hash, $expect, 'compare hash ok');
};

subtest 'build_aoh' => sub {
	plan tests => 1;
	my @first = qw(1 2 3 4 5);
	my @second = qw(6 7 8 9 10);
	my $expect = [ { '1' => '6' }, { '2' => '7' }, { '3' => '8' }, { '4' => '9' }, { '5' => '10' } ];
	my $aoh = build_aoh (\@first, \@second);
	cmp_deeply ($aoh, $expect, 'build_aoh ok');
};

subtest 'partition' => sub {
	plan tests => 2;
	my @list = (1..10);
	my ($true, $false) = partition { $_ % 2 } \@list;

	my $expect_true = [ qw(1 3 5 7 9) ];
	my $expect_false =  [ qw(2 4 6 8 10) ];
	cmp_deeply ($true, $expect_true, 'true array ok');
	cmp_deeply ($false, $expect_false, 'false array ok');
};
