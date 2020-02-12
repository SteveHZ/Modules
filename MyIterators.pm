package MyIterators;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK	 = qw (make_iterator make_circular_iterator make_reverse_iterator);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub make_iterator {
    my $array = shift;
    my $size = $#$array;
    my $index = 0;

    return sub {
        return undef if $index > $size;
        return @$array [ $index++ ];
    }
}

sub make_circular_iterator {
    my $array = shift;
    my $size = $#$array;
    my $index = 0;

    return sub {
        $index = 0 if $index > $size;
        return @$array [ $index++ ];
    }
}

sub make_reverse_iterator {
	my $array = shift;
    my $index = $#$array;

	return sub {
		return undef if $index < 0;
		return @$array [ $index-- ];
	}
}

1;
