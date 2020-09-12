package StakesGen;

use strict;
use warnings;

use parent 'SeriesGen';
use MyMath qw(build_range);

sub new {
	my $class = shift;

	my $self = $class->SUPER::new (@_);
	bless $self, $class;
	return $self;
}

# class method overridden from SeriesGen

sub runIt {
	my ($self, $column) = @_;

	do {
		if ($column < $self->{selections} - 1) {
			$self->runIt ($column + 1);
			if ($column > 0) {
				if (++ ($self->{iArray} [$column - 1]) > $self->{from} - ($self->{selections} - 1)) {
					return;
				} else {
					$self->reInitArray ($column);
				}
			}
  		} else {
			while ( $self->{iArray} [$column] >= 0 ) {
				if ($self->{onIteration}) {
					$self->{onIteration}->($self);
				}
				$self->{count} ++;
				$self->{iArray} [$column] --;
				$self->{iArray} [$column - 1] ++;
			}
			return;
		}
	} while ($column > 0);
}

sub initArray {
	my $self = shift;

	for (my $i = 0;$i < $self->{selections} - 1;$i ++) {
		$self->{iArray} [$i] = 0;
	}
    $self->{iArray} [$self->{selections} - 1] = $self->{from} - $self->{selections};
	return 1;
}

sub reInitArray {
	my ($self, $base) = @_;
	my $cnt = 0;
	my $num;

	for ($num = 0; $num < $base; $num ++) {
		$cnt += ($self->{iArray} [$num] + 1);
	}
	for ($num = $base; $num < ($self->{selections} - 1); $num ++) {
		$self->{iArray} [$num] = 0;
		$cnt ++;
	}
	$self->{iArray} [$self->{selections} - 1] = $self->{from} - $cnt - 1;
}

sub get_stakes {
	my ($self, $start, $end, $interval) = @_;
	my $array = build_range ($start, $end, $interval);

	return $self->map_to ($array);
}

1;
