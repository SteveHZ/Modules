package Roles::Spreadsheet;

#	Roles::Spreadsheet.pm 01/10/16

use Excel::Writer::XLSX;
use List::Util qw (any);
use utf8;

use Moo::Role;
requires 'filename';
has 'blank_columns' => (is => 'rw', default => sub { [] } );

sub BUILD {}

after 'BUILD' => sub {
	my $self = shift;

	$self->{workbook} = Excel::Writer::XLSX->new ( $self->filename () )
		or die "\n\nUnable to create new spreadsheet file : ".$self->filename."\n$!";

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
		color => 'blue',
		align => 'center',
		num_format => '#,##0.00',
	);
	$self->{currency_format} = $self->{workbook}->add_format (
		bg_color => '#FFC7CE',
		color => 'blue',
		align => 'center',
		num_format => '£ #,##0.00',
	);
	$self->{percent_format} = $self->{workbook}->add_format (
		bg_color => '#FFC7CE',
		color => 'blue',
		align => 'center',
		num_format => '0.00 %',
	);

	$self->{range_parser} = qr/^
		(?<left>\D+)
		(?<top>\d+):
		(?<right>\D+)
		(?<bottom>\d+)$
	/x;
};
#sub DESTROY {
#	my $self = shift;
#	$self->{workbook}->close ();
#}

sub write_row {
	my ($self, $worksheet, $row, $row_data) = @_;
	my $col = 0;

	for my $cell_data (@$row_data) {
		while (my ($data, $fmt) = each %$cell_data) {
			$col ++ while any { $col == $_ } $self->blank_columns->@*;
			$worksheet->write ( $row, $col ++, $data, $fmt );
		}
	}
}

sub set_columns {
	my ($self, $worksheet, $columns) = @_;
	my $is_string = qr/(?:[A-Z]\s)+[A-Z]/; # 2 or more letters seperated by a space # ?: non-capturing ()s
	my $is_range = qr/[A-Z]+:[A-Z]+/; # 2 x 1 or more capital letters seperated by a colon

	for my $key (keys %$columns) {
		if ($key =~ $is_string) {
			for my $column (split (' ', $key)) {
				my $col = ($column =~ $is_range) ? $column : "$column:$column";
				_do_columns ($worksheet, $columns, $key, $col);
			}
		} else {
			_do_columns ($worksheet, $columns, $key, "$key:$key");
		}
	}
}

sub _do_columns {
	my ($worksheet, $columns, $column, $col) = @_;

	if (ref ($columns->{$column}) eq "HASH") {
		$worksheet->set_column ($col, $columns->{$column}->{size}, $columns->{$column}->{fmt} );
	} else {
		$worksheet->set_column ($col, $columns->{$column} );
	}
}

sub template_write_row {
	my ($self, $worksheet, $row, $row_data) = @_;

	my $col = 0;
	for my $cell_data (@$row_data) {
		while (my ($data, $fmt) = each %$cell_data) {
			$col ++ while any { $col == $_ } $self->blank_columns->@*;
			$worksheet->write ( $row, $col ++, $data, $self->{ $fmt } );
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

sub copy_format {
	my ($self, $format) = @_;

	my $new_format = $self->{workbook}->add_format ();
	$new_format->copy ($format);
	return $new_format;
}

sub border_range {
	my ($self, $worksheet) = (shift, shift);

	my $args = { @_ };
	my $range = $args->{range} // "A1:B1";
	my $text = $args->{text} // "";
	my $base_format = $args->{format} // $self->{format};

	die "\nRange error in border_range '$range'"
		unless $range =~ $self->{range_parser};

	for my $column ($+{left}..$+{right}) {
		for my $row ($+{top}..$+{bottom}) {

			my $format = $self->copy_format ($base_format);
			$format->set_left (1) if $column eq $+{left};
			$format->set_top (1) if $row == $+{top};
			$format->set_right (1) if $column eq $+{right};
			$format->set_bottom (1) if $row == $+{bottom};

			$worksheet->write ("$column$row", $text, $format);
		}
	}
}

1;
