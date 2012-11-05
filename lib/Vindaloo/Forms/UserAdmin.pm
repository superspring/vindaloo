package Vindaloo::Forms::UserAdmin;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';


has '+widget_wrapper' => ( default => 'Bootstrap' );
has '+item_class'     => ( default => 'Vindaloo::Schema::Result::User' );

has mojo_bcrypt       => (
    is  => 'ro',
    isa => 'CodeRef',
);
has mojo_bcrypt_validate => (
    is  => 'ro',
    isa => 'CodeRef',
);

has_field first_name => (
    type        => 'Text',
    label       => 'First name',
    placeholder => 'First Name',
    required    => 1,
);

has_field surname => ( type => 'Text', label => 'Last name', required => 1,);
has_field password => (
    type                 => 'Password',
    label                => 'Password',
    required             => 1,
    deflate_value_method => \&password_deflator,
);
has_field confirm_password => (
    type     => 'Password',
    label    => 'Confirm Password',
    required => 1,
    noupdate => 1,
);
has_field email => ( type => 'Text', label => 'Email', required => 1,);
has_field roles => (
    type         => 'Multiple',
    widget       => 'CheckboxGroup',
    label_column => 'name',

);
has_field submit => ( type => 'Submit', noupdate => 1 );
has_field 'reset' => ( type => 'Reset' );
has_block buttonset => (
    tag         => 'div',
    class       => ['form-actions'],
    render_list => [qw/submit reset/]
);

sub password_deflator {
    my ( $self, $value ) = @_;
    my $mojo_bcrypt = $self->form->mojo_bcrypt;
    return $mojo_bcrypt->($value);
}

sub validate_confirm_password {
    my ( $self, $field ) = @_;
    my $password = $self->field('password');
    my $bcrypter = $self->mojo_bcrypt;
    my $validate = $self->mojo_bcrypt_validate;
    $field->add_error('Passwords do not match!')
      unless $validate->( $password->value, $field->value );
}

sub build_form_element_class {
    return [qw/well form-horizontal/];
}

sub build_update_subfields {
    return {
        'reset' => { do_wrapper => 0, element_class => [qw/btn /] },
        submit  => {
            do_wrapper    => 0,
            element_class => [qw/btn btn-primary/]
        },
    };
}

sub build_render_list {
    return [
        qw/first_name surname password confirm_password email roles buttonset/];
}

no HTML::FormHandler::Moose;

1;

__END__
