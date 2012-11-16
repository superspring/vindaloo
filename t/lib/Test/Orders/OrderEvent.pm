package Test::Order::OrderEvent;

use Test::Routine;
use Test::More;
use Test::Deep; # (); # uncomment to stop prototype errors
use Test::Exception;


before run_test => sub {
    my $self = shift;
    my $app  = $self->app->app;
    plan skip_all => "Test will not run in production environment."
      if $app->mode eq 'production';
};


test admin_open_event => { desc => "Login as admin and open an event" } =>
sub {
     my $self = shift;

};




1;

__END__
