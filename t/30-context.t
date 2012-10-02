#!perl

use Test::More;
use lib 't/tlib';
use MyContext;
use MyOtherContext;
use MyCtxWithIdChild;

subtest 'instance mgmt' => sub {
  is(MyContext->ctx, undef, 'no current context defined by default');

  my $ct = MyContext->new_ctx;
  ok($ct,                        'Created a context...');
  ok($ct->isa('Class::Context'), '... with the proper parentage');

  is(MyContext->ctx, $ct, 'the current context is now this one');

  my $ot = MyOtherContext->new_ctx;
  ok($ot,                        'Created another context...');
  ok($ot->isa('Class::Context'), '... with the proper parentage');

  is(MyOtherContext->ctx, $ot, 'the current context is now this one');
  is(MyContext->ctx,      $ct, '... but current context is a per context class afair');

  undef $ct;
  is(MyContext->ctx,      undef, 'current context goes back to undef after we destroy it');
  is(MyOtherContext->ctx, $ot,   '... per-class of course');
};


subtest 'subcontext mgmt' => sub {
  is(MyContext->ctx, undef, 'no current context defined by default');

  my $ct = MyContext->new_ctx;
  ok($ct, 'Created a context...');
  is(MyContext->ctx, $ct, '... the current context was updated');

  my $cs = $ct->sub_ctx;
  ok($cs,                        'Created a sub context...');
  ok($cs->isa('Class::Context'), '... with the proper parentage');
  is(MyContext->ctx, $ct, '... but the current context still uses the top level context');

  undef $cs;
  is(MyContext->ctx, $ct, 'After subcontext dies, current context still uses the top level context');
};


subtest 'context attrs' => sub {
  my $ct = MyContext->new_ctx(id => 1);
  my $cs = $ct->sub_ctx(parent_id => 2, id => 3);

  like($ct->id, qr{^[a-fA-F0-9-]{36}$}, 'main context id attr looks like a UUID');
  is($ct->parent_id, undef, '... and its parent_id attr is undef');

  like($cs->id, qr{^[a-fA-F0-9-]{36}$}, 'sub context id attr looks like a UUID');
  isnt($cs->id, $ct->id, '... and its a different id from its parent');
  is($cs->parent_id, $ct->id, 'subcontext parent_id matches the main context id');
};


subtest 'run code under context' => sub {
  my $ct = MyContext->new_ctx;
  my $cs = $ct->sub_ctx;

  is(MyContext->ctx, $ct, 'current context set to main context');
  $cs->run(
    sub {
      is(MyContext->ctx, $cs, 'current context inside run() matches the context used to run() it');
    }
  );

  my $cb = $ct->cb(
    sub {
      is(MyContext->ctx, $ct, '... but current context inside callback matches the context used to cb() it');
    }
  );

  my $cn = MyContext->new_ctx;
  is(MyContext->ctx, $cn, 'current context updated to new top level context we created');
  $cb->();
};


subtest 'callbacks keep context alive' => sub {
  my $ct = MyContext->new_ctx;
  is(MyContext->ctx, $ct, 'current context set to newly created top level context');
  undef $ct;
  is(MyContext->ctx, undef, 'When context goes out-of-scope, current context is reset to undef');

  $ct = MyContext->new_ctx;
  is(MyContext->ctx, $ct, 'current context set to newly created top level context');
  my $cb = $ct->cb(sub { });
  ok($cb, 'create callback using this context');
  my $id = $ct->id;
  undef $ct;
  is(MyContext->ctx->id, $id, 'When context goes out-of-scope, callback keeps it alive');

  undef $cb;
  is(MyContext->ctx, undef, 'When callback goes out-of-scope, current context is finally reset to undef');
};


subtest 'context ID' => sub {
  my $ct = MyCtxWithId->new_ctx;
  ok($ct, 'Got a new context for MyCtxWithId');
  is(MyCtxWithIdChild->ctx, $ct, '... subclass uses same ctx_id(), so same ctx');

  $ct = MyCtxWithIdChild->new_ctx;
  is(MyCtxWithId->ctx, $ct, '... and vice-versa');
};


done_testing();
