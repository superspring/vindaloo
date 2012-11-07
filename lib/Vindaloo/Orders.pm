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
              . "that does not exist or does not"
              . " belong to him/her." );
        $self->render_not_found;
        return;
    }
    $self->stash( order => $order );
}

sub order_history {
    my $self = shift;
    my $user = $self->current_user;
    my %dates;

    my $order_events = $user->order_events;
    $dates{$_}++ foreach $order_events->get_column('event_date')->all;
    my $side_order_events = $user->side_order_events;
    $dates{$_}++ foreach $side_order_events->get_column('event_date')->all;
    my @dates = sort {$a cmp $b } keys %dates;

    $self->stash(  dates => \@dates);
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

sub side_dish {
    my $self      = shift;
    my $link      = $self->param('dish');
    my $side_dish = $self->db->resultset('SideDish')->find( { link => $link } );
    if ( not $side_dish ) {
        $self->app->log->error( 'Side dish ' . $link . ' not found.' );
        $self->render_not_found;
        return 0;
    }
    my $event        = $self->stash->{event};
    my $current_user = $self->current_user;
    $current_user->add_to_side_orders(
        {
            side_dish   => $side_dish->id,
            order_event => $event->id,
        }
    );
    my $balance = $current_user->balance;
    $balance += $side_dish->price;
    $current_user->balance($balance);
    $current_user->update;
    $self->redirect_to( $self->url_for('/curries')->to_abs->scheme('https') );
    return;
}

sub user_side_dish_admin {
    my $self         = shift;
    my $id           = $self->param('id');
    my $current_user = $self->current_user;
    my $side_order   = $current_user->side_orders->find($id);
    if ( not $side_order ) {
        $self->app->log->error( "User "
              . $current_user->first_name . " "
              . $current_user->surname
              . " tried to do something with an order that "
              . " does not exist or belong to him/her " );
        $self->render_not_found;
        return;
    }
    $self->stash( side_order => $side_order );

}

sub cancel_side_dish {
    my $self            = shift;
    my $side_order      = $self->stash->{side_order};
    my $current_user    = $self->current_user;
    my $balance         = $current_user->balance;
    my $side_dish       = $side_order->side_dish;
    my $side_dish_price = $side_dish->price;
    $balance -= $side_dish_price;
    $current_user->balance($balance);
    $side_order->delete;
    $self->redirect_to( $self->url_for('/curries')->to_abs->scheme('https') );
    return;
}

sub orders {
    my $self     = shift;
    my $event    = $self->stash->{event};
    my $model    = $self->db;
    my $order_rs = $event->orders;

    #$model->resultset('Order')->search( { order_event => $event->id } );
    my $orders = $order_rs->search(
        undef,
        {
            columns  => [qw/dish spiceyness/],
            group_by => [qw/dish spiceyness/],
        }
    );
    my $user_orders = $order_rs->search(
        undef,
        {
            columns  => [qw/curry_user /],
            group_by => [qw/curry_user/]
        }
    );
    my $side_order_rs = $event->side_orders;

    #$model->resultset('SideOrder')->search( { order_event => $event->id } );

    my $side_orders =
      $side_order_rs->search( undef,
        { columns => [qw/side_dish/], group_by => [qw/side_dish/] } );
    my $user_side_orders = $side_order_rs->search(
        undef,
        {
            columns  => [qw/curry_user side_dish/],
            group_by => [qw/curry_user side_dish/]
        }
    );

    $self->stash(
        orders           => $orders,
        user_orders      => $user_orders,
        order_rs         => $order_rs,
        side_orders      => $side_orders,
        user_side_orders => $user_side_orders,
        side_order_rs    => $side_order_rs
    );
}

sub payment {
    my $self    = shift;
    my $payment = $self->param('payment');
    my $user    = $self->stash->{user};
    my $balance = $user->balance;
    my $reduce_by;
    given ($payment) {
        when (qr/\A\d+\z/) {
            $reduce_by = $payment;
        }
        when ('today') {
            my $event =
              $self->db->resultset('OrderEvent')->get_column('id')->max;
            my $orders =
              $user->orders( { order_event => $event }, { 'join' => 'dish' } );
            my $side_orders = $user->side_orders( { order_event => $event },
                { 'join' => 'side_dish' } );

            my $order_total = $orders->get_column('dish.price')->sum;
            my $side_order_total =
              $side_orders->get_column('side_dish.price')->sum;

            $reduce_by = $order_total + $side_order_total;
        }
        when ('account') {
            $reduce_by = $balance;
        }
    }
    $balance -= $reduce_by;
    $user->balance($balance);
    $user->update;
    $user->add_to_payments( { payment => $reduce_by } );
    $self->redirect_to( $self->url_for('userlist')->to_abs->scheme('https') );
    return;

}

sub closed {
    my $self = shift;

}

1;

__END__

=head1 NAME

Vindaloo::Orders - Controller for managing order logic.

=head1 SYNOPSIS

  use Vindaloo::Orders;

  # synopsis...

=head1 DESCRIPTION

# longer description...


=head1 INTERFACE

=head2 verify_event

Check that an open event exists.


=head2 order_dish

Process an order request. Add information to set of orders for a particular
B<open> event.


=head2 user_order_admin

Preprocessing step for several order operations. Main job is to store an order
in the stash for following methods.


=head2 cancel_order

Remove an order from the system. Adjust logged in user's account balance
accordingly.


=head2 side_dish

Process a side dish order. Add cost to what user owes.


=head2 user_side_dish_admin

Preprocessing step for processing side dish orders.


=head2 cancel_side_dish

Remove a side dish order from the system.


=head2 orders

Admin page for list of orders. Should be scrollable by event.



=head2 payment

Action for processing payments. Handles incrementing/decrementing users
account balance.

=head1 DEPENDENCIES


=head1 SEE ALSO


