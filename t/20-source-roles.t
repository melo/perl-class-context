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


subtest 'source Cron' => sub {
  require RawSrcCron;
  my @flds = qw( script uid gid );

  ok(RawSrcCron->can($_), "C::C::R::Source::Cron can $_") for @flds;

  my $cr = RawSrcCron->new;
  is($cr->script, $0, 'default for script attr is the script name');
  is($cr->uid,    $>, 'default for uid attr is the effective user_id');
  is($cr->gid,    $), 'default for gid attr is the effective group_id');

  $cr->$_($_) for @flds;
  is($cr->$_(), $_, "C::C::R::Source::Cron allows updates to $_") for @flds;
};


done_testing();
