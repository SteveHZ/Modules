package Team;

use strict;

use Score;

my $stats_size = 12;

sub new {
    my $this = shift;
    my $class = ref ($this) || $this;
	my ($tmno, $ref) = @_;
	my $self = {
		teamNo => $tmno,
		homes => _homes ($ref),
		aways => _aways ($ref),
	};
	
    bless $self, $class;
    return $self;
}

# private methods

sub _homes {
	my ($ref) = @_;
	my $array = [];
	
	for (my $i = 0; $i < $stats_size / 2; $i++) {
		my ($h, $a) = split (/-/, @$ref [$i]);
		push ($array, Score->new ($h, $a));	
	}
	return $array;
}

sub _aways {
	my ($ref) = @_;
	my $array = [];
	
	for (my $i = $stats_size / 2; $i < $stats_size; $i++) {
		my ($h, $a) = split (/-/, @$ref [$i]);
		push ($array, Score->new ($h, $a));	
	}
	return $array;
}

# class accessors

sub teamNo {
	my $self = shift;
	if (@_) { $self->{teamNo} = shift; }
	return $self->{teamNo};
}

sub homes {
	my $self = shift;
	if (@_) { $self->{stats} = @_;}
	return $self->{homes};
}

sub aways {
	my $self = shift;
	if (@_) { $self->{stats} = @_;}
	return $self->{aways};
}

sub csvStats {
	my ($self, $str) = @_;
	my $i;
	
	for ($i = 0;$i < $stats_size / 2;$i++) {
		push (@$str,$self->{homes}[$i]->score ());
		push (@$str,",");
	}
	for ($i = 0;$i < $stats_size / 2;$i ++) {
		push (@$str,$self->{aways}[$i]->score ());
		push (@$str,",");
	}
	pop ( @{$str} );
	return $str;
}

sub stats {
	my ($self, $str) = @_;
	my $i;
	
	for ($i = 0;$i < $stats_size / 2;$i++) {
		push (@$str,$self->{homes}[$i]->score ());
	}
	for ($i = 0;$i < $stats_size / 2;$i ++) {
		push (@$str,$self->{aways}[$i]->score ());
	}
	return $str;
}

1;
