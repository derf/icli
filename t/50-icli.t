#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Test::Command tests => (19*3);

my $icli = 'bin/icli -f t/in/status.dat -c t/in/objects.cache';

my $EMPTY = q{};

my $cmd = Test::Command->new(cmd => $icli);

$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/standard');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh -g local");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/hosts_group_local');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh -s");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/hosts_short');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls -h steel-vpn,steel.derf0.net");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/host_steel_steel');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_hosts');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh -C");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_hosts_nc');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_services');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls -C");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_services_nc');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls -g local");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/services_group_local');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh -g derf-remote,http-servers");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/hosts_group_reduce');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls -s");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/services_short');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls -h steel.derf0.net");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_services_single');
$cmd->stderr_is_eq($EMPTY);


$cmd = Test::Command->new(cmd => "$icli -g invalid");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("Unknown hostgroup: invalid\n");

$cmd = Test::Command->new(cmd => "$icli -h invalid");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("Unknown host: invalid\n");

$cmd = Test::Command->new(cmd => "$icli -lh -h invalid");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("Unknown host: invalid\n");

$cmd = Test::Command->new(cmd => "$icli -l INVALID");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("See perldoc -F bin/icli\n");


$icli = "bin/icli -f t/in/status.dat.weird.1 -c t/in/objects.cache";

$cmd = Test::Command->new(cmd => $icli);
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("Unknown field in t/in/status.dat.weird.1: bork\n");

$icli = "bin/icli -f t/in/status.dat.weird.2 -c t/in/objects.cache";

$cmd = Test::Command->new(cmd => "$icli -lh -h alpha");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("Unknown host state: 23\n");

$cmd = Test::Command->new(cmd => "$icli -ls -h aneurysm");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("Unknown service state: 23\n");
