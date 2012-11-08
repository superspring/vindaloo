package Vindaloo::Events;

use Mojo::Base 'Mojolicious::Controller';
use TryCatch;
sub index {
    my $self = shift;
    my $events =
      $self->db->resultset('OrderEvent')
      ->search( undef, { order_by => { -desc => [qw/event_date/] } } );
    $self->stash( events => $events );
}

sub admin {
    my $self              = shift;
    my $id                = $self->param('id');
    my $event_rs          = $self->db->resultset('OrderEvent');
    my $event             = $event_rs->find($id);
    my $previous_event_id = $event->id - 1;
    my $next_event_id     = $event->id + 1;
    my ( $previous_event, $next_event );
    $previous_event = $event_rs->find($previous_event_id)
      unless $previous_event_id <= 0;
    $next_event = $event_rs->find($next_event_id);
    $self->stash( event => $event, previous_event => $previous_event,
        next_event => $next_event );
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

sub open {
    my $self = shift;
    my $event = $self->stash->{event};
    
}

1;

__END__

=head1 NAME

Vindaloo::Events - Controller for managing events in Curry Land

=head1 SYNOPSIS

  use Vindaloo::Events;

  # synopsis...

=head1 DESCRIPTION

# longer description...


=head1 INTERFACE


=head2 index

Landing page for event management interface.


=head2 admin

Preprocessing step for managing events.


=head2 create

Add a new open event.

=head2 close

Close an open event.


=head1 DEPENDENCIES


=head1 SEE ALSO


