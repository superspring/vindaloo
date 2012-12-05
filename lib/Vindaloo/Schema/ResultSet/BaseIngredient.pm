package Vindaloo::Schema::ResultSet::BaseIngredient;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::ResultSet' }

sub active_ingredients {
    my $self = shift;
    my $rs   = $self->search(
        { 'curry_menus.active' => 1 },
        {
            join     => 'curry_menus',
            prefetch => { curry_menus => 'curry_type' }
        }
    );
    return $rs;
}

1;

__END__
