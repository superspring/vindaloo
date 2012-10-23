package Vindaloo::Users;

use Mojo::Base 'Mojolicious::Controller';

use Vindaloo::Forms::UserAdmin;
use TryCatch;

sub authenticate {
    my $self = shift;
    $self->app->log->debug("Calling basic authentication.");
    $self->redirect_to( $self->url_for('/login')->to_abs->scheme('https') )
      and return 0
      unless $self->is_user_authenticated;
}

sub index {
    my $self = shift;
    my $users = $self->db->resultset('User');
    $self->stash(users => $users);
}

sub admin {
    my $self = shift;
    my $id = $self->param('id');
    my $user = $self->db->resultset('User')->find($id);
    $self->stash(user => $user);
}

sub edit {
    my $self = shift;
    my $user = $self->stash->{user};
    my $form = Vindaloo::Forms::UserAdmin->new();
    $form->process(
        item => $user,
        schema => $self->db,
        action => $self->url_for(edituser => id =>
            $user->id)->to_abs->scheme('https'),
        inactive => [qw/password confirm_password/]

    );
    $self->stash(form => $form);
}

sub post_edit {
    my $self = shift;
    $self->edit;
    my $form  = $self->stash->{form};
    my $request = $self->request->param->to_hash;
    $form->process(params => $request);
    if ($form->validated) {
        $self->redirect_to($self->url_for('userlist')->to_abs->scheme('https'));
    }
}

sub signup {
    my $self = shift;
    my $form = Vindaloo::Forms::UserAdmin->new(
        mojo_bcrypt_validate => sub {
            my ( $bcrypted, $to_confirm ) = @_;
            return $self->bcrypt_validate( $to_confirm, $bcrypted );
        },
        mojo_bcrypt => sub {
            my $value    = shift;
            my $bcrypted = $self->bcrypt($value);
            return $bcrypted;
        }
    );
    $form->process(
        schema => $self->db,
        action => $self->url_for('signup')->to_abs->scheme('https'),
        inactive => [qw/roles/],
    );
    $self->stash(
        form        => $form,
        breadcrumbs => [ { name => 'Sign up' } ]
    );
}

sub signup_validated {
    my $self = shift;
    $self->signup;
    my $form = $self->stash->{form};
    try {
        $form->process(
            params => $self->req->params->to_hash
        );
        if ($form->validated) {
            $self->redirect_to(
                $self->url_for('/')->to_abs->scheme('https')
            );
        }

    }
    catch (DBIx::Class::Exception $e where {$_ ~~ qr/email_key/}) {
        $form->field('email')->add_error("This email already exists!");
    }

    $self->render('users/signup');
}


1;

__END__
