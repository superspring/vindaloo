package Vindaloo::Logout;

use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self  = shift;
    $self->logout;
    $self->redirect_to($self->url_for('/'));
}

1;

__END__
