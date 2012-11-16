package Test;

use Moose;
use namespace::autoclean;


use Test::Mojo;


has app_init => (
    is      => 'ro',
    isa     => 'Test::Mojo',
    default => sub {
        my $self = shift;
        my $app  = Test::Mojo->new('Vindaloo');
        return $app;
    },
);

has app => (
    is        => 'ro',
    isa     => 'Test::Mojo',
    builder => 'app_init',
);




1;

__END__
