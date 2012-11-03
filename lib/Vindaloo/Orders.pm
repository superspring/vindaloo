package Vindaloo::Orders;

use Mojo::Base 'Mojolicious::Controller';

use List::MoreUtils 'any';

sub verify_event {
    my $self = shift;
    my $event =
      $self->db->resultset('OrderEvent')->search( { orders_open => 1 } )->first;

    if ( not $event ) {
        $self->redirect_to(
            $self->url_for('ordersclosed')->to_abs->scheme('https') );
        return;
    }
    $self->stash( event => $event );
}

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

    if ( any { not defined $_ } $ingred_obj, $curry_obj, $spice_obj ) {
        $self->app->log->error(
            "User tried to order a curry that did not exist!");
        $self->app->log->error( join " " => $ingredient, $curry, $spice );
        $self->redirect_to(
            $self->url_for('/curries')->to_abs->scheme('https') );
        return 0;
    }

    my $event = $self->stash->{event};
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

sub user_order_admin {
    my $self         = shift;
    my $order_id     = $self->param('id');
    my $event        = $self->stash->{event};
    my $current_user = $self->current_user;
    my $order        = $current_user->orders->find($order_id);
    if ( not defined $order ) {
        $self->app->log->error( "User "
              . $current_user->first_name . " "
              . $current_user->surname
              . " just tried to access an order "
              ."that does not exist or does not"
              ." belong to him/her." );
        $self->render_not_found;
        return;
    }
    $self->stash( order => $order );
}

sub cancel_order {
    my $self         = shift;
    my $order_id     = $self->param('id');
    my $current_user = $self->current_user;

    my $order   = $self->stash->{order};
    my $dish    = $order->dish;
    my $price   = $dish->price;
    my $balance = $current_user->balance;
    $balance -= $price;
    $current_user->balance($balance);
    $current_user->update;
    $order->delete();
    $self->redirect_to( $self->url_for('/curries')->to_abs->scheme('https') );
    return;
}

sub closed {
    my $self = shift;

}

1;

__END__
