package Vindaloo::Schema::Result::BaseIngredient;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('base_ingredients');
__PACKAGE__->add_columns(qw/id name link active category/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint([qw/link/]);


__PACKAGE__->has_many(
    curry_menus => CurryMenu => { 'foreign.base_ingredient' => 'self.id' } );

__PACKAGE__->belongs_to(
    category => 'Vindaloo::Schema::Result::IngredientCategory' =>
      { 'foreign.id' => 'self.category' } );

1;

__END__
