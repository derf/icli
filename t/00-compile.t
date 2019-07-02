#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Test::More;
use Test::Compile;

my $test = Test::Compile->new();
$test->all_files_ok('bin/icli');
$test->done_testing();
