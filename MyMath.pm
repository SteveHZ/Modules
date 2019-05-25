package MyMath;

#	MyMath.pm 16/08/17

use v5.010;	# state
use strict;
use warnings;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK = qw (power factorial perms new_perms build_range);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub power {
	my ($num, $exp) = @_;
	return $num ** $exp;
}

sub factorial {
	my $number = shift;
	state $cache = {};

	return 1 if $number == 1 or $number == 0;
	unless (exists $cache->{$number}) {
		$cache->{$number} =  $number * factorial ($number - 1);
	}
	return $cache->{$number};
}

sub perms {
	my ($sels, $from) = @_;
	my ($top, $bot) = (1, 1);
	my $cnt;

	for ($cnt = $from; $cnt > ($from - $sels); $cnt --) {
		$top *= $cnt;
	}
	for ($cnt = 2; $cnt <= $sels; $cnt ++) {
		$bot *= $cnt;
	}
	return $top / $bot;
}

sub new_perms {
	my ($sels, $from) = @_;
	my ($top, $bot) = (1, 1);

	$top *= $_ for @{ build_range ($from - ($sels - 1), $from, -1) };
	$bot *= $_ for (2..$sels);

	return $top / $bot;
}

sub build_range {
	my ($start, $end, $interval) = @_;
	$interval = (defined $interval) ? abs ($interval) : 1;
	my @list = ();

	if ($start < $end) {
		for (my $next_val = $start; $next_val <= $end; $next_val += $interval) {
			push @list, $next_val;
		}
	} else {
		for (my $next_val = $start; $next_val >= $end; $next_val -= $interval) {
			push @list, $next_val;
		}
	}
	return \@list;
}

1;
