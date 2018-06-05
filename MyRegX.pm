package MyRegX;

use Moo;
use namespace::clean;

# fixtures.pl
sub upper { qr/[A-Z]/; }
sub lower {	qr/[a-z]/; }
sub numeric { qr/\d/; }

sub time { qr/\d{2}:\d{2}/; }
sub dmy_date { qr/\d\d\/\d\d\/\d\d/; }

# oddsp.pl
sub score { qr/(\d\d?):(\d\d?)/; }
sub team { qr/[A-Za-z\& \.]/; }
sub odds { qr/\d+\.\d{2}/; }
sub date { 
	qr/
		(?<date>\d{2})\s
		(?<month>\w+)\s
		(?<year>\d{4})
	/x;
}

sub yesterdays_date {
	qr/
		Yesterday\W+
		(?<date>\d{2})\s
		(?<month>\w{3})
	/x;
}

1;