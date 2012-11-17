package Test::Basic;

use Test::Routine;
use Test::More;


test test_user_login_logout => {
    desc => "Test basic login; make request; logout cycle."
  } => sub {
    my $self = shift;
    my $app  = $self->app;
    $self->user_login( { email => 'test1@test.com', password => '1234' } );
    $app->get_ok('/')->status_is('200')->content_like(qr/Random/);
    $self->logout_user;
  };

1;

__END__
