package MyEuler;

use strict;
use warnings;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK	 = qw (my_sum is_prime is_whole my_product generate_primes prime_no_gen);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub my_sum {
    my $sum = 0;
    $sum += $_ for @_;
    return $sum;
}

sub is_prime {
    my $number = shift;
    for my $i (2...sqrt ($number)) {
        return 0 if $number % $i == 0;
    }
    return 1;
}

sub is_whole {
    my $number = shift;
    return 1 if int($number) == $number;
    return 0;
}

sub my_product {
    my $total = 1;
    $total *= $_ for @_;
    return $total;
}

sub prime_no_gen {
    my @primes = ();
    my $number = 0;
    return sub {
        if ($number == 0) {
            $number = 1;
            return 2;
        }

        while ($number) {
            $number += 2;
            if (is_prime_gen_check ($number, \@primes)) {
                push @primes, $number;
                return $number;
            }
        }
    }
}

sub generate_primes {
    my $max = shift;
    my @primes = qw(2);
    my $count = 1;

    for (my $number = 3; $count < $max; $number += 2) {
        if (_is_prime_gen_check ($number, \@primes)) {
            push @primes, $number;
            $count ++;
        }
    }
    return \@primes;
}

sub _is_prime_gen_check {
    my ($number, $primes) = @_;
    my $sqrt = sqrt $number;
    for my $i (@$primes) {
        last if $i > $sqrt;
        return 0 if $number % $i == 0;
    }
    return 1;
}

1;
