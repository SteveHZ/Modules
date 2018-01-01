package Roles::MyJSON;

#	Roles::MyJSON.pm 04/05/16

use Moo::Role;
use JSON -support_by_pp;

sub read_json {
	my ($self, $filename) = @_;
    local $/; # end of record character

    my $json = JSON->new;
	
    open (my $fh, '<', $filename) or die "\n\n Can't open $filename for reading !!!";
    my $json_text = <$fh>;
    close $fh;
	return $json->decode ($json_text);
}

sub write_json {
    my ($self, $filename, $data, $indent) = @_;
	$indent //= 4;

    my $json = JSON->new;
	my $pretty_print = $json->pretty->indent_length ($indent)->encode ($data);

	open (my $fh, '>', $filename) or die "\n\n Can't open $filename for writing !!!";
	print $fh $pretty_print;
    close $fh;
}

#	$json = $json->allow_blessed ();
#	$json = $json->convert_blessed ();
#	$json = $json->allow_nonref ();

1;
