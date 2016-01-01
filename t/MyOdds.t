
#	MyOdds.t 28/07/15

use strict;
use warnings;
use Test::More;

use MyOdds;

my @odds_array = ( '7-2','4','11-8',);

my @expect = (
	[ 7,2,3.5,'7-2' ],
	[ 4,1,4,'4-1' ],
	[ 11,8,1.375,'11-8' ],
);

for my $i (0...$#odds_array) {
	my $odds = MyOdds->new ($odds_array[$i]);
	ok (defined $odds, 'created ...');
	ok ($odds->isa ('MyOdds'), 'a new MyOdds class');

	print "Odds value = ".$odds_array[$i]."\n";
	is ($odds->first (), $expect[$i][0], "first = ".$odds->first ());
	is ($odds->second (), $expect[$i][1], "second = ".$odds->second ());
	is ($odds->ratio (), $expect[$i][2], "ratio = ".$odds->ratio ());
	is ($odds->show (), $expect[$i][3], "show = ".$odds->show ());

	print "\n";
}

done_testing ();