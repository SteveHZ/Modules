package MyRegX;

use Moo;
use namespace::clean;

# fixtures.pl
sub upper { qr/[A-Z]/; }
sub lower {	qr/[a-z]/; }
sub numeric { qr/\d/; }

sub time { qr/\d{2}:\d{2}/; }
sub dmy_date { qr/\d{2}\/\d{2}\/\d{2}/; }
sub dm_date { qr/\d{2}\/\d{2}/; }

sub as_date_month {	
	my ($self, $val) = @_;
	$val =~ s/\d{4}-(\d{2})-(\d{2})/$2\/$1/;
	return $val;
};

sub as_dmy {
	my ($self, $val) = @_;
	$val =~ s/\d{2}(\d{2})-(\d{2})-(\d{2})/$3\/$2\/$1/;
	return $val;
}

# oddsp.pl
sub score { qr/(\d\d?):(\d\d?)/; }
sub team { qr/[A-Za-z\& \.]/; }
sub odds { qr/\d+\.\d{2}/; }

sub date {
qr/
	(?<date>\d{2})\s
	(?<month>\w+)\s
	(?<year>\d{4})
/x;
}

sub yesterdays_date {
qr/
	Yesterday\W+
	(?<date>\d{2})\s
	(?<month>\w{3})
/x;
}

# euro_results.pl, results.pl
sub date_parser {
qr/
	\w+\s				# day
	(?<date>\d\d?)		# date
	\w\w\s				# date end (st,nd,rd,th)
	(?<month>\w+)\s		# month
	(?<year>\d\d\d\d)	# year
/x;
}

sub game_parser {
qr/
	(?<home>\D+)		# home team
	(?<home_score>\d\d?)# home score
	(?<away>\D+)		# away team
	(?<away_score>\d\d?)# away score
/x;
}

=pod

=head1 NAME

MyRegX.pm

=head1 SYNOPSIS

A collection of regexes

=head1 DESCRIPTION

=head1 AUTHOR

Steve Hope

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;