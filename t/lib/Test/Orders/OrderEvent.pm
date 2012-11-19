package Test::Orders::OrderEvent;

use Test::Routine;
use Test::More;

test admin_open_event => { desc => "Login as admin and open an event" } => sub {
    my $self = shift;
    my $app  = $self->app;
    $self->login( { email => 'admin@user.com', password => 'test123' } )
      ->get_ok('/event/create');

    my $event =
      $app->app->db->resultset('OrderEvent')->search( { orders_open => 1 } )
      ->first;
    $app->get_ok('/logout');
    BAIL_OUT("No active event.") unless $event;
    $self->{event} = $event;
};

test user_orders => { desc => "Login as user and order." } => sub {
    my $self       = shift;
    my $app = $self->app;
    my @spices     = qw/mild medium hot/;
    my @categories = qw/chicken lamb beef vegetable/;
    my $orders = [];
    foreach my $count ( 1 .. 7 ) {
        my $spice    = $spices[ int( rand( scalar @spices ) ) ];
        my $category = $categories[ int( rand( scalar @categories ) ) ];
        my $email    = 'test' . $count . '@test.com';
        $self->login(
            {
                email    => $email,
                password => '1234'
            }
          )->get_ok( '/order/random/' . $category . '/' . $spice );
          push @{$orders},$category;

          $app->get_ok('/logout');
    }
    $self->{orders} = $orders;
};

test admin_close_event => { desc => "Login as admin and close event." } => sub {
    my $self  = shift;
    my $event = $self->{event};
    my $orders = $self->{orders};
    my $sum = 0;
    foreach my $order (@{$orders}) {
        if ($order eq 'vegetable') {
            $sum += 10;
        }
        else {
            $sum += 11;
        }
    }
    $self->login(
        {
            email    => 'admin@user.com',
            password => 'test123'
        }
    )->get_ok('/event/admin/'.$event->id.'/close')
    ->get_ok( '/event/admin/' . $event->id . '/orders#by-dish'
    )->content_like(qr/\$$sum/)->get_ok('/logout');
};

1;

__END__
