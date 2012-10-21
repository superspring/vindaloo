package Vindaloo::Curry;

use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self               = shift;
    my $ingredients        = $self->db->resultset('BaseIngredient');
    my $curry_types        = $self->db->resultset('CurryType');
    my $spiceyness         = $self->db->resultset('Spiceyness');
    my $menus              = $self->db->resultset('CurryMenu');
    my $spiceyness_btn_map = {
        mild   => 'btn-success',
        medium => 'btn-warning',
        hot    => 'btn-danger'
    };
    $self->stash(
        ingredients     => $ingredients,
        curry_types     => $curry_types,
        spiceyness      => $spiceyness,
        menus           => $menus,
        spiceyness_btns => $spiceyness_btn_map
    );

}

1;

__END__
