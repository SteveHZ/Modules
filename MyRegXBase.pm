package MyRegXBase;

use Moo;
use namespace::clean;

sub upper { qr/[A-Z]/; }
sub lower {	qr/[a-z]/; }
sub alpha { qr/[A-Za-z]/; }
sub numeric { qr/\d/; }

sub time {
qr/
    \d{2}:          # hours :
    \d{2}           # minutes eg 15:00
/x;
}

sub dm_date {
qr/
    \d{2}\/         # date
    \d{2}           # month
/x;
}

sub dmy_date {
qr/
    \d{2}\/         # date
    \d{2}\/         # month
    \d{2}           # 2-digit year
/x;
}

sub full_dmy_date {
qr/
    \d\d\/          # date
    \d\d\/          # month
    \d\d\d\d        # 4-digit year
/x;
}

1;
