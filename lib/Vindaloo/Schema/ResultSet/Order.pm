package Vindaloo::Schema::ResultSet::Order;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::ResultSet' }

sub grouped_dish {
    my $self = shift;
    my $rs   = $self->search(
        undef,
        {
            join =>
              [ { dish => [qw/base_ingredient curry_type/] }, 'spiceyness' ],
            select => [
                'base_ingredient.name', 'curry_type.name',
                'spiceyness.name', { count => 'base_ingredient.name' },
                { sum => 'dish.price' },
            ],
            as       => [qw/ingredient curry spiceyness num_of_dishes price/],
            group_by => [
                qw/
                  base_ingredient.name
                  curry_type.name
                  spiceyness.name
                  dish.price
                  /
            ]
        }
    );
    return $rs;
}

sub grouped_order {
    my $self = shift;
    my $rs = $self->search(
        undef,
        {
            columns  => [qw/dish spiceyness order_event/],
            group_by => [qw/dish spiceyness order_event /],
            prefetch => [
                'spiceyness',
                {
                    dish => [
                        qw/
                        base_ingredient
                          curry_type
                          /
                    ]
                }
            ]
        }
    );
    return $rs;
}

sub group_by_dish_user {
    my $self = shift;
    my $rs = $self->search(
        undef,
        {
            columns => [qw/dish spiceyness  order_event curry_user/],
            group_by => [qw/order_event dish spiceyness curry_user/],
            prefetch => [
                'curry_user',
                'spiceyness',
                {
                    dish => [
                        qw/
                        base_ingredient
                        curry_type
                        /
                    ]
                }
            ]
        }
    );
   return $rs;
}

1;

__END__
