package Vindaloo::Curry;

use Mojo::Base 'Mojolicious::Controller';

use feature 'switch';

use TryCatch;
use Time::HiRes qw/time/;

use Vindaloo::Forms::Ingredient;
use Vindaloo::Forms::CurryType;
use Vindaloo::Forms::SideDish;
use Vindaloo::Forms::MenuItem;

sub index {
    my $self       = shift;
    my $start_time = time;
    $self->app->log->info( "Begin processing index: " . $start_time );
    my $model = $self->db;

    my $spiceyness_rs = $model->resultset('Spiceyness');
    my $spiceynesses  = {};
    while ( my $heat = $spiceyness_rs->next ) {
        $spiceynesses->{ $heat->id } = $heat->name;
    }
    my $new_time = time;
    $self->app->log->info( "Process query 1: " . ( $new_time - $start_time ) );

    my $dish_spiceyness_set =
      $model->resultset('DishSpiceyness')
      ->search( {}, { prefetch => [qw/dish/] } );
    my $dish_spiceyness_hash = {};
    foreach my $dish_spiceyness ( $dish_spiceyness_set->all ) {
        my $spiceyness_id = $dish_spiceyness->get_column('spiceyness');
        $dish_spiceyness_hash->{ $dish_spiceyness->dish->id }->{$spiceyness_id}
          = $spiceynesses->{$spiceyness_id};
    }
    my $new_time2 = time;
    $self->app->log->info( "Process query 2: " . ( $new_time2 - $new_time ) );

    my $side_dishes = $model->resultset('SideDish');
    my $event_resultset =
      $model->resultset('OrderEvent')
      ->search( undef, { order_by => { -desc => [qw/id/] } } );
    my $event     = $event_resultset->next;
    my $new_time3 = time;
    $self->app->log->info( "Process query 3: " . ( $new_time3 - $new_time2 ) );

    my $spiceyness_btn_map = {
        mild   => 'btn-success',
        medium => 'btn-warning',
        hot    => 'btn-danger'
    };
    my $user = $self->current_user;
    my (  $previous_balance, $user_orders );
    my ( $user_side_orders, $latest_payment );
    my $current_balance = 0;
    $current_balance = $user->balance // 0 if $user;
    $self->app->log->info("Users current balance $current_balance");

    my ( $previous_event, $payment_amount,$users_by_dish );
    $self->app->log->info("Work out user balance ");
    if ( $user and $event ) {

        my $dish_time = time;
        $self->app->log->info("Begin processing users-per-dish.");
        my $event_orders = $event->orders({},
            {
                prefetch => [
                    'spiceyness','curry_user',
                        {dish => [qw/base_ingredient curry_type/]}
                ]

            });
        while ( my $event_order = $event_orders->next ) {
            my $dish            = $event_order->dish;
            my $ingredient      = $dish->base_ingredient;
            my $curry           = $dish->curry_type;
            my $ingredient_name = $ingredient->name;
            my $curry_name      = $curry->name;
            my $spiceyness      = $event_order->spiceyness;
            my $spiceyness_name = ucfirst( lc( $spiceyness->name ) );
            my $user            = $event_order->curry_user;
            push @{ $users_by_dish->{$ingredient_name}->{$curry_name}
                  ->{$spiceyness_name} },
              $user;

        }
        $self->app->log->info("Finished processing users-per-dish elapsed: "
            .(time - $dish_time));

        my $event_date = $event->event_date;
        $latest_payment =
          $user->payments->search( { payment_date => $event_date } );
        $user_orders = $user->orders(
            { order_event => $event->id },
            {
                join     => 'dish',
                prefetch => [
                    'spiceyness', { dish => [qw/base_ingredient curry_type/] }
                ]
            }
        );
        $user_side_orders = $user->side_orders( { order_event => $event->id },
            { prefetch => 'side_dish', join => 'side_dish' } );

        my $event_sum = $user_orders->get_column('dish.price')->sum // 0;
        my $side_dish_event_sum =
          $user_side_orders->get_column('side_dish.price')->sum // 0;
        $event_sum += $side_dish_event_sum;

        $event_sum = sprintf "%.2f", $event_sum;
        $previous_balance = $current_balance - $event_sum;
        if ($latest_payment) {
            my $sum = $latest_payment->get_column('payment')->sum // 0;
            $payment_amount = sprintf "%.2f", $sum;
        }
        $previous_balance += $payment_amount if $payment_amount;
        $previous_balance = sprintf "%.2f", $previous_balance;

        $self->app->log->debug( 'Event sum ' . $event_sum );
        $previous_event = $event_resultset->next;

    }
    my $new_time4 = time;
    $self->app->log->info(
        "Finished with account stuff: " . ( $new_time4 - $new_time3 ) );
    my $categories = $model->resultset('IngredientCategory');

    $self->stash(
        categories        => $categories,
        spiceyness_btns   => $spiceyness_btn_map,
        event             => $event,
        user_orders       => $user_orders,
        user_side_orders  => $user_side_orders,
        previous_balance  => $previous_balance,
        side_dishes       => $side_dishes,
        latest_payment    => $payment_amount,
        spiceynesses      => $spiceynesses,
        dish_spiceynesses => $dish_spiceyness_hash,
        previous_event    => $previous_event,
        users_by_dish => $users_by_dish,
    );

}

sub menu {
    my $self = shift;
    $self->base_ingredients;
    $self->curry_types;
    $self->side_dishes;
    my $spiceyness_btn_map = {
        mild   => 'btn-success',
        medium => 'btn-warning',
        hot    => 'btn-danger'
    };
    my $menus = $self->db->resultset('CurryMenu')->search(
        undef,
        {
            order_by =>
              { '-asc' => [qw/base_ingredient curry_type spiceyness/] }
        }
    );
    my $categories = $self->db->resultset('IngredientCategory');
    $self->stash(
        menus         => $menus,
        categories    => $categories,
        spicey_button => $spiceyness_btn_map
    );
}

sub base_ingredients {
    my $self             = shift;
    my $base_ingredients = $self->db->resultset('BaseIngredient');
    $self->stash( bases => $base_ingredients );
}

sub curry_types {
    my $self        = shift;
    my $curry_types = $self->db->resultset('CurryType');
    $self->stash( curry_types => $curry_types );
}

sub side_dishes {
    my $self        = shift;
    my $side_dishes = $self->db->resultset('SideDish');
    $self->stash( side_dishes => $side_dishes );
}

sub type {
    my $self  = shift;
    my $model = $self->db;
    my $type  = $self->param('type');
    my ( $redirect_to, $form );
    given ($type) {
        when ('base-ingredient') {
            $form = Vindaloo::Forms::Ingredient->new();
        }
        when ('curry-type') {
            $form = Vindaloo::Forms::CurryType->new();
        }
        when ('side-dish') {
            $form = Vindaloo::Forms::SideDish->new();
        }
        when ('menu') {
            $form = Vindaloo::Forms::MenuItem->new();
        }

    }
    $redirect_to = $self->url_for('currymanager')->to_abs->scheme('https');
    $self->stash( form => $form, type => $type, redirect_to => $redirect_to );
}

sub admin {
    my $self  = shift;
    my $id    = $self->param('id');
    my $type  = $self->stash->{type};
    my $model = $self->db;
    my $resultset;
    given ($type) {
        when ('base-ingredient') {
            $resultset = $model->resultset('BaseIngredient');
        }
        when ('curry-type') {
            $resultset = $model->resultset('CurryType');
        }
        when ('side-dish') {
            $resultset = $model->resultset('SideDish');
        }
        when ('menu') {
            $resultset = $model->resultset('CurryMenu');
        }
    }
    if ($resultset) {
        my $object = $resultset->find($id);
        $self->stash( item => $object ) if $object;
    }
}

sub deactivate {
    my $self = shift;
    my $item = $self->stash->{item};
    $item->active(undef);
    $item->update;
    $self->redirect_to(
        $self->url_for('currymanager')->to_abs->scheme('https')
    );
    return;
}

sub create {
    my $self = shift;
    my $type = $self->stash->{type};
    my $action =
      $self->url_for( createmenuitem => type => $type )
      ->to_abs->scheme('https');
    $self->stash( form_action => $action );
    $self->process_form;

}

sub process_form {
    my $self = shift;
    my ( $type, $form, $item, $action ) = @{ $self->stash }{
        qw/type form item
          form_action/
    };
    try {
        my @item_param;
        push @item_param, item => $item if $item;
        $form->process(
            @item_param,
            params => $self->req->params->to_hash,
            schema => $self->db,
            action => $action
        );
        if ( $form->validated ) {
            $self->redirect_to( $self->stash->{redirect_to} );
        }
    }
    catch (DBIx::Class::Exception $e) {
        $form->add_form_error("This item already exists!");
    }

}

sub edit {
    my $self = shift;
    my ( $type, $item ) = @{ $self->stash }{qw/type item/};
    my $action =
      $self->url_for( editmenuitem => type => $type => id => $item->id )
      ->to_abs->scheme('https');
    $self->stash( form_action => $action );
    $self->process_form;

}

1;

__END__

=head1 NAME

Vindaloo::Curry - Controller for managing curry list.

=head1 SYNOPSIS

  use Vindaloo::Curry;

  # synopsis...

=head1 DESCRIPTION

# longer description...


=head1 INTERFACE

=head2 index

Display list of available curries.

=head2 menu

Manage interface for curries.

=head2 base_ingredients

Action for managing list of base ingredients.

=head2 curry_types

Action for managing list of curry types.


=head2 side_dishes

Action for managing list of side dishes.


=head2 type

Geneeral admin action to load relevant form for base ingredient, curry type,
or side dish.


=head2 admin

Preprocessing step to fetch relevant object from db.

=head2 create

Create an object in the database.

=head2 process_form

Generic method for processing the menu item forms.


=head2 edit

Setup form for processing.












=head1 DEPENDENCIES


=head1 SEE ALSO


