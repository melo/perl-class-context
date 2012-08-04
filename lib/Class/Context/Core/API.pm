package Class::Context::Core::API;

use Moo::Role;
use namespace::autoclean;

requires '__ctx_get', '__ctx_new', '__ctx_set', '__ctx_run';


#################################
# Context factory/instance access

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


######################################################
# code execution under ctx, immediate or as a callback

sub run {
  my ($c, $cb) = @_;

  return $c->__ctx_run($cb);
}

sub cb {
  my ($c, $cb) = @_;

  return sub { $c->run($cb) };
}


1;
