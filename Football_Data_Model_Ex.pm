package Football_Data_Model_Ex;

use List::MoreUtils qw(any);
use DBI;
use Text::CSV;

use Moo;
use namespace::clean;

has 'full_data' => (is => 'rw', default => '0');

sub update {
	my ($self, $file) = @_;
	my @league_games = ();

	open my $fh, '<', $file or die "Can't find $file";
	my $line = <$fh>;	# skip first line
	while ($line = <$fh>) {
		my @data = split (',', $line);
		last if $data [0] eq ""; # don't remove !!!
		die "No result for $data[2] v $data[3]\n...in $file\n" if any {$_ eq ""} ( $data[4], $data[5] );
		
		if ($self->{full_data}) {
			push ( @league_games, {
				date => $data [1],
				home_team => $data [2],
				away_team => $data [3],
				home_score => $data [4],
				away_score => $data [5],
				half_time_home => $data [7],
				half_time_away => $data [8],
			});
		} else {
			push ( @league_games, {
				date => $data [1],
				home_team => $data [2],
				away_team => $data [3],
				home_score => $data [4],
				away_score => $data [5],
			});
		}
	}
	close $fh;
	return \@league_games;
}

sub update_dbi  {
	my ($self, $file) = @_;
	my @league_games = ();
		
	my $dbh = DBI->connect ("DBI:CSV:", undef, undef, {
		f_dir => "C:/Mine/perl/Football/data",
		f_ext => ".csv",
		csv_eol => "\n",
		RaiseError => 1,
	})	or die "Couldn't connect to database : ".DBI->errstr;
	
	my $query = "select Date, HomeTeam, AwayTeam, FTHG, FTAG from $file";
	my $sth = $dbh->prepare ($query)
		or die "Couldn't prepare statement : ".$dbh->errstr;
	$sth->execute;

	while (my $row = $sth->fetchrow_hashref) {
		if ($self->{full_data}) {
			push ( @league_games, {
				date => $row->{Date},
				home_team => $row->{HomeTeam},
				away_team => $row->{AwayTeam},
				home_score => $row->{FTHG},
				away_score => $row->{FTAG},
				half_time_home => $row->{HTHG},
				half_time_away => $row->{HTAG},
			});
		} else {
			push ( @league_games, {
				date => $row->{Date},
				home_team => $row->{HomeTeam},
				away_team => $row->{AwayTeam},
				home_score => $row->{FTHG},
				away_score => $row->{FTAG},
			});
		}
	}
	$dbh->disconnect;
	return \@league_games;
}

sub update_csv {
	my ($self, $file) = @_;
	my @league_games = ();
	
	my $csv = Text::CSV->new ( { binary => 1 } )
		or die "Cannot use CSV: ".Text::CSV->error_diag ();

	open my $fh, "<:encoding(utf8)", $file or die "$file : $!";
	$csv->getline ( $fh );

	while ( my $row = $csv->getline ( $fh ) ) {
		last if $row->[0] eq ""; # don't remove !!!
		die "No result for $row->[2] v $row->[3]\n...in $file\n" if any {$_ eq ""} ( $row->[4], $row->[5] );
		if ($self->{full_data}) {
			push ( @league_games, {
				date => $row->[1],
				home_team => $row->[2],
				away_team => $row->[3],
				home_score => $row->[4],
				away_score => $row->[5],
				half_time_home => $row->[7],
				half_time_away => $row->[8],
			});
		} else {
			push ( @league_games, {
				date => $row->[1],
				home_team => $row->[2],
				away_team => $row->[3],
				home_score => $row->[4],
				away_score => $row->[5],
			});
		}
	}
	$csv->eof or $csv->error_diag();
	close $fh;

	return \@league_games;
}

1;