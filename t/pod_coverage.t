# $Id$

use Test::More;
eval "use Test::Pod::Coverage";

if( $@ )
	{
	plan skip_all => "Test::Pod::Coverage required for testing POD";
	}
else
	{
	plan tests => 1;

	pod_coverage_ok( "Palm::Magellan::NavCompanion",
		{
		trustme => [ qr/^Pa*/, qr/new_/ ],
		},
		);      
	}
