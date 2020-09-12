
#	SeriesGen.t 29/07/15, 15/06/16

use strict;
use warnings;
use Test::More tests => 11;
use Test::Deep;

use StakesGen;
use ComboGen;
use PermGen;
use AllGen;
use XPermGen;

my $coderef = sub {
	my $objref = shift;

	print "\n\t";
	for (my $i = 0; $i < $objref->selections (); $i ++) {
		printf ("%2d ", $objref->index ($i) + 1 );
	}
};

my $coderef_end = sub {
	my $objref = shift;

	print "\t".$objref->count." combinations\n";
};

subtest 'StakesGen' => sub {
	plan tests => 2;
	my $stakes_gen = StakesGen->new (3,6);
#	$stakes_gen->onIteration ($coderef);
	$stakes_gen->onIterationEnd ($coderef_end);

	isa_ok ($stakes_gen, 'StakesGen', '$stakes_gen');
	$stakes_gen->run ();
	is ($stakes_gen->count, 10, "Stakes_Gen (3,6) = 10 combinations")
};
print "\n\n";

subtest 'ComboGen' => sub {
	plan tests => 2;
	my $combo_gen = ComboGen->new (3,6);
#	$combo_gen->onIteration ($coderef);
	$combo_gen->onIterationEnd ($coderef_end);

	isa_ok ($combo_gen, 'ComboGen', '$combo_gen');
	$combo_gen->run ();
	is ($combo_gen->count, 20, "Combo_Gen (3,6) = 20 combinations")
};
print "\n\n";

subtest 'PermGen' => sub {
	plan tests => 2;
	my $perm_gen = PermGen->new (4);
#	$perm_gen->onIteration ($coderef);
	$perm_gen->onIterationEnd ($coderef_end);

	isa_ok ($perm_gen, 'PermGen', '$perm_gen');
	$perm_gen->run ();
	is ($perm_gen->count, 24, "Perm_Gen (4) = 24 combinations")
};
print "\n\n";

subtest 'AllGen' => sub {
	plan tests => 2;
	my $all_gen = AllGen->new (3,6);
#	$all_gen->onIteration ($coderef);
	$all_gen->onIterationEnd ($coderef_end);

	isa_ok ($all_gen, 'AllGen', '$all_gen');
	$all_gen->run ();
	is ($all_gen->count, 216, "All_Gen (4) = 216 combinations")
};
print "\n\n";

subtest 'XPermGen' => sub {
	plan tests => 2;
	my $xperm_gen = XPermGen->new (3,6);
#	$xperm_gen->onIteration ($coderef);
	$xperm_gen->onIterationEnd ($coderef_end);

	isa_ok ($xperm_gen, 'XPermGen', '$xperm_gen');
	$xperm_gen->run ();
	is ($xperm_gen->count, 120, "XPerm_Gen (4) = 120 combinations")
};
print "\n\n";

subtest 'ComboGen - get_combs' => sub {
	plan tests => 3;
	my $combo_gen = ComboGen->new (3,5);
	isa_ok ($combo_gen, 'ComboGen', '$combo_gen');

	my $array = [qw(Steve Hope Zap Zappa Zappy)];
	my $expect = [
		[ qw(Steve Hope Zap) ],
		[ qw(Steve Hope Zappa) ],
		[ qw(Steve Hope Zappy) ],
		[ qw(Steve Zap Zappa) ],
		[ qw(Steve Zap Zappy) ],
		[ qw(Steve Zappa Zappy) ],
		[ qw(Hope Zap Zappa) ],
		[ qw(Hope Zap Zappy) ],
		[ qw(Hope Zappa Zappy) ],
		[ qw(Zap Zappa Zappy) ],
	];
	my $combs = $combo_gen->get_combs ($array);
	is (@$combs, 10, "10 combinations");
	cmp_deeply ($expect, $combs, "10 combinations - 3 from 5");
};
print "\n\n";

subtest 'PermGen - get_perms' => sub {
	plan tests => 3;
	my $perm_gen = PermGen->new (3);
	isa_ok ($perm_gen, 'PermGen', '$perm_gen');

	my $array = [qw(Steve Hope Zap)];
	my $expect = [
		[ qw(Steve Hope Zap) ],
		[ qw(Steve Zap Hope) ],
		[ qw(Hope Steve Zap) ],
		[ qw(Hope Zap Steve) ],
		[ qw(Zap Steve Hope) ],
		[ qw(Zap Hope Steve) ],
	];
	my $perms = $perm_gen->get_perms ($array);
	is (@$perms, 6, "6 combinations");
	cmp_deeply ($expect, $perms, "6 permutations from 3");
};
print "\n\n";

subtest 'AllGen - get_all' => sub {
	plan tests => 3;
	my $all_gen = AllGen->new (3,3);
	isa_ok ($all_gen, 'AllGen', '$all_gen');

	my $array = [qw(10 20 30)];
	my $expect = [
		[ qw(10 10 10) ],
		[ qw(10 10 20) ],
		[ qw(10 10 30) ],
		[ qw(10 20 10) ],
		[ qw(10 20 20) ],
		[ qw(10 20 30) ],
		[ qw(10 30 10) ],
		[ qw(10 30 20) ],
		[ qw(10 30 30) ],

		[ qw(20 10 10) ],
		[ qw(20 10 20) ],
		[ qw(20 10 30) ],
		[ qw(20 20 10) ],
		[ qw(20 20 20) ],
		[ qw(20 20 30) ],
		[ qw(20 30 10) ],
		[ qw(20 30 20) ],
		[ qw(20 30 30) ],

		[ qw(30 10 10) ],
		[ qw(30 10 20) ],
		[ qw(30 10 30) ],
		[ qw(30 20 10) ],
		[ qw(30 20 20) ],
		[ qw(30 20 30) ],
		[ qw(30 30 10) ],
		[ qw(30 30 20) ],
		[ qw(30 30 30) ],
		];
	my $all = $all_gen->get_all ($array);
	is (@$all, 27, "6 combinations");
	cmp_deeply ($expect, $all, "27 permutations from 3");
};
print "\n\n";

subtest 'XPermGen - get_xperms' => sub {
	plan tests => 3;
	my $xperm_gen = XPermGen->new (3,4);
	isa_ok ($xperm_gen, 'XPermGen', '$xperm_gen');

	my $array = [qw(10 20 30 40)];
	my $expect = [
		[ qw(10 20 30) ],
		[ qw(10 20 40) ],
		[ qw(10 30 20) ],
		[ qw(10 30 40) ],
		[ qw(10 40 20) ],
		[ qw(10 40 30) ],

		[ qw(20 10 30) ],
		[ qw(20 10 40) ],
		[ qw(20 30 10) ],
		[ qw(20 30 40) ],
		[ qw(20 40 10) ],
		[ qw(20 40 30) ],

		[ qw(30 10 20) ],
		[ qw(30 10 40) ],
		[ qw(30 20 10) ],
		[ qw(30 20 40) ],
		[ qw(30 40 10) ],
		[ qw(30 40 20) ],

		[ qw(40 10 20) ],
		[ qw(40 10 30) ],
		[ qw(40 20 10) ],
		[ qw(40 20 30) ],
		[ qw(40 30 10) ],
		[ qw(40 30 20) ],
	];
	my $xperms = $xperm_gen->get_xperms ($array);
	is (@$xperms, 24, "24 combinations");
	cmp_deeply ($expect, $xperms, "24x3 permutations from 4");
};
print "\n\n";

subtest 'StakesGen - get_stakes' => sub {
	plan tests => 3;
	my $stakes_gen = StakesGen->new (3,5);
	isa_ok ($stakes_gen, 'StakesGen', '$stakes_gen');

	my $expect = [
		[ qw(10 10 30) ],
		[ qw(10 20 20) ],
		[ qw(10 30 10) ],
		[ qw(20 10 20) ],
		[ qw(20 20 10) ],
		[ qw(30 10 10) ],
	];
	my $stakes = $stakes_gen->get_stakes (10,50,10);
	is (@$stakes, 6, "6 combinations");
	cmp_deeply ($expect, $stakes, "6 combinations - 3 from 5");
};
print "\n\n";

subtest 'ComboGen - get_combs default' => sub {
	plan tests => 2;
	my $combo_gen = ComboGen->new (3,5);
	$combo_gen->onIteration ($coderef);
	isa_ok ($combo_gen, 'ComboGen', '$combo_gen');

	my $array = [ qw( 1 2 3 4 5) ];
	my $expect = [
		[ qw (1 2 3) ], [ qw (1 2 4) ], [ qw (1 2 5) ],
		[ qw (1 3 4) ], [ qw (1 3 5) ], [ qw (1 4 5) ],
		[ qw (2 3 4) ], [ qw (2 3 5) ], [ qw (2 4 5) ], [ qw (3 4 5) ],
	];
	my $combs = $combo_gen->get_combs ($array);
	is ($combo_gen->count, 10, "Combo_Gen (3,5) = 10 combinations")
#	is (@$combs, 10, "10 combinations - default");
#	cmp_deeply ($expect, $combs, "10 combinations - 3 from 5");
};

#use Data::Dumper;
#subtest 'SeriesGen - get_array' => sub {
#		plan tests => 1;
#		is (1,1,'ok');
#		my $gen = ComboGen->new (3,5);
#		$gen->run();
#		print Dumper $gen->get_array ();
#};
