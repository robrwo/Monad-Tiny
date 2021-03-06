package Monad::Tiny::Maybe;

use parent qw/ Monad::Tiny /;

use Carp ();
use Exporter qw/ import /;;
use Scalar::Util ();

our $VERSION = 'v0.7.0';

use constant Nothing => __PACKAGE__->return( sub { Carp::croak "Nothing"; } );

sub Just {
    my ($val) = @_;
    return __PACKAGE__->return($val);
}

our @EXPORT    = qw/ Just Nothing /;
our @EXPORT_OK = @EXPORT;

sub is_nothing {
    my ($self) = @_;
    return ( Scalar::Util::refaddr $self) == ( Scalar::Util::refaddr &Nothing );
}

my %MaybeMap;

sub fmap {
    my ( $class, $func ) = @_;
    $MaybeMap{ Scalar::Util::refaddr $func } //= sub {
        eval { CORE::return $class->SUPER::fmap($func)->(@_); };
        CORE::return Nothing;
    };

}

{

    no warnings 'once';

    *lift = *fmap;
}

sub fail {
    CORE::return Nothing;
}

1;
