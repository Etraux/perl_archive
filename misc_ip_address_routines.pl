#!/usr/bin/perl
use strict;
use warnings;

sub XFORM {
    # Extract the sort key from $_[0] and return it.
    # This will often be written in-line
    # rather than as a real subroutine.
    return sprintf("%012.0f", ip2val($_[0]));
}

my ($addstr,$value,@addstrary,@addvalary,@sorted,$DEBUG);

{ 
    no warnings 'numeric';
    if($ARGV[0] > 0) {
        $DEBUG = shift @ARGV;
    } else {
        $DEBUG = 0;
    }
}

while (<>) {
    s/(^\s+)//;        #remove indentation
    s/\s+[\n\r]+//g;   #remove all eol spaces/tabs & ctrl chars

    if(/^$/) { next; } #ignore blank lines
    if(/^#/) { next; } #ignore comments

    ($addstr) = Extract_IP_Address($_);

    if($addstr ne '') {
        #Use this to check the XFORM routine
        #printf "%15.15s   %s\n",$addstr,XFORM($addstr);
        push @addstrary, $addstr;
    }
}

if($DEBUG == 0) {
    @sorted= @addstrary[
         map { unpack "N", substr($_,-4) }
         sort
         map { XFORM($addstrary[$_]) . pack "N", $_ }
         0..$#addstrary
    ];

} else {    #split up Tye's GRT sort above into separate pieces

    my (@arytosort, @sorted_stuff, @index_info);
    @arytosort = map { XFORM($addstrary[$_]) . pack "N", $_ } 0..$#addstrary;
    @sorted_stuff = sort @arytosort;
    @index_info = map { unpack "N", substr($_,-4) } @sorted_stuff;

    @sorted = @addstrary[@index_info];
}

foreach my $str (@sorted) {
    print "$str\n";
}

#---- Misc. IP address routines ----

###########################################
# convert 4 byte integer value to an IP address
###########################################
sub val2ip {
    my ($a,$b,$c,$d)=unpack("CCCC",pack("N",$_[0]));
    return "$a.$b.$c.$d";
}

###########################################
# convert IP address to a 4 byte integer value
###########################################
sub ip2val {
    if ( $_[0]=~ /([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)/o ){
        return (unpack("N",pack("CCCC",$1,$2,$3,$4)) );
    } else {
        return 0;
    }
}

#####################################################################
# Find the first dotted ip address in any string, puts it in $1, 
# and put the individual octets in $2, $3, $4 & $5. Figure out the
# long integer representation of that address, and Return everything
# in a list.
#
# NOTE: it doesn't check to make sure each octet is between 0-254, 
#   nor if the numbers between the dots are 1 to 3 characters in length.
#
# Example: given "the IP address of www.xxx.com is 206.24.105.142"
# return the list ('206.24.105.142',206,24,105,142,3457706382)
#####################################################################
sub Extract_IP_Address {
    if ( $_[0]=~ /(([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+))/o ){
        return ($1,$2,$3,$4,$5, unpack("N",pack("CCCC",$2,$3,$4,$5)) );
    } else {
        return ();
    }
}
