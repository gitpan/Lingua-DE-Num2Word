# For Emacs: -*- mode:cperl; mode:folding coding:iso-8859-1 -*-
#
# Started by rv@petamem.com at 2002-07-11
#
# $Id: Num2Word.pm,v 1.4 2002/07/12 14:03:38 rv Exp $
#
# PPCG: 0.5

package Lingua::DE::Num2Word;

use strict;

BEGIN {
  use Exporter ();
  use vars qw($VERSION @ISA @EXPORT_OK);
  $VERSION = '0.01';
  @ISA     = qw(Exporter);
  @EXPORT_OK = qw(&num2de_cardinal);
}

# {{{ num2de_cardinal                 convert number to text

sub num2de_cardinal {
  my $positive = shift;
  my $out;

  my @tokens1 = qw(null ein zwei drei vier fünf sechs sieben acht neun zehn elf zwölf);
  my @tokens2 = qw(zwanzig dreissig vierzig fünfzig sechzig siebzig achtzig neunzig hundert);
#    my @tokens3 = qw(million milliarde billion billiarde); # Not needed now

  if($positive >= 0 && $positive <= 12) {
    $out = $tokens1[$positive];
  } elsif($positive >= 13 && $positive <= 19) {
    $out = $tokens1[$positive-10].'zehn';
  } elsif($positive >= 20 && $positive <= 100) {
    my $one_idx = int $positive/10-2;
    my $ten_idx = $positive-($one_idx+2)*10;

    $out = $tokens1[$ten_idx].'und' if $ten_idx;
    $out .= $tokens2[$one_idx];
  } elsif($positive >= 101 && $positive <= 999) {
    my $one_idx = int $positive/100;

    $out = $tokens1[$one_idx].'hundert'.&num2de_cardinal($positive-$one_idx*100);
  } elsif($positive >= 1000 && $positive <= 999999) {
    my $one_idx = int $positive/1000;
    my $tausend = $positive-$one_idx*1000;
    my $nonull = $tausend ? &num2de_cardinal($tausend) : '';

    $out = &num2de_cardinal($one_idx).'tausend'.$nonull;
  } elsif($positive >= 1000000 && $positive <= 999999999) {
    my $one_idx = int $positive/1000000;
    my $mio     = $positive-$one_idx*1000000;
    my $nonull  = $mio ? ' '.&num2de_cardinal($mio) : '';
    my $one     = $one_idx == 1 ? 'e' : '';

    $out = &num2de_cardinal($one_idx).$one.' million';
    $out .= 'en' if $one_idx > 1;
    $out .= $nonull;
  }

  return $out;
}

# }}}


1;
__END__

# {{{ module documentation

=head1 NAME

Lingua::DE::Num2Word - positive number to text convertor for german. Output
text is in iso-8859-1 encoding.

=head1 SYNOPSIS

 use Lingua::DE::Num2Word;
 
 my $text = Lingua::DE::Num2Word::num2de_cardinal( 123 );
 
 print $text || "sorry, can't convert this number into german language.";

=head1 DESCRIPTION

Lingua::DE::Num2Word is module for converting numbers into their representation
in german. Converts whole numbers from 0 up to 999 999 999.

=head2 Functions

=over

=item * num2de_cardinal(number)

Convert number to text representation.

=back

=head1 EXPORT_OK

num2de_cardinal

=head1 KNOWN BUGS

None.

=head1 AUTHOR

Richard Jelinek E<lt>rj@petamem.comE<gt>,
Roman Vasicek E<lt>rv@petamem.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2002 PetaMem s.r.o.

This package is free software. Tou can redistribute and/or modify it under
the same terms as Perl itself.

=cut

# }}}


