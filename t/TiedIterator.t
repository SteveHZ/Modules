use strict;
use warnings;
use v5.10;

use Test::More tests => 2;
use TiedIterator;

my $list = [1..10];
tie my $iterator, q(TiedIterator), $list;

subtest 'fetch' => sub {
    plan tests => scalar @$list;
    my @expect = @$list;
    my $idx = 0;
    while (my $n = $iterator) {
        is ($n, $expect[$idx++], "correct value - $n");
    }
};

subtest 'store' => sub {
    my $new_list = [ qw(2 4 6 8 10) ];
    my @expect = @$new_list;
    plan tests => scalar @$new_list;

    $iterator = $new_list;
    my $idx = 0;
    while (my $n = $iterator) {
        is ($n, $expect[$idx++], "correct value = $n");
    }
};
