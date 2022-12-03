#<<<
use strict; use warnings;
#>>>

use Test::More import => [ qw( BAIL_OUT note explain is_deeply use_ok ) ], tests => 1;

use HTTP::Request::Common       qw( GET );
use Log::Any::Adapter           qw();
use Log::Any::Adapter::Log4perl qw();
use Plack::Test                 qw();

my $middleware;

BEGIN {
  $middleware = 'Plack::Middleware::LogAny';
  use_ok( $middleware ) or BAIL_OUT "Cannot load middleware '$middleware'!";
}

my $conf = q(
  log4perl.rootLogger             = TRACE, BUFFER
  log4perl.appender.BUFFER        = Log::Log4perl::Appender::TestBuffer
  log4perl.appender.BUFFER.name   = buffer
  log4perl.appender.BUFFER.layout = Log::Log4perl::Layout::PatternLayout
  log4perl.appender.BUFFER.layout.ConversionPattern = %-5p [%c, %M] - %m%n
);
Log::Log4perl->init( \$conf );
Log::Any::Adapter->set( 'Log::Log4perl' );

my $messages;

my $app = sub {
  local *__ANON__ = 'My::PSGI::app';
  my ( $env ) = @_;
  map { $env->{ 'psgix.logger' }->( $_ ) } @{ $messages };
  return [ 200, [], [] ];
};

$messages = [
  { level => 'trace', message => 'this is a trace message' },
  { level => 'debug', message => 'this is a debug message' }
];

Plack::Test->create( $middleware->wrap( $app ) )->request( GET '/' );

my $test_appender = Log::Log4perl::Appender::TestBuffer->by_name( 'buffer' );

note explain $test_appender->buffer;
$test_appender->clear;

$messages = [
  { level => 'info',    message => 'this is an info message' },
  { level => 'warning', message => 'this is a warning message' }
];

Plack::Test->create( $middleware->wrap( $app, category => 'plack.test' ) )->request( GET '/' );

note explain $test_appender->buffer;
$test_appender->clear;
