package SeriesGen;

use strict;
use warnings;

sub new {
	my $class = shift;

	my $self = {
		selections => shift,
		from => shift,
		count => 0,
		onIteration => 0,
		onIterationEnd => 0,
		iArray => [],
	};
	die "error in SeriesGen !!" if ( $self->{selections} < 1 ||
									 $self->{selections} > $self->{from} );
	
	bless $self, $class;
	return $self;
}

# class accessors

sub index {
	my ($self, $idx) = @_;
	return @{$self->{iArray}}[$idx];
}

sub selections {
	my $self = shift;
	if (@_) { $self->{selections} = shift; }
	return $self->{selections};
}

sub from {
	my $self = shift;
	if (@_) { $self->{from} = shift; }
	return $self->{from};
}

sub count {
	my $self = shift;
	if (@_) { $self->{count} = shift; }
	return $self->{count};
}

sub onIteration {
	my $self = shift;
	if (@_) { $self->{onIteration} = shift; }
	return $self->{onIteration};
}

sub onIterationEnd {
	my $self = shift;
	if (@_) { $self->{onIterationEnd} = shift; }
	return $self->{onIterationEnd};
}

# class methods

sub initArray {
	my $self = shift;
	if ($self->{selections}) {
		my $s = ($self->{selections}) - 1;
		@{$self->{iArray}} = (0...$s);
		return 1;
	} else {
		return 0;
	}
}

sub reInitArray {
	my ($self, $column) = @_;
	my $count = 1;
	for (my $i = $column+ 1;$i < $self->{selections};$i++,$count++) {
		@{$self->{iArray}}[$i] = @{$self->{iArray}}[$column] + $count;
	}
}

sub run {
	my $self = shift;

	if ($self->initArray ()) {
		$self->runIt (0);
		if ($self->{onIterationEnd}) {
			$self->{onIterationEnd}->($self);
		}
	}
	return 1;
}

sub runIt {}

1;
