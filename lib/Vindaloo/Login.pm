package Vindaloo::Login;

use Mojo::Base 'Mojolicious::Controller';

use Vindaloo::Forms::Login;

sub setup_form {
    my $self = shift;
    my $form = Vindaloo::Forms::Login->new();
    $form->process(
        action => $self->url_for('/login')->to_abs->scheme('https') );
    $self->stash( form => $form, breadcrumbs => [ { name => 'Login' } ] );
}

sub index {
    my $self = shift;
    $self->setup_form;
    $self->app->log->debug("Redirected to login.");
}

sub validate {
    my $self = shift;
    $self->setup_form;
    my $form = $self->stash->{form};
    $form->process( params => $self->req->params->to_hash );
    if ( $form->validated ) {
        my $login    = $self->param('email');
        my $password = $self->param('password');
        if ( $self->authenticate( $login, $password ) ) {

            my $current_user = $self->current_user;
            my $user_role = $current_user->roles({name => 'user'})->first;
            $current_user->add_to_roles({name => 'user'}) unless $user_role;

            $self->redirect_to(
                $self->url_for('/curries')->to_abs->scheme('https') );
        }
        else {
            $self->app->log->error("User not authenticated!");
        }
    }
    else {
        $self->app->log->error("Form invalid");
    }
    $self->render('login/index');
}

1;

__END__
