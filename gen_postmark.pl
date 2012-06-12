#!/usr/bin/perl

use strict;
use warnings;

my $expfile = shift @ARGV or die "Specify experiement parameter file.";
my $rep = shift @ARGV or die "Specify number of repetitions.";
my $target = shift @ARGV or die "Specify directory under test.";

open (EXPF, "<$expfile") or die "Can't open $expfile";

my @paramNames = split(' ', <EXPF>);
my @paramVal;
while (<EXPF>) {
	chomp ($_);
	push @paramVal, [split(' ', $_)];
}	
close(EXPF);


my $i;
my $j;
for ($i=0; $i < $rep; $i++) {
	for ($j=0; $j < scalar @paramVal; $j++) {
		open (RUNF, ">run/pm_run_" . $j . "_" . $i) or die "Can't open run/pm_run$j" . "_" . "$i";
		print RUNF "set size $paramVal[$j][0] $paramVal[$j][1]\n";
		print RUNF "set number $paramVal[$j][2]\n";
		print RUNF "set transactions 100000\n";
		print RUNF "set read $paramVal[$j][3]\n";
		print RUNF "set write $paramVal[$j][4]\n";
		print RUNF "set buffering $paramVal[$j][5]\n";
		print RUNF "set bias read $paramVal[$j][6]\n";
		print RUNF "set bias create $paramVal[$j][7]\n";
		print RUNF "set subdirectories $paramVal[$j][8]\n";
		print RUNF "set seed ", $i+1, "\n";
		print RUNF "set location $target\n";
		print RUNF "set report terse\n";
		print RUNF "run\n";
		print RUNF "quit\n";
		close (RUNF);
	}
}
	

