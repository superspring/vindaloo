package Vindaloo::Schema::Result::Payment;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('payment');
__PACKAGE__->add_columns(qw/id curry_user payment payment_date/);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(
    curry_user => User => { 'foreign.id' => 'self.curry_user' } );

__PACKAGE__->inflate_column(
    payment => {
        inflate => sub {
            my $value = shift;
            return sprintf "%.2f", $value if $value;
            return;
          }

    }
);

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;

__END__
