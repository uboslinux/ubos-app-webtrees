#!/usr/bin/perl
#
# Simple test.
#
# Copyright (C) 2015 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

package WebTreesTest1;

use UBOS::WebAppTest;

# The states and transitions for this test

my $TEST = new UBOS::WebAppTest(
    appToTest   => 'webtrees',
    description => 'Tests that the app comes up.',
    checks      => [
            new UBOS::WebAppTest::StateCheck(
                    name  => 'virgin',
                    check => sub {
                        my $c = shift;

                        $c->get( '/' ); # ignore the first access; it (sometimes?) redirect somewhere else
                        $c->getMustRedirect( '/', '/login.php?url=index.php%3F', undef, 'Not redirecting to login page' );

                        $c->getMustMatch( '/login.php?url=index.php%3F', '<link rel="icon.*themes/webtrees',                        undef, 'Wrong front page (1)' );
                        $c->getMustMatch( '/login.php?url=index.php%3F', '<label for="username".*<input type="text" id="username"', undef, 'Wrong front page (2)' );

                        $c->getMustNotContain( '/login.php?url=index.php%3F', 'error', undef, 'Error message' );

                        return 1;
                    }
            )
    ]
);

$TEST;
