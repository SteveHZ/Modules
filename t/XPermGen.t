
#	XPermGen.t 13-14/11/17

use strict;
use warnings;
use Test::More tests => 2;
use Test::Deep;
use Data::Dumper;

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

subtest 'XPermGen' => sub {
	plan tests => 2;
	
	my $xperm_gen = XPermGen->new (3,4);
	$xperm_gen->onIteration ($coderef);
	$xperm_gen->onIterationEnd ($coderef_end);

	isa_ok ($xperm_gen, 'XPermGen', 'a new XPermGen class');
	$xperm_gen->run ();
	is ($xperm_gen->count, 24, "XPerm_Gen (4) = 24 combinations")
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

	print "\n\nxperms = ".Dumper ($xperms);	
};
print "\n\n";
