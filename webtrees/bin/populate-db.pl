#!/usr/bin/perl
#
# Taken in Step six from setup.php
#

use strict;
use warnings;

use UBOS::Databases::MySqlDriver;
use UBOS::Logging;
use UBOS::ResourceManager;
use UBOS::Utils;

if( $operation eq 'install' ) {
    my $appconfigid = $config->getResolve( 'appconfig.appconfigid' );
    my $context     = $config->getResolve( 'appconfig.context' );

    my( $dbName, $dbHost, $dbPort, $dbUser, $dbPassword, $dbCredentialType )
            = UBOS::ResourceManager::findProvisionedDatabaseFor(
            'mysql', $appconfigid, 'webtrees', 'maindb' );

    my $adminid    = $config->getResolve( 'site.admin.userid' );
    my $adminname  = $config->getResolve( 'site.admin.username' );
    my $adminpass  = $config->getResolve( 'site.admin.credential' );
    my $adminemail = $config->getResolve( 'site.admin.email' );
    my $hostname   = $config->getResolve( 'site.hostname' );
    my $protocol   = $config->getResolve( 'site.protocol' );
    my $wtLocale   = $config->getResolve( 'installable.customizationpoints.locale.value' );
    my $dir        = $config->getResolve( 'appconfig.apache2.dir' );

    my $php = <<PHP;
<?php

# Taken from setup.php

    namespace Fisharebest\\Webtrees;

    define('WT_TBLPREFIX', 'wt_');
    define('WT_DEBUG_SQL', false);
    define('WT_DATA_DIR', 'data/');
    define('SERVER_NAME', '$hostname');

    define('WT_ROOT', '' );
    define('WT_MODULES_DIR', 'modules_v3/');
    define('WT_CLIENT_IP', '127.0.0.1' );
    define('WT_BASE_URL', '$protocol://$hostname$context' );

    \$_SERVER['SERVER_NAME'] = SERVER_NAME;

    require 'vendor/autoload.php';
    require 'app/Database.php';

# Taken from setup.php, step one

    Session::start();

    define('WT_LOCALE', I18N::init(Filter::post('lang', '[a-zA-Z-]+', Filter::get('lang', '[a-zA-Z-]+'))));

# Taken from setup.php, step three

    Database::createInstance(
        '$dbHost',
        '$dbPort',
        '', // No DBNAME - we will connect to it explicitly
        '$dbUser',
        '$dbPassword'
    );
    Database::exec("SET NAMES 'utf8'");

# Taken from setup.php, step four

    Database::exec("USE `$dbName`");

# Taken from setup.php, step six

	// Create/update the database tables.
	Database::updateSchema('\\Fisharebest\\Webtrees\\Schema', 'WT_SCHEMA_VERSION', 30);

	// Create the admin user
	\$admin = User::create('$adminid', '$adminname', '$adminemail', '$adminpass');
	\$admin->setPreference('canadmin', '1');
	\$admin->setPreference('language', '$wtLocale');
	\$admin->setPreference('verified', '1');
	\$admin->setPreference('verified_by_admin', '1');
	\$admin->setPreference('auto_accept', '0');
	\$admin->setPreference('visibleonline', '1');
PHP

    my $out;
    my $err;
    if( UBOS::Utils::myexec( "cd '$dir'; php", $php, \$out, \$err )) {
        error( 'Webtrees populate-db.pl failed:', $out, $err );
    }
}

1;
