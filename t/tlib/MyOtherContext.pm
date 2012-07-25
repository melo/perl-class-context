package MyOtherContext;

use Moo;

extends 'Class::Context';
with 'Class::Context::Sources::WebRequest', 'Class::Context::Sources::Cron', 'Class::Context::ID::UUID';

1;
