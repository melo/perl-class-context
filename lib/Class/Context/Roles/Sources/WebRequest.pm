package Class::Context::Roles::Sources::WebRequest;

use Moo::Role;

has 'ip'     => (is => 'rw');
has 'url'    => (is => 'rw');
has 'method' => (is => 'rw');

1;
