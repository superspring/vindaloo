package Vindaloo::Forms::MenuItem;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

has '+widget_wrapper' => ( default => 'Bootstrap' );
has '+item_class'     => ( default => 'Vindaloo::Schema::Result::CurryMenu' );

has_field base_ingredient => (
    type         => 'Select',
    empty_select => '-- Pick an
Ingredient --',
    label_column => 'name'
);
has_field curry_type => (
    type         => 'Select',
    empty_select => '-- Pick a
curry --',
    label_column => 'name'
);
has_field spiceynesses => (
    type         => 'Multiple',
    widget       => 'CheckboxGroup',
    label_column => 'name',
    label        => 'Spiceyness'
);
has_field price => ( type => 'Text' );
has_field active => ( type => 'Checkbox', label_column => 'active' );

has_field submit => ( type => 'Submit' );
has_field cancel => ( type => 'Reset' );

has_block buttonset => (
    tag         => 'div',
    class       => ['form-actions'],
    render_list => [qw/submit cancel/]
);

sub build_form_element_class {
    return [qw/well form-horizontal/];
}

sub build_update_subfields {
    return {
        cancel => { do_wrapper => 0, element_class => [qw/btn/] },
        submit => { do_wrapper => 0, element_class => [qw/btn btn-primary/] }
    };
}

sub build_render_list {
    return [qw/base_ingredient curry_type spiceynesses price active buttonset/];
}

no HTML::FormHandler::Moose;

1;

__END__
