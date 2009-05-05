#!/usr/bin/perl

open PAULUS, "<smallus.ppm";
open FILE, "$ARGV[0]";

$seen=0;

$sumerr=0;
$tot=0;
$err=0;

while (<FILE>) {
    $p=<PAULUS>;
    if ($seen < 4) {
        $seen++;
    } else {
        chomp;
        chomp($p);
        $sumerr += abs($p - $_);
        $tot++;
        print "real: $p, produced: $_.\n";
        $line = <STDIN>;
    }
}

$err = $sumerr / $tot;

print "$err\n";
