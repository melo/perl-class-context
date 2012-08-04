#!perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use lib 't/tlib';
use MyDataContext;

my $ctx = MyDataContext->new_ctx;
cmp_deeply($ctx->data, {}, 'new contexts have an empty data');
ok(!$ctx->data_was_updated, '... and signal for data update is clear');

is($ctx->data('question'), undef, 'fetching non-existing data key returns undef');
cmp_deeply($ctx->data, {}, '... no data autovivification');
ok(!$ctx->data_was_updated, '... nor data update signals');

is($ctx->data('question'), undef, 'fetching non-existing data key returns undef');
cmp_deeply($ctx->data, {}, '... no data autovivification');
ok(!$ctx->data_was_updated, '... nor data update signals');

is($ctx->data({ question => 'who knows?' }), undef, 'setting a new data with a HashRef');
cmp_deeply($ctx->data, { question => 'who knows?' }, '... data was updated');
ok($ctx->data_was_updated, '... and data update signal was sent');

is($ctx->data('question'), 'who knows?', 'fetching a existing data key returns the correct value');
ok(!$ctx->data_was_updated, '... no data update signals were sent');

is($ctx->data(author => 'whom', answer => 'who is who?'), undef, 'merging new data, list of pairs');
cmp_deeply($ctx->data, { question => 'who knows?', author => 'whom', answer => 'who is who?' }, '... data was updated');
ok($ctx->data_was_updated, '... and data update signal was sent');

is($ctx->data(author => undef, agent => undef), undef, 'merging new data, list of pairs, some are deletes');
cmp_deeply($ctx->data, { question => 'who knows?', answer => 'who is who?' }, '... data was updated properly');
ok($ctx->data_was_updated, '... and data update signal was sent');

is($ctx->data({ this_is => 'the end' }), undef, 'setting new data via HashRef');
cmp_deeply($ctx->data, { this_is => 'the end' }, '... data was updated, old data removed');
ok($ctx->data_was_updated, '... and data update signal was sent');


done_testing();
