package Monad::Tiny::Maybe;

use parent qw/ Monad::Tiny /;

use Carp ();
use Exporter qw/ import /;;
use Scalar::Util ();

our $VERSION = 'v0.7.0';

sub Left {
    my ($message = @_;
    return __PACKAGE__->return(sub { Carp::croak $message } );
}

sub Right {
    my ($val) = @_;
    return __PACKAGE__->return($val);
}

our @EXPORT    = qw/ Left Right /;
our @EXPORT_OK = @EXPORT;

my %MaybeMap;

sub fmap {
    my ( $class, $func ) = @_;
    $MaybeMap{ Scalar::Util::refaddr $func } //= sub {
        eval { CORE::return $class->SUPER::fmap($func)->(@_); };
        CORE::return Left($@);
    };

}

{

    no warnings 'once';

    *lift = *fmap;
}

sub fail {
    my ( $class, $message ) = @_;
    CORE::return Left($message);
}

1;
