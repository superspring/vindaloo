package Test::Users;

use Test::Routine;
use Test::More;

test navigate_to_manage_curry =>
  { desc => "Navigate to curry management interface" } => sub {
    my $self = shift;
    $self->navigate_to_manage_curry_as_user(
        { email => 'test1@test.com', password => '1234' } )->status_is(404);
  };

1;

__END__
