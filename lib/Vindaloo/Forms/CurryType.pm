package Vindaloo::Forms::CurryType;

use HTML::FormHandler::Moose;
extends 'Vindaloo::Forms::MenuBase';

has '+item_class' => ( default => 'Vindaloo::Schema::Result::CurryType' );

no HTML::FormHandler::Moose;

1;

__END__
