package Vindaloo::Forms::InlineLogin;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field email    => ( type => 'Text',     element_attr => {placeholder =>
"Email"}, label => undef );
has_field password => ( type => 'Password', element_attr => {placeholder =>
"Password"} , label => undef);
has_field submit   => ( type => 'Submit',   value    => 'Login' );

sub build_form_element_class {
    return [qw/form-inline /];
}

sub build_update_subfields {
    return {
        submit => {
            do_wrapper    => 0,
            element_class => [qw/btn btn-primary/]
        },
        email    => { do_wrapper => 0, element_class => [qw/input-small/] },
        password => { do_wrapper => 0, element_class => [qw/input-small/] }
    };
}

sub build_render_list {
    return [qw/email password submit/];
}

no HTML::FormHandler::Moose;

1;

__END__
