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
      spiceyness
      price
      active
      reverse_name/
);

__PACKAGE__->belongs_to(base_ingredient => BaseIngredient => {'foreign.id' =>
'self.base_ingredient'});

__PACKAGE__->belongs_to(curry_type => CurryType => {'foreign.id' =>
'self.curry_type'});

__PACKAGE__->belongs_to(spiceyness => Spiceyness => {'foreign.id' =>
'self.spiceyness'});




1;

__END__
