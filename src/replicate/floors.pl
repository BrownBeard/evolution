#!/usr/bin/perl

use POSIX floor;

while (<>) {
    if (/^\d+\.\d+$/) {
        print floor($_), "\n";
    } else {
        print;
    }
}
