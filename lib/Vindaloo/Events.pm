package Vindaloo::Events;

use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    my $events =
      $self->db->resultset('OrderEvent')
      ->search( undef, { order_by => { -desc => [qw/event_date/] } } );
    $self->stash( events => $events );
}

sub admin {
    my $self  = shift;
    my $id    = $self->param('id');
    my $event = $self->db->resultset('OrderEvent')->find($id);
    $self->stash( event => $event );
}

sub create {
    my $self = shift;
    $self->db->resultset('OrderEvent')->create( { orders_open => 1 } );
    $self->redirect_to( $self->url_for('/events')->to_abs->scheme('https') );
    return 0;
}

sub close {
    my $self  = shift;
    my $event = $self->stash->{event};
    $event->orders_open(undef);
    $event->update;
    $self->redirect_to( $self->url_for('/events')->to_abs->scheme('https') );
    return 0;
}

1;

__END__
