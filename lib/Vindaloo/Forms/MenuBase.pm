package Vindaloo::Forms::MenuBase;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';

use Smart::Comments;

has '+widget_wrapper' => ( default => 'Bootstrap' );

has_field name => ( type => 'Text', label => 'Name' );
has_field active => (
    type         => 'Checkbox',
    label        => 'Active',
    label_column => 'active'
);

has_field 'link' => (
    type                 => 'Text',
    disabled => 1,
    deflate_default_method =>\&convert_name_to_link,
    inflate_default_method =>\&convert_name_to_link,
);

sub convert_name_to_link {
        my ( $self, $field ) = @_;
        my $value = lc $self->form->field('name')->value;
        if ( $value =~ /[\s]/ ) {

            $value = lc $value;
            ### name field : $value
            $value =~ s/\s+/-/g;
            ### converted to : $value
            return $value;
        }
        return $value;
}

has_field submit  => ( type => 'Submit' );
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
        'reset' => { do_wrapper => 0, element_class => [qw/btn/] },
        submit  => { do_wrapper => 0, element_class => [qw/btn btn-primary/] },
    };
}

sub build_render_list {
    return [qw/name link active buttonset/];
}

no HTML::FormHandler::Moose;

1;

__END__
