package Test::Basic;

use Test::Routine;

use Test::More;
use Test::Deep ();    # uncomment to stop prototype errors
use Test::Exception;

test basic_request => { desc => "Make basic request to Vindaloo page" } => sub {
    my $self = shift;

    my $app = $self->app;
    $app->get_ok('/')->status_is(302);
};

test user_login => { desc => "Test login" } => sub {
    my $self = shift;
    my $app  = $self->app;
    $app->post_form_ok(
        '/login',
        {
            email    => 'testy@test.com',
            password => 'test123'
        }
    )->status_is(302)->content_like(qr/Menu/);
};


1;

__END__
