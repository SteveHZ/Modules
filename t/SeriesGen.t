
#	SeriesGen.t 29/07/15

use strict;
use warnings;
use Test::More;

use StakesGen;
use ComboGen;
use PermGen;

my $coderef = sub {
	my $objref = shift;

	print "\n";
	for (my $i = 0; $i < $objref->selections; $i ++) {
		printf ("%2d ", $objref->index ($i) + 1 );
	}
};

my $coderef_end = sub {
	my $objref = shift;

	print "\n".$objref->count ()." combinations\n";
};

my $stakes_gen = StakesGen->new (3,6);
$stakes_gen->onIteration ($coderef);
$stakes_gen->onIterationEnd ($coderef_end);

ok (defined $stakes_gen, 'created ...');
ok ($stakes_gen->isa ('StakesGen'), 'a new StakesGen class');
ok ($stakes_gen->run (), 'finished');

print "\n\n";

my $combo_gen = ComboGen->new (3,6);
$combo_gen->onIteration ($coderef);
$combo_gen->onIterationEnd ($coderef_end);

ok (defined $combo_gen, 'created ...');
ok ($combo_gen->isa ('ComboGen'), 'a new ComboGen class');
ok ($combo_gen->run (), 'finished');

print "\n\n";

my $perm_gen = PermGen->new (4);
$perm_gen->onIteration ($coderef);
$perm_gen->onIterationEnd ($coderef_end);

ok (defined $perm_gen, 'created ...');
ok ($perm_gen->isa ('PermGen'), 'a new PermGen class');
ok ($perm_gen->run (), 'finished');

done_testing ();
