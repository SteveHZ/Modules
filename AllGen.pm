package AllGen;

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
	my ($self,$column) = @_;

    do {
    	if ($column < $self->{selections} - 1) {
        	$self->runIt ($column + 1);
            if (@{ $self->{iArray} }[$column] >= $self->{from} - 1) {
            	return;
            } else {
            	$self->reInitArray ($column);
            }
        } else {
        	while (@{ $self->{iArray} }[$column] < $self->{from}) {
            	if ($self->{onIteration}) {
                	$self->{onIteration}->($self);
                }
                @{ $self->{iArray} }[$column] ++;
                $self->{count} ++;
            }
            return;
        }
    } while ($column >= 0);
}

sub initArray {
	my $self = shift;

    for (my $i = 0;$i < $self->{selections};$i ++) {
    	@{ $self->{iArray} }[$i] = 0;
    }
    return 1;
}

sub reInitArray {
	my ($self,$base) = @_;

    @{$self->{iArray}}[$base] ++;

    for (my $i = $base + 1;$i < $self->{selections};$i ++) {
    	@{ $self->{iArray} }[$i] = 0;
    }
}

sub get_all {
	my ($self, $array) = @_;
	return $self->map_to ($array);
}

1;
