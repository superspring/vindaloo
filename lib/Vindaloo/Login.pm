package Vindaloo::Login;

use Mojo::Base 'Mojolicious::Controller';

use Vindaloo::Forms::Login;

sub setup_form {
    my $self = shift;
    my $form = Vindaloo::Forms::Login->new();
    $form->process(
        action => $self->url_for('/login')->to_abs->scheme('https')
    );
    $self->stash(form => $form, breadcrumbs => [{name => 'Login'}]);
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
    $form->process(forms => $self->req->params->to_hash);
    if ($form->validated) {
        my $login = $self->param('email');
        my $password = $self->param('password');
        if ($self->authenticated($login,$password)) {
            $self->redirect_to(
                $self->url_for('/')->to_abs->scheme('https')
            );
        }
    }
    $self->render('login/index');
}

1;

__END__
