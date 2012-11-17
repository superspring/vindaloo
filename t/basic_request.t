#!/usr/bin/env perl

use strict;
use warnings;
use lib qw{ ./t/lib };

use Test::More  tests => 1;
use Test::Routine::Util;

run_tests(
    'Test basic request to web app',
    [qw/Test Test::CheckEnv Test::Basic /]
);
