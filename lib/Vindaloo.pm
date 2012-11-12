package Vindaloo;
use Mojo::Base 'Mojolicious';

use File::Basename 'dirname';
use File::Spec::Functions 'catdir';

use Vindaloo::Schema;

has schema => sub {
    my $self   = shift;
    my $config = $self->app->config;
    ### config : $config
    my $schema_config = $config->{'Vindaloo::Schema'};
    my $connect_info  = $schema_config->{connect_info};
    ### connect info: $connect_info
    my ( $dsn, $user, $password ) = @{$connect_info}{qw/dsn user password/};
    return Vindaloo::Schema->connect( $dsn, $user, $password );
};

sub startup {
    my $self = shift;

    $self->home->parse( catdir( dirname(__FILE__), 'Vindaloo' ) );
    $self->static->paths->[0]   = $self->home->rel_dir('public');
    $self->renderer->paths->[0] = $self->home->rel_dir('templates');

    my $config = $self->plugin('Config');
    $self->app->config( %{$config} );
    $self->plugin( 'bcrypt', { cost => 4 } );
    $self->plugin(
        Libravatar => {
            size       => 30,
            rating     => 'PG',
            https      => 1,
            mojo_cache => 1,
        }
    );

    $self->helper(
        db => sub {
            my $app = shift;
            $self->app->schema;
        }
    );
    $self->plugin(
        authentication => {
            autoload_user => 1,
            session_key   => 'hotteenvindaloo',
            load_user     => \&load_user,
            validate_user => \&validate_user,
        }
    );
    $self->plugin(
        Authorization => {
            has_priv   => \&has_priv,
            is_role    => \&is_role,
            user_privs => \&user_privs,
            user_role  => \&user_role
        }
    );

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    # Router
    my $r = $self->routes;

    # Basic authentication for all routes.
    my $authenticated_route = $r->bridge('/')->to('users#authenticate');

    # This is the landing page
    $authenticated_route->route('/menu')->name('menu')->to('curry#index');

    $authenticated_route->get('')->to('curry#index');
    $r->get('/login')->to('login#index');
    $r->post('/login')->to('login#validate');
    $r->get('/signup')->name('signup')->to('users#signup');
    $r->post('/signup')->to('users#signup_validated');
    $authenticated_route->route('/logout')->to('logout#index');

    # Main user list
    $authenticated_route->route('/users')->over( is => 'admin' )
      ->name('userlist')->to('users#index');

    # User admin route. Takes :id param from path
    my $user_admin =
      $authenticated_route->bridge('/user/admin/:id')->over( is => 'admin' )
      ->to('users#admin');
    $user_admin->get('/edit')->name('edituser')->to('users#edit');
    $user_admin->post('/edit')->to('users#post_edit');
    $user_admin->route('/payment/:payment')->name('payment')
      ->to('orders#payment');
    my $user_password_admin =
      $user_admin->bridge('/password')->to('users#password');

    $user_password_admin->get('/edit')->name('adminpasswordedit')
      ->to('users#edit');
    $user_password_admin->post('/edit')->to('users#post_edit');

    # Menu (curry) management
    $authenticated_route->route('/curry/manage')->over( is => 'admin' )
      ->name('currymanager')->to('curry#menu');
    $authenticated_route->route('/curry/base-ingredients')
      ->over( is => 'admin' )->to('curry#base_ingredients');
    $authenticated_route->route('/curry/curry-types')->over( is => 'admin' )
      ->to('curry#curry_types');
    $authenticated_route->route('/curry/side-dishes')->over( is => 'admin' )
      ->to('curry#side_dishes');

    # Event management
    $authenticated_route->route('/events')->over( is => 'admin' )
      ->to('events#index');
    $authenticated_route->route('/event/create')->name('createevent')
      ->over( is => 'admin' )->to('events#create');
    my $event_admin =
      $authenticated_route->bridge('/event/admin/:id')->over( is => 'admin' )
      ->to('events#admin');
    $event_admin->route('/close')->name('closeevent')->to('events#close');
    $event_admin->route('/open')->name('openevent')->to('events#open');

    $event_admin->route('/orders')->name('eventorders')->to('orders#orders');

    # Edit a type of curry (type means "base ingredient", "curry type", or
    # "side dish", not necessarily a type of curry
    my $curry_manager =
      $authenticated_route->bridge('/curry/type/:type')->over( is => 'admin' )
      ->to('curry#type');
    $curry_manager->route('/create')->name('createmenuitem')
      ->to('curry#create');
    my $admin_curry = $curry_manager->bridge('/admin/:id')->to('curry#admin');
    $admin_curry->route('/edit')->name('editmenuitem')->to('curry#edit');
    $admin_curry->route('/deactivate')->name('deactivatemenuitem')
      ->to('curry#deactivate');

    # Profile management (user stuff like change profile, edit pw, name,
    # etc.
    my $profile_admin =
      $authenticated_route->bridge('/user/profile')->to('users#profile');
    $profile_admin->get('/edit')->name('editprofile')->to('users#edit');
    $profile_admin->post('/edit')->to('users#post_edit');
    my $password_admin =
      $profile_admin->bridge('/password')->to('users#password');
    $password_admin->get('/edit')->name('changepassword')->to('users#edit');
    $password_admin->post('/edit')->to('users#post_edit');

    $authenticated_route->route('/user/order-history')->name('orderhistory')
      ->to('orders#order_history');

    # User routes for ordering dishes and sides.
    my $user_order =
      $authenticated_route->bridge('/order')->over( is => 'user' )
      ->to('orders#verify_event');

    $user_order->route('/dish/:ingredient/:curry/:spice')->name('orderdish')
      ->to('orders#order_dish');

    $user_order->route('/random/:category/:spice')->name('randomcategoryorder')
      ->to('orders#random_curry');
    my $user_order_admin =
      $user_order->bridge('/admin/:id')->to('orders#user_order_admin');
    $user_order_admin->route('/cancel')->name('cancelorder')
      ->to('orders#cancel_order');

    $user_order->route('/side-dish/:dish')->name('ordersidedish')
      ->to('orders#side_dish');

    my $side_dish_admin =
      $user_order->bridge('/side-dish/admin/:id')
      ->to('orders#user_side_dish_admin');

    $side_dish_admin->route('/cancel')->name('cancelsidedish')
      ->to('orders#cancel_side_dish');

    $r->route('/orders/closed')->name('ordersclosed')->to('orders#closed');

}

sub load_user {
    my ( $app, $uid ) = @_;
    my $ref_app = ref $app;
    $app->app->log->debug("$ref_app loading user $uid");
    my $schema = $app->db;
    my $user   = $schema->resultset('User')->find($uid);
    return $user;
}

sub validate_user {
    my ( $app, $username, $password, $extradata ) = @_;
    my $logger = $app->app->log;

    #$logger->debug( "Validating user " . "$username with pw $password" );
    my $user =
      $app->db->resultset('User')->search( { email => $username } )->first;
    if ( not $user ) {
        $app->redirect_to( $app->url_for('menu')->to_abs->scheme('https') );
        return;
    }
    $logger->debug( "Queried user with id: " . $user->id );
    $logger->debug("User available");
    my $user_password = $user->password;
    my $result = $app->bcrypt_validate( $password, $user_password );
    $logger->debug( "User validated with result: " . $result );
    return unless $result;
    return $user->id;
}

sub has_priv {
    my ( $app, $privilege, $extradata ) = @_;
    return 1;

}

sub is_role {
    my ( $app, $role, $extradata ) = @_;
    my $user = $app->current_user;
    if ( not $user ) {
        $app->redirect_to(
            $app->url_for( '/login', )->to_abs->scheme('https') );
        return 0;
    }
    $app->app->log->debug(
        "Checking if " . $user->email . " has role " . $role );
    my $count = $user->roles( { 'role.name' => $role } )->count;
    return $count;

}

sub user_privs {
    return 1;
}

sub user_roles {
    my ( $app, $extradata ) = @_;
    return $app->current_user->roles->first->name;

}

1;

=head1 NAME

Vindaloo - A place to order curries

=head1 SYNOPSIS

  use Vindaloo;



=head1 DESCRIPTION

Nothing special



=head1 INTERFACE


=head2 load_user

Authentication method.

=head2 startup

Sets up routing and helpers.

=head2 load_user

Authorization method used to fetch the user object (a
L<DBIx::Class|DBIx::Class>) object from the database.

=head2 validate_user

Use the BCrypt plugin to validate the password submitted by the user with that
stored in the db.


=head2 has_priv

Check to see if user has specified privilege. Not implemented at the moment as
there are no privileges.


=head2 is_role

Check to see if user has a specific role. Current possibilties are B<user> and
B<admin>.


=head2 user_privs

Return set of privileges for a the current user. Currently not implemented.


=head2 user_roles

Return set of roles for a given user.








=head1 DEPENDENCIES


=head1 SEE ALSO


