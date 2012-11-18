#!/usr/bin/env perl

use lib qw{ ./t/lib };

use Test::More tests => 1;
use Test::Routine::Util;

run_tests("Test logging into application.",
    [qw/Test Test::CheckEnv Test::Admin/]);
