package Vindaloo::Forms::Ingredient;

use HTML::FormHandler::Moose;
extends 'Vindaloo::Forms::MenuBase';

has '+item_class' => ( default => 'Vindaloo::Schema::Result::BaseIngredient' );

has_field category => (type => 'Select', label_column => 'name', empty_select
=> '-- Pick a category --');

sub build_render_list {
    return [qw/name category active buttonset/];
}

no HTML::FormHandler::Moose;

1;

__END__
