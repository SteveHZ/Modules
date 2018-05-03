use strict;
use warnings;
use Test::More tests => 4;

use MyString qw(:all);

my $name = "Steve Hope";

subtest 'constructor' => sub {
	plan tests => 1;
	my $str = MyString->new ();
	isa_ok ($str, 'MyString', '$str');
};

subtest 'leftstr' => sub {
	plan tests => 1;
	is (leftstr ($name,4), 'Stev', 'leftstr ok');
};

subtest 'midstr' => sub {
	plan tests => 1;
	is (midstr ($name,3,5), 'eve H', 'midstr ok');
};

subtest 'rightstr' => sub {
	plan tests => 1;
	is (rightstr ($name,3), 'ope', 'midstr ok');
};
