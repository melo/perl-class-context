package Class::Context::Roles::Sources::WebRequest;

# ABSTRACT: common fields for contexts used in web frameworks
# VERSION
# AUTHORITY

use Moo::Role;
use Scalar::Util 'blessed';
use URI;

has 'ip'     => (is => 'rw');
has 'uri'    => (is => 'rw', coerce => sub { blessed($_[0]) ? $_[0] : URI->new($_[0]) });
has 'method' => (is => 'rw');

around 'BUILDARGS' => sub {
  my $orig = shift;
  my $args = $orig->(@_);

  if (my $env = delete $args->{psgi_env}) {
    require Plack::Request;
    my $r = Plack::Request->new($env);

    $args->{ip}     = $r->address;
    $args->{uri}    = $r->uri;
    $args->{method} = $r->method;
  }

  return $args;
};

1;

=encoding utf8

=head1 SYNOPSIS

    ## In your App context class
    
    package My::App::Context;
    
    use Moo; ## or use Moose
    extends 'Class::Context';
    with 'Class::Context::Roles::Sources::WebRequest';
    
    1;


=head1 DESCRIPTION

This role provides a set of attributes that a
L<Class::Context> subclass will find usefull if its used in web requests.

We keep track of three attributes discussed below in L</ATTRIBUTES>, but
given that most Perl web frameworks use the L<PSGI> specification, we
also accept a constructor argument named C<psgi_env>. If used, we will
use L<Plack::Request> (which you must include on your app dependencies)
to extract the other attribute values.


=head1 ATTRIBUTES

=head2 ip

The IP address of the client.

=head2 method

The method used by the request

=head2 uri

A L<URI> object representing the requested URI.

=cut
