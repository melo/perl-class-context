#!perl

use Test::More;
use lib 't/tlib';

subtest 'source WebRequest' => sub {
  require RawSrcWebRequest;
  my @flds = qw( ip method url );

  ok(RawSrcWebRequest->can($_), "C::C::R::Source::WebRequest can $_") for @flds;

  my $wr = RawSrcWebRequest->new;
  is($wr->$_(), undef, "C::C::R::Source::WebRequest default for $_ is undef") for @flds;

  $wr->$_($_) for @flds;
  is($wr->$_(), $_, "C::C::R::Source::WebRequest allows updates to $_") for @flds;
};


done_testing();
