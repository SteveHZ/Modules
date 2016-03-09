package Savings;

# Savings.pm 19-20/01/16

use strict;
use warnings;

use Exporter 'import';
use vars qw ($VERSION @EXPORT_OK %EXPORT_TAGS);
use Encode;

$VERSION     = 1.00;
@EXPORT_OK = qw (	fmt net tax tax_from_net gross_from_net interest monthly_interest reg_saver_interest
					effective_gross_interest_rate effective_net_interest_rate drip_feed_interest reg_saver);
					
%EXPORT_TAGS = ( All => [qw (&fmt &net &tax &tax_from_net &gross_from_net &interest &monthly_interest &reg_saver_interest
							 &effective_gross_interest_rate &effective_net_interest_rate &drip_feed_interest &reg_saver)]);

#					calc_interest_rate drip_feed_interest reg_saver);
#							 &calc_interest_rate &drip_feed_interest &reg_saver)]);


sub fmt {
	my $amount = shift;
	my $format = shift // "\$%.2f"; #	my $format = shift // chr(156)."%.2f";
	return sprintf ($format, $amount);
}

sub net {
	my $amount = shift;
	return $amount * 0.8;
}

sub tax {
	my $amount = shift;
	return $amount * 0.2;
}

sub tax_from_net {
	my $amount = shift;
	return $amount * 0.25;
}

sub gross_from_net {
	my $amount = shift;
	return $amount * 1.25;
}

sub interest {
	my ($amount, $rate) = @_;
	return $amount * ($rate / 100);
}

sub monthly_interest {
	my ($amount, $rate) = @_;
	return $amount * ($rate / 100) * (30 / 365);
}

sub per_cent {
	my ($top, $bot) = @_;
	return ($top / $bot) * 100;
}
sub reg_saver_interest {
	my ($amount, $rate) = @_;
	
	my ($total, $interest, $total_interest) = (0,0,0);
	for (1...12) {
		$total += $amount;
		$interest = monthly_interest ($total, $rate);
		printf "\ntotal = %8.02f \t interest = %6.02f \t ongoing = %8.02f", $total, $interest, $total + $interest;
		
		$total += $interest;
		$total_interest += $interest;
	}
	print "\n";
	return $total_interest;
}

sub effective_gross_interest_rate {
	my ($interest, $amount) = @_;
	return fmt (($interest/ $amount) * 100, "%.2f%%");
#	return sprintf ("%0.2f%%", ($interest/ $amount) * 100);
}

sub effective_net_interest_rate {
	my ($interest, $amount) = @_;
	return fmt (net (($interest/ $amount) * 100), "%.2f%%");
#	return sprintf ("%0.2f%%", net (($interest/ $amount) * 100));
}

sub drip_feed_interest {
	my ($saver_amount, $feeder_rate, $saver_rate) = @_;
	
	my ($saver_total, $saver_interest, $feeder_interest, $total_interest) = (0,0,0,0);
	my $feeder_amount = $saver_amount * 12;

	for (1...12) {
		$saver_total += $saver_amount;
		$saver_interest = monthly_interest ($saver_total, $saver_rate);
		$total_interest += $saver_interest;
		
		$feeder_amount -= $saver_amount;
		$feeder_interest = monthly_interest ($feeder_amount, $feeder_rate);
		$total_interest += $feeder_interest;

		printf "\nfeeder = %8.02f \t %6.02f \tsaver = %8.02f \t %6.02f \ttotal = %8.02f",
				$feeder_amount, $feeder_interest, $saver_total, $saver_interest, $total_interest;

		$saver_total += $saver_interest;
		$feeder_amount += $feeder_interest;
	}
	print "\n";
	return $total_interest;
}

sub reg_saver {
	my ($amount, $rate, $months) = @_;
	$months = defined ($months) ? $months : 12;
	
	my ($total, $invested, $interest, $total_interest) = (0,0,0);
	my $reg_saver = [];
	my $ongoing;
	
	for my $this_month (1...$months) {
		$total += $amount;
		$invested += $amount;
		$interest = monthly_interest ($total, $rate);
		$ongoing = $total + $interest;
		my $month = {
			month => $this_month,
			invested => $invested,
			total => $total,
			interest => $interest,
			ongoing => $ongoing,
		};
		push (@$reg_saver, $month);

		$total += $interest;
		$total_interest += $interest;
	}
	return $reg_saver;
}

1;



