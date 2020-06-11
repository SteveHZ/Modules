package MyTemplate;

use Mu;
use namespace::clean;

extends 'Template';
ro 'filename' => (required => 1);
ro 'template' => (required => 1);
ro 'data' => (required => 1);

#   To set an absolute path in code using this package eg template => "c:/mine/..."
#   add ABSOLUTE => 1 in call to constructor

sub write_file {
    my $self = shift;
    my $fh = $self->open_file ();
    $self->process_file ($fh);
    $self->close_file ($fh);
}

sub open_file {
    my $self = shift;
    open my $out_fh, '>:raw', $self->{filename}
        or die "$self->{filename} : $!\n";
    return $out_fh;
}

sub process_file {
    my ($self, $fh) = @_;
    $self->process ( $self->template, {
        data => $self->data,
    }, $fh) or die $self->error;
    return $fh;
}

sub close_file {
    my ($self, $fh) = @_;
    close $fh;
}

=pod

=head1 NAME

Modules/MyTemplate.pl

=head1 SYNOPSIS

use MyTemplate

=head1 DESCRIPTION

Module to simplify Template Toolkit usage

=head1 AUTHOR

Steve Hope

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
