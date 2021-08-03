package MyCombinations;

use Moo;
use namespace::clean;

has 'choose' => (is => 'ro', required => 1);
has 'arr' => (is => 'ro', required => 1);

sub BUILD {
	my $self = shift;
	my $n = scalar $self->{arr}->@*;
	$self->{data} = [];
	$self->{list} = [];
	$self->do_combs ($self->{arr}, $self->{data}, 0, $n-1, 0, $self->{choose});
#	$self->do_combs2 (0, $n-1, 0);
}

sub do_combs {
	my ($self, $arr, $data, $start, $end, $index, $choose) = @_;
	if ($index == $self->{choose}) {
		push $self->{list}->@*, [ map {$_} @$data [0..$choose-1]];
		return;
	}
	for (my $i = $start; $i <= $end && (($end-$i+1) >= ($choose-$index)); $i++) {
		@$data[$index] = @$arr[$i];
		$self->do_combs ($arr, $data, $i+1, $end, $index+1, $choose)
	}
}

sub do_combs2 {
	my ($self, $start, $end, $index) = @_;
	if ($index == $self->{choose}) {
		push $self->{list}->@*, [ map {$_} $self->{data}->@[0..$self->{choose}-1]];
		return;
	}
	for (my $i = $start; $i <= $end && (($end-$i+1) >= ($self->{choose}-$index)); $i++) {
		$self->{data}->@[$index] = $self->{arr}->@[$i];
		$self->do_combs2 ($i+1, $end, $index+1);
	}
}

sub iterator {
	my $self = shift;
	my $index = 0;

	return sub {
		return undef if $index >= scalar $self->{list};
		return $self->{list} [$index++];
	};
}

1;