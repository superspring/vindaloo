package Vindaloo;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
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
    my ( $dsn, $user ) = @{$connect_info}{qw/dsn user/};
    return Vindaloo::Schema->connect( $dsn, $user );
};

sub startup {
  my $self = shift;

    $self->home->parse( catdir( dirname(__FILE__), 'Vindaloo' ) );
    $self->static->paths->[0]   = $self->home->rel_dir('public');
    $self->renderer->paths->[0] = $self->home->rel_dir('templates');
    my $config = $self->plugin('Config');
    $self->app->config( %{$config} );
    $self->plugin( 'bcrypt', { cost => 4 } );
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
  $authenticated_route->get('')->to('curry#index');
  $r->get('/login')->to('login#index');
  $r->post('/login')->to('login#validate');
  $r->get('/signup')->name('signup')->to('users#signup');
  $r->post('/signup')->to('users#signup_validated');


  $authenticated_route->route('/curries')->to('curry#index');
  $authenticated_route->route('/logout')->to('logout#index');

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
    $app->app->log->debug( "Validating user " . "$username with pw $password" );
    my $user =
      $app->db->resultset('User')->search( { email => $username } )->first;
    return 0 unless $user;
    my $user_password = $user->password;
    $app->bcrypt_validate( $user_password, $password );
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
    return $app->current_user->roles->first->quaildog_role;

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


=head1 DEPENDENCIES


=head1 SEE ALSO


