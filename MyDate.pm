package MyDate;

use strict;
use warnings;
use Date::Simple qw(today);

use Exporter 'import';

use vars qw (@EXPORT_OK %EXPORT_TAGS);

our @EXPORT = qw( $month_names $short_month_names @days_of_week);
@EXPORT_OK = qw ( month_number get_year);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub new { return bless {}, shift; }

our $month_names = { 
	'January'	=> '01',
	'February'	=> '02',
	'March'		=> '03',
	'April'		=> '04',
	'May'		=> '05',
	'June'		=> '06',
	'July'		=> '07',
	'August'	=> '08',
	'September'	=> '09',
	'October'	=> '10',
	'November'	=> '11',
	'December'	=> '12',
};

our $short_month_names = { 
	'Jan' => '01',
	'Feb' => '02',
	'Mar' => '03',
	'Apr' => '04',
	'May' => '05',
	'Jun' => '06',
	'Jul' => '07',
	'Aug' => '08',
	'Sep' => '09',
	'Oct' => '10',
	'Nov' => '11',
	'Dec' => '12',
};

our @days_of_week = ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');

sub month_number {
	my $month = shift;
	return $short_month_names->{$month} if exists $short_month_names->{$month};
	return $month_names->{$month} if exists $month_names->{$month};
	return 0;
}

sub get_year {
	return today()->year;
}

=pod

=head1 NAME

MyDate.pm

=head1 SYNOPSIS

General date routines and hashes

=head1 DESCRIPTION

=head1 AUTHOR

Steve Hope

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;