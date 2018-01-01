package XPermGen;

use strict;
use warnings;

use parent 'SeriesGen';

sub new {
	my $class = shift;

	my $self = $class->SUPER::new (@_);
	bless $self, $class;
	return $self;
}

sub runIt {
	my ($self,$column) = @_;
	my ($maxCol,$temp);

	do {
		if ($column < ($self->{selections}) - 1) {
			$self->runIt ($column + 1);
			while ((++ @{ $self->{iArray} }[$column]) < $self->{from}) {
				last if (! ($self->checkArray ($column)));
			}
			if (@{$self->{iArray}}[$column] == $self->{from}) {
				return;
			} else {

				$self->reInitArray ($column + 1);
			}
		} else {
			$maxCol = ($self->{from} -(($self->{selections}) - $column));
			while ( @{ $self->{iArray} }[$column] <= $maxCol ) {
				if (! $self->checkArray($column)) {
					if ($self->{onIteration}) {
						$self->{onIteration}->($self);
					}
					$self->{count}++;
				}
				@{ $self->{iArray} }[$column] ++;
			}
			return;
		}
	} while ($column >= 0);
}

sub reInitArray {
	my ($self,$base) = @_;
	my $cnt = 0;
	my ($flag,$num,$i);
	
	for ($num = 0;$num < $self->{from};$num ++) {
		$flag = 0;
		for ($i = 0;$i < $base && (! $flag);$i ++) {
			if ($num == $self->{iArray}[$i]) {
				$flag = 1;
			}
		}
		while (($base + $cnt) < $self->{selections} && ! $flag) {
			@{$self->{iArray}} [$base + $cnt] = $num;
			$cnt ++;
		}
	}
}

sub checkArray {
	my ($self,$column)= @_;

	for (my $i = 0;$i < $column;$i ++) {
		if ( @{ $self->{iArray} }[$i] == @{ $self->{iArray} }[$column]) {
			return 1;
		}
	}
	return 0;
}

sub get_xperms {
	my ($self, $array) = @_;
	return $self->map_to ($array);
}
		
1;
