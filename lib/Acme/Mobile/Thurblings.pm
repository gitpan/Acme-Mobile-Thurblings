=head1 NAME

Acme::Mobile::Thurblings - count keystrokes to write mobile text messages

=head1 SYNOPSIS

  use Acme::Mobile::Thurblings;

  $thurbs = count_thurblings("See u l8r");

  # $thurbs == 23
  
=head1 DESCRIPTION

This module counts the number of I<thurblings> used to write mobile
text messages.  A thurbling is unit used to measure the number of
actions (in this case keypresses or pauses) for people who like to
optimize industrial processes.

So you can use this module to determine useless facts such as that it
takes as many keypresses to write "later" or "great" as it does "l8r"
and "gr8".

I have no idea if a "thurbling" is a real unit of measurement or just
the figment of a former employer's imagination. (Internet searches for
the term were fruitless.) But since this is an Acme module, it doesn't
matter much.

The current version is case insensitive and assumes (by default) a
particular brand of Nokia phone. (I have no idea which model it is; it
was cheap, and it works, which is all I care about.)

A description of methods is below.

=over

=cut

package Acme::Mobile::Thurblings;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use Exporter;

our @ISA = qw( Exporter );

our @EXPORT = qw( count_thurblings );

our %EXPORT_TAGS = (
  'all' => [ @EXPORT ],
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

use constant DEFAULT_SAME_KEY => 1;

use Carp;
use YAML qw( Load Dump );

=item new

  $obj = Acme::Mobile::Thurblings->new();

Used for the object-oriented interface. Only useful if you want to
specify your own keypad:

  open $fh, 'mykeypad.yml';
  $obj = Acme::Mobile::Thurblings->new($fh);

=cut

sub new {
  my $class = shift;
  my $self  = {
    SAME_KEY => DEFAULT_SAME_KEY,
  };
  bless $self, $class;
  $self->_initialize(@_);
  return $self;
}

my $Default;

sub _initialize {
  my $self = shift;
  my $fh   = shift;

  unless (defined $Default) {
    $Default = join("", <DATA>, "\n");
  }

  my $file = (defined $fh) ? join("", <$fh>, "\n") : $Default;
  my $keys = Load($file);

  $self->{KEYPAD} = $keys;

  foreach my $key (0..9) {
    croak "Missing $key key",
      unless (exists $keys->{$key});
  }

  $self->{CHAR}   = { };

  foreach my $key (keys %$keys) {
    my $thurb = 1;
    foreach my $char (split //, $keys->{$key}) {
      $self->{CHAR}->{$char} = [$key, $thurb++];
    }
  }

  return $self;
}

my $Self;

{
  $Self = __PACKAGE__->new();
}

=item count_thurblings

  $count = count_thurblings($message);

  $count = $obj->count_thurblings($message);

Returns the number of "thurblings" (keystrokes) used to generate the
message.  A thurbling is either a keystroke, or the pause when one has
to wait in order to enter multiple letters from the same key (such as
with the word "high").

The default number of thurblings for waiting in the same key is
C<1>. There is no way to change that value for this version.

This message is treated case-insensitively (so does not take into
account keypresses to shift between upper- and lower-case).

=cut

sub count_thurblings {
  my $self  = shift;
  my $text  = shift;

  unless (ref($self)) {
    $text = $self;
    $self = $Self;
  }

  my $last  = "";
  my $thurb = 0;
  foreach my $char (split //, lc($text)) {
    croak "Unknown character: $char",
      unless (exists $self->{CHAR}->{$char});
    $thurb += $self->{CHAR}->{$char}->[1];
    $thurb += $self->{SAME_KEY},
      if ($self->{CHAR}->{$char}->[0] eq ($self->{CHAR}->{$last}->[0]||""));
    $last = $char;
  }
  return $thurb;
}

=back

=head1 AUTHOR

Robert Rothenberg <rrwo at cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Robert Rothenberg.  All Rights Reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.3 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;

__DATA__
--- #YAML:1.0
# The default data is for a Nokia phone. Change to suit your phone.
0: ' 0'
1: ".,'?!\"1-()@/:"
2: 'abc2ä'
3: 'def3èéêëğ'
4: 'ghi4ìíîï'
5: 'jkl5£'
6: 'mno6öøòóôõñ'
7: 'pqrs7ß$'
8: 'tuv8ùúûü'
9: 'wxyz9ış'

