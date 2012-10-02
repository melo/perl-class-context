package Class::Context::Utils;

use strict;
use warnings;
use Carp 'croak';
use Package::Stash;

sub import {
  my $class  = shift;
  my $target = caller;

  for my $meth (@_) {
    if   ($meth eq 'has_data_field') { _install_has_data_field($target) }
    else                             { croak "Method '$meth' not exported by $class," }
  }
}

sub _install_has_data_field {
  my ($target) = @_;

  my $has_cb      = $target->can('has')      || confess("Package $target doesn't have a 'has' method,");
  my $requires_cb = $target->can('requires') || confess("Package $target doesn't have a 'requires' method,");
  my $after_cb    = $target->can('after')    || confess("Package $target doesn't have a 'after' method,");

  my @f_init;
  $requires_cb->('BUILD');
  $after_cb->(
    'BUILD',
    sub {
      my ($self) = @_;

      for (@f_init) {
        my ($ns, $field) = @$_;
        my $val = $self->$field();
        _update_data_field(undef, $ns, $field, $self, $val) if defined $val;
      }
    }
  );

  my $stash = Package::Stash->new($target);
  $stash->add_symbol(
    '&has_data_field',
    sub {
      my ($name, %meta) = @_;

      my $orig_trigger = $meta{trigger};
      my $data_ns      = delete $meta{data_ns};
      $meta{trigger} = sub { _update_data_field($orig_trigger, $data_ns, $name, @_) };

      push @f_init, [$data_ns, $name];
      $has_cb->($name, %meta);
    }
  );
}


sub _update_data_field {
  my ($orig_trigger, $data_ns, $name, $self, $val, @rest) = @_;
  my $df = $name;

  if ($data_ns) {
    my $data = $self->data($data_ns);
    $data = {} unless $data;
    $data->{$name} = $val;

    $val = $data;
    $df  = $data_ns;
  }

  $self->data($df, $val);
  $orig_trigger->($self, $val, @rest) if $orig_trigger;
}


1;
