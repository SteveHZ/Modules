
#	Score.t 28/07/15

use strict;
use warnings;
use Test::More tests => 1;

use Score;

my (@homes) = ( 1,0,1,0 );
my (@aways) = ( 0,1,1,0 );
my (@expect) = qw (W L D N);

my (@result) = qw (won lost drew got_bored);
my (@not_result) = qw (win lose draw get_bored);	

print "\n";

subtest 'score_test' => sub {
	plan tests => scalar @homes;
	for my $i(0...$#homes) {
		my $score = Score->new ($homes[$i], $aways[$i]);

		isa_ok ($score, 'Score', '$score');
	
		for my $j (0...$#result) {
			print "testing $homes[$i]-$aways[$i]";
			($score->result () eq $expect[$j] ) ?
				print " we $result[$j] !\n":
				print " we didn't $not_result[$j] !\n";
		}
		print "\n";
	}
};
