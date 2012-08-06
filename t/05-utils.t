#!perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use lib 't/tlib';
use MyUtilsContext;
use MyUtilsDefaultContext;


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


subtest 'has_data_field with namespace' => sub {
  my $ctx = MyUtilsContext->new_ctx;

  cmp_deeply($ctx->data, {}, 'empty data to start with');
  is($ctx->test3, undef, 'test3 field is undef');
  is($ctx->test4, undef, '...as is test4');

  $ctx->test3('third test');
  is($ctx->test3, 'third test', 'test3 updated to the proper value');
  cmp_deeply(
    $ctx->data,
    { test => { test3 => 'third test' } },
    '... data was updated for test3, with the test namespace',
  );

  $ctx->test4({ answer => 42 });
  cmp_deeply($ctx->test4, { answer => 42 }, 'test4 updated to the proper value');
  cmp_deeply(
    $ctx->data,
    { test => { test3 => 'third test', test4 => { answer => 42 } } },
    '... data was updated for test4, merged with previous value',
  );

  $ctx->test4(undef);
  is($ctx->test4, undef, 'test4 updated to undef');
  cmp_deeply(
    $ctx->data,
    { test => { test3 => 'third test', test4 => undef } },
    '... data was updated for test4, merged with previous value',
  );
};


subtest 'has_data_field with defaults' => sub {
  my $ctx = MyUtilsDefaultContext->new_ctx;

  cmp_deeply($ctx->data, { one => 1, test => { two => 2 }, three => 3, four => 4 },
    'data() is set with default values');
  is($ctx->update_count, 4, 'three data updates, one for each default field, one for builder, one for lazy builder');

  $ctx->one('one');
  $ctx->two('two');
  cmp_deeply($ctx->data, { one => 'one', test => { two => 'two' }, three => 3, four => 4 }, 'data() was updated');
  is($ctx->update_count, 6, 'each field update triggers another data update');
};


done_testing();
