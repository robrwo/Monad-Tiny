use strict;
use warnings;

use Test::More;

use Monad::Tiny;
use Monad::Tiny::Maybe;

subtest "Monday::Tiny" => sub {
    ok( my $m = Monad::Tiny->return(1234), "Monad::Tiny->return" );

    my $f = Monad::Tiny->lift( sub { is( $_[0], 1234, "lift" ) } );

    $f->($m);

    eval { $m->join };
    like $@, qr/Not joinable/;

    ok my $n = Monad::Tiny->return($m), "Monad::Tiny^2";

    eval { $n->join };
    ok !$@, "Joinable";

    ok $f = Monad::Tiny->fail("Error"), "fail";

};

subtest "Monday::Tiny::Maybe" => sub {
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
};

done_testing;
