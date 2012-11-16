package Test::Basic;

use Test::Routine;
use Test::More;

before run_test => sub {
    my $self = shift;
    my $app  = $self->app->app;
    plan skip_all => "Test will not run in production environment."
      if $app->mode eq 'production';
};

test basic_request => { desc => "Test request to landing page." } => sub {
    my $self = shift;
    my $app  = $self->app;
    $app->get_ok('/')->status_is(302);
};

test user_login => { desc => "Test login" } => sub {
    my $self = shift;
    my $app  = $self->app;
    $app->post_form_ok(
        '/login',
        {
            email    => 'test1@test.com',
            password => '1234'
        }
    )->status_is(302);
    $app->get_ok('/')->status_is('200')->content_like(qr/Random/);
};

1;

__END__
