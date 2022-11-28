# NAME

Plack::Middleware::LogAny - Use Log::Any to handle logging from your Plack app

# SYNOPSIS

```perl
builder {
  enable 'LogAny', category => 'plack';
  $app;
}
```

# DESCRIPTION

LogAny is a [Plack::Middleware](https://metacpan.org/pod/Plack%3A%3AMiddleware) component that allows you to use [Log::Any](https://metacpan.org/pod/Log%3A%3AAny)
to handle the logging object, `psgix.logger`.

It really tries to be the thinnest possible shim, so it doesn't handle any
configuration beyond setting the category to which messages from plack might be
logged.

# METHODS

## prepare\_app

This method initializes the logger using the category that you (optionally)
set.

## call

Actually handles making sure the logger is invoked.

# CONFIGURATION

- category

    The `Log::Any` category to send logs to. Defaults to `''` which means it send
    to the root logger.

# AUTHOR

Sven Willenbuecher <sven.willenbuecher@kuehne-nagel.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Michael Alan Dorman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

# SEE ALSO

[Log::Any](https://metacpan.org/pod/Log%3A%3AAny)

