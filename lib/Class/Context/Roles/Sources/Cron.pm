package Class::Context::Roles::Sources::Cron;

use Moo::Role;

has 'script' => (is => 'rw', default => sub { $0 });
has 'uid'    => (is => 'rw', default => sub { $> });
has 'gid'    => (is => 'rw', default => sub { $) });

1;
