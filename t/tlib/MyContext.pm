package MyContext;

use Moo;

extends 'Class::Context';
with 'Class::Context::Roles::Sources::WebRequest', 'Class::Context::Roles::ID::UUID';

1;
