package Class::Context::Extras::Stash;

use Moo::Role;
use Carp 'croak';
use namespace::autoclean;

has '_stash' => (is => 'ro', default => sub { {} });

sub stash {
  my $self  = shift;
  my $stash = $self->_stash;

  return $stash unless @_;
  if (@_ == 1) {
    my $k = shift;
    return unless exists $stash->{$k};
    return $stash->{$k};
  }
  croak("Odd number of parameters in call to stash(),") if @_ % 2;

  for (my $i = 0; $i < $#_; $i += 2) {
    $stash->{ $_[$i] } = $_[$i + 1];
  }

  return;
}


1;
