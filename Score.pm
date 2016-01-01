package Score;

use strict;

sub new {
	my $class = shift;
	my ($home, $away) = @_;

	my $self = {
		home => $home,
		away => $away,
	};
	
    bless $self, $class;
    return $self;
}

# class accessors

sub home {
	my $self = shift;
	if (@_) { $self->{home} = shift; }
	return $self->{home};
}

sub away {
	my $self = shift;
	if (@_) { $self->{away} = shift; }
	return $self->{away};
}

sub score {
	my $self = shift;
	return $self->{home}.'-'.$self->{away};
}

sub result {
	my $self = shift;
	
	return 'W' if ($self->{home} > $self->{away});
	return 'L' if ($self->{home} < $self->{away});
	return 'N' if ($self->{home} eq '0');
	return 'D';
}

1;
