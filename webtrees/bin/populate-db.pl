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

my $appconfigid = $config->getResolve( 'appconfig.appconfigid' );

sub encryptedPass {
    my $pass = shift;

    # Use PHP to generate encrypted pass
    my $php = <<PHP;
<?php
print crypt( '$pass' ) . "\n";
PHP

    my $out = '';
    my $err = '';

    # pipe PHP in from stdin
    debug( 'About to execute PHP:', $php );

    if( UBOS::Utils::myexec( 'php', $php, \$out, \$err ) != 0 ) {
        error( 'Generating encrypted password failed for', $appconfigid, ':', $err );
    }
    my $ret = $out;
    $ret =~ s/^\s+//;
    $ret =~ s/\s+$//;
    return $ret;
}

if( $operation eq 'install' ) {
    my( $dbName, $dbHost, $dbPort, $dbUser, $dbPassword, $dbCredentialType ) = UBOS::ResourceManager::getDatabase(
            'mysql',
            $appconfigid,
            'webtrees',
            'maindb' );

    my $adminid    = $config->getResolve( 'site.admin.userid' );
    my $adminname  = $config->getResolve( 'site.admin.username' );
    my $adminpass  = $config->getResolve( 'site.admin.credential' );
    my $adminemail = $config->getResolve( 'site.admin.email' );
    my $wtLocale   = $config->getResolve( 'installable.customizationpoints.locale.value' );

    # defaults from setup.php script
    my $smtpUse    = 'internal';
    my $smtpServ   = 'localhost';
    my $smtpSender = $adminemail;
    my $smtpPort   = '25';
    my $smtpUsePw  = '1';
    my $smtpUser   = '';
    my $smtpPass   = '';
    my $smtpSecure = 'none';
    my $smtpFrom   = $smtpSender;

    my $encryptedWtPass = encryptedPass( $adminpass );

    my @sql = ();
    push @sql, <<SQL;
INSERT IGNORE INTO `wt_site_access_rule` (user_agent_pattern, rule, comment) VALUES
('Mozilla/5.0 (%) Gecko/% %/%', 'allow', 'Gecko-based browsers'),
('Mozilla/5.0 (%) AppleWebKit/% (KHTML, like Gecko)%', 'allow', 'WebKit-based browsers'),
('Opera/% (%) Presto/% Version/%', 'allow', 'Presto-based browsers'),
('Mozilla/% (compatible; MSIE %', 'allow', 'Trident-based browsers'),
('Mozilla/5.0 (compatible; Konqueror/%', 'allow', 'Konqueror browser');
SQL

    push @sql, <<SQL;
INSERT IGNORE INTO `wt_gedcom` (gedcom_id, gedcom_name) VALUES
(-1, 'DEFAULT_TREE');
SQL

    push @sql, <<SQL;
INSERT IGNORE INTO `wt_user` (user_id, user_name, real_name, email, password) VALUES
(-1, 'DEFAULT_USER', 'DEFAULT_USER', 'DEFAULT_USER', 'DEFAULT_USER');
SQL

    push @sql, <<SQL;
INSERT INTO `wt_user` (user_id, user_name, real_name, email, password) VALUES
(1, '$adminid', '$adminname', '$adminemail', '$encryptedWtPass' )
ON DUPLICATE KEY UPDATE user_name='$adminid', real_name='$adminname', email='$adminemail', password='$encryptedWtPass';
SQL

    push @sql, <<SQL;
INSERT IGNORE INTO `wt_user_setting` (user_id, setting_name, setting_value) VALUES
(1, 'canadmin',          '1' ),
(1, 'language',          '$wtLocale' ),
(1, 'verified',          '1' ),
(1, 'verified_by_admin', '1' ),
(1, 'editaccount',       '1' ),
(1, 'auto_accept',       '0' ),
(1, 'visibleonline',     '1' );
SQL

    push @sql, <<SQL;
INSERT IGNORE INTO `wt_site_setting` (setting_name, setting_value) VALUES
('WT_SCHEMA_VERSION',               '-2'),    # developer installation process seems to put '23' there
('INDEX_DIRECTORY',                 'data/'),
('STORE_MESSAGES',                  '1'),
('USE_REGISTRATION_MODULE',         '1'),
('REQUIRE_ADMIN_AUTH_REGISTRATION', '1'),
('ALLOW_USER_THEMES',               '1'),
('ALLOW_CHANGE_GEDCOM',             '1'),
('SESSION_TIME',                    '7200'),
('SMTP_ACTIVE',                     '$smtpUse' ),
('SMTP_HOST',                       '$smtpServ' ),
('SMTP_HELO',                       '$smtpSender' ),
('SMTP_PORT',                       '$smtpPort' ),
('SMTP_AUTH',                       '$smtpUsePw' ),
('SMTP_AUTH_USER',                  '$smtpUser' ),
('SMTP_AUTH_PASS',                  '$smtpPass' ),
('SMTP_SSL',                        '$smtpSecure' ),
('SMTP_FROM_NAME',                  '$smtpFrom' );
SQL

# developer installation process also has:
# ('FV_SCHEMA_VERSION','4'),
# ('NB_SCHEMA_VERSION','3'),

# This comes from the WT_Module::getInstalledModules('enabled') script
    push @sql, <<SQL;
INSERT IGNORE INTO `wt_module` (module_name, status, tab_order, menu_order, sidebar_order) VALUES
('ahnentafel_report','enabled',NULL,NULL,NULL),
('batch_update','enabled',NULL,NULL,NULL),
('bdm_report','enabled',NULL,NULL,NULL),
('birth_report','enabled',NULL,NULL,NULL),
('cemetery_report','enabled',NULL,NULL,NULL),
('change_report','enabled',NULL,NULL,NULL),
('charts','enabled',NULL,NULL,NULL),
('ckeditor','enabled',NULL,NULL,NULL),
('clippings','enabled',NULL,20,60),
('death_report','enabled',NULL,NULL,NULL),
('descendancy','enabled',NULL,NULL,30),
('descendancy_report','enabled',NULL,NULL,NULL),
('extra_info','enabled',NULL,NULL,10),
('fact_sources','enabled',NULL,NULL,NULL),
('families','enabled',NULL,NULL,50),
('family_group_report','enabled',NULL,NULL,NULL),
('family_nav','enabled',NULL,NULL,20),
('faq','enabled',NULL,40,NULL),
('gedcom_block','enabled',NULL,NULL,NULL),
('gedcom_favorites','enabled',NULL,NULL,NULL),
('gedcom_news','enabled',NULL,NULL,NULL),
('gedcom_stats','enabled',NULL,NULL,NULL),
('GEDFact_assistant','enabled',NULL,NULL,NULL),
('googlemap','enabled',80,NULL,NULL),
('html','enabled',NULL,NULL,NULL),
('individual_ext_report','enabled',NULL,NULL,NULL),
('individual_report','enabled',NULL,NULL,NULL),
('individuals','enabled',NULL,NULL,40),
('lightbox','enabled',60,NULL,NULL),
('logged_in','enabled',NULL,NULL,NULL),
('login_block','enabled',NULL,NULL,NULL),
('marriage_report','enabled',NULL,NULL,NULL),
('media','enabled',50,NULL,NULL),
('missing_facts_report','enabled',NULL,NULL,NULL),
('notes','enabled',40,NULL,NULL),
('occupation_report','enabled',NULL,NULL,NULL),
('page_menu','enabled',NULL,10,NULL),
('pedigree_report','enabled',NULL,NULL,NULL),
('personal_facts','enabled',10,NULL,NULL),
('random_media','enabled',NULL,NULL,NULL),
('recent_changes','enabled',NULL,NULL,NULL),
('relative_ext_report','enabled',NULL,NULL,NULL),
('relatives','enabled',20,NULL,NULL),
('review_changes','enabled',NULL,NULL,NULL),
('sitemap','enabled',NULL,NULL,NULL),
('sources_tab','enabled',30,NULL,NULL),
('stories','enabled',55,30,NULL),
('theme_select','enabled',NULL,NULL,NULL),
('todays_events','enabled',NULL,NULL,NULL),
('todo','enabled',NULL,NULL,NULL),
('top10_givnnames','enabled',NULL,NULL,NULL),
('top10_pageviews','enabled',NULL,NULL,NULL),
('top10_surnames','enabled',NULL,NULL,NULL),
('tree','enabled',68,NULL,NULL),
('upcoming_events','enabled',NULL,NULL,NULL),
('user_blog','enabled',NULL,NULL,NULL),
('user_favorites','enabled',NULL,NULL,NULL),
('user_messages','enabled',NULL,NULL,NULL),
('user_welcome','enabled',NULL,NULL,NULL),
('yahrzeit','enabled',NULL,NULL,NULL);
SQL

    push @sql, <<SQL;
INSERT IGNORE INTO `wt_module_privacy` (module_name, gedcom_id, component, access_level) VALUES
('ahnentafel_report',-1,'report',2),
('bdm_report',-1,'report',2),
('birth_report',-1,'report',2),
('cemetery_report',-1,'report',2),
('change_report',-1,'report',1),
('charts',-1,'block',2),
('clippings',-1,'menu',1),
('clippings',-1,'sidebar',1),
('death_report',-1,'report',2),
('descendancy',-1,'sidebar',2),
('descendancy_report',-1,'report',2),
('extra_info',-1,'sidebar',2),
('fact_sources',-1,'report',1),
('families',-1,'sidebar',2),
('family_group_report',-1,'report',2),
('family_nav',-1,'sidebar',2),
('faq',-1,'block',2),
('faq',-1,'menu',2),
('gedcom_block',-1,'block',2),
('gedcom_favorites',-1,'block',2),
('gedcom_news',-1,'block',2),
('gedcom_stats',-1,'block',2),
('googlemap',-1,'tab',2),
('html',-1,'block',2),
('individual_ext_report',-1,'report',1),
('individual_report',-1,'report',2),
('individuals',-1,'sidebar',2),
('lightbox',-1,'tab',2),
('logged_in',-1,'block',2),
('login_block',-1,'block',2),
('marriage_report',-1,'report',2),
('media',-1,'tab',2),
('missing_facts_report',-1,'report',1),
('notes',-1,'tab',2),
('occupation_report',-1,'report',1),
('page_menu',-1,'menu',2),
('pedigree_report',-1,'report',2),
('personal_facts',-1,'tab',2),
('random_media',-1,'block',2),
('recent_changes',-1,'block',2),
('relative_ext_report',-1,'report',2),
('relatives',-1,'tab',2),
('review_changes',-1,'block',2),
('sources_tab',-1,'tab',2),
('stories',-1,'block',-1),
('stories',-1,'menu',-1),
('stories',-1,'tab',-1),
('theme_select',-1,'block',2),
('todays_events',-1,'block',2),
('todo',-1,'block',2),
('top10_givnnames',-1,'block',2),
('top10_pageviews',-1,'block',2),
('top10_surnames',-1,'block',2),
('tree',-1,'tab',2),
('upcoming_events',-1,'block',2),
('user_blog',-1,'block',2),
('user_favorites',-1,'block',2),
('user_messages',-1,'block',2),
('user_welcome',-1,'block',2),
('yahrzeit',-1,'block',2);
SQL

# Resumed to main setup
    push @sql, <<SQL;
INSERT IGNORE INTO `wt_block` (user_id, location, block_order, module_name) VALUES
(-1, 'main', 1, 'todays_events'),
(-1, 'main', 2, 'user_messages'),
(-1, 'main', 3, 'user_favorites'),
(-1, 'side', 1, 'user_welcome'),
(-1, 'side', 2, 'random_media'),
(-1, 'side', 3, 'upcoming_events'),
(-1, 'side', 4, 'logged_in');
SQL

    push @sql, <<SQL;
INSERT IGNORE INTO `wt_block` (gedcom_id, location, block_order, module_name) VALUES
(-1, 'main', 1, 'gedcom_stats'),
(-1, 'main', 2, 'gedcom_news'),
(-1, 'main', 3, 'gedcom_favorites'),
(-1, 'main', 4, 'review_changes'),
(-1, 'side', 1, 'gedcom_block'),
(-1, 'side', 2, 'random_media'),
(-1, 'side', 3, 'todays_events'),
(-1, 'side', 4, 'logged_in');
SQL

    my $dbh = UBOS::Databases::MySqlDriver::dbConnect( $dbName, $dbUser, $dbPassword, $dbHost, $dbPort );
    if( $dbh ) {
        foreach my $s ( @sql ) {
            UBOS::Databases::MySqlDriver::sqlPrepareExecute( $dbh, $s );
        }

    } else {
        error( 'Failed to acquire database handle', $dbName, $dbUser );
    }

}

1;
