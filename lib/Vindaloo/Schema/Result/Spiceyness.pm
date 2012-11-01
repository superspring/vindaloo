package Vindaloo::Schema::Result::Spiceyness;

use Moose;
use namespace::autoclean;
BEGIN {extends 'DBIx::Class::Core'};

__PACKAGE__->table('spiceyness');
__PACKAGE__->add_columns(qw/id name/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(curry_menus => CurryMenu => {'foreign.spiceyness' =>
'self.id'});

__PACKAGE__->has_many(dish_spiceynesses =>
'Vindaloo::Schema::Result::DishSpiceyness' => {'foreign.spiceyness' =>
'self.id'});


__PACKAGE__->many_to_many(dishes => dish_spiceynesses => 'dish');




1;

__END__
