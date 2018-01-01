package Spreadsheets::Base;

#	Spreadsheets::Base.pm 07/02/16

use strict;
use warnings;

use Excel::Writer::XLSX;
use List::Util qw (any);
use utf8;

sub new {
	my ($class, $xlsx_file) = @_;
	my $self = {};

	$self->{workbook} = Excel::Writer::XLSX->new ($xlsx_file)
		or die "Problems creating new Excel file '$xlsx_file' : $!";

	$self->{format} = $self->{workbook}->add_format (
		bg_color => '#FFC7CE',
		color => 'blue',
		align => 'center',
		num_format => '#0',
	);
	$self->{bold_format} = $self->{workbook}->add_format (
		bg_color => '#FFC7CE',
		color => 'black',
		align => 'center',
		num_format => '#0',
		bold => 'true',
		border => 1,
	);
	$self->{float_format} = $self->{workbook}->add_format (
		bg_color => '#FFC7CE',
		color    => 'blue',
		align => 'center',
		num_format => '#,##0.00',
	);
	$self->{currency_format} = $self->{workbook}->add_format (
		bg_color => '#FFC7CE',
		color    => 'blue',
		align => 'center',
		num_format => '£ #,##0.00',
	);
	$self->{percent_format} = $self->{workbook}->add_format (
		bg_color => '#FFC7CE',
		color    => 'blue',
		align => 'center',
		num_format => '0.00 %',
	);

    bless $self, $class;
    return $self;
}

sub write_row {
	my ($self, $worksheet, $row, $col, $row_data, $blank_cols) = @_;

	for my $data (@$row_data) {
		for my $key (keys %$data) {
			$worksheet->write ( $row, $col ++, $key, $data->{$key} );
			$col ++ while any {$col == $_ } @$blank_cols;
		}
	}
}

sub add_worksheet {
	my ($self, $sheet_name) = @_;
	return $self->{workbook}->add_worksheet ($sheet_name);
}

sub add_format {
	my ($self, $format) = @_;
	return $self->{workbook}->add_format (%$format);
}

1;