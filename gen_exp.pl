#!/usr/bin/perl 

use warnings;
use strict; 

my @pb;

my $pbfile = shift @ARGV or die "Specify PB design file to be used.";
my $lvlfile = shift @ARGV or die "Specify parameter level file.";	
my $expfile = shift @ARGV or die "Specify experiment parameter output file path.";

## READ PB FILE
open (PBF, "<$pbfile") or die "Can't open $pbfile";
while (<PBF>) {

	chomp($_);
	push @pb, [split(' ', $_)];
}
close (PBF);
foreach my $row (@pb) {
	foreach my $val (@$row) {
		printf "%2d ", $val;
	}
	print "\n";
}

## Read parameter level file.	
open (LVF, "<$lvlfile") or die "Can't open $lvlfile";
<LVF>;
my @lvl;
while (<LVF>) {
	chomp ($_);
	push @lvl, [split(' ', $_)];
}
close (LVF);
foreach my $row (@lvl) {
	foreach my $val (@$row) {
		printf "%17s ", $val;
	}
	print "\n";
}


## Check if appropriate PB method is being used.
my $no_param =  scalar @lvl;
my $PB_size = scalar @pb;
die "$PB_size is not correct PB size for $no_param parameters" unless (($no_param+1 <= $PB_size) && ($no_param+1 >= $PB_size-4)) ;
print "Number of parameters: $no_param  PB size: $PB_size\n";


## Generate experiment paramter list
my @expParam;
foreach my $exp(@pb) {
	my @tmp;
	my $i;
	for ($i=0; $i<$no_param; $i++) {
		if (@$exp[$i] eq "-1") {
			push @tmp, $lvl[$i][1];
		}
		else {
			push @tmp, $lvl[$i][2];
		}
	}
	push @expParam, [@tmp];
}
foreach my $row (@expParam) {
	foreach my $val (@$row) {
		printf "%s ", $val;
	}
	print "\n";
}
## Write experiment parameter list to a file
open (EXPF, ">$expfile") or die "Can't open $expfile";
foreach (@lvl) {
	print EXPF "@$_[0] ";
}
print EXPF "\n";
foreach my $row(@expParam) {
	foreach my $val(@$row) {
		print EXPF "$val ";
	}
	print EXPF"\n";
}
close (EXPF);

print "$PB_size experiments created!\n";
