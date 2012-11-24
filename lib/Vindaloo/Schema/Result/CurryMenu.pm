package Vindaloo::Schema::Result::CurryMenu;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('curry_menus');
__PACKAGE__->add_columns(
    qw/
      id
      base_ingredient
      curry_type
      price
      active
      reverse_name
      /
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->inflate_column(
    price => {
        inflate => sub {
            return sprintf "%.2f", shift;
          }
    }
);

__PACKAGE__->belongs_to( base_ingredient => BaseIngredient =>
      { 'foreign.id' => 'self.base_ingredient' } );

__PACKAGE__->belongs_to(
    curry_type => CurryType => { 'foreign.id' => 'self.curry_type' } );

__PACKAGE__->has_many( orders => Order => { 'foreign.dish' => 'self.id' } );

__PACKAGE__->has_many(
    dish_spiceynesses => 'Vindaloo::Schema::Result::DishSpiceyness' =>
      { 'foreign.dish' => 'self.id' } );

__PACKAGE__->many_to_many( spiceynesses => dish_spiceynesses => 'spiceyness' );

1;

__END__
