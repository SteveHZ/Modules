package MyStats;

#	MyStats.pm 03/03/20

use strict;
use warnings;
use List::Util qw(sum);
use MyMath qw(power factorial);

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK = qw (
	binomial_coeff probability binomial_prob bayes
	mean sample_variance standard_sample_deviation population_variance standard_population_deviation
);
%EXPORT_TAGS = (all => \@EXPORT_OK);

# https://www.mathsisfun.com/combinatorics/combinations-permutations.html      (n)
# calculate number of combinations (order does not matter) - often written as  (r) - in continuos brackets
# n is the number of things to choose from, r is the number to choose without repetition (n choose r)
# eg perms (3 from 5) -> binomial_coeff (5,3)
sub binomial_coeff {
	my ($n, $r) = @_;
	return factorial ($n) /
		  (factorial ($r) * factorial ($n - $r));
}

# pk(1-p)(n-k)
# https://www.mathsisfun.com/data/binomial-distribution.html
# calculate probability of k out of n ways
sub probability {
	my ($p, $k, $n) = @_;
	return power ($p, $k)
		   * power (1 - $p, $n - $k);
}

sub binomial_prob {
	my ($k, $n, $p) = @_;
	return binomial_coeff ($n, $k)
		   * probability ($p, $k, $n);
}

# https://www.mathsisfun.com/data/bayes-theorem.html
sub bayes {
	my ($prob_a, $prob_b, $prob_ba) = @_;
	return ( $prob_a * $prob_ba ) / $prob_b;
}

# https://www.mathsisfun.com/data/standard-deviation-formulas.html
sub mean {
    my $list = shift;
    return sum (@$list) / scalar @$list;
}

sub _get_total {
    my $list = shift;
    my $mean = mean ($list);
    my $total = 0;
    for my $item (@$list) {
		$total += ($item - $mean) ** 2;
    }
    return $total;
}

#use for smaller samples of data (part-populations)
sub sample_variance {
    my $list = shift;
    return _get_total ($list) / scalar @$list - 1;
}

sub standard_sample_deviation {
    my $list = shift;
    return sqrt (sample_variance ($list));
}

# use for full populations of data
sub population_variance {
    my $list = shift;
    return _get_total ($list) / scalar @$list;
}

sub standard_population_deviation {
    my $list = shift;
    return sqrt (population_variance ($list));
}

1;
