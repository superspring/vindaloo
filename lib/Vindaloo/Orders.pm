package Vindaloo::Orders;

use Mojo::Base 'Mojolicious::Controller';

sub order_dish {
    my $self  = shift;
    my $dish  = $self->param('dish');
    my $user  = $self->current_user;
    my $model = $self->db;
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
                dish        => $dish,
                order_event => $event->id,
                curry_user  => $user->id
            }
        );
        my $dish_obj = $model->resultset('CurryMenu')->find($dish);
        my $balance = $user->balance;
        $balance += $dish_obj->price;
        $user->balance($balance);
        $user->update;

    };
    if ( my $e = $@ ) {
        $self->app->log->error( "Error inserting order: " . $e );
    }
    $self->redirect_to( $self->url_for('/curries')->to_abs->scheme('https') );

    return ;
}

sub closed {
    my $self = shift;

}

1;

__END__
