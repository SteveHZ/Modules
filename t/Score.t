
#	Score.t 28/07/15

use strict;
use warnings;
use Test::More;

use Score;

my (@homes) = ( 1,0,1,0 );
my (@aways) = ( 0,1,1,0 );
my (@expect) = ( qw/ W L D N/ );

my (@result) = ( qw/ won lost drew got_bored/ );
my (@not_result) = ( qw/ win lose draw get_bored/ );	

print "\n";

for my $i(0...$#homes) {
	my $score = Score->new ($homes[$i], $aways[$i]);

	ok (defined $score, 'created ...');
	ok ($score->isa ('Score'), 'a new Score class');
	
	for my $j (0...$#result) {
		print "testing $homes[$i]-$aways[$i]";
		($score->result () eq $expect[$j] ) ?
			print " we $result[$j] !\n":
			print " we didn't $not_result[$j] !\n";
	}
	print "\n";
}

#sub check_all {
#	my ($condition1, $condition2) = @_;
#	return ($condition1 eq $condition2) ? 1 : 0;
#}

done_testing ();