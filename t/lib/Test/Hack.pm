package Test::Hack;


use Test::More;
use Test::Routine;


test non_authenticated_access =>
  { desc => "Try to access admin site as user" } => sub {
    my $self = shift;
    my $app  = $self->app;
    $app->get_ok('/curry/manage')->status_is('404');
  };


1;

__END__
