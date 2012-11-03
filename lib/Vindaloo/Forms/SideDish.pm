package Vindaloo::Forms::SideDish;

use HTML::FormHandler::Moose;
extends 'Vindaloo::Forms::MenuBase';

has '+item_class' => ( default => 'Vindaloo::Schema::Result::SideDish' );
has_field price => ( type => 'Text' );

sub build_render_list {
    return [qw/name link price active buttonset/];
}

no HTML::FormHandler::Moose;

1;

__END__
