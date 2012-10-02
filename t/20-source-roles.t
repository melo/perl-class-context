#!perl

use Test::More;
use Test::Deep;
use lib 't/tlib';

subtest 'source WebRequest' => sub {
  require MySrcWebRequest;
  my @flds = qw( ip method uri );

  ok(MySrcWebRequest->can($_), "C::C::R::Source::WebRequest can $_") for @flds;

  my $wr = MySrcWebRequest->new_ctx;
  is($wr->$_(), undef, "C::C::R::Source::WebRequest default for $_ is undef") for @flds;

  $wr->uri('http://example.com/');
  is(ref($wr->uri),       'URI::http',           'uri attr coerces strings into URI objects');
  is($wr->uri->as_string, 'http://example.com/', '... with the expected URI');

  $wr->ip('10.10.10.10');
  is($wr->ip, '10.10.10.10', 'ip attr is read/write');

  $wr->method('POST');
  is($wr->method, 'POST', 'method attr is read/write');

  cmp_deeply(
    $wr->data,
    { web_request => {
        ip     => '10.10.10.10',
        method => 'POST',
        uri    => URI->new('http://example.com/'),
      }
    },
    'data() was properly updated',
  );
};


subtest 'source WebRequest via psgi_env' => sub {
  require MySrcWebRequest;
  my $env = {
    "HTTP_ACCEPT"            => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "HTTP_ACCEPT_ENCODING"   => "gzip, deflate",
    "HTTP_ACCEPT_LANGUAGE"   => "en-us",
    "HTTP_DNT"               => 1,
    "HTTP_HOST"              => "example.com",
    "HTTP_USER_AGENT"        => "user agent 007",
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

  my $wr = MySrcWebRequest->new_ctx(psgi_env => $env);
  ok($wr, 'Got a WebRequest instance');
  is($wr->ip,             '10.10.10.10',                  '... ip attr ok');
  is($wr->method,         'GET',                          '... method attr ok');
  is($wr->user_agent,     'user agent 007',               '... user_agent attr ok');
  is($wr->uri->as_string, 'http://example.com/path?a=42', '... uri attr ok');
  ok(!$wr->secure, '... secure attr ok');

  cmp_deeply(
    $wr->data,
    { web_request => {
        ip         => '10.10.10.10',
        method     => 'GET',
        uri        => URI->new('http://example.com/path?a=42'),
        secure     => 0,
        user_agent => 'user agent 007',
      }
    },
    'data() was properly updated',
  );

  $env = {
    "HTTP_ACCEPT"            => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "HTTP_ACCEPT_ENCODING"   => "gzip, deflate",
    "HTTP_ACCEPT_LANGUAGE"   => "en-us",
    "HTTP_DNT"               => 1,
    "HTTP_HOST"              => "example.com",
    "HTTP_USER_AGENT"        => "user agent 007",
    "HTTP_X_FORWARDED_FOR"   => "10.10.10.10",
    "HTTP_X_FORWARDED_PROTO" => "http",
    "HTTP_X_REAL_IP"         => "10.10.10.10",
    "PATH_INFO"              => "/path",
    "psgi.multiprocess"      => 1,
    "psgi.multithread"       => "",
    "psgi.nonblocking"       => "",
    "psgi.run_once"          => "",
    "psgi.streaming"         => 1,
    "psgi.url_scheme"        => "https",
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

  $wr = MySrcWebRequest->new_ctx(psgi_env => $env);
  ok($wr, 'Got a WebRequest instance for a secure psgi env');
  is($wr->ip,             '10.10.10.10',                   '... ip attr ok');
  is($wr->method,         'GET',                           '... method attr ok');
  is($wr->user_agent,     'user agent 007',                '... user_agent attr ok');
  is($wr->uri->as_string, 'https://example.com/path?a=42', '... uri attr ok');
  ok($wr->secure, '... secure attr ok');

  cmp_deeply(
    $wr->data,
    { web_request => {
        ip         => '10.10.10.10',
        method     => 'GET',
        uri        => URI->new('https://example.com/path?a=42'),
        secure     => 1,
        user_agent => 'user agent 007',
      }
    },
    'data() was properly updated',
  );
};


subtest 'source Cron' => sub {
  require MySrcCron;
  my @flds = qw( script uid gid );

  ok(MySrcCron->can($_), "C::C::R::Source::Cron can $_") for @flds;

  my $cr = MySrcCron->new_ctx;
  is($cr->script, $0, 'default for script attr is the script name');
  is($cr->uid,    $>, 'default for uid attr is the effective user_id');
  is($cr->gid,    $), 'default for gid attr is the effective group_id');
  cmp_deeply($cr->data, { cron => { script => $0, uid => $>, gid => $) } }, "data() was init'ed with the defaults");

  $cr->$_($_) for @flds;
  is($cr->$_(), $_, "C::C::R::Source::Cron allows updates to $_") for @flds;
  cmp_deeply($cr->data, { cron => { script => 'script', uid => 'uid', gid => 'gid' } }, '... data() was updated');
};


done_testing();
