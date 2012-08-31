#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More;
use Test::Deep;
use Test::Fatal;
use MyStash;


subtest 'basic stash' => sub {
  my $ctx = MyStash->new;
  cmp_deeply($ctx->stash, {}, 'stash starts empty');

  is($ctx->stash('k'), undef, 'non-existing keys return undef...');
  cmp_deeply($ctx->stash, {}, '... and dont autovivify');

  $ctx->stash(a => 1, b => 2, c => undef);
  cmp_deeply($ctx->stash, { a => 1, b => 2, c => undef }, 'stash updated properly');
  is($ctx->stash('b'), 2, 'stash with existing key returns value');

  $ctx->stash(a => 2, b => 42, d => 'd');
  cmp_deeply($ctx->stash, { a => 2, b => 42, c => undef, d => 'd' }, 'stash updated properly with merge');

  like(
    exception { $ctx->stash(f => 1, 'g') },
    qr/^\QOdd number of parameters in call to stash()\E/,
    'wrong number of arguments will get you exceptioned'
  );
};

subtest 'stash push' => sub {
  my $ctx = MyStash->new;

  is($ctx->stash_push('list', 'a'), 1, 'stash_push() returns number of elements in key after push');
  is($ctx->stash_push('list', 'b', 'c', 'd'), 4, '... you can also push multiple values');
  cmp_deeply($ctx->stash('list'), [qw(a b  c d)], 'final list as expected');

  $ctx->stash('upgr', 'xpto');
  is($ctx->stash_push('upgr', 'ypto'), 2, 'regular keys are upgraded to lists, proper number of elements');
  cmp_deeply($ctx->stash('upgr'), [qw(xpto ypto)], '... proper content');

  is($ctx->stash_push,          undef, 'calls with no args are ignored, return undef');
  is($ctx->stash_push('stash'), undef, 'calls with no values also ignored, return undef');
};


done_testing();
