#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($version) = 
    (map { m{\$VERSION *= *'([^']+)'} ? ($1) : () } 
    io->file('lib/Test/Count.pm')->getlines()
    )
    ;

if (!defined ($version))
{
    die "Version is undefined!";
}

my $mini_repos_base = 'https://svn.berlios.de/svnroot/repos/web-cpan/Test-Count';

my @cmd = (
    "svn", "copy", "-m",
    "Tagging the Test-Count release as $version",
    "$mini_repos_base/trunk",
    "$mini_repos_base/tags/releases/$version",
);

print join(" ", map { /\s/ ? qq{"$_"} : $_ } @cmd), "\n";
exec(@cmd);

