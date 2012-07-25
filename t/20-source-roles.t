#!perl

use Test::More;
use lib 't/tlib';

subtest 'source WebRequest' => sub {
  require RawSrcWebRequest;
  my @flds = qw( ip method uri );

  ok(RawSrcWebRequest->can($_), "C::C::R::Source::WebRequest can $_") for @flds;

  my $wr = RawSrcWebRequest->new;
  is($wr->$_(), undef, "C::C::R::Source::WebRequest default for $_ is undef") for @flds;

  $wr->uri('http://example.com/');
  is(ref($wr->uri),       'URI::http',           'uri attr coerces strings into URI objects');
  is($wr->uri->as_string, 'http://example.com/', '... with the expected URI');

  $wr->ip('10.10.10.10');
  is($wr->ip, '10.10.10.10', 'ip attr is read/write');

  $wr->method('POST');
  is($wr->method, 'POST', 'method attr is read/write');
};


subtest 'source WebRequest via psgi_env' => sub {
  require RawSrcWebRequest;
  my $env = {
    "HTTP_ACCEPT"            => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "HTTP_ACCEPT_ENCODING"   => "gzip, deflate",
    "HTTP_ACCEPT_LANGUAGE"   => "en-us",
    "HTTP_DNT"               => 1,
    "HTTP_HOST"              => "example.com",
    "HTTP_X_FORWARDED_FOR"   => "10.10.10.10",
    "HTTP_X_FORWARDED_PROTO" => "http",
    "HTTP_X_REAL_IP"         => "10.10.10.10",
    "PATH_INFO"              => "/path",
    "psgi.multiprocess"      => 1,
    "psgi.multithread"       => "",
    "psgi.nonblocking"       => "",
    "psgi.run_once"          => "",
    "psgi.streaming"         => 1,
    "psgi.url_scheme"        => "http",
    "psgi.version"           => [1, 1],
    "psgix.harakiri"         => 1,
    "psgix.input.buffered"   => 1,
    "QUERY_STRING"           => "a=42",
    "REMOTE_ADDR"            => "10.10.10.10",
    "REMOTE_HOST"            => "127.0.0.1",
    "REQUEST_METHOD"         => "GET",
    "REQUEST_URI"            => "/path?a=42",
    "SCRIPT_NAME"            => "",
    "SERVER_NAME"            => "127.0.0.1",
    "SERVER_PORT"            => 80,
    "SERVER_PROTOCOL"        => "HTTP/1.0",
  };

  my $wr = RawSrcWebRequest->new(psgi_env => $env);
  ok($wr, 'Got a WebRequest instance');
  is($wr->ip,             '10.10.10.10',                  '... ip attr ok');
  is($wr->method,         'GET',                          '... method attr ok');
  is($wr->uri->as_string, 'http://example.com/path?a=42', '... uri attr ok');
};


subtest 'source Cron' => sub {
  require RawSrcCron;
  my @flds = qw( script uid gid );

  ok(RawSrcCron->can($_), "C::C::R::Source::Cron can $_") for @flds;

  my $cr = RawSrcCron->new;
  is($cr->script, $0, 'default for script attr is the script name');
  is($cr->uid,    $>, 'default for uid attr is the effective user_id');
  is($cr->gid,    $), 'default for gid attr is the effective group_id');

  $cr->$_($_) for @flds;
  is($cr->$_(), $_, "C::C::R::Source::Cron allows updates to $_") for @flds;
};


done_testing();
