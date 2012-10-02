package MyCtxWithId;

use Moo;
extends 'Class::Context';
with 'Class::Context::Core', 'Class::Context::ID::UUID';

sub ctx_id {'my_ctx_id'}

1;
