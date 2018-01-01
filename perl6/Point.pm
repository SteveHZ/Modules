#	Point.pm

use MyJSON6;

class Point is rw does MyJSON6 {
	subset PointLimit of Real where -10.0 .. 10.0; 
	has PointLimit $.x;
	has PointLimit $.y;

	method print {
		say "Point is at locations: ", $!x ~" and "~ $!y;
	}
	
	method read_from ($file) returns Point {
		my @list = self.read_json($file);
		return self.new( x => @list[0],
						 y => @list[1],
		);
	}

	method write_to ($file) {
		self.write_json($file,($!x, $!y) );
	}
}
