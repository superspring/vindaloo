package Vindaloo::Schema::Result::OrderEvent;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('order_events');
__PACKAGE__->add_columns(qw/id event_date orders_open/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    orders => Order => { 'foreign.order_event' => 'self.id' } );

__PACKAGE__->has_many(
    side_orders => SideOrder => { 'foreign.order_event' => 'self.id' } );
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;

__END__
