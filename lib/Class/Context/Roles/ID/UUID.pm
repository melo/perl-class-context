package Class::Context::Roles::ID::UUID;

use Moo::Role;
use Carp ();

our $uuid_gen;

BEGIN {
  eval { require Data::UUID };
  if (!$@) {
    my $du = Data::UUID->new;
    $uuid_gen = sub { $du->create_str };
  }
  else {
    eval { require Data::UUID::LibUUID };
    if (!$@) {
      $uuid_gen = sub { Data::UUID::LibUUID::new_uuid_string(4) };
    }
    else {
      Carp::confess("Either Data::UUID (faster on Linux) or Data::UUID::LibUUID (faster on OS X) is required");
    }
  }
}

sub generate_id { return $uuid_gen->() }

1;
