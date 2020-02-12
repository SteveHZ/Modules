package MyRole;

#   MyRole.pm 23/05/19
#   http://perladvent.org/2017/2017-12-06.html

use Mu::Role;
use Data::Dumper;

our $VERSION = '1.000000';

use Import::Into;
use experimental ();
use feature ();

sub import {
    my $caller_level = 1;

    Mu::Role->import::into($caller_level);
    Data::Dumper->import::into($caller_level);

    my @experiments = qw( signatures );
    experimental->import::into( $caller_level, @experiments );

    my ($version) = $^V =~ /^v(5\.\d+)/;
    feature->import::into( $caller_level, ':' . $version );
}

=pod

=head1 NAME

MyRole.pm

=head1 SYNOPSIS

with 'MyRole';

=head1 DESCRIPTION

Replace boiler-plate code for roles with one use statement.
Enables both stable and experimental features.

=head1 AUTHOR

Steve Hope

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
