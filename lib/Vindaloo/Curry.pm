package Vindaloo::Curry;

use Mojo::Base 'Mojolicious::Controller';

use feature 'switch';

use Vindaloo::Forms::Ingredient;
use Vindaloo::Forms::CurryType;
use Vindaloo::Forms::SideDish;
use Vindaloo::Forms::MenuItem;

sub index {
    my $self               = shift;
    my $model              = $self->db;
    my $categories         = $model->resultset('IngredientCategory');
    my $ingredients        = $self->db->resultset('BaseIngredient');
    my $curry_types        = $self->db->resultset('CurryType');
    my $spiceyness         = $self->db->resultset('Spiceyness');
    my $menus              = $self->db->resultset('CurryMenu');
    my $spiceyness_btn_map = {
        mild   => 'btn-success',
        medium => 'btn-warning',
        hot    => 'btn-danger'
    };
    $self->stash(
        categories      => $categories,
        ingredients     => $ingredients,
        curry_types     => $curry_types,
        spiceyness      => $spiceyness,
        menus           => $menus,
        spiceyness_btns => $spiceyness_btn_map
    );

}

sub menu {
    my $self = shift;
    $self->base_ingredients;
    $self->curry_types;
    $self->side_dishes;
    my $spiceyness_btn_map = {
        mild   => 'btn-success',
        medium => 'btn-warning',
        hot    => 'btn-danger'
    };
    my $menus = $self->db->resultset('CurryMenu')->search(
        undef,
        {
            order_by =>
              { '-asc' => [qw/base_ingredient curry_type spiceyness/] }
        }
    );
    my $categories = $self->db->resultset('IngredientCategory');
    $self->stash(
        menus         => $menus,
        categories    => $categories,
        spicey_button => $spiceyness_btn_map
    );
}

sub base_ingredients {
    my $self             = shift;
    my $base_ingredients = $self->db->resultset('BaseIngredient');
    $self->stash( bases => $base_ingredients );
}

sub curry_types {
    my $self        = shift;
    my $curry_types = $self->db->resultset('CurryType');
    $self->stash( curry_types => $curry_types );
}

sub side_dishes {
    my $self        = shift;
    my $side_dishes = $self->db->resultset('SideDish');
    $self->stash( side_dishes => $side_dishes );
}

sub type {
    my $self  = shift;
    my $model = $self->db;
    my $type  = $self->param('type');
    my ( $redirect_to, $form );
    given ($type) {
        when ('base-ingredient') {
            $form = Vindaloo::Forms::Ingredient->new();
        }
        when ('curry-type') {
            $form = Vindaloo::Forms::CurryType->new();
        }
        when ('side-dish') {
            $form = Vindaloo::Forms::SideDish->new();
        }
        when ('menu') {
            $form = Vindaloo::Forms::MenuItem->new();
        }

    }
    $redirect_to = $self->url_for('/curry/menu')->to_abs->scheme('https');
    $self->stash( form => $form, type => $type, redirect_to => $redirect_to );
}

sub admin {
    my $self  = shift;
    my $id    = $self->param('id');
    my $type  = $self->stash->{type};
    my $model = $self->db;
    my $resultset;
    given ($type) {
        when ('base-ingredient') {
            $resultset = $model->resultset('BaseIngredient');
        }
        when ('curry-type') {
            $resultset = $model->resultset('CurryType');
        }
        when ('side-dish') {
            $resultset = $model->resultset('SideDish');
        }
        when ('menu') {
            $resultset = $model->resultset('CurryMenu');
        }
    }
    if ($resultset) {
        my $object = $resultset->find($id);
        $self->stash( item => $object ) if $object;
    }
}

sub create {
    my $self = shift;
    my $type = $self->stash->{type};
    my $action =
      $self->url_for( createmenuitem => type => $type )
      ->to_abs->scheme('https');
    $self->stash( form_action => $action );
    $self->process_form;

}

sub process_form {
    my $self = shift;
    my ( $type, $form, $item, $action ) = @{ $self->stash }{
        qw/type form item
          form_action/
    };
    my @item_param;
    push @item_param, item => $item if $item;
    $form->process(
        @item_param,
        params => $self->req->params->to_hash,
        schema => $self->db,
        action => $action
    );
    if ( $form->validated ) {
        $self->redirect_to( $self->stash->{redirect_to} );
    }

}

sub edit {
    my $self = shift;
    my ( $type, $item ) = @{ $self->stash }{qw/type item/};
    my $action =
      $self->url_for( editmenuitem => type => $type => id => $item->id )
      ->to_abs->scheme('https');
    $self->stash( form_action => $action );
    $self->process_form;

}

1;

__END__
