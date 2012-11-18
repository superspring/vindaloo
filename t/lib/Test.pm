package Test;

use Moose;
use namespace::autoclean;

use Test::Mojo;

has app_init => (
    is      => 'ro',
    isa     => 'Test::Mojo',
    default => sub {
        my $self = shift;
        my $app  = Test::Mojo->new('Vindaloo');
        return $app;
    },
);

has app => (
    is      => 'ro',
    isa     => 'Test::Mojo',
    builder => 'app_init',
);

sub get_curry_manage_ok {
    my $self = shift;
    my $app  = $self->app;
   return $app->get_ok('/curry/manage');
}

sub login {
    my ( $self, $credentials ) = @_;
    my $app = $self->app;
    return $app->post_form_ok( '/login', $credentials, )->status_is(302);
}

sub logout_user {
    my $self = shift;
    my $app  = $self->app;
    $app->get_ok('/logout')->status_is(302);

}

sub navigate_to_manage_curry_as_user {
    my ($self, $credentials) = @_;
    $self->login($credentials);
    return $self->get_curry_manage_ok;
}

1;

__END__
