package MyContext;

use Moo;

extends 'Class::Context';
with 'Class::Context::Sources::WebRequest', 'Class::Context::ID::UUID';

1;
