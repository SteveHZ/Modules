package Savings;

# Savings.pm 19-20/01/16

use strict;
use warnings;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK = qw ( fmt net tax tax_from_net gross_from_net interest monthly_interest reg_saver_interest
				  effective_gross_interest_rate effective_net_interest_rate drip_feed_interest reg_saver);

%EXPORT_TAGS = (all => \@EXPORT_OK);

sub fmt {
	my $amount = shift;
	my $format = shift // chr(156)." %.2f"; #	chr(156) = pound sign
	return sprintf ($format, $amount);
}

sub net {
	my $args = {@_};
	return $args->{amount} * 0.8;
}

sub tax {
	my $args = {@_};
	return $args->{amount} * 0.2;
}

sub tax_from_net {
	my $args = {@_};
	return $args->{amount} * 0.25;
}

sub gross_from_net {
	my $args = {@_};
	return $args->{amount} * 1.25;
}

sub interest {
	my $args = {@_};
	return $args->{amount} * ($args->{rate} / 100);
}

sub monthly_interest {
	my $args = {@_};
	return $args->{amount} * ($args->{rate} / 100) * (30 / 365);
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
		$interest = monthly_interest (amount => $total, rate => $rate);
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
}

sub effective_net_interest_rate {
	my ($interest, $amount) = @_;
	return fmt (net (($interest/ $amount) * 100), "%.2f%%");
}

sub drip_feed_interest {
	my ($saver_amount, $feeder_rate, $saver_rate) = @_;

	my ($saver_total, $saver_interest, $feeder_interest, $total_interest) = (0,0,0,0);
	my $feeder_amount = $saver_amount * 12;

	for (1...12) {
		$saver_total += $saver_amount;
		$saver_interest = monthly_interest (amount => $saver_total, rate => $saver_rate);
		$total_interest += $saver_interest;

		$feeder_amount -= $saver_amount;
		$feeder_interest = monthly_interest (amount => $feeder_amount, rate => $feeder_rate);
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
	my $args = {@_};
	$args->{months} //= 12;

	my ($total, $invested, $interest, $total_interest) = (0,0,0);
	my $reg_saver = [];
	my $ongoing;

	for my $this_month (1...$args->{months}) {
		$total += $args->{amount};
		$invested += $args->{amount};
		$interest = monthly_interest (amount => $total, rate => $args->{rate});
		$ongoing = $total + $interest;
		push (@$reg_saver, {
			month => $this_month,
			invested => $invested,
			total => $total,
			interest => $interest,
			ongoing => $ongoing,
		});

		$total += $interest;
		$total_interest += $interest;
	}
	return $reg_saver;
}

1;
