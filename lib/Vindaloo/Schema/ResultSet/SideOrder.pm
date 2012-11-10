package Vindaloo::Schema::ResultSet::SideOrder;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::ResultSet' }

sub grouped_side_dish {
    my $self = shift;
    my $rs   = $self->search(
        undef,

        {
            join   => 'side_dish',
            select => [
                'side_dish.name',
                { count => 'side_dish.name' },
                { sum   => 'side_dish.price' }
            ],
            as       => [qw/side num_of_sides price/],
            group_by => [qw/side_dish.name side_dish.price/]
        }
    );
    return $rs;

}

1;

__END__
