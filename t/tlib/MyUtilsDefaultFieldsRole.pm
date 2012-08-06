package MyUtilsDefaultFieldsRole;

use Moo::Role;
use Class::Context::Utils 'has_data_field';
use namespace::autoclean;

has_data_field 'one' => (is => 'rw', default => sub {1});
has_data_field 'two' => (is => 'rw', data_ns => 'test', default => sub {2});

has_data_field 'three' => (is => 'lazy', builder => 1);
has_data_field 'four'  => (is => 'rw',   builder => 1);

sub _build_three { return 3 }
sub _build_four  { return 4 }

1;
