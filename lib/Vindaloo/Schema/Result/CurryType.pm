package Vindaloo::Schema::Result::CurryType;

use Moose;
use namespace::autoclean;
BEGIN {extends 'DBIx::Class::Core'};

__PACKAGE__->table('curry_types');
__PACKAGE__->add_columns(qw/id name/);
__PACKAGE__->set_primary_key('id');


__PACKAGE__->has_many(curry_menus => CurryMenu => {'foreign.curry_type' =>
'self.id'});


1;

__END__
