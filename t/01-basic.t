use strict;
use warnings;

use Test::Most;

use Monad::Tiny;
use Monad::Tiny::Maybe;

{
    ok( my $m = Monad::Tiny->return(1234), "Monad::Tiny->return" );

    my $f = Monad::Tiny->lift( sub { is( $_[0], 1234, "lift" ) } );

    $f->($m);

    throws_ok { $m->join } qr/Not joinable/;

    ok my $n = Monad::Tiny->return($m), "Monad::Tiny^2";

    lives_ok { $n->join } "Joinable";

    ok $f = Monad::Tiny->fail("Error"), "fail";

}

{
    ok( my $n = Monad::Tiny::Maybe->Nothing, "Nothing" );

    ok( $n->is_nothing, "nothing" );

    ok( my $m = Monad::Tiny::Maybe::Just(123), "Just" );
    ok( !$m->is_nothing, "not nothing" );

    my $f = Monad::Tiny::Maybe->lift( sub { is( $_[0], 123, "lift" ) } );

    $f->($m);

    my $g = Monad::Tiny::Maybe->lift( sub { $_[0] + 1; } );

    ok( $g->($n)->is_nothing, "lift Nothing" );

    ok my $f = Monad::Tiny::Maybe->fail("Error"), "fail";
    ok $f->is_nothing, "fail == Nothing";
}

done_testing;
