package Vindaloo::Forms::SideDish;

use HTML::FormHandler::Moose;
extends 'Vindaloo::Forms::MenuBase';

has '+item_class' => ( default => 'Vindaloo::Schema::Result::SideDish' );
has_field price   => ( type    => 'Text' );

has_field limited_per_user => (
    type         => 'Checkbox',
    label        => 'Limit Per User',
    label_column => 'limited_per_user'
);

sub build_render_list {
    return [qw/name link price active  limited_per_user buttonset/];
}

no HTML::FormHandler::Moose;

1;

__END__
