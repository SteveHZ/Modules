package MyRole;

#   MyRole.pm 23/05/19
#   http://perladvent.org/2017/2017-12-06.html

use Mu::Role;
use namespace::clean;
use Data::Dumper;

our $VERSION = '1.000000';

use Import::Into;

use feature ();

sub import {
    my $caller_level = 1;

    Mu::Role->import::into($caller_level);
    namespace::clean->import::into($caller_level);
    Data::Dumper->import::into($caller_level);

    my @experiments = qw( signatures postderef postref_qq );
    experimental->import::into( $caller_level, @experiments );

    my ($version) = $^V =~ /^v(5\.\d+)/;
    feature->import::into( $caller_level, ':' . $version );
}

1;
