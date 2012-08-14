package Class::Context::Core;

use Moo::Role;
use namespace::autoclean;

with
  'Class::Context::Core::ID',
  'Class::Context::Core::Singleton',
  'Class::Context::Core::API',
  'Class::Context::Core::Data',
  ;

## Need to make sure it exists, other roles require it
sub DEMOLISH { }
sub BUILD    { }

1;
