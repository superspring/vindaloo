package Vindaloo::Schema::Result::SideDish;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('side_dishes');
__PACKAGE__->add_columns(qw/id name link active/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint( [qw/link/] );

__PACKAGE__->has_many( orders => 'Vindaloo::Schema::Result::SideOrder' =>
      { 'foreign.side_dish' => 'self.id' } );

1;

__END__
