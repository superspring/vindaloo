#!/usr/bin/env perl

use lib qw{ ./t/lib };

use Test::Routine::Util;
use Test::More tests => 1;

run_tests("Admin navigate to accounts interface.",
    [qw/Test Test::CheckEnv Test::Admin Test::Users Test::Logout /]
);

