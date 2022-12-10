#<<<
use strict; use warnings;
#>>>

use Test::More import => [ qw( BAIL_OUT explain is is_deeply pass use_ok ) ], tests => 5;

use HTTP::Request::Common qw( GET );
use Plack::Test           qw();

my $middleware;

BEGIN {
  $middleware = 'Plack::Middleware::LogAny';
  use_ok( $middleware ) or BAIL_OUT "Cannot load middleware '$middleware'!";
}

my $coreApp = sub { my ( $env ) = @_; pass( 'core app was called' ); return [ 200, [], [ 'some response content' ] ] };

my $expected_header_name  = 'X-Request-ID';
my $expected_header_value = '77e1c83b-7bb0-437b-bc50-a7a58e5660ac';
my $testApp =
  Plack::Test->create(
  $middleware->wrap( $coreApp, header_names => [ 'Content-Type', 'X-B3-TraceId', $expected_header_name ] ) );

$testApp->request( GET '/' );
is scalar( %{ Log::Any->_manager->get_context } ), 0, 'empty Log Any context';

$testApp->request( GET '/', $expected_header_name => $expected_header_value );
is_deeply( Log::Any->_manager->get_context, { $expected_header_name, $expected_header_value },
  'check Log Any context' );
