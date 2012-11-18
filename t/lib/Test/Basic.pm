package Test::Basic;

use Test::Routine;
use Test::More;

test test_user_login_logout =>
  { desc => "Test basic login; make request." } => sub {
    my $self = shift;
    my $app  = $self->app;
    $self->login( { email => 'test1@test.com', password => '1234' } )
      ->get_ok('/')->status_is('200')->content_like(qr/Random/);
  };

test navigate_to_manage_events =>
  { desc => 'Try going to manage events as user' } => sub {
    my $self = shift;
    $self->app->get_ok('/events')->status_is(404);
  };

test navigate_to_manage_users =>
  { desc => "Try going to manage users as non admin" } => sub {
    my $self = shift;
    $self->app->get_ok('/users')->status_is(404);
  };

test post_update_to_self => { desc => 'Try and post an update to a user.' } =>
  sub {
    my $self = shift;
    $self->app->post_form_ok(
        '/user/profile/edit',
        {
            roles      => [ 1, 2 ],
            first_name => 'Ima Adminow'
        }
    )->status_is(200)->content_like(qr/First\sname/);
  };

1;


__END__
