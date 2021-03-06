package Vindaloo::Schema::Result::UserRole;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('user_roles');
__PACKAGE__->add_columns(qw/curry_user user_role/);
__PACKAGE__->set_primary_key(qw/curry_user user_role/);

__PACKAGE__->belongs_to( user => 'Vindaloo::Schema::Result::User' =>
      { 'foreign.id' => 'self.curry_user' } );
__PACKAGE__->belongs_to( role => 'Vindaloo::Schema::Result::Role' =>
      { 'foreign.id' => 'self.user_role' } );

1;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

__END__
