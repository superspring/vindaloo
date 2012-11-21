package Vindaloo::Schema::Result::Role;

use Moose;
use namespace::autoclean;
BEGIN {extends 'DBIx::Class::Core'};

__PACKAGE__->table('roles');
__PACKAGE__->add_columns(qw/id name/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint([qw/name/]);


__PACKAGE__->has_many(user_roles => UserRole => {'foreign.user_role' =>
'self.id'});

__PACKAGE__->many_to_many(users => user_roles => 'user');






1;

__END__
