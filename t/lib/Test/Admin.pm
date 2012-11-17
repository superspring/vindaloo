package Test::Admin;

use Test::Routine;
use Test::More;

before run_test => sub {
    my $self = shift;
    my $app  = $self->app->app;
    plan skip_all => "Test will not run in production environment."
      if $app->mode eq 'production';
};

test admin_login => { desc => "Test login" } => sub {
    my $self = shift;
    my $app  = $self->app;
    $app->post_form_ok(
        '/login',
        {
            email    => 'admin@user.com',
            password => 'test123'
        }
    )->status_is(302);
};




1;

__END__
