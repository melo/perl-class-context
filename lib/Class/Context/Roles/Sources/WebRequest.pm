package Class::Context::Roles::Sources::WebRequest;

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
