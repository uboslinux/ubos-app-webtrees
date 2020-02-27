#!/usr/bin/perl
#
# Update the admin account
#
# Copyright (C) 2015 and later, Indie Computing Corp. All rights reserved. License: see package.
#

use strict;
use warnings;

use UBOS::Databases::MySqlDriver;
use UBOS::Logging;
use UBOS::ResourceManager;
use UBOS::Utils;

if( $operation eq 'install' || $operation eq 'upgrade' ) {

    my $appConfigId = $config->getResolve( 'appconfig.appconfigid' );
    my $adminId     = $config->getResolve( 'site.admin.userid' );
    my $adminName   = $config->getResolve( 'site.admin.username' );
    my $adminPass   = $config->getResolve( 'site.admin.credential' );
    my $adminEmail  = $config->getResolve( 'site.admin.email' );

    my( $dbName, $dbHost, $dbPort, $dbUser, $dbPassword, $dbCredentialType )
            = UBOS::ResourceManager::findProvisionedDatabaseFor(
            'mysql', $appConfigId, 'webtrees', 'maindb' );

    $adminPass = UBOS::Utils::escapeSquote( $adminPass );

    my $php = <<PHP;
<?php
    print( password_hash( '$adminPass', PASSWORD_DEFAULT ));
PHP

    my $out;
    my $err;
    if( UBOS::Utils::myexec( 'php', $php, \$out, \$err )) {
        error( 'Webtrees calculating hashed password failed:', $out, $err );
    }

    $adminPass = $out;
    $adminPass =~ s!^\s+!!;
    $adminPass =~ s!\s+$!!;

    my $escAdminId    = UBOS::Utils::escapeSquote( $adminId );
    my $escAdminEmail = UBOS::Utils::escapeSquote( $adminEmail );
    my $escAdminName  = UBOS::Utils::escapeSquote( $adminName );
    my $escAdminPass  = UBOS::Utils::escapeSquote( $adminPass );

    my $dbh = UBOS::Databases::MySqlDriver::dbConnect( $dbName, $dbUser, $dbPassword );
    unless( $dbh ) {
        error( 'Failed to connect to webtrees database:', $dbName );
    }

    unless( UBOS::Databases::MySqlDriver::sqlPrepareExecute( $dbh, <<SQL )) {
UPDATE `wt_user`
    SET `user_name` = '$escAdminId',
        `email`     = '$escAdminEmail',
        `real_name` = '$escAdminName',
        `password`  = '$escAdminPass'
    WHERE user_id=1;
SQL
        error( 'Failed to update webtrees admin user' );
    }
}

1;
