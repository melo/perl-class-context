package MyOtherContext;

use Moo;

extends 'Class::Context';
with 'Class::Context::Roles::Sources::WebRequest', 'Class::Context::Roles::Sources::Cron',
  'Class::Context::Roles::ID::UUID';

1;
