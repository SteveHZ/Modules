#	MyJSON6.pm 30/07/16

use JSON::Fast;

role MyJSON6 {
	method read_json ($file) {
		my @data := from-json slurp $file;
		return @data;
	}

	method write_json($file, $data, $spacing = 4) {
		spurt $file, to-json $data, :spacing($spacing);
	}
}
