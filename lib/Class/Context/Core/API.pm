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

sub run_in_sub_ctx {
  my ($c, $cb, @extra) = @_;

  ## save and make sure we restore the current ctx after we are done
  my $current_ctx = $c->__ctx_get;
  my $guard = Class::Context::Guard->new(sub { $current_ctx->__ctx_set });

  ## Create the new sub context, make it the active one
  my $sc = $c->sub_ctx(@extra);

  ## Run the original callback under a new fresh sub context
  return $sc->run($cb);
}

1;
