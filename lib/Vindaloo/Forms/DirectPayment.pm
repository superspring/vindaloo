package Vindaloo::Forms::DirectPayment;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has '+widget_wrapper' => ( default => 'Bootstrap' );

has_field payment => ( type => 'Integer', label => 'Payment', required => 1 );
has_field 'reset' => ( type => 'Reset' );
has_field submit  => ( type => 'Submit' );
has_block buttonset => (
    tag         => 'div',
    class       => [qw/form-actions/],
    render_list => [qw/submit reset/]
);

sub build_form_element_class {
    return [qw/well form-horizontal/];
}

sub build_update_subfields {
    return {
        'reset' => { do_wrapper => 0, element_class => [qw/btn/] },
        submit  => { do_wrapper => 0, element_class => [qw/btn btn-primary/] }
    };
}

sub build_render_list {
    return [ qw/ payment buttonset/ ];
}

no HTML::FormHandler::Moose;

1;

__END__
