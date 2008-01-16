# $Id$
use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.14";

WriteMakefile
	(
	'NAME'          => 'Palm::Magellan::NavCompanion',
	'ABSTRACT'      => 'access the Magellan GPS Companion waypoints file',
	'VERSION_FROM'  => 'lib/NavCompanion.pm',
	'LICENSE'       => 'perl',
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',

	'PM'            => {
		'lib/NavCompanion.pm'     => '$(INST_LIBDIR)/NavCompanion.pm',
		},

	'PREREQ_PM'      => {
		'Test::More'        => '0',
		'Palm::Raw'         => '0',
		'Palm::StdAppInfo'  => '0',
		},

	'MAN3PODS'       => {
		'lib/NavCompanion.pm' => '$(INST_MAN3DIR)/Palm::Magellan::NavCompanion.3',
		},

	clean => { FILES => 'Palm-Magellan-*' },
	);
