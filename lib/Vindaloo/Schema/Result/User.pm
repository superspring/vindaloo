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
      email
      password
      balance
      receive_email
      create_date
      active
      /
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
    user_roles => UserRole => { 'foreign.curry_user' => 'self.id' } );

__PACKAGE__->has_many(
    orders => Order => { 'foreign.curry_user' => 'self.id' } );

__PACKAGE__->has_many(
    side_orders => SideOrder => { 'foreign.curry_user' => 'self.id' } );

__PACKAGE__->many_to_many( roles => user_roles => 'role' );

1;

__END__
