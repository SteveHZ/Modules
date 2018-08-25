#	MyRegX.t 17/06/18

use strict;
use warnings;
use Test::More tests => 11;

use lib "C:/Mine/perl/Modules";
use MyRegX;

my $rx = MyRegX->new ();

subtest 'constructor' => sub {
	plan tests => 1;
	isa_ok ($rx, 'MyRegX', '$rx');
};

subtest 'time' => sub {
	plan tests => 2;
	like ('21:12', $rx->time, 'like time');
	unlike ('Ru:sh', $rx->time, 'unlike time');
};

subtest 'team' => sub {
	plan tests => 2;
	like ('Rushden & Diamonds', $rx->team, 'like team');
	unlike ('1860', $rx->team, 'unlike team');
};

subtest 'dmy_date' => sub {
	plan tests => 2;
	like ('17/06/2018', $rx->dmy_date, 'like dmy_date');
	unlike ('17/06', $rx->dmy_date, 'unlike dmy_date');
};

subtest 'dm_date' => sub {
	plan tests => 2;
	like ('17/06', $rx->dm_date, 'like dm_date');
	unlike ('17-06-2018', $rx->dm_date, 'unlike dm_date');
};

subtest 'odds' => sub {
	plan tests => 2;
	like ('1.50', $rx->odds, 'like odds');
	unlike ('10.5', $rx->odds, 'unlike odds');
};

subtest 'score' => sub {
	plan tests => 4;
	like ('2:0', $rx->score, 'like score 2:0');
	like ('2:10', $rx->score, 'like score 2:10');
	like ('12:0', $rx->score, 'like score 12:0');
	unlike ('2-0', $rx->score, 'unlike score');
};

subtest 'as_date_month' => sub {
	plan tests => 2;
	is ($rx->as_date_month ('2018-06-23'), '23/06', 'date_month is 23/06');
	isnt ($rx->as_date_month ('2018-06-23'), '06/23', qq(date_month isn't 06/23));
};

subtest 'as_dmy' => sub {
	plan tests => 2;
	is ($rx->as_dmy ('2018-06-23'), '23/06/18', 'dmy is 23/06/18');
	isnt ($rx->as_dmy ('2018-06-23'), '18/06/23', qq(dmy isn't 18/06/23));
};

subtest 'date' => sub {
	plan tests => 2;
	like ('23 June 2018', $rx->date, 'like date');
	unlike ('23/06/18', $rx->date, 'unlike date');
};

subtest 'yesterdays_date' => sub {
	plan tests => 2;
	like ('Yesterday 23 June', $rx->yesterdays_date, 'like yesterdays_date');
	unlike ('Today 23 June', $rx->yesterdays_date, 'unlike yesterdays_date');
};
