#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 60;

use_ok('Acme::Mobile::Thurblings');

my $obj = new Acme::Mobile::Thurblings();
ok(defined $obj);

foreach my $key (qw( a d g j m p t w )) {
  ok($obj->count_thurblings($key)     == 1);
  ok($obj->count_thurblings(uc($key)) == 1);
}

foreach my $key (qw( b e h k n q u x 0 )) {
  ok($obj->count_thurblings($key)     == 2);
  ok($obj->count_thurblings(uc($key)) == 2);
}

foreach my $key (qw( c f i l o r v y )) {
  ok($obj->count_thurblings($key)     == 3);
  ok($obj->count_thurblings(uc($key)) == 3);
}

foreach my $key (qw( s z )) {
  ok($obj->count_thurblings($key)     == 4);
  ok($obj->count_thurblings(uc($key)) == 4);
}

ok($obj->count_thurblings("") == 0);
ok($obj->count_thurblings("this is silly") == 37);

ok(count_thurblings("") == 0);
ok(count_thurblings("this is silly") == 37);
