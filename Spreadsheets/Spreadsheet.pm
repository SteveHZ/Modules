package Spreadsheets::Spreadsheet;

#	Spreadsheets::Spreadsheet.pm 01/10/16

use Excel::Writer::XLSX;
use List::Util qw (any);
use utf8;

use Moo::Role;
requires 'filename';

sub BUILD {}

after 'BUILD' => sub {
	my $self = shift;

	$self->{workbook} = Excel::Writer::XLSX->new ( $self->filename () )
		or die "Problems creating new Excel file ".$self->filename ()." : $!";

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

};

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