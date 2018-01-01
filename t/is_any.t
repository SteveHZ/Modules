use strict;
use warnings;

use Test::More tests => 1;
use Test::Any qw(is_any);

my $array = [1,2,3,4,5,8];
my $expect = [1,2,3,4,5,8];
#my $expect = [1,3,5,7,9,11];

subtest 'is_any' => sub {
	plan tests => scalar @$array;
	is_any ($_, $expect, "value : $_") for @$array;
};
