package Test::Any;

#	http://perlmaven.com/multiple-expected-values

use strict;
use warnings;

use List::MoreUtils qw(any);
use Test::Builder::Module;
    
our $VERSION = '0.01';
    
use Exporter qw(import);
our @EXPORT_OK = qw(is_any);
     
my $Test = Test::Builder::Module->builder;
     
sub is_any {
	my ($actual, $expected, $test_name) = @_;
	$test_name ||= '';
     
	$Test->ok( (any {$_ eq $actual} @$expected), $test_name) 
		or $Test->diag("Received: $actual\nExpected:\n" 
			. join "", map {"         $_\n"} @$expected);
}
     
1;