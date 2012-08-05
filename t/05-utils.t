#!perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use lib 't/tlib';
use MyUtilsContext;


subtest 'has_data_field' => sub {
  my $ctx = MyUtilsContext->new_ctx;

  cmp_deeply($ctx->data, {}, 'empty data to start with');
  is($ctx->test1,           undef, 'test1 field is undef');
  is($ctx->test2,           undef, '...as is test2');
  is($ctx->test1_triggered, 0,     '... and test1 trigger flag is down');

  $ctx->test1({ a => 42 });
  cmp_deeply($ctx->test1, { a => 42 }, 'test1 update to 42 worked fine');
  is($ctx->test1_triggered, 1, '... original trigger was called');
  cmp_deeply($ctx->data, { test1 => { a => 42 } }, '... data was updated for test1');

  $ctx->test2({ b => 84 });
  cmp_deeply($ctx->test2, { b => 84 }, 'test2 update to 84 worked fine');
  is($ctx->test1_triggered, 0, '... test1 trigger was not used');
  cmp_deeply(
    $ctx->data,
    { test2 => { b => 84 }, test1 => { a => 42 } },
    '... data was updated for test2, without touching test1'
  );
};


done_testing();
