package Test::Users;

use Test::Routine;
use Test::More;

test navigate_to_curry_menu =>
  { desc => "Navigate to curry menu interface" } => sub {
    my $self = shift;
    my $app = $self->app;
    $self->user_login({email => 'test1@test.com',password => '1234'});
    $self->navigate_to_manage_curry;
    $app->status_is(404);
  };

1;

__END__
