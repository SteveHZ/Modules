use strict;
use warnings;
use MyKeyword qw(TESTING DEVELOPMENT);
BEGIN { 
	$ENV{PERL_KEYWORD_DEVELOPMENT} = 1;
	$ENV{PERL_KEYWORD_TESTING} = 0;
}

DEVELOPMENT {
	print "\nIn development block";
} else {
	print "\nNo development code called";
}
TESTING {
	print "\nIn test block";
} else {
	print "\nNo test code called";
}
print "\nHello";