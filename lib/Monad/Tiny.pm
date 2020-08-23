package Monad::Tiny;

use v5.10.1;

use strict;
use warnings;

use Carp ();
use Const::Fast ();
use Scalar::Util ();

our $VERSION = 'v0.7.0';

my %Data;

sub return {
    my ( $class, $data ) = @_;

    my $self = \$data;
    bless $self, $class;
    Const::Fast::_make_readonly( $self => 1 );

    $Data{ Scalar::Util::refaddr $self } = $self;
}

my %FMap;

sub fmap {
    my ( $class, $func ) = @_;
    $FMap{ Scalar::Util::refaddr $func } //= sub {
        my @args = map { ${ $Data{ Scalar::Util::refaddr $_ } } } @_;
        $class->return( $func->(@args) );

    };
}

{
    no warnings 'once';
    *lift = *fmap;
}

sub join {
    my ($self) = shift;
    my $val = ${ $Data{ Scalar::Util::refaddr $self } };
    if ( Scalar::Util::blessed($val) && $val->isa(__PACKAGE__) ) {
        CORE::return $val;
    } else {
        Carp::croak "Not joinable";
    }
}

my %Bind;

sub bind {
    my ( $class, $func ) = @_;
    $Bind{ Scalar::Util::refaddr $func } //= sub {
        $class->fmap($func)->(@_)->join;
    };
}

sub fail {
    my ( $class, $message ) = @_;
    $class->return( undef );
}

1;
