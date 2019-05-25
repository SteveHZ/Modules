package TiedIterator;

use strict;
use warnings;

sub TIESCALAR {
    my ($package, $list) = @_;
    return bless {
        iterator => _make_iterator ($list)
    }, $package;
}

sub FETCH {
    my $self = shift;
    return $self->{iterator}->();
}

sub STORE {
    my ($self, $list) = @_;
    $self->{iterator} = _make_iterator ($list);
}

sub _make_iterator {
    my $list = shift;
    my $idx = 0;
    return sub {
        return undef if $idx > $#$list;
        return @$list[$idx++];
    }
}

1;
