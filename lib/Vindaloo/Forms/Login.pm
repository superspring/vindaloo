package Vindaloo::Forms::Login;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has '+widget_wrapper' => ( default => 'Bootstrap' );

has_field email => ( type => 'Text', label => 'Email Address', required => 1 );
has_field password => (
    type     => 'Password',
    label    => 'Password',
    required => 1
);

has_field submit  => ( type => 'Submit',value => 'Login' );
has_field 'reset' => ( type => 'Reset' );

has_block buttonset => (
    tag         => 'div',
    class       => ['form-actions'],
    render_list => [qw/submit reset/]
);

sub build_form_element_class {
    return [qw/well form-horizontal/];
}

sub build_update_subfields {
    return {
        'reset' => { do_wrapper => 0,, element_class => [qw/btn/] },
        submit  => { do_wrapper => 0,  element_class => [qw/btn btn-primary/] }
    };
}

sub build_render_list {
    return [qw/email password buttonset/];
}

no HTML::FormHandler::Moose;

1;

__END__
