package MyKeyword;

use 5.012;    # required for pluggable keywords
use strict;
use warnings;
use Keyword::Simple;

sub import {
	my ($self, @keywords) = @_;

	for my $keyword (@keywords) {
		Keyword::Simple::define "$keyword", sub {
			my ($ref) = @_;
			if ( $ENV{"PERL_KEYWORD_$keyword"} ) {
				substr( $$ref, 0, 0 ) = 'if (1)';
			}
			else {
				substr( $$ref, 0, 0 ) = 'if (0)';
			}
		};
	}
}

sub unimport {
	my ($self, @keywords) = @_;
	for my $keyword (@keywords) {
		Keyword::Simple::undefine "$keyword";
	}
}

1;    # End of MyKeyword
