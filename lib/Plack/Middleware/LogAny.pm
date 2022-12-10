#<<<
use strict; use warnings;
#>>>

package Plack::Middleware::LogAny;

our $VERSION = '0.001003';

use parent                qw( Plack::Middleware );
use Log::Any              qw();
use Plack::Util::Accessor qw( category logger );

sub prepare_app {
  my ( $self ) = @_;
  $self->logger( Log::Any->get_logger( category => defined $self->category ? $self->category : '' ) );
}

sub call {
  my ( $self, $env ) = @_;

  my $logger = $self->logger;
  $env->{ 'psgix.logger' } = sub {
    my ( $level, $message ) = @{ $_[ 0 ] }{ qw( level message ) };

    @_ = ( $logger, $message );
    goto &{ $logger->can( $level ) };
  };

  $self->app->( $env );
}

1;
