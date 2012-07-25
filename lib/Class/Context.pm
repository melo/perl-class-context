package Class::Context;

# ABSTRACT: a base class for Context objects
# VERSION
# AUTHORITY

use Moo;
use Carp ();
use Scalar::Util 'weaken';
use namespace::autoclean;

### Attributes common to all contexts
has 'id'        => (is => 'lazy');
has 'parent_id' => (is => 'ro');

sub _build_id { shift->generate_id }


### Context setup
sub ctx {
  return shift->__ctx_get;
}

sub new_ctx {
  my $c = shift->__ctx_new(@_);
  $c->__ctx_set;
  return $c;
}

sub sub_ctx {
  my $c = shift;

  return $c->__ctx_new(@_, parent_id => $c->id);
}


## Context instance management (singletons)
{
  my %ctxs;

  sub __ctx_get {
    my $class = shift;
    $class = ref($class) || $class;
    return $ctxs{$class};
  }

  sub __ctx_set {
    my $self = shift;
    $ctxs{ ref($self) } = $self;
    weaken($ctxs{ ref($self) });
  }

  sub __ctx_new {
    my $class = shift;
    $class = ref($class) || $class;
    return $class->new(@_, id => $class->generate_id);
  }

  sub __ctx_run {
    my ($c, $cb) = @_;

    local $ctxs{ ref($c) } = $c;
    return $cb->();
  }

  sub DEMOLISH {
    my $c     = shift;
    my $class = ref($c);

    delete $ctxs{$class} if exists $ctxs{$class} && $ctxs{$class} eq $c;
  }
}


## code execution under ctx, immediate or on a callback
sub run {
  my ($c, $cb) = @_;

  return $c->__ctx_run($cb);
}

sub cb {
  my ($c, $cb) = @_;

  return sub { $c->run($cb) };
}

1;
