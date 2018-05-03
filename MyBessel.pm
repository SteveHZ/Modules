package MyBessel;

#	MyBessel.pm 08-14/08/17, 29/09/17-06/10/17

use strict;
use warnings;

use Math::Cephes qw(iv);

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK = qw (calc_besseliv);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub calc_besseliv {
	my ($aa, $bb, $harm_mean) = @_;
	return $bb * _besseliv (abs ($aa), 2 * $harm_mean);
}

sub _besseliv {
	my ($v, $x) = @_;
	return iv ($v, $x);
}

1;
