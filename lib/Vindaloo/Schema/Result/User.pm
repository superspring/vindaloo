package Vindaloo::Schema::Result::User;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    qw/
      id
      first_name
      surname
      nickname
      email
      password
      balance
      receive_email
      create_date
      active
      /
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint([qw/email/]);


__PACKAGE__->inflate_column(
    balance => {
        inflate => sub {
            my $value = shift;
            $value = $value // 0;
            return sprintf "%.2f", $value;
        },
    }
);

__PACKAGE__->has_many(
    user_roles => UserRole => { 'foreign.curry_user' => 'self.id' } );

__PACKAGE__->has_many(
    orders => Order => { 'foreign.curry_user' => 'self.id' } );

__PACKAGE__->has_many(
    payments => Payment => { 'foreign.curry_user' => 'self.id' } );

__PACKAGE__->has_many(
    side_orders => SideOrder => { 'foreign.curry_user' => 'self.id' } );

__PACKAGE__->many_to_many(order_events => orders => 'order_event' );
__PACKAGE__->many_to_many(side_order_events => side_orders => 'order_event' );

__PACKAGE__->many_to_many( roles => user_roles => 'role' );

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;

__END__
