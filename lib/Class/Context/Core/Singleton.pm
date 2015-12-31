package Class::Context::Core::Singleton;

use Moo::Role;
use Scalar::Util 'weaken';
use namespace::autoclean;

requires 'DEMOLISH', 'generate_id';

our %ctxs;

sub ctx_id { my $class = shift; return ref($class) || $class }

sub __ctx_get { return $ctxs{ shift->ctx_id } }

sub __ctx_set {
  my $self = shift;
  my $id   = $self->ctx_id;

  $ctxs{$id} = $self;
  weaken($ctxs{$id});
}

sub __ctx_new {
  my $class = shift;
  $class = ref($class) if ref($class);

  return $class->new(@_, id => $class->generate_id);
}

sub __ctx_run {
  my ($c, $cb) = @_;

  local $ctxs{ $c->ctx_id } = $c;
  return $cb->();
}

before DEMOLISH => sub {
  my $c  = shift;
  my $id = $c->ctx_id;

  delete $ctxs{$id} if exists $ctxs{$id} and (!$ctxs{$id} or $ctxs{$id} eq $c);
};

1;
