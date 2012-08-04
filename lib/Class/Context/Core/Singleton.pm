package Class::Context::Core::Singleton;

use Moo::Role;
use Scalar::Util 'weaken';
use namespace::autoclean;

requires 'DEMOLISH', 'generate_id';

our %ctxs;

sub __ctx_get {
  my $class = shift;
  $class = ref($class) if ref($class);

  return $ctxs{$class};
}

sub __ctx_set {
  my $self  = shift;
  my $class = ref($self);

  $ctxs{$class} = $self;
  weaken($ctxs{$class});
}

sub __ctx_new {
  my $class = shift;
  $class = ref($class) if ref($class);

  return $class->new(@_, id => $class->generate_id);
}

sub __ctx_run {
  my ($c, $cb) = @_;

  local $ctxs{ ref($c) } = $c;
  return $cb->();
}

before DEMOLISH => sub {
  my $c     = shift;
  my $class = ref($c);

  delete $ctxs{$class} if exists $ctxs{$class} && $ctxs{$class} eq $c;
};

1;
