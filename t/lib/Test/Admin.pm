package Test::Admin;

use Test::Routine;
use Test::More;


test admin_login => { desc => "Test login" } => sub {
    my $self = shift;
    $self->login_admin_user;
};




1;

__END__
