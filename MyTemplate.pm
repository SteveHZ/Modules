package MyTemplate;

use Mu;
use namespace::clean;

extends 'Template';
ro 'filename' => (required => 1);

sub open_file {
    my $self = shift;
    open my $out_fh, '>:raw', $self->{filename}
        or die "$self->{filename} : $!\n";
    return $out_fh;
}

1;
