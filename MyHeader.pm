package MyHeader;

#   MyHeader.pm 22/05/19
#   http://perladvent.org/2017/2017-12-06.html

use strict;
use warnings;
use Data::Dumper;
#use signatures;

our $VERSION = '1.000000';

use Import::Into;

use feature ();
#use utf8 ();
#use open qw( :encoding(UTF-8) :std ); # This adds the UTF-8 layer on STDIN, STDOUT, STDERR

sub import {
    my $caller_level = 1;

    strict->import::into($caller_level);
    warnings->import::into($caller_level);
    Data::Dumper->import::into($caller_level);
#    signatures->import::into($caller_level);

    my @experiments = qw( signatures postderef postref_qq );
    experimental->import::into( $caller_level, @experiments );

    my ($version) = $^V =~ /^v(5\.\d+)/;
    feature->import::into( $caller_level, ':' . $version );
}

1;

=head
http://perladvent.org/2017/2017-12-06.html

## no critic (NamingConventions::Capitalization)
package NorthPole::Ourperl;
## use critic (NamingConventions::Capitalization)

use strict;
use warnings;

our $VERSION = '1.000000';

use Import::Into;

# XXX - it'd be nice to include bareword::filehandles but this conflicts with
# autodie - see https://rt.cpan.org/Ticket/Display.html?id=93591
use autodie 2.25 ();
use IPC::System::Simple;    # to fatalize system
use experimental     ();
use feature          ();
use indirect         ();
use mro              ();
use multidimensional ();

# This adds the UTF-8 layer on STDIN, STDOUT, STDERR for _everyone_
use open qw( :encoding(UTF-8) :std );
use utf8 ();

sub import {
    my $caller_level = 1;

    strict->import::into($caller_level);
    warnings->import::into($caller_level);

    my @experiments = qw(
        lexical_subs
        postderef
        signatures
    );
    experimental->import::into( $caller_level, @experiments );

    my ($version) = $^V =~ /^v(5\.\d+)/;
    feature->import::into( $caller_level, ':' . $version );
    ## no critic (Subroutines::ProhibitCallsToUnexportedSubs)
    mro::set_mro( scalar caller(), 'c3' );
    ## use critic
    utf8->import::into($caller_level);

    indirect->unimport::out_of( $caller_level, ':fatal' );
    multidimensional->unimport::out_of($caller_level);
    'open'->import::into( $caller_level, ':encoding(UTF-8)' );
    autodie->import::into( $caller_level, ':all' );
}
=cut

1;
