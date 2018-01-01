package MyOdds;

use strict;
use warnings;

sub new {
	my $class = shift;
	my $price = shift;

	my $self;
	if ($price =~ /(\d+)([-.])(\d+)/) {
		if ($2 eq '-') {
			$self = { first => $1, second => $3, }
		} elsif ($2 eq '.') {
			$self = { first => $price - 1, second => 1, }
		} else {
			die "error in MyOdds";
		}
	} else {
		$self = { first => $price, second => 1, }
	}

	return bless $self, $class;
}

sub first {
	my $self = shift;
	if (@_) { $self->{first} = shift; }
	return $self->{first};
}

sub second {
	my $self = shift;
	if (@_) { $self->{second} = shift; }
	return $self->{second};
}

sub ratio {
	my $self = shift;
	return $self->{first} / $self->{second};
}

sub show {
	my $self = shift;
	if ($self->{first} =~ /(\d+).(\d+)/) {
		return sprintf "%.02f", $self->{first} + 1;
	} else {
		return $self->{first}. "-" .$self->{second};
	}
}

=head2
#	08/09/15
sub new {
	my $this = shift;
	my $class = ref($this) || $this;
	my $self;
	
	my $price = shift;
	if ($price =~/(\d+)-(\d+)/) {
		$self = {
			first => $1,
			second => $2,
		}
	} elsif ($price =~/(\d+.\d+)/) {
		my ($first, $second) = calc_odds ( $1 );
		$self = {
			first => $first,
			second => $second,
		}
	} else {
		$self = {
			first => $price,
			second => 1,
		}
	}
	bless $self,$class;
	return $self;
}

sub calc_odds {
	my $decimal = (shift) - 1; # remove stake value from decimal odds
	my $first = $decimal;
	my $second = 1;
	my $diff;

	while (1) {
#$DB::single=1;
		last if ($first * $second) == int ($first * $second);
#		$diff = ($first * $second) - int ($first * $second);
#		if ($diff <= 0.001 && $diff >= -0.001) {
#			$first += $diff;
#			last;
#		}
		last if $second > 30; # escape if 100-30 hasn't broken out of loop
		$first += $decimal;
		$second ++;
	}
	return ($first, $second);
}

sub show {
	my $self = shift;
	($self->{first} == int ($self->{first}) ) ?
		return $self->{first}."-".$self->{second} :
		return $self->{first};
}

sub new {
	my $class = shift;
	my $price = shift;
	my $self;

	if ($price =~/(\d+)-(\d+)/) {
		$self = {
			first => $1,
			second => $2,
		}
	} else {
		$self = {
			first => $price,
			second => 1,
		}
	}
	bless $self,$class;
}
=cut
	
1;
