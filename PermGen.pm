package PermGen;

use strict;
use warnings;

use parent 'SeriesGen';

sub new {
	my $class = shift;
	my $selections = shift;

	my $self = $class->SUPER::new ($selections, $selections);
	bless $self, $class;
	return $self;
}

sub runIt {
	my ($self, $column) = @_;
	my $temp;

	if ($self->{from} > 0) {
		while ($column >= 0) {
			if ($column < ($self->{from}) - 2) {
				$self->runIt ($column + 1);
				while ((++ $self->{iArray} [$column]) < $self->{from}) {
					last if (! ($self->checkArray ($column)));
				}
				if ($self->{iArray} [$column] == $self->{from}) {
					return;
				} else {
					$self->reInitArray ($column + 1);
				}
			} else {
				$self->{count} ++;
				if ($self->{onIteration}) {
					$self->{onIteration}->($self);
				}
				$temp = $self->{iArray} [$column];
				$self->{iArray} [$column] = $self->{iArray} [$column + 1];
				$self->{iArray} [$column + 1] = $temp;
				$self->{count} ++;
				if ($self->{onIteration}) {
					$self->{onIteration}->($self);
				}
				return;
			}
		}
	}
}

sub initArray {
	my $self = shift;
	my $s = ($self->{from}) - 1;
	$self->{iArray}->@*  = (0...$s);
}

sub reInitArray {
	my ($self, $base) = @_;
	my $cnt = 0;
	my ($flag, $num, $i);

	for ($num = 0; $num < $self->{from}; $num ++) {
		$flag = 0;
		for ($i = 0; $i < $base && (! $flag); $i ++) {
			if ($num == $self->{iArray} [$i]) {
				$flag = 1;
			}
		}
		if (! $flag) {
			$self->{iArray} [$base + $cnt] = $num;
			$cnt ++;
		}
	}
}

sub checkArray {
	my ($self, $column)= @_;

	for (my $i = 0;$i < $column;$i ++) {
		if ($self->{iArray} [$i] == $self->{iArray} [$column]) {
			return 1;
		}
	}
	return 0;
}

sub get_perms {
	my ($self, $array) = @_;
	return $self->map_to ($array);
}

1;
