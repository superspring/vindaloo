package Vindaloo::Schema::Result::DishSpiceyness;

use Moose;
use namespace::autoclean;
BEGIN {extends 'DBIx::Class::Core'};

__PACKAGE__->table('dish_spiceyness');
__PACKAGE__->add_columns(qw/dish spiceyness/);
__PACKAGE__->belongs_to(dish => 'Vindaloo::Schema::Result::CurryMenu' =>
{'foreign.id' => 'self.dish'});
__PACKAGE__->belongs_to(spiceyness => 'Vindaloo::Schema::Result::Spiceyness'
=> {'foreign.id' => 'self.spiceyness'});





1;

__END__
