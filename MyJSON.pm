package MyJSON;

#	MyJSON.pm 06/01/16 v1.1 13/08/19

use strict;
use warnings;
use JSON -support_by_pp;
#use JSON::MaybeXS;
#use Cpanel::JSON::XS;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK	 = qw (read_json write_json my_encode_json);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub read_json {
	my $filename = shift;
    local $/; # end of record character

    open my $fh, '<', $filename or die "\n\n Can't open $filename for reading !!!\nReason : $!";
    my $json_text = <$fh>;
    close $fh;

	return decode_json $json_text;
}

sub write_json {
    my ($filename, $data, $indent) = @_;
	$indent //= 4;

	my $json = JSON->new;
	my $pretty_print = $json->pretty->indent_length ($indent)->encode ($data);

    open my $fh, '>', $filename or die "\n\n Can't open $filename for writing !!!\nReason : $!";
    print $fh $pretty_print;
    close $fh;
}

#	added 05/12/22
#	https://github.polettix.it/ETOOBUSY/2022/11/29/json-pppp/

use v5.10; # state

sub my_encode_json {
	state $encoder = JSON->new->utf8->canonical->pretty;
	return $encoder->encode ($_[0]);
}

=head

# original version

use strict;
use JSON -support_by_pp;
use warnings;

use Exporter 'import';
use vars qw (@EXPORT_OK %EXPORT_TAGS);

@EXPORT_OK	 = qw (read_json write_json);
%EXPORT_TAGS = (all => \@EXPORT_OK);

sub read_json {
	my $filename = shift;
    local $/; # end of record character

    open (my $fh, '<', $filename) or die "\n\n Can't open $filename for reading !!! - $!";
    my $json_text = <$fh>;
    close $fh;

	return decode_json ($json_text);
}

sub write_json {
    my ($filename, $data, $indent) = @_;
	$indent //= 4;

    my $json = JSON->new;
	my $pretty_print = $json->pretty->indent_length ($indent)->encode ($data);

    open (my $fh, '>', $filename) or die "\n\n Can't open $filename for writing !!!\nReason is $!";
    print $fh $pretty_print;
    close $fh;
}
=cut

1;
