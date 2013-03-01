package Class::Context;

# ABSTRACT: a base class for Context objects
# VERSION
# AUTHORITY

use Moo;
use namespace::autoclean;

with 'Class::Context::Core';

sub generate_id { my $class = ref($_[0]); die "FATAL: define a generate_id() method in $class," }


##################################
# Simple Guard-like implementation

package    # hide from PAUSE, private class
  Class::Context::Guard;

sub new {
  my ($class, $cb) = @_;
  return bless { cb => $cb }, $class;
}

## sub cancel { delete $_[0]->{cb} }

sub DESTROY { my $cb = delete $_[0]{cb}; $cb->() if ref($cb) eq 'CODE' }

1;
