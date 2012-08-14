package Class::Context::Core::ID;

use Moo::Role;
use namespace::autoclean;

### Attributes common to all contexts
has 'id' => (is => 'ro', required => 1);
has 'parent_id' => (is => 'ro');

1;
