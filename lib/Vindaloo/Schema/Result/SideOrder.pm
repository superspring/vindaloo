package Vindaloo::Schema::Result::SideOrder;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('curry_side_order');
__PACKAGE__->add_columns(
    qw/id side_dish order_event curry_user
      limited_per_user/
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( curry_user => 'Vindaloo::Schema::Result::User' =>
      { 'foreign.id' => 'self.curry_user' } );

__PACKAGE__->belongs_to(
    order_event => 'Vindaloo::Schema::Result::OrderEvent' =>
      { 'foreign.id' => 'self.order_event' } );

__PACKAGE__->belongs_to( side_dish => 'Vindaloo::Schema::Result::SideDish' =>
      { 'foreign.id' => 'self.side_dish' } );
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;

__END__
