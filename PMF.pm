package PMF;

use Moo;
use namespace::clean;

sub BUILD {
    my $self = shift;
    $self->{hash} = {};
    $self->{total} = 0;
};

sub set {
    my ($self, $key, $val) = @_;
    $self->{hash}->{$key} = $val;
    $self->{total} += $val;
    return $self->{hash}->{$key};
}

sub incr {
    my ($self, $key, $amount) = @_;
    $self->{hash}->{$key} = 0 unless exists $self->{hash}->{$key};
    $self->{hash}->{$key} += $amount;
    $self->{total} += $amount;
    return $self->{hash}->{$key};
}

sub inc {
    my ($self, $key) = @_;
    return $self->incr ($key, 1);
}

sub normalise {
    my $self = shift;
    for my $key (keys $self->{hash}->%*) {
        $self->{hash}->{$key} /= $self->{total};
    }
    return $self->{hash};
}

sub mean {
    my $self = shift;
    return $self->{total} / keys ($self->{hash}->%*)
}

sub variance {
    my $self = shift;
    my $mean = $self->mean ();
    my $total = 0;
    for my $key (keys $self->{hash}->%*) {
        $total += ($self->{hash}->{$key} - $mean) ** 2;
    }
    return $total / keys $self->{hash}->%*;
}

sub standard_deviation {
    my $self = shift;
    return sqrt ($self->variance ());
}

1;
