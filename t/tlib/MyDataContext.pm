package MyDataContext;

use Moo;

extends 'Class::Context';
with 'Class::Context::ID::UUID';

has '_flag' => (is => 'rw', default => sub {0});

sub data_was_updated {
  my $self = shift;
  my $v    = $self->_flag;
  $self->_flag(0);
  return $v;
}

after signal_data_updated => sub { shift->_flag(1) };


1;
