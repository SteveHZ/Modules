package MyLib;

#	MyLib.pm 05/04/16

use MyHeader;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK	 = qw (prompt wordcase unique sort_HoA where all_pass date_where multi_where qk each_array multi_array
				   is_empty_array is_empty_hash build_aoh partition var_precision read_file write_file);
%EXPORT_TAGS = (all => \@EXPORT_OK);

#sub prompt ($str, $prompt = '>') {
sub prompt {
	my ($str, $prompt) = @_;
	$prompt //= '>';

	print "\n$str $prompt ";
	chomp (my $in = <STDIN>);
	return $in;
}

sub wordcase {
	my $str = shift;
	return join ' ', map { ucfirst } split ' ', $str;
}

sub unique {
	my $args = { order => "asc", @_ };

	my $sort_func = ($args->{order} eq "asc") ?
		sub { $a cmp $b } : sub { $b cmp $a };

	my %temp = map { $_->{$args->{field}}  => 1 } $args->{db}->@*;
	return [ sort $sort_func keys %temp ];
}

sub where {
	my $args = { order => "asc", @_ };

	my $sort_func = ($args->{order} eq "asc") ?
		sub { $a->{ $args->{sort_by} } cmp $b->{ $args->{sort_by} } } :
		sub { $b->{ $args->{sort_by} } cmp $a->{ $args->{sort_by} } };

	return [
		sort $sort_func
		grep { $_->{ $args->{field} } eq $args->{data} }
		$args->{db}->@*
	];
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
		} $args->{db}->@*
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
		grep { $_->{ $args->{field} } eq $args->{data} }
		$args->{db}->@*
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
			sort { $a cmp $b } $toSort->{$key}->@*
		];
	}
	return $sorted;
}

sub all_pass {
	return 0 if !@_ ;
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

	return { map { $_ => $value } @$list };
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
		return map { @$arrays[$_]->[$idx] } (0..$num_args);
	}
}

sub is_empty_array {
    my $arrayref = shift;
	return ($#$arrayref == -1) ? 1 : 0;
}

sub is_empty_hash {
	my $hashref = shift;
	return (keys %$hashref == 0) ? 1 : 0;
}

#   Build an array of hashes where the key/values of each hash
#   are each successive element of the two arrays passed in.
#	Given an array of $keys and an array of $values,
#	creates an array of $key => $value hashes.

#   For example,
#   my @first = qw(1 2 3 4 5);
#   my @second = qw(6 7 8 9 10);
#   returns
#   [ { '1' => '6' }, { '2' => '7' }, { '3' => '8' }, { '4' => '9' }, { '5' => '10' } ];

sub build_aoh ($first, $second) {
	use MyIterators qw(make_iterator);
    my $it = make_iterator ($second);
    return [
        map { { $_ => $it->() } } @$first
    ];
}

#	partition an array into seperate arrays of true/false values based
#	on $code parameter.
#   $code must return a true/false value which indexes into $results
#   thereby producing arrays of true and false values respectively
#	List::Util::part is approx 3x quicker, see perl/partition.t

sub partition :prototype(&$) {
	use List::MoreUtils qw(part);
    my ($code, $list) = @_;
	my @parts = part { $code->($_) } @$list;
	return ($parts[1], $parts[0]); # true, false
}

#	Allow a variable-length precision in (s)printf for floating point numbers, removing unwanted zeros

sub var_precision {
	use List::Util qw(min);
    my ($num, $max) = @_;
    $max //= 2;

    return 0 if index ($num,'.') == -1;						# no decimal point, use zero precision
    $num =~ s/.*\.//;										# remove everything before and including decimal point
	$num =~ s/0.*$//;										# remove trailing zeros
	return min (length ($num), $max);						# return number of non-zero digits found, up to $max
}

sub read_file {
	my $filename = shift;
	my @lines = ();
	my $line;

	open my $fh, '<', $filename or die "Can't find $filename";
	while ($line = <$fh>) {
		push @lines, $line;
	}
	close $fh;
	return \@lines;
}

sub write_file {
	my ($filename, $lines) = @_;

	open my $fh, '>', $filename or die "Unable to open $filename";
	for my $line (@$lines) {
		print $fh "$line";
	}
	close $fh;
}

1;
