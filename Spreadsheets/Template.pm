package Spreadsheets::Template;

#	Spreadsheets::Template.pm 
#	v1.0 12-13/12/16

use List::MoreUtils qw(each_arrayref);
use Moo;
use namespace::clean;

sub BUILD {
	my ($self, $args) = @_;

	$self->{values} = [];
	$self->{formats} = [];
	$self->{dispatch} = [
		sub { my ($hash, $strs) = @_; return $hash->{ @$strs[0] }; },
		sub { my ($hash, $strs) = @_; return $hash->{ @$strs[0] }->{ @$strs[1] }; },
		sub { my ($hash, $strs) = @_; return $hash->{ @$strs[0] }->{ @$strs[1] }->{ @$strs[2] }; },
		sub { my ($hash, $strs) = @_; return $hash->{ @$strs[0] }->{ @$strs[1] }->{ @$strs[2] }->{ @$strs[3] }; },
	];

	open my $fh, '<', $args->{file} or die "Can't find $args->{file}";
	while (my $line = <$fh>) {
		next if $line eq "\n";
		my $temp = [ split ',', $line ];
		push @{ $self->{values} },  [ split '\.', @$temp[0] ];
		push @{ $self->{formats} }, @$temp[1];
	}
	close $fh;
}

sub map {
	my ($self, $hash) = @_;
	my @row_data = ();

	my $iterator = each_arrayref ($self->{values}, $self->{formats});
	while (my ($value, $format) = $iterator->() ) {
		my $cell_data = $self->{dispatch}->[ scalar(@$value)-1 ]->($hash, $value) ;
		$format =~ s/^\s//; # remove any initial whitespace
		chomp $format;
		push @row_data, { $cell_data => $format };
	}
	return \@row_data;
}

1;