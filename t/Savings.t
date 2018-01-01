
#	Savings.t 19-20/01/16

use strict;
use warnings;

use Test::More tests => 2;
use Savings qw (:All);
use utf8;

my $amount = 100.00;
my $pound = chr(156);

subtest 'Simple Tests' => sub {
	plan tests => 9;
	is (fmt (net (amount => $amount)), "$pound 80.00", "Net of $pound 100.00 = $pound 80.00");
	is (fmt (net (amount => $amount), "$pound %.5f"), "$pound 80.00000", "fmt format test - Net of $pound 100.00 = $pound 80.00000");

	is (fmt (tax (amount => $amount)), "$pound 20.00", "Tax on $pound 100.00 = $pound 20.00");
	is (fmt (gross_from_net (amount => $amount)), "$pound 125.00", "Gross of $pound 100.00 = $pound 125.00");

	is (fmt (interest (amount => $amount, rate => 5.0)), "$pound 5.00", "5.00% interest on $pound 100.00 = $pound 5.00 per year");
	is (fmt (monthly_interest (amount => $amount, rate => 5.0)), "$pound 0.41", "5.00% interest on $pound 100.00 = $pound 0.41 per month");

	is (fmt (reg_saver_interest (250,6)), "$pound 97.92", "Interest on M&S regular saver = $pound 97.92");
	is (effective_gross_interest_rate (97.92, 3000), "3.26%", "Gross effective interest rate on M&S regular saver = 3.26%");

	is (fmt (drip_feed_interest (250,1.2,5)), "$pound 97.75", "Drip feed test on 1.2 and 5 per cent");
};

subtest 'Reg Saver Test' => sub {
	plan tests => 1;
	print "\nreg_saver test...";

	my $test = reg_saver (amount => 250, rate => 6);
	for my $month (@$test) {
		printf ("\nmonth %2d = ", ($month->{month}));
		print "\t".fmt ($month->{total}, "$pound %10.2f");
		print "\t".fmt ($month->{interest}, "$pound %10.2f");
		print "\t".fmt ($month->{ongoing}, "$pound %10.2f");
	}
	print "\n";
	is (fmt (@$test[11]->{ongoing} - @$test[11]->{invested}), "$pound 97.92", "Regular Saver interest $pound 97.92");
};
