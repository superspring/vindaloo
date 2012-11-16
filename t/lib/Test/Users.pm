package Test::Users;

use Test::Routine;
use Test::More;

test navigate_to_curry_menu => { desc => "Navigate to curry menu interface" } =>
  sub {
    my $self = shift;
    my $app  = $self->app;
    $app->get_ok('/curry/manage')->status_is(200)->content_like(qr/Curry/);
  };

1;

__END__
