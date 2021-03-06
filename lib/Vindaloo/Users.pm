package Vindaloo::Users;

use Mojo::Base 'Mojolicious::Controller';

use feature 'switch';

use Vindaloo::Forms::UserAdmin;
use Vindaloo::Forms::DirectPayment;
use TryCatch;
use Data::Dumper;

sub authenticate {
    my $self = shift;
    $self->app->log->info("Calling basic authentication.");
    $self->redirect_to( $self->url_for('/login')->to_abs->scheme('https') )
      and return
      unless $self->is_user_authenticated;
}

sub index {
    my $self = shift;
    my $users =
      $self->db->resultset('User')
      ->search( undef, { order_by => { -asc => [qw/surname/] } } );
    $self->stash(  users => $users, );
}


sub admin {
    my $self = shift;
    my $id   = $self->param('id');
    my $user = $self->db->resultset('User')->find($id);
    $self->stash(
        user        => $user,
        form_action => $self->url_for( edituser => id => $user->id )
          ->to_abs->scheme('https'),
        validate_redirect =>
          $self->url_for('userlist')->to_abs->scheme('https'),
        inactive_fields => [qw/password confirm_password/]
    );
}

sub profile {
    my $self = shift;
    my $user = $self->current_user;

    # override the action set in admin
    $self->stash(
        user        => $user,
        form_action => $self->url_for( editprofile => id => $user->id )
          ->to_abs->scheme('https'),
        validate_redirect =>
          $self->url_for('menu')->to_abs->scheme('https'),
        inactive_fields => [qw/roles password confirm_password/]
    );

}

sub password {
    my $self = shift;
    my ( $current_user, $user, $form_action, $validate_redirect );
    $current_user = $self->current_user;
    $user         = $self->stash->{user};
    if ( $self->is('admin') and ( $user->id != $current_user->id ) ) {
        $form_action =
          $self->url_for( adminpasswordedit => id => $user->id )
          ->to_abs->scheme('https');
        $validate_redirect =
          $self->url_for('userlist')->to_abs->scheme('https');
    }
    else {
        $form_action =
          $self->url_for('changepassword')->to_abs->scheme('https');
        $validate_redirect =
          $self->url_for('menu')->to_abs->scheme('https');

    }
    $self->stash(
        user              => $user,
        form_action       => $form_action,
        validate_redirect => $validate_redirect,
        inactive_fields   => [qw/first_name surname roles email receive_email/]
    );
}

sub edit {
    my $self = shift;
    my $user = $self->stash->{user};
    my $form = Vindaloo::Forms::UserAdmin->new(
        mojo_bcrypt_validate => sub { $self->mojo_bcrypt_validate(@_) },
        mojo_bcrypt          => sub { $self->mojo_bcrypt(@_) }
    );
    $form->process(
        item     => $user,
        schema   => $self->db,
        action   => $self->stash->{form_action},
        inactive => $self->stash->{inactive_fields}
    );
    $self->stash( form => $form );
}

sub post_edit {
    my $self = shift;
    $self->edit;
    my $form    = $self->stash->{form};
    my $request = $self->req->params->to_hash;
    $self->app->log->debug("submitted: ".Dumper($request));
    $form->process(
        params   => $request,
        item     => $self->stash->{user},
        inactive => $self->stash->{inactive_fields}
    );
    if ( $form->validated ) {
        $self->redirect_to( $self->stash->{validate_redirect} );
    }
    else {
        $self->app->log->error(Dumper($form->errors));
        $self->app->log->error("User submitted invalid data: ".Dumper($request));
    }
    $self->render('users/edit');
}

sub signup {
    my $self = shift;
    my $form = Vindaloo::Forms::UserAdmin->new(
        mojo_bcrypt_validate => sub {
            my ( $bcrypted, $to_confirm ) = @_;
            return $self->bcrypt_validate( $to_confirm, $bcrypted );
        },
        mojo_bcrypt => sub {
            my $value = shift;
            $self->mojo_bcrypt($value);
        }
    );
    $form->process(
        schema   => $self->db,
        action   => $self->url_for('signup')->to_abs->scheme('https'),
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
            inactive => [qw/roles/],
            params => $self->req->params->to_hash );
        if ( $form->validated ) {
            $self->app->log->debug("Validated");
            $self->redirect_to( $self->url_for('/')->to_abs->scheme('https') );
        }
    }
    catch( DBIx::Class::Exception $e where { $_ ~~ qr/email_key/ } ) {
        $form->field('email')->add_error("A user with this email already exists!");
     }

      $self->render('users/signup');
}

sub direct_pay {
    my $self = shift;
    my $user = $self->stash->{user};
    my $form_action = $self->url_for(directpay => id =>
        $user->id)->to_abs->scheme('https');
    my $form = Vindaloo::Forms::DirectPayment->new();
    my @request_params;
    my $params = $self->req->params->to_hash;
    push @request_params, params => $params;

    $form->process(
        @request_params,
        action => $form_action
    );
    if ($form->validated) {
        my $payment = $self->param('payment');
        $self->redirect_to($self->url_for(payment => payment =>
                $payment)->to_abs->scheme('https'));
        return;
    }
    $self->stash(form => $form);

}

sub mojo_bcrypt_validate {
    my ( $self, $bcrypted, $to_confirm ) = @_;

    return $self->bcrypt_validate( $to_confirm, $bcrypted );
}

sub mojo_bcrypt {
    my ( $self, $value ) = @_;
    my $bcrypted = $self->bcrypt($value);
    return $bcrypted;
}


1;

__END__


=head1 NAME

Vindaloo::Users - Controller for managing users.

=head1 SYNOPSIS

  use Vindaloo::Users;

  # synopsis...

=head1 DESCRIPTION

# longer description...


=head1 INTERFACE

=head2 authenticate

Checks that a user is authenticated. Routes to L<login> if not.


=head2 index

Landing page for this controller. Displays list of users.


=head2 admin

Bridge method for fetching user object from db based on C<:id> parameter in
request.


=head2 profile

Action for user profile changes.

=head2 password

Action for user password changes.



=head2 edit

Set up form for basic changes to user profile or administrative information.


=head2 post_edit

Handle the POSTed form data for an edit.

=head2 signup

Set up form for users to sign up to the site.

=head2 signup_validated

Handle POSTed form data for user signup.


=head2 mojo_bcrypt_validate

Callback handed to instance of L<HTML::FormHandler|HTML::FormHandler> for
validating password fields submitted during signup.


=head2 mojo_bcrypt

Callback passed to L<HTML::FormHandler> instance. This calls the
L<Mojolicious::Plugin::BCrypt> method internally.








=head1 DEPENDENCIES


=head1 SEE ALSO


