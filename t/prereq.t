# $Id$

use Test::More;
eval "use Test::Prereq 1.00";
plan skip_all => "Test::Prereq 1.00 required for testing POD" if $@;
prereq_ok();