package Vindaloo::Users;

use Mojo::Base 'Mojolicious::Controller';

sub authenticate {
    my $self = shift;
    $self->redirect_to( $self->url_for('/login')->to_abs->scheme('https') )
      and return 0
      unless $self->is_user_authenticated;
}

1;

__END__
