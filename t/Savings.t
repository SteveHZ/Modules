
#	Savings.t 19-20/01/16

use strict;
use warnings;

use Test::More;
use Savings qw (:All);

my $amount = 100.00;

is (fmt (net ($amount)), "\$80.00", "Net of \$100.00 = \$80.00");
is (fmt (net ($amount), "\$%.5f"), "\$80.00000", "fmt format test - Net of \$100.00 = \$80.00000");

is (fmt (tax ($amount)), "\$20.00", "Tax on \$100.00 = \$20.00");
is (fmt (gross_from_net ($amount)), "\$125.00", "Gross of \$100.00 = \$125.00");

is (fmt (interest ($amount, 5.0)), "\$5.00", "5.00% interest on \$100.00 = \$5.00 per year");
is (fmt (monthly_interest ($amount, 5.0)), "\$0.41", "5.00% interest on \$100.00 = \$0.41 per month");

is (fmt (reg_saver_interest (250,6)), "\$97.92", "Interest on M&S regular saver = \$97.92");
is (calc_interest_rate (97.92, 3000), "3.26%", "Gross effective interest rate on M&S regular saver = 3.26%");
#is (effective_gross_interest_rate (97.92, 3000), "3.26%", "Gross effective interest rate on M&S regular saver = 3.26%");

is (fmt (drip_feed_interest (250,1.2,5)), "\$97.75", "Drip feed test on 1.2 and 5 per cent");


print "\nreg_saver test...";

my $test = reg_saver (250,6);
for my $month (@$test) {
	printf ("\nmonth %2d = ", ($month->{month}));
	print "\t".fmt ($month->{total}, "\$%10.2f");
	print "\t".fmt ($month->{interest}, "\$%10.2f");
	print "\t".fmt ($month->{ongoing}, "\$%10.2f");
}
print "\n";

done_testing ();
