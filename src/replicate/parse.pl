#!/usr/bin/perl

use strict;

my @reds = ();
my @greens = ();
my @blues = ();

my $seen_magic = 0;
my $seen_dims = 0;
my $seen_max = 0;

my $rotation = 0;

while (<>) {
    if (/^\s*#/) {
        next;
    } elsif (/P3/) {
        $seen_magic++;
        next;
    } elsif (/[^\d\s]/) {
        print "Error, non-digit where it shouldn't be.\n$_";
        exit;
    } else {
        foreach my $num (split(/\s+/)) {
            if ($seen_dims < 2) {
                $seen_dims++;
            } elsif ($seen_max < 1) {
                $seen_max++;
            } elsif ($rotation == 0) {
                push @reds, $num;
                $rotation++;
            } elsif ($rotation == 1) {
                push @greens, $num;
                $rotation++;
            } elsif ($rotation == 2) {
                push @blues, $num;
                $rotation = 0;
            }
        }
    }
}

open(RF, ">R") or die "Can't open R: $!\n";
open(GF, ">G") or die "Can't open G: $!\n";
open(BF, ">B") or die "Can't open B: $!\n";

print RF "#(", join(' ', @reds), ")\n";
print GF "#(", join(' ', @greens), ")\n";
print BF "#(", join(' ', @blues), ")\n";

close(RF);
close(GF);
close(BF);
