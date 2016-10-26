#!/usr/local/bin/perl
# Mike McQuade
# Reads-contigs.pl
# Generates contigs from a selection of reads.

# Define the packages to use
use strict;
use warnings;

# Initialize variables
my (@reads,@contigs,@finalMatches,@skip);

# Open the file to read
open(my $fh,"<ba3k.txt") or die $!;

# Read in the values from the file
while (my $line = <$fh>) {
	chomp($line);
	push @reads,$line;
}

# Map each k-mer pair with a matching suffix to a k-mer pair with a matching prefix
for (my $i = 0; $i < scalar(@reads); $i++) {
	my $matches = 0;
	my $index;
	for (my $j = 0; $j < scalar(@reads); $j++) {
		if (substr($reads[$i],1) eq substr($reads[$j],0,-1)) {
			$matches++;
			$index = $j;
		}
	}
	if ($matches == 1) {push @contigs,[$reads[$i],$reads[$index]]}
}
for (my $i = 0; $i < scalar(@contigs); $i++) {
	my $matches = 0;
	for (my $j = 0; $j < scalar(@contigs); $j++) {
		if ($contigs[$i][1] eq $contigs[$j][1]) {
			$matches++;
		}
	}
	if ($matches == 1) {
		push @finalMatches,$contigs[$i];
		push @skip,$contigs[$i][0],$contigs[$i][1];
	}
}

# Add the contigs to the original list
for (my $i = 0; $i < scalar(@finalMatches); $i++) {
	push @reads,$finalMatches[$i][0].substr($finalMatches[$i][1],-1);
}

# Print out the final contigs
foreach my $contig (sort @reads) {
	if (!grep(/^$contig$/, @skip)) {
		print "$contig\n";
	}
}

# Close the file
close($fh) || die "Couldn't close file properly";