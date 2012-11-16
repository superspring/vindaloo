#!/usr/bin/env perl

use lib qw{ ./t/lib };

use Test::Routine::Util;
use Test::More tests => 1;

run_tests(
    "Test access to non authorised urls.",
    [qw/Test Test::Basic Test::Hack/]
);
