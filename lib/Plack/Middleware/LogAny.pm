package Plack::Middleware::LogAny;

use Log::Any qw{};
use Plack::Util::Accessor qw{category logger};
use parent qw{Plack::Middleware};
use strict;
use warnings;

our $VERSION = '0.001001';

sub prepare_app {
    my ($self) = @_;
    $self->logger (Log::Any->get_logger (category => $self->category || ''));
}

sub call {
    my ($self, $env) = @_;

    $env->{'psgix.logger'} = sub {
        my $args = shift;
        my $level = $args->{level};
        $self->logger->$level ($args->{message});
    };

    $self->app->($env);
}

1;
