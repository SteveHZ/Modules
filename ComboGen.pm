package ComboGen;

use strict;
use warnings;

use parent 'SeriesGen';

sub new {
	my $class = shift;

	my $self = $class->SUPER::new (@_);
	bless $self, $class;
	return $self;
}

# class method overridden from SeriesGen

sub runIt {
	my ($self, $column) = @_;
	my $maxCol;

	do {
		if ($column < ($self->{selections}) - 1) {
			$self->runIt ($column + 1);
			$maxCol = ($self->{from} -(($self->{selections}) - $column));
			if (@{$self->{iArray}}[$column] > $maxCol) {
				return;
			} else {
				@{$self->{iArray}}[$column] ++;
				$self->reInitArray ($column);
			}
		} else {
			$maxCol = ($self->{from} -(($self->{selections}) - $column));
			while (@{$self->{iArray}}[$column] <= $maxCol) {
				if ($self->{onIteration}) {
					$self->{onIteration}->($self);
				}
				@{$self->{iArray}}[$column] ++;
				$self->{count} ++;
			}
			return;
		}
	} while ($column >= 0);
} 

1;
