# $Id$
package Palm::Magellan::NavCompanion;

use strict;

use base qw(Palm::StdAppInfo Palm::Raw Exporter);

use vars qw($VERSION);

use Palm::Raw;
use Palm::StdAppInfo();

$VERSION = 0.1;

our $Creator = "MGtz";
our $Type    = "Twpt";

sub import
	{
	&Palm::PDB::RegisterPDBHandlers( __PACKAGE__, 
		[ $Creator, $Type ] );
	}

sub new
	{
	my $class	= shift;
	my $self	= $class->SUPER::new(@_);
			# Create a generic PDB. No need to rebless it,
			# though.

	$self->{name}    = "MemoDB";	# Default
	$self->{creator} = $Creator;
	$self->{type}    = $Type;
	
	$self->{attributes}{resource} = 0;
				# The PDB is not a resource database by
				# default, but it's worth emphasizing,
				# since MemoDB is explicitly not a PRC.

	# Initialize the AppInfo block
	$self->{appinfo} = {
		sortOrder	=> undef,	# XXX - ?
	};

	# Add the standard AppInfo block stuff
	&Palm::StdAppInfo::seed_StdAppInfo($self->{appinfo});

	# Give the PDB a blank sort block
	$self->{sort} = undef;

	# Give the PDB an empty list of records
	$self->{records} = [];

	return $self;
	}
	
sub new_Record
	{
	my $class = shift;
	my $hash = $class->SUPER::new_Record(@_);

	$hash->{data} = "";

	return $hash;
	}
	
# ParseAppInfoBlock
# Parse the AppInfo block for Memo databases.
sub ParseAppInfoBlock
	{
	warn( "Calling ParseAppInfoBlock" );
	my $self = shift;
	my $data = shift;
	my $sortOrder;
	my $i;
	my $appinfo = {};
	my $std_len;

	# Get the standard parts of the AppInfo block
	$std_len = &Palm::StdAppInfo::parse_StdAppInfo($appinfo, $data);

	warn( "AppInfo length is $std_len" );
	$data = $appinfo->{other};		# Look at the non-category part

	return $appinfo;
	}

sub PackAppInfoBlock
	{
	my $self = shift;
	my $retval;
	my $i;

	# Pack the non-category part of the AppInfo block
	$self->{appinfo}{other} =
		pack("x4 C x1", $self->{appinfo}{sortOrder});

	# Pack the AppInfo block
	$retval = &Palm::StdAppInfo::pack_StdAppInfo($self->{appinfo});

	return $retval;
	}

sub PackSortBlock
	{
	return undef;
	}

require Data::Dumper;
sub ParseRecord
	{
	my $self = shift;
	my %record = @_;

	my @created = ();
	my @unk_time = ();
	my( $latitude, $longitude, $elevation, $plot, $name );
	
	( @created[0..5], undef, @unk_time[0..5], undef, 
		@record{ qw(latitude longitude elevation plot ) },
		undef,
		@record{ qw(name description) },
		) = unpack 's6 s s6 s l l l C C A*', $record{data};

	@record{ qw(creation_sec  creation_min creation_hour) }
		= @created[2,1,0];
	@record{ qw(creation_date creation_mon creation_year) }
		= @created[3,4,5];
		
	$record{'creation_time'} = sprintf "%d:%02d.%02d", @created[2,1,0];
	$record{'creation_date'} = sprintf "%d/%d/%04d",   @created[3,4,5];
		
	@record{ qw(latitude longitude) } = map { $_ / 1e5 }
		@record{ qw(latitude longitude) };
	
	foreach my $key ( qw(data offset id category) )
		{
		delete $record{ $key };
		}
		
	print STDERR Data::Dumper::Dumper( \%record );

	return \%record;
	}

sub PackRecord
	{
	my $self   = shift;
	my $record = shift;

	return $record->{data} . "\0";	# Add the trailing NUL
	}

1;