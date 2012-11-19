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


1;


__END__
