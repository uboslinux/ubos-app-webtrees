-- From a MySQL dump

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wt_block`
--

DROP TABLE IF EXISTS `wt_block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_block` (
  `block_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `xref` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location` enum('main','side') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `block_order` int(11) NOT NULL,
  `module_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`block_id`),
  KEY `wt_block_module_name_index` (`module_name`),
  KEY `wt_block_gedcom_id_index` (`gedcom_id`),
  KEY `wt_block_user_id_index` (`user_id`),
  CONSTRAINT `wt_block_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_block_module_name_foreign` FOREIGN KEY (`module_name`) REFERENCES `wt_module` (`module_name`),
  CONSTRAINT `wt_block_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_block`
--

LOCK TABLES `wt_block` WRITE;
/*!40000 ALTER TABLE `wt_block` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_block` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_block_setting`
--

DROP TABLE IF EXISTS `wt_block_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_block_setting` (
  `block_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_value` longtext COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`block_id`,`setting_name`),
  CONSTRAINT `wt_block_setting_block_id_foreign` FOREIGN KEY (`block_id`) REFERENCES `wt_block` (`block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_block_setting`
--

LOCK TABLES `wt_block_setting` WRITE;
/*!40000 ALTER TABLE `wt_block_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_block_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_change`
--

DROP TABLE IF EXISTS `wt_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_change` (
  `change_id` int(11) NOT NULL AUTO_INCREMENT,
  `change_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('accepted','pending','rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pending',
  `gedcom_id` int(11) NOT NULL,
  `xref` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `old_gedcom` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `new_gedcom` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`change_id`),
  KEY `wt_change_gedcom_id_status_xref_index` (`gedcom_id`,`status`,`xref`),
  KEY `wt_change_user_id_index` (`user_id`),
  CONSTRAINT `wt_change_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_change_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_change`
--

LOCK TABLES `wt_change` WRITE;
/*!40000 ALTER TABLE `wt_change` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_change` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_dates`
--

DROP TABLE IF EXISTS `wt_dates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_dates` (
  `d_day` tinyint(4) NOT NULL,
  `d_month` char(5) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `d_mon` tinyint(4) NOT NULL,
  `d_year` smallint(6) NOT NULL,
  `d_julianday1` mediumint(9) NOT NULL,
  `d_julianday2` mediumint(9) NOT NULL,
  `d_fact` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `d_gid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `d_file` int(11) NOT NULL,
  `d_type` enum('@#DGREGORIAN@','@#DJULIAN@','@#DHEBREW@','@#DFRENCH R@','@#DHIJRI@','@#DROMAN@','@#DJALALI@') COLLATE utf8mb4_general_ci NOT NULL,
  KEY `wt_dates_d_day_index` (`d_day`),
  KEY `wt_dates_d_month_index` (`d_month`),
  KEY `wt_dates_d_mon_index` (`d_mon`),
  KEY `wt_dates_d_year_index` (`d_year`),
  KEY `wt_dates_d_julianday1_index` (`d_julianday1`),
  KEY `wt_dates_d_julianday2_index` (`d_julianday2`),
  KEY `wt_dates_d_gid_index` (`d_gid`),
  KEY `wt_dates_d_file_index` (`d_file`),
  KEY `wt_dates_d_type_index` (`d_type`),
  KEY `wt_dates_d_fact_d_gid_index` (`d_fact`,`d_gid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_dates`
--

LOCK TABLES `wt_dates` WRITE;
/*!40000 ALTER TABLE `wt_dates` DISABLE KEYS */;
INSERT INTO `wt_dates` VALUES (1,'JAN',1,1850,2396759,2396759,'BIRT','X1',1,'@#DGREGORIAN@');
/*!40000 ALTER TABLE `wt_dates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_default_resn`
--

DROP TABLE IF EXISTS `wt_default_resn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_default_resn` (
  `default_resn_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_id` int(11) NOT NULL,
  `xref` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tag_type` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `resn` enum('none','privacy','confidential','hidden') COLLATE utf8mb4_general_ci NOT NULL,
  `comment` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`default_resn_id`),
  UNIQUE KEY `wt_default_resn_gedcom_id_xref_tag_type_unique` (`gedcom_id`,`xref`,`tag_type`),
  CONSTRAINT `wt_default_resn_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_default_resn`
--

LOCK TABLES `wt_default_resn` WRITE;
/*!40000 ALTER TABLE `wt_default_resn` DISABLE KEYS */;
INSERT INTO `wt_default_resn` VALUES (1,-1,NULL,'SSN','confidential',NULL,'2023-04-03 23:07:41'),(2,-1,NULL,'SOUR','privacy',NULL,'2023-04-03 23:07:41'),(3,-1,NULL,'REPO','privacy',NULL,'2023-04-03 23:07:41'),(4,-1,NULL,'SUBM','confidential',NULL,'2023-04-03 23:07:41'),(5,-1,NULL,'SUBN','confidential',NULL,'2023-04-03 23:07:41'),(6,1,NULL,'SSN','confidential',NULL,'2023-04-03 23:08:59'),(7,1,NULL,'SOUR','privacy',NULL,'2023-04-03 23:08:59'),(8,1,NULL,'REPO','privacy',NULL,'2023-04-03 23:08:59'),(9,1,NULL,'SUBM','confidential',NULL,'2023-04-03 23:08:59'),(10,1,NULL,'SUBN','confidential',NULL,'2023-04-03 23:08:59');
/*!40000 ALTER TABLE `wt_default_resn` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_families`
--

DROP TABLE IF EXISTS `wt_families`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_families` (
  `f_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `f_file` int(11) NOT NULL,
  `f_husb` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `f_wife` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `f_gedcom` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `f_numchil` int(11) NOT NULL,
  PRIMARY KEY (`f_id`,`f_file`),
  UNIQUE KEY `wt_families_f_file_f_id_unique` (`f_file`,`f_id`),
  KEY `wt_families_f_husb_index` (`f_husb`),
  KEY `wt_families_f_wife_index` (`f_wife`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_families`
--

LOCK TABLES `wt_families` WRITE;
/*!40000 ALTER TABLE `wt_families` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_families` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_favorite`
--

DROP TABLE IF EXISTS `wt_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_favorite` (
  `favorite_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `gedcom_id` int(11) NOT NULL,
  `xref` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `favorite_type` enum('INDI','FAM','SOUR','REPO','OBJE','NOTE','URL') COLLATE utf8mb4_general_ci NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `note` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`favorite_id`),
  KEY `wt_favorite_user_id_index` (`user_id`),
  KEY `wt_favorite_gedcom_id_user_id_index` (`gedcom_id`,`user_id`),
  CONSTRAINT `wt_favorite_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`) ON DELETE CASCADE,
  CONSTRAINT `wt_favorite_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_favorite`
--

LOCK TABLES `wt_favorite` WRITE;
/*!40000 ALTER TABLE `wt_favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_gedcom`
--

DROP TABLE IF EXISTS `wt_gedcom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_gedcom` (
  `gedcom_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`gedcom_id`),
  UNIQUE KEY `wt_gedcom_gedcom_name_unique` (`gedcom_name`),
  KEY `wt_gedcom_sort_order_index` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_gedcom`
--

LOCK TABLES `wt_gedcom` WRITE;
/*!40000 ALTER TABLE `wt_gedcom` DISABLE KEYS */;
INSERT INTO `wt_gedcom` VALUES (-1,'DEFAULT_TREE',0),(1,'tree1',0);
/*!40000 ALTER TABLE `wt_gedcom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_gedcom_chunk`
--

DROP TABLE IF EXISTS `wt_gedcom_chunk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_gedcom_chunk` (
  `gedcom_chunk_id` int(11) NOT NULL AUTO_INCREMENT,
  `gedcom_id` int(11) NOT NULL,
  `chunk_data` longblob DEFAULT NULL,
  `imported` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`gedcom_chunk_id`),
  KEY `wt_gedcom_chunk_gedcom_id_imported_index` (`gedcom_id`,`imported`),
  CONSTRAINT `wt_gedcom_chunk_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_gedcom_chunk`
--

LOCK TABLES `wt_gedcom_chunk` WRITE;
/*!40000 ALTER TABLE `wt_gedcom_chunk` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_gedcom_chunk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_gedcom_setting`
--

DROP TABLE IF EXISTS `wt_gedcom_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_gedcom_setting` (
  `gedcom_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_value` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`gedcom_id`,`setting_name`),
  CONSTRAINT `wt_gedcom_setting_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_gedcom_setting`
--

LOCK TABLES `wt_gedcom_setting` WRITE;
/*!40000 ALTER TABLE `wt_gedcom_setting` DISABLE KEYS */;
INSERT INTO `wt_gedcom_setting` VALUES (1,'CONTACT_USER_ID','1'),(1,'imported','1'),(1,'REQUIRE_AUTHENTICATION',''),(1,'title','My family tree'),(1,'WEBMASTER_USER_ID','1');
/*!40000 ALTER TABLE `wt_gedcom_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_hit_counter`
--

DROP TABLE IF EXISTS `wt_hit_counter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_hit_counter` (
  `gedcom_id` int(11) NOT NULL,
  `page_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `page_parameter` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `page_count` int(11) NOT NULL,
  PRIMARY KEY (`gedcom_id`,`page_name`,`page_parameter`),
  CONSTRAINT `wt_hit_counter_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_hit_counter`
--

LOCK TABLES `wt_hit_counter` WRITE;
/*!40000 ALTER TABLE `wt_hit_counter` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_hit_counter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_individuals`
--

DROP TABLE IF EXISTS `wt_individuals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_individuals` (
  `i_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `i_file` int(11) NOT NULL,
  `i_rin` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `i_sex` enum('U','M','F') COLLATE utf8mb4_general_ci NOT NULL,
  `i_gedcom` longtext COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`i_id`,`i_file`),
  UNIQUE KEY `wt_individuals_i_file_i_id_unique` (`i_file`,`i_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_individuals`
--

LOCK TABLES `wt_individuals` WRITE;
/*!40000 ALTER TABLE `wt_individuals` DISABLE KEYS */;
INSERT INTO `wt_individuals` VALUES ('X1',1,'X1','M','0 @X1@ INDI\n1 NAME John /DOE/\n1 SEX M\n1 BIRT\n2 DATE 01 JAN 1850\n2 NOTE Edit this individual and replace their details with your own.');
/*!40000 ALTER TABLE `wt_individuals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_link`
--

DROP TABLE IF EXISTS `wt_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_link` (
  `l_file` int(11) NOT NULL,
  `l_from` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `l_type` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `l_to` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`l_from`,`l_file`,`l_type`,`l_to`),
  UNIQUE KEY `wt_link_l_to_l_file_l_type_l_from_unique` (`l_to`,`l_file`,`l_type`,`l_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_link`
--

LOCK TABLES `wt_link` WRITE;
/*!40000 ALTER TABLE `wt_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_log`
--

DROP TABLE IF EXISTS `wt_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_log` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `log_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `log_type` enum('auth','config','debug','edit','error','media','search') COLLATE utf8mb4_general_ci NOT NULL,
  `log_message` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `gedcom_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `wt_log_log_time_index` (`log_time`),
  KEY `wt_log_log_type_index` (`log_type`),
  KEY `wt_log_ip_address_index` (`ip_address`),
  KEY `wt_log_user_id_index` (`user_id`),
  KEY `wt_log_gedcom_id_index` (`gedcom_id`),
  CONSTRAINT `wt_log_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_log_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_log`
--

LOCK TABLES `wt_log` WRITE;
/*!40000 ALTER TABLE `wt_log` DISABLE KEYS */;
INSERT INTO `wt_log` VALUES (1,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"1\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(2,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"2\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(3,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"3\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(4,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"4\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(5,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"5\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(6,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"6\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(7,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"7\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(8,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"8\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(9,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"9\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(10,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"10\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(11,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"11\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(12,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"12\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(13,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"13\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(14,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"14\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(15,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"15\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(16,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"16\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(17,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"17\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(18,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"18\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(19,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"19\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(20,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"20\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(21,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"21\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(22,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"22\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(23,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"23\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(24,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"24\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(25,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"25\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(26,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"26\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(27,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"27\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(28,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"28\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(29,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"29\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(30,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"30\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(31,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"31\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(32,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"32\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(33,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"33\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(34,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"34\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(35,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"35\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(36,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"36\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(37,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"37\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(38,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"38\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(39,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"39\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(40,'2023-04-03 23:07:40','config','Site preference \"WT_SCHEMA_VERSION\" set to \"40\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(41,'2023-04-03 23:07:41','config','Site preference \"WT_SCHEMA_VERSION\" set to \"41\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(42,'2023-04-03 23:07:41','config','Site preference \"WT_SCHEMA_VERSION\" set to \"42\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(43,'2023-04-03 23:07:41','config','Site preference \"WT_SCHEMA_VERSION\" set to \"43\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(44,'2023-04-03 23:07:41','config','Site preference \"WT_SCHEMA_VERSION\" set to \"44\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(45,'2023-04-03 23:07:41','config','Site preference \"WT_SCHEMA_VERSION\" set to \"45\"','fe80::35:f0ff:fed5:77a4%host0',NULL,NULL),(46,'2023-04-03 23:08:46','config','Site preference \"SITE_UUID\" set to \"883cec2ed9ad44c8aa80aa46d3a086b8\"','127.0.0.1',1,NULL),(47,'2023-04-03 23:08:47','config','Site preference \"LATEST_WT_VERSION\" set to \"2.1.16|2.0.0|https://github.com/fisharebest/webtrees/releases/download/2.1.16/webtrees-2.1.16.zip\"','127.0.0.1',1,NULL),(48,'2023-04-03 23:08:47','config','Site preference \"LATEST_WT_VERSION_TIMESTAMP\" set to \"1680563326\"','127.0.0.1',1,NULL),(49,'2023-04-03 23:08:59','config','Tree preference \"imported\" set to \"1\"','192.168.205.1',1,1),(50,'2023-04-03 23:08:59','config','Tree preference \"title\" set to \"My family tree\"','192.168.205.1',1,1),(51,'2023-04-03 23:08:59','config','Tree preference \"REQUIRE_AUTHENTICATION\" set to \"\"','192.168.205.1',1,1),(52,'2023-04-03 23:08:59','config','Tree preference \"CONTACT_USER_ID\" set to \"1\"','192.168.205.1',1,1),(53,'2023-04-03 23:08:59','config','Tree preference \"WEBMASTER_USER_ID\" set to \"1\"','192.168.205.1',1,1);
/*!40000 ALTER TABLE `wt_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_media`
--

DROP TABLE IF EXISTS `wt_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_media` (
  `m_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `m_file` int(11) NOT NULL,
  `m_gedcom` longtext COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`m_file`,`m_id`),
  UNIQUE KEY `wt_media_m_id_m_file_unique` (`m_id`,`m_file`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_media`
--

LOCK TABLES `wt_media` WRITE;
/*!40000 ALTER TABLE `wt_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_media_file`
--

DROP TABLE IF EXISTS `wt_media_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_media_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `m_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `m_file` int(11) NOT NULL,
  `multimedia_file_refn` varchar(248) COLLATE utf8mb4_general_ci NOT NULL,
  `multimedia_format` varchar(4) COLLATE utf8mb4_general_ci NOT NULL,
  `source_media_type` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `descriptive_title` varchar(248) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wt_media_file_m_id_m_file_index` (`m_id`,`m_file`),
  KEY `wt_media_file_m_file_m_id_index` (`m_file`,`m_id`),
  KEY `wt_media_file_m_file_multimedia_file_refn_index` (`m_file`,`multimedia_file_refn`),
  KEY `wt_media_file_m_file_multimedia_format_index` (`m_file`,`multimedia_format`),
  KEY `wt_media_file_m_file_source_media_type_index` (`m_file`,`source_media_type`),
  KEY `wt_media_file_m_file_descriptive_title_index` (`m_file`,`descriptive_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_media_file`
--

LOCK TABLES `wt_media_file` WRITE;
/*!40000 ALTER TABLE `wt_media_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_media_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_message`
--

DROP TABLE IF EXISTS `wt_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_message` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_general_ci NOT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`message_id`),
  KEY `wt_message_user_id_index` (`user_id`),
  CONSTRAINT `wt_message_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_message`
--

LOCK TABLES `wt_message` WRITE;
/*!40000 ALTER TABLE `wt_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_module`
--

DROP TABLE IF EXISTS `wt_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_module` (
  `module_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('enabled','disabled') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'enabled',
  `tab_order` int(11) DEFAULT NULL,
  `menu_order` int(11) DEFAULT NULL,
  `sidebar_order` int(11) DEFAULT NULL,
  `footer_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`module_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_module`
--

LOCK TABLES `wt_module` WRITE;
/*!40000 ALTER TABLE `wt_module` DISABLE KEYS */;
INSERT INTO `wt_module` VALUES ('ahnentafel_report','enabled',NULL,NULL,NULL,NULL),('ancestors_chart','enabled',NULL,NULL,NULL,NULL),('austrian-history','disabled',NULL,NULL,NULL,NULL),('austrian-presidents','disabled',NULL,NULL,NULL,NULL),('bdm_report','enabled',NULL,NULL,NULL,NULL),('bing-maps','disabled',NULL,NULL,NULL,NULL),('bing-webmaster-tools','disabled',NULL,NULL,NULL,NULL),('birth_report','enabled',NULL,NULL,NULL,NULL),('branches_list','enabled',NULL,NULL,NULL,NULL),('british-monarchs','disabled',NULL,NULL,NULL,NULL),('british-prime-ministers','disabled',NULL,NULL,NULL,NULL),('british-social-history','disabled',NULL,NULL,NULL,NULL),('calendar-menu','enabled',NULL,NULL,NULL,NULL),('cemetery_report','enabled',NULL,NULL,NULL,NULL),('change_report','enabled',NULL,NULL,NULL,NULL),('charts','enabled',NULL,NULL,NULL,NULL),('charts-menu','enabled',NULL,NULL,NULL,NULL),('check-for-new-version','enabled',NULL,NULL,NULL,NULL),('ckeditor','enabled',NULL,NULL,NULL,NULL),('clippings','enabled',NULL,NULL,NULL,NULL),('clouds','enabled',NULL,NULL,NULL,NULL),('colors','enabled',NULL,NULL,NULL,NULL),('compact-chart','enabled',NULL,NULL,NULL,NULL),('contact-links','enabled',NULL,NULL,NULL,NULL),('custom-css-js','disabled',NULL,NULL,NULL,NULL),('czech-leaders','disabled',NULL,NULL,NULL,NULL),('death_report','enabled',NULL,NULL,NULL,NULL),('descendancy','enabled',NULL,NULL,NULL,NULL),('descendancy_chart','enabled',NULL,NULL,NULL,NULL),('descendancy_report','enabled',NULL,NULL,NULL,NULL),('dutch_monarchs','disabled',NULL,NULL,NULL,NULL),('dutch_prime_ministers','disabled',NULL,NULL,NULL,NULL),('esri-maps','disabled',NULL,NULL,NULL,NULL),('extra_info','enabled',NULL,NULL,NULL,NULL),('fab','enabled',NULL,NULL,NULL,NULL),('fact_sources','enabled',NULL,NULL,NULL,NULL),('family_book_chart','enabled',NULL,NULL,NULL,NULL),('family_group_report','enabled',NULL,NULL,NULL,NULL),('family_list','enabled',NULL,NULL,NULL,NULL),('family_nav','enabled',NULL,NULL,NULL,NULL),('fan_chart','enabled',NULL,NULL,NULL,NULL),('faq','enabled',NULL,NULL,NULL,NULL),('fix-add-death','enabled',NULL,NULL,NULL,NULL),('fix-ceme-tag','enabled',NULL,NULL,NULL,NULL),('fix-duplicate-links','enabled',NULL,NULL,NULL,NULL),('fix-name-slashes-spaces','enabled',NULL,NULL,NULL,NULL),('fix-name-tags','enabled',NULL,NULL,NULL,NULL),('fix-place-names','enabled',NULL,NULL,NULL,NULL),('fix-prim-tag','enabled',NULL,NULL,NULL,NULL),('fix-search-and-replace','enabled',NULL,NULL,NULL,NULL),('fix-wt-obje-sort','enabled',NULL,NULL,NULL,NULL),('french-history','disabled',NULL,NULL,NULL,NULL),('gedcom_block','enabled',NULL,NULL,NULL,NULL),('gedcom_favorites','enabled',NULL,NULL,NULL,NULL),('gedcom_news','enabled',NULL,NULL,NULL,NULL),('gedcom_stats','enabled',NULL,NULL,NULL,NULL),('GEDFact_assistant','enabled',NULL,NULL,NULL,NULL),('geonames','disabled',NULL,NULL,NULL,NULL),('google-analytics','disabled',NULL,NULL,NULL,NULL),('google-maps','disabled',NULL,NULL,NULL,NULL),('google-webmaster-tools','disabled',NULL,NULL,NULL,NULL),('here-maps','disabled',NULL,NULL,NULL,NULL),('hit-counter','enabled',NULL,NULL,NULL,NULL),('hourglass_chart','enabled',NULL,NULL,NULL,NULL),('html','enabled',NULL,NULL,NULL,NULL),('individual_ext_report','enabled',NULL,NULL,NULL,NULL),('individual_list','enabled',NULL,NULL,NULL,NULL),('individual_report','enabled',NULL,NULL,NULL,NULL),('language-af','enabled',NULL,NULL,NULL,NULL),('language-ar','enabled',NULL,NULL,NULL,NULL),('language-bg','enabled',NULL,NULL,NULL,NULL),('language-bs','enabled',NULL,NULL,NULL,NULL),('language-ca','enabled',NULL,NULL,NULL,NULL),('language-cs','enabled',NULL,NULL,NULL,NULL),('language-cy','disabled',NULL,NULL,NULL,NULL),('language-da','enabled',NULL,NULL,NULL,NULL),('language-de','enabled',NULL,NULL,NULL,NULL),('language-dv','disabled',NULL,NULL,NULL,NULL),('language-el','enabled',NULL,NULL,NULL,NULL),('language-en-AU','disabled',NULL,NULL,NULL,NULL),('language-en-GB','enabled',NULL,NULL,NULL,NULL),('language-en-US','enabled',NULL,NULL,NULL,NULL),('language-es','enabled',NULL,NULL,NULL,NULL),('language-et','enabled',NULL,NULL,NULL,NULL),('language-fa','disabled',NULL,NULL,NULL,NULL),('language-fi','enabled',NULL,NULL,NULL,NULL),('language-fo','disabled',NULL,NULL,NULL,NULL),('language-fr','enabled',NULL,NULL,NULL,NULL),('language-fr-CA','disabled',NULL,NULL,NULL,NULL),('language-gl','enabled',NULL,NULL,NULL,NULL),('language-he','enabled',NULL,NULL,NULL,NULL),('language-hi','enabled',NULL,NULL,NULL,NULL),('language-hr','enabled',NULL,NULL,NULL,NULL),('language-hu','enabled',NULL,NULL,NULL,NULL),('language-id','disabled',NULL,NULL,NULL,NULL),('language-is','enabled',NULL,NULL,NULL,NULL),('language-it','enabled',NULL,NULL,NULL,NULL),('language-ja','disabled',NULL,NULL,NULL,NULL),('language-jv','disabled',NULL,NULL,NULL,NULL),('language-ka','enabled',NULL,NULL,NULL,NULL),('language-kk','enabled',NULL,NULL,NULL,NULL),('language-ko','disabled',NULL,NULL,NULL,NULL),('language-ku','disabled',NULL,NULL,NULL,NULL),('language-ln','disabled',NULL,NULL,NULL,NULL),('language-lt','enabled',NULL,NULL,NULL,NULL),('language-lv','disabled',NULL,NULL,NULL,NULL),('language-mi','disabled',NULL,NULL,NULL,NULL),('language-mr','disabled',NULL,NULL,NULL,NULL),('language-ms','disabled',NULL,NULL,NULL,NULL),('language-nb','disabled',NULL,NULL,NULL,NULL),('language-ne','disabled',NULL,NULL,NULL,NULL),('language-nl','enabled',NULL,NULL,NULL,NULL),('language-nn','disabled',NULL,NULL,NULL,NULL),('language-oc','disabled',NULL,NULL,NULL,NULL),('language-pl','enabled',NULL,NULL,NULL,NULL),('language-pt','enabled',NULL,NULL,NULL,NULL),('language-pt-BR','disabled',NULL,NULL,NULL,NULL),('language-ro','disabled',NULL,NULL,NULL,NULL),('language-ru','enabled',NULL,NULL,NULL,NULL),('language-sk','enabled',NULL,NULL,NULL,NULL),('language-sl','disabled',NULL,NULL,NULL,NULL),('language-sq','disabled',NULL,NULL,NULL,NULL),('language-sr','disabled',NULL,NULL,NULL,NULL),('language-sr-Latn','disabled',NULL,NULL,NULL,NULL),('language-su','disabled',NULL,NULL,NULL,NULL),('language-sv','enabled',NULL,NULL,NULL,NULL),('language-sw','disabled',NULL,NULL,NULL,NULL),('language-ta','disabled',NULL,NULL,NULL,NULL),('language-th','disabled',NULL,NULL,NULL,NULL),('language-tl','disabled',NULL,NULL,NULL,NULL),('language-tr','enabled',NULL,NULL,NULL,NULL),('language-tt','disabled',NULL,NULL,NULL,NULL),('language-uk','enabled',NULL,NULL,NULL,NULL),('language-ur','disabled',NULL,NULL,NULL,NULL),('language-vi','enabled',NULL,NULL,NULL,NULL),('language-yi','disabled',NULL,NULL,NULL,NULL),('language-zh-Hans','enabled',NULL,NULL,NULL,NULL),('language-zh-Hant','enabled',NULL,NULL,NULL,NULL),('legacy-urls','enabled',NULL,NULL,NULL,NULL),('lifespans_chart','enabled',NULL,NULL,NULL,NULL),('lightbox','enabled',NULL,NULL,NULL,NULL),('lists-menu','enabled',NULL,NULL,NULL,NULL),('location_list','enabled',NULL,NULL,NULL,NULL),('logged_in','enabled',NULL,NULL,NULL,NULL),('login_block','enabled',NULL,NULL,NULL,NULL),('low_countries_rulers','disabled',NULL,NULL,NULL,NULL),('map-link-bing','enabled',NULL,NULL,NULL,NULL),('map-link-google','enabled',NULL,NULL,NULL,NULL),('map-link-openstreetmap','enabled',NULL,NULL,NULL,NULL),('map-location-geonames','disabled',NULL,NULL,NULL,NULL),('map-location-nominatim','disabled',NULL,NULL,NULL,NULL),('map-location-ors','disabled',NULL,NULL,NULL,NULL),('mapbox','disabled',NULL,NULL,NULL,NULL),('marriage_report','enabled',NULL,NULL,NULL,NULL),('matomo-analytics','disabled',NULL,NULL,NULL,NULL),('media','enabled',NULL,NULL,NULL,NULL),('media_list','enabled',NULL,NULL,NULL,NULL),('minimal','enabled',NULL,NULL,NULL,NULL),('missing_facts_report','enabled',NULL,NULL,NULL,NULL),('note_list','enabled',NULL,NULL,NULL,NULL),('notes','enabled',NULL,NULL,NULL,NULL),('occupation_report','enabled',NULL,NULL,NULL,NULL),('openrouteservice','disabled',NULL,NULL,NULL,NULL),('openstreetmap','enabled',NULL,NULL,NULL,NULL),('osgb-historic','disabled',NULL,NULL,NULL,NULL),('pedigree_chart','enabled',NULL,NULL,NULL,NULL),('pedigree_report','enabled',NULL,NULL,NULL,NULL),('pedigree-map','enabled',NULL,NULL,NULL,NULL),('personal_facts','enabled',NULL,NULL,NULL,NULL),('places','enabled',NULL,NULL,NULL,NULL),('places_list','enabled',NULL,NULL,NULL,NULL),('powered-by-webtrees','enabled',NULL,NULL,NULL,NULL),('privacy-policy','enabled',NULL,NULL,NULL,NULL),('random_media','enabled',NULL,NULL,NULL,NULL),('recent_changes','enabled',NULL,NULL,NULL,NULL),('relationships_chart','enabled',NULL,NULL,NULL,NULL),('relative_ext_report','enabled',NULL,NULL,NULL,NULL),('relatives','enabled',NULL,NULL,NULL,NULL),('reports-menu','enabled',NULL,NULL,NULL,NULL),('repository_list','enabled',NULL,NULL,NULL,NULL),('review_changes','enabled',NULL,NULL,NULL,NULL),('search-menu','enabled',NULL,NULL,NULL,NULL),('share-anniversary','enabled',NULL,NULL,NULL,NULL),('share-url','enabled',NULL,NULL,NULL,NULL),('sitemap','disabled',NULL,NULL,NULL,NULL),('source_list','enabled',NULL,NULL,NULL,NULL),('sources_tab','enabled',NULL,NULL,NULL,NULL),('statcounter','disabled',NULL,NULL,NULL,NULL),('statistics_chart','enabled',NULL,NULL,NULL,NULL),('stories','enabled',NULL,NULL,NULL,NULL),('submitter_list','disabled',NULL,NULL,NULL,NULL),('theme_select','enabled',NULL,NULL,NULL,NULL),('timeline_chart','enabled',NULL,NULL,NULL,NULL),('todays_events','enabled',NULL,NULL,NULL,NULL),('todo','enabled',NULL,NULL,NULL,NULL),('top10_givnnames','enabled',NULL,NULL,NULL,NULL),('top10_pageviews','enabled',NULL,NULL,NULL,NULL),('top10_surnames','enabled',NULL,NULL,NULL,NULL),('tree','enabled',NULL,NULL,NULL,NULL),('trees-menu','enabled',NULL,NULL,NULL,NULL),('upcoming_events','enabled',NULL,NULL,NULL,NULL),('us-presidents','disabled',NULL,NULL,NULL,NULL),('user_blog','enabled',NULL,NULL,NULL,NULL),('user_favorites','enabled',NULL,NULL,NULL,NULL),('user_messages','enabled',NULL,NULL,NULL,NULL),('user_welcome','enabled',NULL,NULL,NULL,NULL),('webtrees','enabled',NULL,NULL,NULL,NULL),('xenea','enabled',NULL,NULL,NULL,NULL),('yahrzeit','enabled',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `wt_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_module_privacy`
--

DROP TABLE IF EXISTS `wt_module_privacy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_module_privacy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `gedcom_id` int(11) NOT NULL,
  `interface` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `access_level` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wt_module_privacy_ix1` (`gedcom_id`,`module_name`,`interface`),
  UNIQUE KEY `wt_module_privacy_ix2` (`module_name`,`gedcom_id`,`interface`),
  CONSTRAINT `wt_module_privacy_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`) ON DELETE CASCADE,
  CONSTRAINT `wt_module_privacy_module_name_foreign` FOREIGN KEY (`module_name`) REFERENCES `wt_module` (`module_name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_module_privacy`
--

LOCK TABLES `wt_module_privacy` WRITE;
/*!40000 ALTER TABLE `wt_module_privacy` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_module_privacy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_module_setting`
--

DROP TABLE IF EXISTS `wt_module_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_module_setting` (
  `module_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_value` longtext COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`module_name`,`setting_name`),
  CONSTRAINT `wt_module_setting_module_name_foreign` FOREIGN KEY (`module_name`) REFERENCES `wt_module` (`module_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_module_setting`
--

LOCK TABLES `wt_module_setting` WRITE;
/*!40000 ALTER TABLE `wt_module_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_module_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_name`
--

DROP TABLE IF EXISTS `wt_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_name` (
  `n_file` int(11) NOT NULL,
  `n_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `n_num` int(11) NOT NULL,
  `n_type` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `n_sort` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `n_full` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `n_surname` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n_surn` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n_givn` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n_soundex_givn_std` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n_soundex_surn_std` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n_soundex_givn_dm` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `n_soundex_surn_dm` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`n_id`,`n_file`,`n_num`),
  KEY `wt_name_n_full_n_id_n_file_index` (`n_full`,`n_id`,`n_file`),
  KEY `wt_name_n_surn_n_file_n_type_n_id_index` (`n_surn`,`n_file`,`n_type`,`n_id`),
  KEY `wt_name_n_givn_n_file_n_type_n_id_index` (`n_givn`,`n_file`,`n_type`,`n_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_name`
--

LOCK TABLES `wt_name` WRITE;
/*!40000 ALTER TABLE `wt_name` DISABLE KEYS */;
INSERT INTO `wt_name` VALUES (1,'X1',0,'NAME','DOE,John','John DOE','DOE','DOE','John','J500','D000','160000:460000:560000:156000:456000:556000','300000');
/*!40000 ALTER TABLE `wt_name` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_news`
--

DROP TABLE IF EXISTS `wt_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_news` (
  `news_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `gedcom_id` int(11) DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `body` text COLLATE utf8mb4_general_ci NOT NULL,
  `updated` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`news_id`),
  KEY `wt_news_user_id_updated_index` (`user_id`,`updated`),
  KEY `wt_news_gedcom_id_updated_index` (`gedcom_id`,`updated`),
  CONSTRAINT `wt_news_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`) ON DELETE CASCADE,
  CONSTRAINT `wt_news_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_news`
--

LOCK TABLES `wt_news` WRITE;
/*!40000 ALTER TABLE `wt_news` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_other`
--

DROP TABLE IF EXISTS `wt_other`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_other` (
  `o_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `o_file` int(11) NOT NULL,
  `o_type` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `o_gedcom` longtext COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`o_id`,`o_file`),
  UNIQUE KEY `wt_other_o_file_o_id_unique` (`o_file`,`o_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_other`
--

LOCK TABLES `wt_other` WRITE;
/*!40000 ALTER TABLE `wt_other` DISABLE KEYS */;
INSERT INTO `wt_other` VALUES ('HEAD',1,'HEAD','0 HEAD\n1 SOUR webtrees\n1 DEST webtrees\n1 GEDC\n2 VERS 5.5.1\n2 FORM LINEAGE-LINKED\n1 CHAR UTF-8\n1 DATE 03 APR 2023');
/*!40000 ALTER TABLE `wt_other` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_place_location`
--

DROP TABLE IF EXISTS `wt_place_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wt_place_location` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `place` varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wt_place_location_parent_id_place_unique` (`parent_id`,`place`),
  UNIQUE KEY `wt_place_location_place_parent_id_unique` (`place`,`parent_id`),
  KEY `wt_place_location_latitude_index` (`latitude`),
  KEY `wt_place_location_longitude_index` (`longitude`),
  CONSTRAINT `wt_place_location_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `wt_place_location` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_place_location`
--

LOCK TABLES `wt_place_location` WRITE;
/*!40000 ALTER TABLE `wt_place_location` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_place_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_placelinks`
--

DROP TABLE IF EXISTS `wt_placelinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_placelinks` (
  `pl_p_id` int(11) NOT NULL,
  `pl_gid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `pl_file` int(11) NOT NULL,
  PRIMARY KEY (`pl_p_id`,`pl_gid`,`pl_file`),
  KEY `wt_placelinks_pl_p_id_index` (`pl_p_id`),
  KEY `wt_placelinks_pl_gid_index` (`pl_gid`),
  KEY `wt_placelinks_pl_file_index` (`pl_file`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_placelinks`
--

LOCK TABLES `wt_placelinks` WRITE;
/*!40000 ALTER TABLE `wt_placelinks` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_placelinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_places`
--

DROP TABLE IF EXISTS `wt_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_places` (
  `p_id` int(11) NOT NULL AUTO_INCREMENT,
  `p_place` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `p_parent_id` int(11) DEFAULT NULL,
  `p_file` int(11) NOT NULL,
  `p_std_soundex` longtext COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_dm_soundex` longtext COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`p_id`),
  UNIQUE KEY `wt_places_p_parent_id_p_file_p_place_unique` (`p_parent_id`,`p_file`,`p_place`),
  KEY `wt_places_p_file_p_place_index` (`p_file`,`p_place`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_places`
--

LOCK TABLES `wt_places` WRITE;
/*!40000 ALTER TABLE `wt_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_session`
--

DROP TABLE IF EXISTS `wt_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_session` (
  `session_id` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `session_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `user_id` int(11) NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_general_ci NOT NULL,
  `session_data` longblob DEFAULT NULL,
  PRIMARY KEY (`session_id`),
  KEY `wt_session_session_time_index` (`session_time`),
  KEY `wt_session_user_id_ip_address_index` (`user_id`,`ip_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_session`
--

LOCK TABLES `wt_session` WRITE;
/*!40000 ALTER TABLE `wt_session` DISABLE KEYS */;
INSERT INTO `wt_session` VALUES ('2pdmbmblakgon5ig5tvneda970','2023-04-03 23:07:41',0,'fe80::35:f0ff:fed5:77a4%host0','initiated|b:1;'),('jlc78bof5uslh62u28dkkg75ur','2023-04-03 23:07:41',1,'192.168.205.1','initiated|b:1;wt_user|i:1;language|s:5:\"en-US\";theme|s:8:\"webtrees\";CSRF_TOKEN|s:32:\"38xu4eJT9kKnBvvTDwKCPTzuwQwnc8WE\";');
/*!40000 ALTER TABLE `wt_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_site_setting`
--

DROP TABLE IF EXISTS `wt_site_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_site_setting` (
  `setting_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_value` varchar(2000) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`setting_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_site_setting`
--

LOCK TABLES `wt_site_setting` WRITE;
/*!40000 ALTER TABLE `wt_site_setting` DISABLE KEYS */;
INSERT INTO `wt_site_setting` VALUES ('LANGUAGE','en-US'),('LATEST_WT_VERSION','2.1.16|2.0.0|https://github.com/fisharebest/webtrees/releases/download/2.1.16/webtrees-2.1.16.zip'),('LATEST_WT_VERSION_TIMESTAMP','1680563326'),('SITE_UUID','883cec2ed9ad44c8aa80aa46d3a086b8'),('WT_SCHEMA_VERSION','45');
/*!40000 ALTER TABLE `wt_site_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_sources`
--

DROP TABLE IF EXISTS `wt_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_sources` (
  `s_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `s_file` int(11) NOT NULL,
  `s_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `s_gedcom` longtext COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`s_id`,`s_file`),
  UNIQUE KEY `wt_sources_s_file_s_id_unique` (`s_file`,`s_id`),
  KEY `wt_sources_s_name_index` (`s_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_sources`
--

LOCK TABLES `wt_sources` WRITE;
/*!40000 ALTER TABLE `wt_sources` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_sources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_user`
--

DROP TABLE IF EXISTS `wt_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `real_name` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `wt_user_user_name_unique` (`user_name`),
  UNIQUE KEY `wt_user_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_user`
--

LOCK TABLES `wt_user` WRITE;
/*!40000 ALTER TABLE `wt_user` DISABLE KEYS */;
INSERT INTO `wt_user` VALUES (-1,'DEFAULT_USER','DEFAULT_USER','DEFAULT_USER','DEFAULT_USER'),(1,'admin','My Ad. Min','test@ubos.net','$2y$10$c3AMfhzq0iWQtaq1gZ9/7OUPHCj/0FNLZde8/YApAD9lGSk1F20GK');
/*!40000 ALTER TABLE `wt_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_user_gedcom_setting`
--

DROP TABLE IF EXISTS `wt_user_gedcom_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_user_gedcom_setting` (
  `user_id` int(11) NOT NULL,
  `gedcom_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_value` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`user_id`,`gedcom_id`,`setting_name`),
  KEY `wt_user_gedcom_setting_gedcom_id_index` (`gedcom_id`),
  CONSTRAINT `wt_user_gedcom_setting_gedcom_id_foreign` FOREIGN KEY (`gedcom_id`) REFERENCES `wt_gedcom` (`gedcom_id`),
  CONSTRAINT `wt_user_gedcom_setting_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_user_gedcom_setting`
--

LOCK TABLES `wt_user_gedcom_setting` WRITE;
/*!40000 ALTER TABLE `wt_user_gedcom_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `wt_user_gedcom_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wt_user_setting`
--

DROP TABLE IF EXISTS `wt_user_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wt_user_setting` (
  `user_id` int(11) NOT NULL,
  `setting_name` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
  `setting_value` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`user_id`,`setting_name`),
  CONSTRAINT `wt_user_setting_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `wt_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wt_user_setting`
--

LOCK TABLES `wt_user_setting` WRITE;
/*!40000 ALTER TABLE `wt_user_setting` DISABLE KEYS */;
INSERT INTO `wt_user_setting` VALUES (1,'canadmin','1'),(1,'language','en-US'),(1,'sessiontime','1582765478'),(1,'verified','1'),(1,'verified_by_admin','1'),(1,'visibleonline','1');
/*!40000 ALTER TABLE `wt_user_setting` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
