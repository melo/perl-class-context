package MyUtilsDefaultContext;

use Moo;

extends 'Class::Context';
with 'Class::Context::ID::UUID', 'MyUtilsDefaultFieldsRole';

has 'update_count' => (is => 'rw', default => sub {0});

after 'signal_data_updated' => sub {
  my $self = shift;
  $self->update_count($self->update_count + 1);
};

1;
