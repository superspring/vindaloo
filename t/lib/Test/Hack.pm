package Test::Hack;

use Test::Routine;
use Test::More;
#use Smart::Comments;

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


test post_update_to_self => { desc => 'Try to give user admin role.' } =>
  sub {
    my $self = shift;
    $self->app->post_form_ok(
        '/user/profile/edit',
        {
            roles      => [ 1, 2 ],
            first_name => 'Ima',
            surname => 'Adminow',
            email => 'test1@test.com'
        }
    )->status_is(302)->content_like(qr/First\sname/);
    my $schema = $self->app->app->db;
    my $user = $schema->resultset('User')->search({email =>
            'test1@test.com'})->first;
    my $roles = $user->roles({name => 'admin'});

    cmp_ok($roles->count,'==',0, 'User is not admin');

  };
1;

__END__
