package PMF;

use Moo;
use namespace::clean;
use MyMath qw(power factorial);

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
#    $self->{hash}->{$_} /= $self->{total}
#        for keys $self->{hash}->%*;
    for my $key (keys $self->{hash}->%*) {
        $self->{hash}->{$key} /= $self->{total};
    }
    return $self->{hash};
}

sub mean {
    my $self = shift;
    return $self->{total} / scalar keys ($self->{hash}->%*)
}

sub variance {
    my $self = shift;
    my $mean = $self->mean ();
    my $total = 0;
    for my $key (keys $self->{hash}->%*) {
        $total += power ($self->{hash}->{$key} - $mean, 2);
    }
    return $total / scalar $self->{hash};
}

package main;

use strict;
use warnings;
use PMF;
use Data::Dumper;
use List::Util qw(sum);
#use MyMath qw(power factorial);
use MyStats qw(:all);

my $pmf = PMF->new ();
for my $x (1..6) {
    $pmf->set ($x,$x*2);
}
print Dumper $pmf;
print "\nmean = ".$pmf->mean ();
print "\nvariance = ". $pmf->variance ()."\n";
$pmf->normalise ();
print Dumper $pmf;
print "\nmean = ".$pmf->mean ();
print "\nvariance = ". $pmf->variance ();

# https://www.mathsisfun.com/data/standard-deviation.html
my @dogs = (600,470,170,430,300);
print "\nmean2 = ".mean (\@dogs);
print "\nvariance = ".sample_variance (\@dogs);
print "\nstandard deviation = ".standard_population_deviation (\@dogs);

my @flowers = (9, 2, 5, 4, 12, 7, 8, 11, 9, 3, 7, 4, 12, 5, 4, 10, 9, 6, 9, 4);
print "\nflowers - population mean = ".mean (\@flowers);
print "\nflowers - population standard deviation = ".standard_population_deviation (\@flowers);
my @flowers2 = (9, 2, 5, 4, 12, 7);
print "\nflowers - sample mean = ".mean (\@flowers2);
print "\nflowers - sample standard deviation = ".standard_sample_deviation (\@flowers2);

=head
sub mean {
    my $list = shift;
    return sum (@$list) / scalar @$list;
}

sub get_total {
    my $list = shift;
    my $mean = mean ($list);
    my $total = 0;
    for my $item (@$list) {
        $total += power ($item - $mean, 2);
    }
    return $total;
}

#use for small samples
sub sample_variance {
    my $list = shift;
    return get_total ($list) / scalar @$list - 1;
}

sub standard_sample_deviation {
    my $list = shift;
    return sqrt (sample_variance ($list));
}

# use for larger populations
sub population_variance {
    my $list = shift;
    return get_total ($list) / scalar @$list;
}

sub standard_population_deviation {
    my $list = shift;
    return sqrt (population_variance ($list));
}
=cut
