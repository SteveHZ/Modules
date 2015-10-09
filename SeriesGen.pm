package SeriesGen;

use strict;
use warnings;

sub new {
	my $this = shift;
	my $class = ref($this) || $this;
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
	
	bless $self,$class;
	return $self;
}

# class accessors

sub index {
	my ($self,$idx) = @_;
	return @{$self->{iArray}}[$idx];
}

sub selections {
	my $self = shift;
	if (@_) {
		return $self->{selections} = shift;
	} else {
		return $self->{selections};
	}
}

sub from {
	my $self = shift;
	if (@_) {
		return $self->{from} = shift;
	} else {
		return $self->{from};
	}
}

sub count {
	my $self = shift;
	if (@_) {
		return $self->{count} = shift;
	} else {
		return $self->{count};
	}
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
	my ($self,$column) = @_;
	my $count = 1;
	for (my $i = $column+ 1;$i < $self->{selections};$i++,$count++) {
		@{$self->{iArray}}[$i] = @{$self->{iArray}}[$column] + $count;
	}
}

sub onIteration {
	my $self = shift;
	if (@_) {
		return $self->{onIteration} = shift;
	} else {
		return $self->{onIteration};
	}
}

sub onIterationEnd {
	my $self = shift;
	if (@_) {
		return $self->{onIterationEnd} = shift;
	} else {
		return $self->{onIterationEnd};
	}
}

sub run {
	my $self = shift;

	if ($self->initArray ()) {
		$self->runIt(0);
		if ($self->{onIterationEnd}) {
			$self->{onIterationEnd}->($self);
		}
	}
	return 1;
}

sub runIt {}

1;
