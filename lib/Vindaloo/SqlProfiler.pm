package Vindaloo::SqlProfiler;

use strict;
use warnings;
use parent qw(DBIx::Class::Storage::Statistics);

use Time::HiRes qw/time/;


sub query_start {
    my ($start,$sql,@params) = @_;
    my $self->{start} = time;
}

sub query_end {
    my ($self, $sql, @params) = @_;
    my $elapsed = sprintf "%.4f", time - $self->{start};
    delete $self->{start};
}


1;

__END__
