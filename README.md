# NAME

Plack::Middleware::LogAny - Use Log::Any to handle logging from your PSGI
application

# SYNOPSIS

```perl
# in app.psgi file
use Plack::Builder;

# PSGI application
my $app = sub { ... };

# DSL interface
builder {
  enable 'LogAny', category => 'plack', context => [ qw( X-Request-ID ) ];
  $app;
}

# alternative OO interface
Plack::Middleware::LogAny->wrap( $app, category => 'plack', context => [ qw( X-Request-ID ) ] );
```

# DESCRIPTION

LogAny is a [Plack::Middleware](https://metacpan.org/pod/Plack%3A%3AMiddleware) component that allows you to use [Log::Any](https://metacpan.org/pod/Log%3A%3AAny)
to handle the `psgix.logger` logging object. This object is a code reference
that is described in [PSGI::Extensions](https://metacpan.org/pod/PSGI%3A%3AExtensions).

# METHODS

## prepare\_app()

This method initializes the logger using the category that you (optionally)
set.

## call()

This method sets the logging object and the logging context. The logging
context is localized.

# CONFIGURATION OPTIONS

- category

    The `Log::Any` category to send logs to. Defaults to `''` which means it send
    to the root logger.

- context

    As of release 0.002.

    A list of HTTP header names that is passed from the [PSGI
    environment](https://metacpan.org/pod/PSGI#The-Environment) to the `Log::Any` logging context.

# AUTHOR

Sven Willenbuecher <sven.willenbuecher@kuehne-nagel.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Michael Alan Dorman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# SEE ALSO

[Log::Any](https://metacpan.org/pod/Log%3A%3AAny)

