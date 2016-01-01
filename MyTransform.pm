package MyTransform;

#	http://perladvent.org/2014/2014-12-05.html
#   05-06/12/15

use strict;
use warnings;

use Exporter 'import';
use vars qw ($VERSION @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@EXPORT_OK = qw (schwartzian_sort schwartzian_sort_cmp);  # symbols to export on request
%EXPORT_TAGS = ( All => [qw (&schwartzian_sort &schwartzian_sort_cmp)]);

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
1;
