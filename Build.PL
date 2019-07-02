#!/usr/bin/env perl

use strict;
use warnings;
use Module::Build;


# defaults at the end
my @object_paths = (
	'/var/cache/icinga2/objects.cache',
	'/var/cache/icinga/objects.cache',
);
my @status_paths = (
	'/var/cache/icinga2/status.dat',
	'/var/lib/icinga/status.dat',
);
my @command_paths = (
	'/var/run/icinga2/cmd/icinga.cmd',
	'/var/lib/icinga/rw/icinga.cmd',
);

my $build = Module::Build->new(
	build_requires => {
		'Test::More' => 0,
		'Test::Compile' => "1.3.0",
		'Test::Pod' => 0,
		'Test::Command' => 0,
	},
	configure_requires => {
		'Module::Build' => 0.40,
	},
	config_data => {
		object_file => '/var/cache/icinga/objects.cache',
		status_file => '/var/lib/icinga/status.dat',
		command_file => '/var/lib/icinga/rw/icinga.cmd',
	},
	module_name => 'App::Icli',
	license => 'unrestricted',
	requires => {
		'perl' => '5.10.0',
		'Carp' => 0,
		'DateTime' => 0,
		'DateTime::Format::Strptime' => 0,
		'DateTime::TimeZone' => 0,
		'Getopt::Long' => 0,
		'JSON' => 0,
		'List::MoreUtils' => 0,
		'LWP::UserAgent' => 0,
		'Net::Netrc' => 0,
		'POSIX' => 0,
		'Term::ANSIColor' => 0,
		'Term::Size' => 0,
	},
	script_files => 'bin/',
	sign => 1,
	test_types => {
		author => '.at',
	},
	meta_merge => {
		resources => {
			repository => 'https://github.com/derf/icli'
		}
	},
);

print <<'EOF';

-----------------------------------------------------------------------

Note: To work with an Icinga installation, icli needs to know the path to
three files:
* objects.cache (icinga.cfg object_cache_file)
* status.dat (icinga.cfg status_file)
* icinga.cmd (icinga.cfg command_file)

If you are building interactively and the default values for these paths
do not exist, you will be asked for them -- hit return to keep the default.
In a non-interactive build, the defaults will be used (unless changed using
an option, see below).

If you need to set them regardless of the build host, do not wish to be
promited at all, or are using a non-interactive build process (perhaps even
for a whole distribution), you can set them using the following options:
perl Build.PL --icli-object-file=.../objects.cache \
              --icli-status-file=.../status.dat \
              --icli-command-file=.../icinga.cmd

-----------------------------------------------------------------------

EOF

if ($build->args('icli-object-file')) {
	$build->config_data(object_file => $build->args('icli-object-file'));
}
else {
	for my $path (@object_paths) {
		if (not -e $build->config_data('object_file')) {
			$build->config_data(object_file => $path);
		}
	}
	if (not -e $build->config_data('object_file')) {
		my $reply = $build->prompt('Enter location of Icinga objects.cache',
			$build->config_data('object_file'));
		$build->config_data(object_file => $reply);
	}
}

if ($build->args('icli-status-file')) {
	$build->config_data(status_file => $build->args('icli-status-file'));
}
else {
	for my $path (@status_paths) {
		if (not -e $build->config_data('status_file')) {
			$build->config_data(status_file => $path);
		}
	}
	if (not -e $build->config_data('status_file')) {
		my $reply = $build->prompt('Enter location of Icinga status.dat',
			$build->config_data('status_file'));
		$build->config_data(status_file => $reply);
	}
}

if ($build->args('icli-command-file')) {
	$build->config_data(command_file => $build->args('icli-command-file'));
}
else {
	for my $path (@command_paths) {
		if (not -e $build->config_data('command_file')) {
			$build->config_data(command_file => $path);
		}
	}
	if (not -e $build->config_data('command_file')) {
		my $reply = $build->prompt('Enter location of Icinga command pipe',
			$build->config_data('command_file'));
		$build->config_data(command_file => $reply);
	}
}

$build->create_build_script();
