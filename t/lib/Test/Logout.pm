package Test::Logout;

use Test::Routine;
use Test::More;

test logout_user => {desc => "Log a user out"} => sub {
     my $self = shift;
     my $app = $self->app;
     $app->get_ok('/logout')->status_is(302);
};




1;

__END__
