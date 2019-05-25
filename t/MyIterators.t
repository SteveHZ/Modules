
#   MyIterators.pm 17/12/18

use strict;
use warnings;
use MyIterators qw(:all);
use Test::More (tests => 3);

my @array = (1..5);

subtest 'make_iterator' => sub {
    plan tests => scalar @array;
    my $iterator = make_iterator (\@array);
    my $idx = 0;
    while (my $received = $iterator->()) {
        is ($received, $array[$idx], "received correct data at index $idx");
        $idx++;
    }
};

subtest 'make_reverse_iterator' => sub {
    plan tests => scalar @array;
    my $iterator = make_reverse_iterator (\@array);
    my $idx = $#array;
    while (my $received = $iterator->()) {
        is ($received, $array[$idx], "received correct data at index $idx");
        $idx--;
    }
};

subtest 'make_circular_iterator' => sub {
    my $times = 3;
    plan tests => $times * scalar @array;
    my $iterator = make_circular_iterator (\@array);
    my ($idx, $loop_count) = (0,0);

    while (my $received = $iterator->()) {
        $idx = 0 if $idx > $#array;
        $loop_count++ if $idx == 0;
        last if $loop_count > $times;
        is ($received, $array[$idx], "received correct data at index $idx");
        $idx++;
    }
};
