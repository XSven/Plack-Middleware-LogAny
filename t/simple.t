#<<<
use strict; use warnings;
#>>>

use Test::More import => [ qw( BAIL_OUT is_deeply use_ok ) ], tests => 2;

use HTTP::Request::Common qw( GET );
use Log::Any::Test        qw();
use Log::Any              qw( $log );
use Plack::Test           qw( test_psgi );

my $middleware;

BEGIN {
  $middleware = 'Plack::Middleware::LogAny';
  use_ok( $middleware ) or BAIL_OUT "Cannot load middleware '$middleware'!";
}

my $messages = [
  { category => 'plack.test', level => 'debug', message => 'this is a debug message' },
  { category => 'plack.test', level => 'info',  message => 'this is an info message' }
];

my $app = sub {
  my ( $env ) = @_;
  map { $env->{ 'psgix.logger' }->( $_ ) } @{ $messages };
  return [ 200, [], [] ];
};

$app = Plack::Middleware::LogAny->wrap( $app, category => 'plack.test' );

test_psgi $app, sub {
  my ( $cb ) = @_;
  my $res = $cb->( GET '/' );
  is_deeply( $log->msgs, $messages, 'check Log::Any global log buffer' );
};
