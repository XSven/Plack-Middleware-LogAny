#<<<
use strict; use warnings;
#>>>

on 'configure' => sub {
  requires 'ExtUtils::MakeMaker::CPANfile' => '0';
};

on 'runtime' => sub {
  requires 'Log::Any'              => '>=1.711';
  requires 'Plack::Middleware'     => '0';
  requires 'Plack::Util::Accessor' => '0';
};

on 'test' => sub {
  requires 'Test::More' => '0';
};

on 'develop' => sub {
  requires 'App::Software::License' => 0;
}
