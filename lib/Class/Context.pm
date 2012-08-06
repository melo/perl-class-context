package Class::Context;

# ABSTRACT: a base class for Context objects
# VERSION
# AUTHORITY

use Moo;
use namespace::autoclean;

with 'Class::Context::Core';

sub generate_id { my $class = ref($_[0]); die "FATAL: define a generate_id() method in $class," }

sub BUILD { }

1;
