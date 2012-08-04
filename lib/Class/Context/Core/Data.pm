package Class::Context::Core::Data;

use Moo::Role;
use Carp 'croak';
use namespace::autoclean;

has '_data' => (
  is       => 'rw',
  init_arg => 'data',
  default  => sub { {} },
  trigger  => sub { shift->signal_data_updated },
);

sub data {
  my $self = shift;
  my $d    = $self->_data;

  ## Just give it to me!
  return $d unless @_;

  ## I want to override it... Or just access a specific key, if its really there
  if (@_ == 1) {
    my $p = shift;
    $self->_data($p), return if ref($p) eq 'HASH';
    return $d->{$p} if exists $d->{$p};
    return;
  }

  ## please merge this
  if (@_ % 2 == 0) {
    while (my ($k, $v) = splice(@_, 0, 2)) {
      delete $d->{$k}, next unless defined $v;
      $d->{$k} = $v;
    }
    $self->signal_data_updated;
    return;
  }

  ## I don't know what you want, I bet you do not know what you want either.
  croak 'Bad call to data(): odd number of parameters, check the fine manual,';
}

sub signal_data_updated { }

1;
