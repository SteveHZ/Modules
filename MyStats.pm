package MyStats;

#	MyStats.pm 03/03/20

use MyHeader;
use List::Util qw(sum);
use MyMath qw(power factorial);

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK = qw (
	binomial_coeff probability binomial_prob bayes
	mean variance standard_deviation
);

%EXPORT_TAGS = (all => \@EXPORT_OK);

# https://www.mathsisfun.com/combinatorics/combinations-permutations.html      (n)
# calculate number of combinations (order does not matter) - often written as  (r) - in continuous brackets
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

# $population = 'population' for full populations of data
# $population = 'sample' (or anything !!) for smaller samples of data (part-populations)
{
	use Function::Parameters qw(fun);
	fun variance ($list, :$size = 'population') {
		return ($size eq 'population')
			? _get_total ($list) / scalar @$list
			: _get_total ($list) / scalar @$list - 1;
	}

	fun standard_deviation ($list, :$size = 'population') {
    	return sqrt (variance ($list, size => $size));
	}
}

1;
