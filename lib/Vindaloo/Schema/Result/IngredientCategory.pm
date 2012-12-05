package Vindaloo::Schema::Result::IngredientCategory;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('ingredient_category');
__PACKAGE__->add_columns(qw/id name/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    base_ingredients => BaseIngredient => { 'foreign.category' => 'self.id' } );

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;

__END__
