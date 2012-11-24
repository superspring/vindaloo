package Vindaloo::Schema::Result::Spiceyness;

use Moose;
use namespace::autoclean;
BEGIN { extends 'DBIx::Class::Core' }

__PACKAGE__->table('spiceyness');
__PACKAGE__->add_columns(qw/id name/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint([qw/name/]);


__PACKAGE__->has_many(
    orders => Order => { 'foreign.spiceyness' => 'self.id' } );

__PACKAGE__->has_many(
    curry_menus => CurryMenu => { 'foreign.spiceyness' => 'self.id' } );

__PACKAGE__->has_many(
    dish_spiceynesses => 'Vindaloo::Schema::Result::DishSpiceyness' =>
      { 'foreign.spiceyness' => 'self.id' } );

__PACKAGE__->many_to_many( dishes => dish_spiceynesses => 'dish' );
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;

__END__
