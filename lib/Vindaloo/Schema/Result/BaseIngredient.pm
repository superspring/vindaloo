package Vindaloo::Schema::Result::BaseIngredient;


use Moose;
use namespace::autoclean;
BEGIN {extends 'DBIx::Class::Core'};

__PACKAGE__->table('base_ingredients');
__PACKAGE__->add_columns(qw/id name/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(curry_menus => CurryMenu => {'foreign.base_ingredient' =>
'self.id'});



1;

__END__
