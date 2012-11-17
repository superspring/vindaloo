package Test::CheckEnv;

use Test::Routine;
use Test::More;

before run_test => sub {
    my $self = shift;
    my $app  = $self->app->app;
    plan skip_all => "Test will not run in production environment."
      if $app->mode eq 'production';
};

1;

__END__
