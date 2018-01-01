package MyCombs;

use strict;
use warnings;
use List::Util qw(any);
use ComboGen;

use Exporter 'import';
use vars qw ($VERSION @EXPORT_OK %EXPORT_TAGS);

$VERSION	 = 1.00;
@EXPORT_OK	 = qw (iterator to_binary singles doubles trebles trixie);  # symbols to export on request
%EXPORT_TAGS = ( All => [qw (&iterator &to_binary &singles &doubles &trebles &trixie)]);


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

sub singles		{ return _acca_calc (@_); }
sub doubles		{ return _acca_calc (@_); }
sub trebles		{ return _acca_calc (@_); }
sub four_fold	{ return _acca_calc (@_); }
sub five_fold	{ return _acca_calc (@_); }
sub six_fold	{ return _acca_calc (@_); }
sub seven_fold	{ return _acca_calc (@_); }
sub eight_fold	{ return _acca_calc (@_); }

sub _acca_calc {
	my ($odds, $stake) = @_;
	$stake //= 1;

	$stake *= $_ for @$odds;
	return sprintf "%.2f", $stake;
}

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
	my ($size, $iter_vals) = @_;
	my @result_array = ();
			
	for my $i (0..$size - 1) {
		push (@result_array,
			(any { $_ == $i } @$iter_vals )
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
	
sub trixie {
	my ($odds, $stake) = @_;
	$stake //= 1;
	
	my $results = [ qw(L W) ];
	my $wins = {};
	my $size = scalar (@$odds);
	my $total = 0;

	for my $i (2..$size) {
		my $gen = ComboGen->new ($i, $size);

		$gen->{onIteration} = sub {
			my $obj = shift;
			my ($odds_array, $iter_vals) = _get_odds ($obj, $odds);
			my $result_array = _get_result_array ($size, $iter_vals);
			_print_result_array ($result_array);
			
			my $winnings = ($i == 2) ?  doubles ($odds_array, $stake / 4) : 
										trebles ($odds_array, $stake / 4);
			print $winnings;
			$total += $winnings;
			$wins->{join('', @$result_array)} = sprintf ("%.2f", $winnings);
		};
	
		$gen->run();
	}
	$wins->{total} = sprintf "%.2f", $total;
	printf "\nTotal win = %-3.2f\n", $total;
	return $wins;
}

=head
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
1;
