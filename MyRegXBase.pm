package MyRegXBase;

use Moo;
use namespace::clean;

sub upper { qr/[A-Z]/; }
sub lower {	qr/[a-z]/; }
sub alpha { qr/[A-Za-z]/; }
sub numeric { qr/\d/; }

sub time { qr/\d{2}:\d{2}/; }
sub dmy_date { qr/\d{2}\/\d{2}\/\d{2}/; }
sub dm_date { qr/\d{2}\/\d{2}/; }

1;
