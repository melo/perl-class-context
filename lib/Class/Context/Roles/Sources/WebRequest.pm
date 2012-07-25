package Class::Context::Roles::Sources::WebRequest;

use Moo::Role;

has 'ip'     => (is => 'rw');
has 'uri'    => (is => 'rw');
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
