#!/usr/bin/env perl

BEGIN {
    if ($] < 5.007003) {
        warn "$0 requires Perl v5.7.3 or later.\n";
        exit;
    }

    unless (@ARGV) {
        warn "Usage: $0 string [string ...]\n";
        exit;
    }
}

use 5.007003;
use strict;
use warnings;
use open IO => qw{:encoding(UTF-8) :std};
use constant {
    SEP1 => '=' x 60 . "\n",
    SEP2 => '-' x 60 . "\n",
    FMT => "%s\tU+%-6X %s\n",
    NO_PRINT => "\N{REPLACEMENT CHARACTER}",
};

use Encode 'decode';
use Unicode::UCD 'charinfo';

for my $raw_str (@ARGV) {
    my $str = decode('UTF-8', $raw_str);
    print "\n", SEP1;
    print "String: '$str'\n";
    print SEP1;

    for my $char (split //, $str) {
        my $code_point = ord $char;
        my $char_info = charinfo($code_point);

        if (! defined $char_info) {
            $char_info->{name} = "<unknown> Perl $^V supports Unicode "
                               . Unicode::UCD::UnicodeVersion();
        }

        printf FMT, ($char =~ /^\p{Print}$/ ? $char : NO_PRINT),
                    $code_point, $char_info->{name};
    }

    print SEP2;
}