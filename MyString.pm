package MyString;

use strict;
use warnings;

use Exporter 'import';

use vars qw (@EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK = qw ( leftstr midstr rightstr);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub new { return bless {}, shift; }

sub leftstr {
	my ($str, $chars) = @_;
	return substr ($str, 0, $chars);
}

sub midstr {
	my ($str, $start, $chars) = @_;
	return substr ($str, $start - 1, $chars);
}

sub rightstr {
	my ($str, $chars) = @_;
	return substr ($str, $chars * -1);
}

=pod

=head1 NAME

MyString.pm

=head1 SYNOPSIS

General string routines

=head1 DESCRIPTION

=head1 AUTHOR

Steve Hope

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;