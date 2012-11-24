package Vindaloo::Schema::Result::Order;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('curry_orders');
__PACKAGE__->add_columns(qw/id dish order_event curry_user spiceyness/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to( dish => CurryMenu => { 'foreign.id' => 'self.dish' } );
__PACKAGE__->belongs_to(
    order_event => OrderEvent => { 'foreign.id' => 'self.order_event' } );
__PACKAGE__->belongs_to(
    curry_user => User => { 'foreign.id' => 'self.curry_user' } );

__PACKAGE__->belongs_to(
    spiceyness => Spiceyness => { 'foreign.id' => 'self.spiceyness' } );
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;

__END__
