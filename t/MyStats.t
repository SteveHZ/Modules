
#	MyStats.t 03/03/20

use strict;
use warnings;
use Test::More tests => 2;

use MyStats qw(:all);

# https://www.mathsisfun.com/combinatorics/combinations-permutations.html
# example : pool balls without order
subtest 'binomial_coeff' => sub {
	plan tests => 1;
	is (binomial_coeff (16,3), 560, 'binomial_coeff ok');
};

# https://www.mathsisfun.com/data/bayes-theorem.html
# example : picnic day
subtest 'bayes' => sub {
    plan tests => 1;
    is (bayes (0.1, 0.4, 0.5), 0.125, 'bayes ok');
}
