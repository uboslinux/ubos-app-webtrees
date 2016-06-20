#!/usr/bin/perl
#
# Simple test for gladiwashere. Compare with test for
# gladiwashere-java
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
