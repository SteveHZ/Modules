package MyJSON;

#	MyJSON.pm 06/01/16

use strict;
use warnings;
use JSON -support_by_pp;

use Exporter 'import';
use vars qw ($VERSION @EXPORT_OK %EXPORT_TAGS);

$VERSION	 = 1.00;
@EXPORT_OK	 = qw (read_json write_json);  # symbols to export on request
%EXPORT_TAGS = ( All => [qw (&read_json &write_json)]);

sub read_json {
	my $filename = shift;
    local $/; # end of record character

    open (my $fh, '<', $filename) or die "\n\n Can't open $filename for reading !!!";
    my $json_text = <$fh>;
    close $fh;

	return decode_json ($json_text);
}

sub write_json {
    my ($filename, $data, $indent) = @_;
	$indent //= 4;
	
    my $json = JSON->new;
	my $pretty_print = $json->pretty->indent_length ($indent)->encode ($data);

    open (my $fh, '>', $filename) or die "\n\n Can't open $filename for writing !!!";
    print $fh $pretty_print;
    close $fh;
}

1;
