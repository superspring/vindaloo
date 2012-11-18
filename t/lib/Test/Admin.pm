package Test::Admin;

use Test::Routine;
use Test::More;


test admin_login => { desc => "Test login" } => sub {
    my $self = shift;
    $self->login(
        {
            email    => 'admin@user.com',
            password => 'test123'
        }
    );
};

test navigate_to_manage_events => {desc => 'Test  managing some events.'} => sub {
     my $self = shift;
     $self->app->get_ok('/events')->status_is(200);

};







1;

__END__
