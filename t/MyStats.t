
#	MyStats.t 03/03/20

use strict;
use warnings;
use Test::More tests => 3;

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
};

subtest 'standard deviations' => sub {
# https://www.mathsisfun.com/data/standard-deviation.html
	plan tests => 7;
	my @dogs = (600,470,170,430,300);
	is (mean (\@dogs), 394, 'mean ok');
	is (variance (\@dogs), 21704, 'variance ok');
	is (standard_deviation (\@dogs), 147.322774885623,'standard deviation ok');

# https://www.mathsisfun.com/data/standard-deviation-formulas.html
	my @flowers = (9, 2, 5, 4, 12, 7, 8, 11, 9, 3, 7, 4, 12, 5, 4, 10, 9, 6, 9, 4);
	is (mean (\@flowers), 7, 'population mean ok');
	is (standard_deviation (\@flowers), 2.98328677803526, 'population standard deviation ok');
	my @flowers2 = (9, 2, 5, 4, 12, 7);
	is (mean (\@flowers2), 6.5,'sample mean ok');
	is (standard_deviation (\@flowers2, size => 'sample'), 3.61939221417077,'sample standard deviation ok');
};
