package MyTransform;

#	http://perladvent.org/2014/2014-12-05.html
#   05-06/12/15

use strict;
use warnings;
use Data::Dumper;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK	 = qw (schwartzian_sort schwartzian_sort_cmp schwartz);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub schwartzian_sort (&@) {
    my $weighter = shift;

    return
		map  { $_->[0] }
		sort { $a->[1] <=> $b->[1] }
		map  { [$_, $weighter->() ] } @_;
}

sub schwartzian_sort_cmp (&@) {
    my $weighter = shift;

    return
		map  { $_->[0] }
		sort { $a->[1] cmp $b->[1] }
		map  { [$_, $weighter->() ] } @_;
}

sub schwartz {
    my $args = {@_};

	$args->{sortfunc} //= sub { $a->[1] <=> $b->[1] };

    return
		map  { $_->[0] }
		sort { $args->{sortfunc}->($a, $b) }
		map  { [$_, $args->{weighter}->() ] }
		$args->{toSort}->@*;
}

1;
