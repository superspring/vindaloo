package Vindaloo::Orders;

use Mojo::Base 'Mojolicious::Controller';

use List::MoreUtils 'any';

sub order_dish {
    my $self       = shift;
    my $ingredient = $self->param('ingredient');
    my $curry      = $self->param('curry');
    my $spice      = $self->param('spice');

    my $user  = $self->current_user;
    my $model = $self->db;
    my $ingred_obj =
      $model->resultset('BaseIngredient')->find( { link => $ingredient } );
    my $curry_obj = $model->resultset('CurryType')->find( { link => $curry } );
    my $spice_obj = $model->resultset('Spiceyness')->find( { name => $spice } );
    my $menu = $model->resultset('CurryMenu')->search(
        {
            base_ingredient => $ingred_obj->id,
            curry_type      => $curry_obj->id
        }
    )->first;

    if ( not $menu and not $menu->spiceynesses( { name => $spice } )->count ) {
        $self->app->log->error(
            "User tried to order a curry that did not exist!");
        $self->app->log->error( join " " => $ingredient, $curry, $spice );
        $self->redirect_to(
            $self->url_for('/curries')->to_abs->scheme('https') );
        return 0;
    }

    my $event =
      $model->resultset('OrderEvent')->search( { orders_open => 1 } )->first;

    # TODO: make a "orders closed" page
    if ( not $event ) {
        $self->redirect_to(
            $self->url_for('ordersclosed')->to_abs->scheme('https') );
        return;
    }
    local $@;
    eval {
        $model->resultset('Order')->create(
            {
                dish        => $menu->id,
                order_event => $event->id,
                curry_user  => $user->id,
                spiceyness  => $spice_obj->id,
            }
        );
        my $balance = $user->balance;
        $balance += $menu->price;
        $user->balance($balance);
        $user->update;

    };
    if ( my $e = $@ ) {
        $self->app->log->error( "Error inserting order: " . $e );
    }
    $self->redirect_to( $self->url_for('/curries')->to_abs->scheme('https') );

    return;
}

sub closed {
    my $self = shift;

}

1;

__END__
