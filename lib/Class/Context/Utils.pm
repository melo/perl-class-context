package Class::Context::Utils;

use strict;
use warnings;
use Carp 'croak';
use Sub::Name;
use Package::Stash;

sub import {
  my $class  = shift;
  my $target = caller;
  my $stash  = Package::Stash->new($target);

  for my $meth (@_) {
    if ($meth eq 'has_data_field') { _install_has_data_field($stash, $target) }
    else                           { croak "Method '$meth' not exported by $class," }
  }
}

sub _install_has_data_field {
  my ($stash, $target) = @_;

  my $has_cb = $stash->get_symbol('&has') || confess("Package $target doesn't have a 'has' method,");

  $stash->add_symbol(
    '&has_data_field',
    sub {
      my ($name, %meta) = @_;

      my $orig_trigger = $meta{trigger};
      my $data_ns = exists $meta{data_ns} ? $meta{data_ns} : '';
      $meta{trigger} = subname "_trigger_$name" => sub {
        my ($self, $val) = @_;
        my $df = $name;

        if ($data_ns) {
          my $cur_data = $self->data($data_ns);
          $cur_data = {} unless $cur_data;
          $cur_data->{$name} = $val;

          $val = $cur_data;
          $df  = $data_ns;
        }

        $self->data($df, $val);
        $orig_trigger->(@_) if $orig_trigger;
      };

      $has_cb->($name, %meta);
    }
  );
}


1;
