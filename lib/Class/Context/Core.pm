package Class::Context::Core;

use Moo::Role;
use namespace::autoclean;

with 'Class::Context::Core::Singleton', 'Class::Context::Core::API';

### Attributes common to all contexts
has 'id' => (is => 'ro', required => 1);
has 'parent_id' => (is => 'ro');

## Need to make sure it exists, other roles require it
sub DEMOLISH { }


1;
