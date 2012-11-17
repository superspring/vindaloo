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

sub login_admin_user {
    my $self = shift;
    $self->user_login(
        {
            email    => 'admin@user.com',
            password => 'test123'
        }
    );
}

sub navigate_to_manage_curry {
    my $self = shift;
    my $app  = $self->app;
    $app->get_ok('/curry/manage');
}

sub user_login {
    my ( $self, $credentials ) = @_;
    my $app = $self->app;
    $app->post_form_ok( '/login', $credentials, )->status_is(302);
}

sub logout_user {
    my $self = shift;
    my $app  = $self->app;
    $app->get_ok('/logout')->status_is(302);

}

1;

__END__
