package MyKeyword;

use 5.012;    # required for pluggable keywords
use warnings;
use Keyword::Simple;

my @keywords = qw(DEVELOPMENT TEST ZAPPA)
sub import {
	for my $keyword (@keywords) {
#		Keyword::Simple::define 'DEVELOPMENT', sub {
		Keyword::Simple::define "$keyword", sub {
			my ($ref) = @_;
#			if ( $ENV{PERL_KEYWORD_DEVELOPMENT} ) {
			if ( $ENV{PERL_KEYWORD_$keyword} ) {
				substr( $$ref, 0, 0 ) = 'if (1)';
			}
			else {
				substr( $$ref, 0, 0 ) = 'if (0)';
			}
		};
	}
}

sub unimport {
	for my $keyword (@keywords) {
#		Keyword::Simple::undefine 'DEVELOPMENT';
		Keyword::Simple::undefine "$keyword";
	}
}

1;    # End of Keyword::DEVELOPMENT
