#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

# We need commas in our qw list, they're not accidental
no warnings 'qw';

use Test::Command tests => (38*3);

my $icli = 'bin/icli -f t/in/status.dat -c t/in/objects.cache';

my $EMPTY = q{};

my $cmd = Test::Command->new(cmd => $icli);

sub run_filter_test {
	my ($prefix, $run, $filter) = @_;

	my $file = $filter;
	$file =~ tr/,//d;
	$file =~ tr/!/./;

	$cmd = Test::Command->new(cmd => "$icli $run -z $filter");
	$cmd->exit_is_num(0);
	$cmd->stdout_is_file("t/out/${prefix}_${file}");
	$cmd->stderr_is_eq($EMPTY);
}

$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/standard');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -V");
$cmd->exit_is_num(0);
$cmd->stdout_like(qr{ ^ icli \s version \s \S+ $ }x);
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh -g local");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/hosts_group_local');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh -z!o");
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

$cmd = Test::Command->new(cmd => "$icli -ls -z!o");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/services_short');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls -h steel.derf0.net");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_services_single');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lh -v");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_hosts_v');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -ls -v");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_services_v');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lq");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_queue');
$cmd->stderr_is_eq($EMPTY);

$cmd = Test::Command->new(cmd => "$icli -lq -h aneurysm");
$cmd->exit_is_num(0);
$cmd->stdout_is_file('t/out/list_queue_aneurysm');
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

for my $filter (qw(
	A
	!A,!o
	c
	D
	!o
	!o,!A,!D
	S
	u
	w
	))
{
	run_filter_test('filter', q{}, $filter);
}

for my $filter (qw(
	d
	!o
	S
	S,!x,!A
	x
	))
{
	run_filter_test('h_filter', '-lh', $filter);
}


$icli = "bin/icli -f t/in/status.dat.weird.1 -c t/in/objects.cache";

$cmd = Test::Command->new(cmd => $icli);
$cmd->exit_is_num(0);
$cmd->stdout_is_eq($EMPTY);
$cmd->stderr_is_eq("Unknown field in t/in/status.dat.weird.1: bork\n");

$icli = "bin/icli -f t/in/status.dat.weird.2 -c t/in/objects.cache";

$cmd = Test::Command->new(cmd => "$icli -lh -h alpha");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq('alpha                           ');
$cmd->stderr_is_eq("Unknown host state: 23\n");

$cmd = Test::Command->new(cmd => "$icli -ls -h aneurysm");
$cmd->exit_isnt_num(0);
$cmd->stdout_is_eq('Disk: /             ');
$cmd->stderr_is_eq("Unknown service state: 23\n");
