package MyLib;

#	MyLib.pm 05/04/16

use strict;
use warnings;

use Exporter 'import';
use vars qw ($VERSION @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@EXPORT_OK	 = qw (unique sort_HoA where all_pass date_where multi_where qk prompt each_array multi_array);  # symbols to export on request
%EXPORT_TAGS = ( All => [qw (&unique &sort_HoA &where &all_pass &date_where &multi_where &qk &prompt &each_array &multi_array)]);

sub unique {
	my $hash = { order => "asc", @_ };

	my $sort_func = ($hash->{order} eq "asc") ?
		sub { $a cmp $b } : sub { $b cmp $a };

	return sort $sort_func
		keys %{{ map { $_->{$hash->{field}}  => 1 } @{$hash->{db}} }};
}

sub where {
	my $args = { order => "asc", @_ };

	my $sort_func = ($args->{order} eq "asc") ?
		sub { $a->{ $args->{sort_by} } cmp $b->{ $args->{sort_by} } } :
		sub { $b->{ $args->{sort_by} } cmp $a->{ $args->{sort_by} } };

	return sort $sort_func
		grep { $_->{ $args->{field} } eq $args->{data} } @{ $args->{db} };
}

sub multi_where {
	my $args = { order => "asc", @_ };

	my $sort_func = ($args->{order} eq "asc") ?
		sub { $a->[1] <=> $b->[1] } :
		sub { $b->[1] <=> $a->[1] };

	return [
		map  { $_->[0] }
		sort $sort_func
		map  { [ $_, _getdate( $_->{date} ) ] }
		grep {
			$_->{ $args->{fields}[0] } eq $args->{data} or
			$_->{ $args->{fields}[1] } eq $args->{data}
		} @{ $args->{db} }
	];
}

sub date_where {
	my $args = { order => "asc", @_ };

	my $sort_func = ($args->{order} eq "asc") ?
		sub { $a->[1] <=> $b->[1] } :
		sub { $b->[1] <=> $a->[1] };

	return [
		map  { $_->[0] }
		sort $sort_func
		map  { [ $_, _getdate( $_->{date} ) ] }
		grep { $_->{ $args->{field} } eq $args->{data} } @{ $args->{db} }
	];
}

sub _getdate {
	my $date = shift;
	my ($day, $month, $year) = split ('/', $date);
	my $century = ($year > 80) ? 19 : 20;
	return "$century$year$month$day";
}

sub sort_HoA {
	my $toSort = shift;
	my $sorted = {};

#	get each key, sort each key in array context
#	then save to a new anonymous array

	for my $key (keys %$toSort) {
		$sorted->{$key} = [ 
			sort { $a cmp $b } @{ $toSort->{$key} }
		];
	}
	return $sorted;
}

sub all_pass {
	my @functions = @_;

	return sub {
		for my $test (@functions) {
            return 0 unless $test->($_[0]);
		}
		return 1;
	};
}

# mimic a quote-key (qk) operator
sub qk {
	my ($list, $value) = @_;
	$value //= 1;

	my %hash = map {$_ => $value} @$list;
	return \%hash;
}

sub prompt {
	my $str = shift;
	print "$str > ";
	chomp (my $in = <STDIN>);
	return $in;
}

sub each_array {
	my ($array1, $array2) = @_;
	my $size = scalar @$array1;
	my $idx = -1;

	return sub {
		return () if ++$idx == $size;
		return ( @$array1[$idx], @$array2[$idx] );
	}
}

sub multi_array {
	my $arrays = \@_;
	my $num_args = scalar $#$arrays;
	my $array_size = scalar @{$_[0]};
	my $idx = -1;

	return sub {
		return () if ++$idx == $array_size;
		my @list;
		push @list, @$arrays[$_]->[$idx] for (0..$num_args);
		return @list;
	}
}

1;