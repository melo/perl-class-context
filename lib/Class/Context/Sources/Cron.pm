package Class::Context::Sources::Cron;

# ABSTRACT: common fields for contexts used in cron scripts
# VERSION
# AUTHORITY

use Moo::Role;

has 'script' => (is => 'rw', default => sub { $0 });
has 'uid'    => (is => 'rw', default => sub { $> });
has 'gid'    => (is => 'rw', default => sub { $) });

1;
__END__

=encoding utf8

=head1 SYNOPSIS

    ## In your App context class
    
    package My::App::Context;
    
    use Moo; ## or use Moose
    extends 'Class::Context';
    with 'Class::Context::Sources::Cron';
    
    1;

=head1 DESCRIPTION

This role provides a set of attributes that a L<Class::Context> subclass will
find usefull if its used in cron scripts.

=head1 ATTRIBUTES

=head2 script

The filename of the cron script, defaults to C<$0>.

=head2 uid

The user ID used to run the script, defaults to (C<< $EUID >>/C<< $> >>).

=head2 gid

The group ID used to run the script, defaults to (C<< $EGID >>/C<< $) >>).

=cut
