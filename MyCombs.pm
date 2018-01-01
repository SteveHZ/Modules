package MyCombs;

use Moo;
use namespace::clean;

sub BUILD {
	my $self = shift;

	$self->{combinations} = {
		3 => 4,
		4 => 11,
		5 => 26,
		6 => 57,
		7 => 120,
		8 => 247,
	};

	$self->{full_cover} = {
		3 => 7,
		4 => 15,
		5 => 31,
		6 => 63,
	};
}

sub singles		{ return _acca_calc (@_); }
sub doubles		{ return _acca_calc (@_); }
sub trebles		{ return _acca_calc (@_); }
sub four_fold	{ return _acca_calc (@_); }
sub five_fold	{ return _acca_calc (@_); }
sub six_fold	{ return _acca_calc (@_); }
sub seven_fold	{ return _acca_calc (@_); }
sub eight_fold	{ return _acca_calc (@_); }

sub trixie		{ return _combs (@_); }
sub yankee		{ return _combs (@_); }
sub super_yankee{ return _combs (@_); }
sub heinz		{ return _combs (@_); }
sub super_heinz	{ return _combs (@_); }
sub goliath		{ return _combs (@_); }

sub patent		{ return _full_cover (@_); }
sub lucky_15	{ return _full_cover (@_); }
sub lucky_31	{ return _full_cover (@_); }
sub lucky_63	{ return _full_cover (@_); }

sub _acca_calc {
	my ($self, $odds, $stake) = @_;
	$stake //= 1;

	$stake *= $_ for @$odds;
	return sprintf "%.2f", $stake;
}

#	http://www.jollyodds.com/block-bet-calculator/
#	https://en.wikipedia.org/wiki/Mathematics_of_bookmaking
#	unit_stake * (($a+1)*($b+1)*($c+1) - ($a+$b+$c+1));

sub _combs {
	my ($self, $odds, $stake) = @_;
	$stake //= 1;

	my $bets = scalar @$odds;
	my $unit_stake = $stake / $self->{combinations}->{$bets};
	my $first = 1;
	my $second = 0;
	
	for my $next (@$odds) {
		$first *= $next + 1;
		$second += $next;
	}
	return sprintf "%.2f", $unit_stake * ($first - ($second + 1));
}

#	unit_stake * (($a+1)*($b+1)*($c+1)-1);

sub _full_cover {
	my ($self, $odds, $stake) = @_;
	$stake //= 1;

	my $bets = scalar @$odds;
	my $unit_stake = $stake / $self->{full_cover}->{$bets};
	my $first = 1;
	
	for my $next (@$odds) {
		$first *= $next + 1;
	}
	return sprintf "%.2f", $unit_stake * ($first - 1);
}

=head
#use List::Util qw(any);
#use ComboGen;
#use Data::Dumper;

	$self->{dispatch} = {
		2 => \&doubles,
		3 => \&trebles,
		4 => \&four_fold,
		5 => \&five_fold,
		6 => \&six_fold,
		7 => \&seven_fold,
		8 => \&eight_fold,
	};

	sub _get_odds {
	my ($obj, $odds) = @_;
	my @iter_vals = ();
	
	for my $i (0..$obj->selections () - 1) {
		push (@iter_vals, $obj->index ($i));
	}
		
	my @odds_array = ();
	for my $i (@iter_vals) {
		push (@odds_array, @$odds[ $i ]);
	}
	return (\@odds_array, \@iter_vals);
}

sub _get_result_array {
	my ($size, $iterator_vals) = @_;
	my @result_array = ();

# Loop through 0 to size-1, check if each value is in the values returned
# from the iterator, if so this postion in the array is a win, if not a loss	
	for my $i (0..$size - 1) {
		push (@result_array,
			(any { $_ == $i } @$iterator_vals )
				? 'W' : 'L');
	}
	return \@result_array;
}

sub _print_result_array {
	my $result_array = shift;
	print "\n";
	print $_ for @$result_array;
	print " = ";
}
	
sub _multi {
	my ($self, $odds, $stake) = @_;
	$stake //= 1;
	
	my $wins = {};
	my $size = scalar (@$odds);
	my $total_bets = $self->{total_bets}->{$size};
	my $win_total = 0;

	for my $selections (2..$size) {
		my $gen = ComboGen->new ($selections, $size);

		$gen->{onIteration} = sub {
			my $obj = shift;
			my ($odds_array, $iterator_vals) = _get_odds ($obj, $odds);
			my $result_array = _get_result_array ($size, $iterator_vals);
#			_print_result_array ($result_array);
			
			my $winnings = $self->{dispatch}->{$selections}->($self, $odds_array, $stake / $total_bets);
#			print $winnings;
			$win_total += $winnings;
			$wins->{join('', @$result_array)} = sprintf ("%.2f", $winnings);
		};
	
		$gen->run();
	}
	$wins->{total} = sprintf "%.2f", $win_total;
#	printf "\nTotal win = %-3.2f\n", $win_total;
	return $wins;
}
=cut
=head


sub trixie		{ return _multi (@_); }
sub yankee		{ return _multi (@_); }
sub super_yankee{ return _multi (@_); }
sub heinz		{ return _multi (@_); }
sub super_heinz	{ return _multi (@_); }
sub goliath		{ return _multi (@_); }

sub trixie {
	my ($odds, $stake) = @_;
	$stake //= 1;
	my $results = [ qw(L W) ];
	my $wins = {};
	
	my $size = scalar (@$odds);
	my $total = 0;
	my $it = iterator ($size);
	while ( my $results_array = $it->() ) {
#		print "\n";	print "$_-" for @$results_array;
#		print "\t";	print "@$results[$_]-" for @$results_array;
		my @list;
		push @list, @$results[$_] for @$results_array;
		my $prf = $stake / 4;
		my $winners = grep (/1/, @$results_array);

		if (grep (/1/,@$results_array) > 1) {
			for my $i (0..$size-1) {
				$prf *= @$odds[$i] if @$results_array[$i];
			}
			$total += $prf;
		} else {
			$prf = 0;
		}
#		printf "\t%-3.2f", $prf;
		$wins->{join('',@list)} = sprintf "%.2f", $prf;
	}
#	printf "\nTotal win = %-3.2f\n", $total;
	$wins->{total} = sprintf "%.2f", $total;
	return $wins;
}
=cut
=head
sub trixie {
	my ($odds, $stake) = @_;
	$stake //= 1;
	
	my $results = [ qw(L W) ];
	my $wins = {};
	
	my $size = scalar (@$odds);
	my $total = 0;
#	my @bt = (1.55,1.25,1.85,1.44,2.05);
#	my @bt = (2,4,6,8,10);
	for my $i (2..$size) {
		my $gen = ComboGen->new($i,$size);

		$gen->{onIteration} = sub {
			my $obj = shift;
		
			my @vals = ();
			for my $i (0..$obj->selections () - 1) {
				push (@vals, $obj->index ($i));
			}
			print "\nvals = ";
			print "$_" for (@vals);
		
			my @od = ();
			for my $i (0..$obj->selections () - 1) {
				push (@od, @$odds[ $vals[$i] ]);
			}
			print "\tods = ";
			print "$_," for (@od);

			print "\t";
			my $prf = 0;
			for my $i (0..$obj->selections () - 1) {
				if ($i == 0) {
					$prf += ( ($stake / 4) * $od[$i] );
				} else {
					$prf *= ( ($stake / 4) * $od[$i] );
				}
			}
			printf "\t\$%-3.2f\n", $prf;

			my $it = iterator ($size);
			while ( my $array = $it->() ) {
				print "$_-" for @$array;
				print "@$results[$_]-" for @$array;
				my $prf = 0;
				for my $i (0..$obj->selections ()-1) {
					$prf += $od[$i]*@$array[$i] if @$array[$i];
				}
				printf "\t%-3.2f", $prf;
			}
		};
	
		$gen->run();
	}
	return 1;
}
=cut
=head
sub iterator {
	my $size = shift;
	my $max = (2 ** $size);
	my $count = 0;
	
	return sub {
		return undef if $count == $max;
		return to_binary ($count++, $size);
	}
}

sub to_binary {
	my ($num, $size) = @_;
	my @array = ();
	push (@array, '0') if $num == 0;

	while ($num > 0) {
		my ($quot, $rem) = (int ($num / 2), $num % 2);
		push (@array, $rem);
		$num = $quot;
	}

	my $orig_size = scalar (@array);
	push (@array, '0') while ($size-- > $orig_size);
	return [ reverse @array ];
}
=cut
1;
