#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 100;

use_ok('Acme::Mobile::Thurblings', '0.02');

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


ok(count_thurblings("this is silly",1) == 39);

ok(count_thurblings("This is silly",1) == 37);
ok(count_thurblings("THIS is silly",1) == 39);

ok(count_thurblings("This. Is silly",1) == 38);
ok(count_thurblings("This. is silly",1) == 40);
ok(count_thurblings("This. IS silly",1) == 40);
ok(count_thurblings("This. IS SILLY",1) == 39);

use IO::File;
{
  my $fh = new IO::File('./sample-1.yml');
  $obj = new Acme::Mobile::Thurblings($fh, {
    NO_SHIFT => 1,
  });
  ok(defined $obj, 'Custom configuration file');

  foreach my $key (qw( A D G J M P T W )) {
    ok($obj->count_thurblings($key,1)     == 1);
    ok($obj->count_thurblings(uc($key),1) == 1);
    ok($obj->count_thurblings(lc($key),0) == 1);
    ok($obj->count_thurblings(lc($key),1) != 1);
  }

}


