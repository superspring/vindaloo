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
