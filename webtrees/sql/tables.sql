# Taken in Step six from setup.php
CREATE TABLE IF NOT EXISTS `wt_gedcom` (
 gedcom_id     INTEGER AUTO_INCREMENT NOT NULL,
 gedcom_name   VARCHAR(255)           NOT NULL,
 sort_order    INTEGER                NOT NULL DEFAULT 0,
 PRIMARY KEY                 (gedcom_id),
 UNIQUE  KEY `wt_gedcom_ix1` (gedcom_name),
         KEY `wt_gedcom_ix2` (sort_order)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_site_setting` (
 setting_name  VARCHAR(32)  NOT NULL,
 setting_value VARCHAR(255) NOT NULL,
 PRIMARY KEY (setting_name)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_gedcom_setting` (
 gedcom_id     INTEGER      NOT NULL,
 setting_name  VARCHAR(32)  NOT NULL,
 setting_value VARCHAR(255) NOT NULL,
 PRIMARY KEY                         (gedcom_id, setting_name),
 FOREIGN KEY `wt_gedcom_setting_fk1` (gedcom_id) REFERENCES `wt_gedcom` (gedcom_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_user` (
 user_id   INTEGER AUTO_INCREMENT NOT NULL,
 user_name VARCHAR(32)            NOT NULL,
 real_name VARCHAR(64)            NOT NULL,
 email     VARCHAR(64)            NOT NULL,
 password  VARCHAR(128)           NOT NULL,
 PRIMARY KEY     (user_id),
 UNIQUE  KEY `wt_user_ix1` (user_name),
 UNIQUE  KEY `wt_user_ix2` (email)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_user_setting` (
 user_id       INTEGER      NOT NULL,
 setting_name  VARCHAR(32)  NOT NULL,
 setting_value VARCHAR(255) NOT NULL,
 PRIMARY KEY                       (user_id, setting_name),
 FOREIGN KEY `wt_user_setting_fk1` (user_id) REFERENCES `wt_user` (user_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_user_gedcom_setting` (
 user_id       INTEGER      NOT NULL,
 gedcom_id     INTEGER      NOT NULL,
 setting_name  VARCHAR(32)  NOT NULL,
 setting_value VARCHAR(255) NOT NULL,
 PRIMARY KEY     (user_id, gedcom_id, setting_name),
 FOREIGN KEY `wt_user_gedcom_setting_fk1` (user_id)   REFERENCES `wt_user`   (user_id)   /* ON DELETE CASCADE */,
 FOREIGN KEY `wt_user_gedcom_setting_fk2` (gedcom_id) REFERENCES `wt_gedcom` (gedcom_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_log` (
 log_id      INTEGER AUTO_INCREMENT NOT NULL,
 log_time    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
 log_type    ENUM('auth', 'config', 'debug', 'edit', 'error', 'media', 'search') NOT NULL,
 log_message TEXT         NOT NULL,
 ip_address  VARCHAR(40)  NOT NULL,
 user_id     INTEGER          NULL,
 gedcom_id   INTEGER          NULL,
 PRIMARY KEY              (log_id),
         KEY `wt_log_ix1` (log_time),
         KEY `wt_log_ix2` (log_type),
         KEY `wt_log_ix3` (ip_address),
 FOREIGN KEY `wt_log_fk1` (user_id)   REFERENCES `wt_user`   (user_id)   /* ON DELETE SET NULL */,
 FOREIGN KEY `wt_log_fk2` (gedcom_id) REFERENCES `wt_gedcom` (gedcom_id) /* ON DELETE SET NULL */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_change` (
 change_id      INTEGER AUTO_INCREMENT                  NOT NULL,
 change_time    TIMESTAMP                               NOT NULL DEFAULT CURRENT_TIMESTAMP,
 status         ENUM('accepted', 'pending', 'rejected') NOT NULL DEFAULT 'pending',
 gedcom_id      INTEGER                                 NOT NULL,
 xref           VARCHAR(20)                             NOT NULL,
 old_gedcom     MEDIUMTEXT                              NOT NULL,
 new_gedcom     MEDIUMTEXT                              NOT NULL,
 user_id        INTEGER                                 NOT NULL,
 PRIMARY KEY                 (change_id),
         KEY `wt_change_ix1` (gedcom_id, status, xref),
 FOREIGN KEY `wt_change_fk1` (user_id)   REFERENCES `wt_user`   (user_id)   /* ON DELETE RESTRICT */,
 FOREIGN KEY `wt_change_fk2` (gedcom_id) REFERENCES `wt_gedcom` (gedcom_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_message` (
 message_id INTEGER AUTO_INCREMENT NOT NULL,
 sender     VARCHAR(64)            NOT NULL, # username or email address
 ip_address VARCHAR(40)            NOT NULL, # long enough for IPv6
 user_id    INTEGER                NOT NULL,
 subject    VARCHAR(255)           NOT NULL,
 body       TEXT                   NOT NULL,
 created    TIMESTAMP              NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY                  (message_id),
 FOREIGN KEY `wt_message_fk1` (user_id)   REFERENCES `wt_user` (user_id) /* ON DELETE RESTRICT */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_default_resn` (
 default_resn_id INTEGER AUTO_INCREMENT                             NOT NULL,
 gedcom_id       INTEGER                                            NOT NULL,
 xref            VARCHAR(20)                                            NULL,
 tag_type        VARCHAR(15)                                            NULL,
 resn            ENUM ('none', 'privacy', 'confidential', 'hidden') NOT NULL,
 comment         VARCHAR(255)                                           NULL,
 updated         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY                       (default_resn_id),
 UNIQUE  KEY `wt_default_resn_ix1` (gedcom_id, xref, tag_type),
 FOREIGN KEY `wt_default_resn_fk1` (gedcom_id)  REFERENCES `wt_gedcom` (gedcom_id)
) ENGINE=InnoDB COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `wt_individuals` (
 i_id     VARCHAR(20)         NOT NULL,
 i_file   INTEGER             NOT NULL,
 i_rin    VARCHAR(20)         NOT NULL,
 i_sex    ENUM('U', 'M', 'F') NOT NULL,
 i_gedcom MEDIUMTEXT          NOT NULL,
 PRIMARY KEY                      (i_id, i_file),
 UNIQUE  KEY `wt_individuals_ix1` (i_file, i_id)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_families` (
 f_id      VARCHAR(20)  NOT NULL,
 f_file    INTEGER      NOT NULL,
 f_husb    VARCHAR(20)      NULL,
 f_wife    VARCHAR(20)      NULL,
 f_gedcom  MEDIUMTEXT   NOT NULL,
 f_numchil INTEGER      NOT NULL,
 PRIMARY KEY                   (f_id, f_file),
 UNIQUE  KEY `wt_families_ix1` (f_file, f_id),
         KEY `wt_families_ix2` (f_husb),
         KEY `wt_families_ix3` (f_wife)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_places` (
 p_id          INTEGER AUTO_INCREMENT NOT NULL,
 p_place       VARCHAR(150)               NULL,
 p_parent_id   INTEGER                    NULL,
 p_file        INTEGER               NOT  NULL,
 p_std_soundex TEXT                       NULL,
 p_dm_soundex  TEXT                       NULL,
 PRIMARY KEY                 (p_id),
         KEY `wt_places_ix1` (p_file, p_place),
 UNIQUE  KEY `wt_places_ix2` (p_parent_id, p_file, p_place)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_placelinks` (
 pl_p_id INTEGER NOT NULL,
 pl_gid  VARCHAR(20)  NOT NULL,
 pl_file INTEGER  NOT NULL,
 PRIMARY KEY                     (pl_p_id, pl_gid, pl_file),
         KEY `wt_placelinks_ix1` (pl_p_id),
         KEY `wt_placelinks_ix2` (pl_gid),
         KEY `wt_placelinks_ix3` (pl_file)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_dates` (
 d_day        TINYINT     NOT NULL,
 d_month      CHAR(5)         NULL,
 d_mon        TINYINT     NOT NULL,
 d_year       SMALLINT    NOT NULL,
 d_julianday1 MEDIUMINT   NOT NULL,
 d_julianday2 MEDIUMINT   NOT NULL,
 d_fact       VARCHAR(15) NOT NULL,
 d_gid        VARCHAR(20) NOT NULL,
 d_file       INTEGER     NOT NULL,
 d_type       ENUM ('@#DGREGORIAN@', '@#DJULIAN@', '@#DHEBREW@', '@#DFRENCH R@', '@#DHIJRI@', '@#DROMAN@', '@#DJALALI@') NOT NULL,
 KEY `wt_dates_ix1` (d_day),
 KEY `wt_dates_ix2` (d_month),
 KEY `wt_dates_ix3` (d_mon),
 KEY `wt_dates_ix4` (d_year),
 KEY `wt_dates_ix5` (d_julianday1),
 KEY `wt_dates_ix6` (d_julianday2),
 KEY `wt_dates_ix7` (d_gid),
 KEY `wt_dates_ix8` (d_file),
 KEY `wt_dates_ix9` (d_type),
 KEY `wt_dates_ix10` (d_fact, d_gid)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_media` (
 m_id       VARCHAR(20)            NOT NULL,
 m_ext      VARCHAR(6)                 NULL,
 m_type     VARCHAR(20)                NULL,
 m_titl     VARCHAR(255)               NULL,
 m_filename VARCHAR(512)               NULL,
 m_file     INTEGER                NOT NULL,
 m_gedcom   MEDIUMTEXT                 NULL,
 PRIMARY KEY                (m_file, m_id),
 UNIQUE  KEY `wt_media_ix1` (m_id, m_file),
         KEY `wt_media_ix2` (m_ext, m_type),
         KEY `wt_media_ix3` (m_titl)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_next_id` (
 gedcom_id   INTEGER     NOT NULL,
 record_type VARCHAR(15) NOT NULL,
 next_id     DECIMAL(20) NOT NULL,
 PRIMARY KEY                  (gedcom_id, record_type),
 FOREIGN KEY `wt_next_id_fk1` (gedcom_id) REFERENCES `wt_gedcom` (gedcom_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_other` (
 o_id     VARCHAR(20) NOT NULL,
 o_file   INTEGER     NOT NULL,
 o_type   VARCHAR(15) NOT NULL,
 o_gedcom MEDIUMTEXT      NULL,
 PRIMARY KEY                (o_id, o_file),
 UNIQUE  KEY `wt_other_ix1` (o_file, o_id)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_sources` (
 s_id     VARCHAR(20)    NOT NULL,
 s_file   INTEGER        NOT NULL,
 s_name   VARCHAR(255)   NOT NULL,
 s_gedcom MEDIUMTEXT     NOT NULL,
 PRIMARY KEY                  (s_id, s_file),
 UNIQUE  KEY `wt_sources_ix1` (s_file, s_id),
         KEY `wt_sources_ix2` (s_name)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_link` (
 l_file    INTEGER     NOT NULL,
 l_from    VARCHAR(20) NOT NULL,
 l_type    VARCHAR(15) NOT NULL,
 l_to      VARCHAR(20) NOT NULL,
 PRIMARY KEY                (l_from, l_file, l_type, l_to),
 UNIQUE INDEX `wt_link_ix1` (l_to, l_file, l_type, l_from)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_name` (
 n_file             INTEGER      NOT NULL,
 n_id               VARCHAR(20)  NOT NULL,
 n_num              INTEGER      NOT NULL,
 n_type             VARCHAR(15)  NOT NULL,
 n_sort             VARCHAR(255) NOT NULL,
 n_full             VARCHAR(255) NOT NULL,
 n_surname          VARCHAR(255)     NULL,
 n_surn             VARCHAR(255)     NULL,
 n_givn             VARCHAR(255)     NULL,
 n_soundex_givn_std VARCHAR(255)     NULL,
 n_soundex_surn_std VARCHAR(255)     NULL,
 n_soundex_givn_dm  VARCHAR(255)     NULL,
 n_soundex_surn_dm  VARCHAR(255)     NULL,
 PRIMARY KEY               (n_id, n_file, n_num),
         KEY `wt_name_ix1` (n_full, n_id, n_file),
         KEY `wt_name_ix2` (n_surn, n_file, n_type, n_id),
         KEY `wt_name_ix3` (n_givn, n_file, n_type, n_id)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_module` (
 module_name   VARCHAR(32)                 NOT NULL,
 status        ENUM('enabled', 'disabled') NOT NULL DEFAULT 'enabled',
 tab_order     INTEGER                         NULL, 
 menu_order    INTEGER                         NULL, 
 sidebar_order INTEGER                         NULL,
 PRIMARY KEY (module_name)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_module_setting` (
 module_name   VARCHAR(32) NOT NULL,
 setting_name  VARCHAR(32) NOT NULL,
 setting_value MEDIUMTEXT  NOT NULL,
 PRIMARY KEY                         (module_name, setting_name),
 FOREIGN KEY `wt_module_setting_fk1` (module_name) REFERENCES `wt_module` (module_name) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_module_privacy` (
 module_name   VARCHAR(32) NOT NULL,
 gedcom_id     INTEGER     NOT NULL,
 component     ENUM('block', 'chart', 'menu', 'report', 'sidebar', 'tab', 'theme') NOT NULL,
 access_level  TINYINT     NOT NULL,
 PRIMARY KEY                         (module_name, gedcom_id, component),
 FOREIGN KEY `wt_module_privacy_fk1` (module_name) REFERENCES `wt_module` (module_name) /* ON DELETE CASCADE */,
 FOREIGN KEY `wt_module_privacy_fk2` (gedcom_id  ) REFERENCES `wt_gedcom` (gedcom_id)   /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_block` (
 block_id    INTEGER AUTO_INCREMENT NOT NULL,
 gedcom_id   INTEGER                    NULL,
 user_id     INTEGER                    NULL,
 xref        VARCHAR(20)                NULL,
 location    ENUM('main', 'side')       NULL,
 block_order INTEGER                NOT NULL,
 module_name VARCHAR(32)            NOT NULL,
 PRIMARY KEY                (block_id),
 FOREIGN KEY `wt_block_fk1` (gedcom_id  ) REFERENCES `wt_gedcom` (gedcom_id  ), /* ON DELETE CASCADE */
 FOREIGN KEY `wt_block_fk2` (user_id    ) REFERENCES `wt_user`   (user_id    ), /* ON DELETE CASCADE */
 FOREIGN KEY `wt_block_fk3` (module_name) REFERENCES `wt_module` (module_name)  /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_block_setting` (
 block_id      INTEGER     NOT NULL,
 setting_name  VARCHAR(32) NOT NULL,
 setting_value TEXT        NOT NULL,
 PRIMARY KEY                        (block_id, setting_name),
 FOREIGN KEY `wt_block_setting_fk1` (block_id) REFERENCES `wt_block` (block_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_hit_counter` (
 gedcom_id      INTEGER     NOT NULL,
 page_name      VARCHAR(32) NOT NULL,
 page_parameter VARCHAR(32) NOT NULL,
 page_count     INTEGER     NOT NULL,
 PRIMARY KEY                      (gedcom_id, page_name, page_parameter),
 FOREIGN KEY `wt_hit_counter_fk1` (gedcom_id) REFERENCES `wt_gedcom` (gedcom_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_ip_address` (
 ip_address VARCHAR(40)                                NOT NULL,
 category   ENUM('banned', 'search-engine', 'allowed') NOT NULL,
 comment    VARCHAR(255)                               NOT NULL,
 PRIMARY KEY (ip_address)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_session` (
 session_id   CHAR(128)   NOT NULL,
 session_time TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 user_id      INTEGER     NOT NULL,
 ip_address   VARCHAR(32) NOT NULL,
 session_data MEDIUMBLOB  NOT NULL,
 PRIMARY KEY                  (session_id),
         KEY `wt_session_ix1` (session_time),
         KEY `wt_session_ix2` (user_id, ip_address)
) COLLATE utf8_unicode_ci ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `wt_gedcom_chunk` (
 gedcom_chunk_id INTEGER AUTO_INCREMENT NOT NULL,
 gedcom_id       INTEGER                NOT NULL,
 chunk_data      MEDIUMBLOB             NOT NULL,
 imported        BOOLEAN                NOT NULL DEFAULT FALSE,
 PRIMARY KEY     (gedcom_chunk_id),
         KEY `wd_gedcom_chunk_ix1` (gedcom_id, imported),
 FOREIGN KEY `wd_gedcom_chunk_fk1` (gedcom_id) REFERENCES `wt_gedcom` (gedcom_id) /* ON DELETE CASCADE */
) COLLATE utf8_unicode_ci ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS `wt_site_access_rule` (
 site_access_rule_id INTEGER          NOT NULL AUTO_INCREMENT,
 ip_address_start     INTEGER UNSIGNED NOT NULL DEFAULT 0,
 ip_address_end       INTEGER UNSIGNED NOT NULL DEFAULT 4294967295,
 user_agent_pattern   VARCHAR(255)     NOT NULL,
 rule                 ENUM('allow', 'deny', 'robot', 'unknown') NOT NULL DEFAULT 'unknown',
 comment              VARCHAR(255)     NOT NULL,
 updated              TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY     (site_access_rule_id),
         KEY `wt_site_access_rule_ix1` (rule),
         KEY `wt_site_access_rule_ix2` (user_agent_pattern, ip_address_start, ip_address_end, rule),
         KEY `wt_site_access_rule_ix3` (updated)
) ENGINE=InnoDB COLLATE=utf8_unicode_ci;

