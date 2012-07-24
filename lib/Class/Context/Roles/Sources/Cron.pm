package Class::Context::Roles::Sources::Cron;

use Moo::Role;

has 'script' => (is => 'rw');
has 'uid'    => (is => 'rw');
has 'gid'    => (is => 'rw');

1;
