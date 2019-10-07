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
-- Table structure for table `api_info`
--

DROP TABLE IF EXISTS `api_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `api_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(255) CHARACTER SET utf8 NOT NULL,
  `api_secret` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_info`
--

LOCK TABLES `api_info` WRITE;
/*!40000 ALTER TABLE `api_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `api_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app`
--

DROP TABLE IF EXISTS `app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app` (
  `name` varchar(100) NOT NULL,
  `value` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app`
--

LOCK TABLES `app` WRITE;
/*!40000 ALTER TABLE `app` DISABLE KEYS */;
INSERT INTO `app` VALUES ('version','7.3'),('date','August 23, 2019'),('build','20190823001'),('update','0'),('last_updated','August 23, 2019');
/*!40000 ALTER TABLE `app` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_calendar`
--

DROP TABLE IF EXISTS `attendance_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance_calendar` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` decimal(10,0) NOT NULL,
  `school_date` date NOT NULL,
  `minutes` decimal(10,0) DEFAULT NULL,
  `block` varchar(10) DEFAULT NULL,
  `calendar_id` decimal(10,0) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`syear`,`school_id`,`school_date`,`calendar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_calendar`
--

LOCK TABLES `attendance_calendar` WRITE;
/*!40000 ALTER TABLE `attendance_calendar` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_calendar` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER `ti_cal_missing_attendance`
     AFTER INSERT ON attendance_calendar
     FOR EACH ROW
     BEGIN
     DECLARE associations INT;
     SET associations = (SELECT COUNT(course_period_id) FROM `course_periods` WHERE calendar_id=NEW.calendar_id);
     IF associations>0 THEN
 	CALL ATTENDANCE_CALC_BY_DATE(NEW.school_date, NEW.syear,NEW.school_id);
     END IF;
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER `td_cal_missing_attendance`
     AFTER DELETE ON attendance_calendar
     FOR EACH ROW
 	DELETE mi.* FROM missing_attendance mi,course_periods cp WHERE mi.course_period_id=cp.course_period_id and cp.calendar_id=OLD.calendar_id AND mi.SCHOOL_DATE=OLD.school_date */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `attendance_code_categories`
--

DROP TABLE IF EXISTS `attendance_code_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance_code_categories` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attendance_code_categories_ind1` (`id`) USING BTREE,
  KEY `attendance_code_categories_ind2` (`syear`,`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_code_categories`
--

LOCK TABLES `attendance_code_categories` WRITE;
/*!40000 ALTER TABLE `attendance_code_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_code_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_codes`
--

DROP TABLE IF EXISTS `attendance_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance_codes` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `state_code` varchar(1) DEFAULT NULL,
  `default_code` varchar(1) DEFAULT NULL,
  `table_name` decimal(10,0) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attendance_codes_ind2` (`syear`,`school_id`) USING BTREE,
  KEY `attendance_codes_ind3` (`short_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_codes`
--

LOCK TABLES `attendance_codes` WRITE;
/*!40000 ALTER TABLE `attendance_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_completed`
--

DROP TABLE IF EXISTS `attendance_completed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance_completed` (
  `staff_id` decimal(10,0) NOT NULL,
  `school_date` date NOT NULL,
  `period_id` decimal(10,0) NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `cpv_id` int(11) NOT NULL,
  `substitute_staff_id` decimal(10,0) DEFAULT NULL,
  `is_taken_by_substitute_staff` char(1) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_completed`
--

LOCK TABLES `attendance_completed` WRITE;
/*!40000 ALTER TABLE `attendance_completed` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_completed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_day`
--

DROP TABLE IF EXISTS `attendance_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance_day` (
  `student_id` decimal(10,0) NOT NULL,
  `school_date` date NOT NULL,
  `minutes_present` decimal(10,0) DEFAULT NULL,
  `state_value` decimal(2,1) DEFAULT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`student_id`,`school_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_day`
--

LOCK TABLES `attendance_day` WRITE;
/*!40000 ALTER TABLE `attendance_day` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_day` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance_period`
--

DROP TABLE IF EXISTS `attendance_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance_period` (
  `student_id` decimal(10,0) NOT NULL,
  `school_date` date NOT NULL,
  `period_id` decimal(10,0) NOT NULL,
  `attendance_code` decimal(10,0) DEFAULT NULL,
  `attendance_teacher_code` decimal(10,0) DEFAULT NULL,
  `attendance_reason` varchar(100) DEFAULT NULL,
  `admin` varchar(1) DEFAULT NULL,
  `course_period_id` decimal(10,0) NOT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`student_id`,`school_date`,`period_id`),
  KEY `attendance_period_ind1` (`student_id`) USING BTREE,
  KEY `attendance_period_ind2` (`period_id`) USING BTREE,
  KEY `attendance_period_ind3` (`attendance_code`) USING BTREE,
  KEY `attendance_period_ind4` (`school_date`) USING BTREE,
  KEY `attendance_period_ind5` (`attendance_code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_period`
--

LOCK TABLES `attendance_period` WRITE;
/*!40000 ALTER TABLE `attendance_period` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance_period` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendar_events`
--

DROP TABLE IF EXISTS `calendar_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar_events` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `calendar_id` decimal(10,0) DEFAULT NULL,
  `school_date` date DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendar_events`
--

LOCK TABLES `calendar_events` WRITE;
/*!40000 ALTER TABLE `calendar_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendar_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendar_events_visibility`
--

DROP TABLE IF EXISTS `calendar_events_visibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendar_events_visibility` (
  `calendar_id` int(11) NOT NULL,
  `profile_id` int(11) DEFAULT NULL,
  `profile` varchar(50) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendar_events_visibility`
--

LOCK TABLES `calendar_events_visibility` WRITE;
/*!40000 ALTER TABLE `calendar_events_visibility` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendar_events_visibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `course_details`
--

DROP TABLE IF EXISTS `course_details`;
/*!50001 DROP VIEW IF EXISTS `course_details`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `course_details` (
  `school_id` tinyint NOT NULL,
  `syear` tinyint NOT NULL,
  `marking_period_id` tinyint NOT NULL,
  `subject_id` tinyint NOT NULL,
  `course_id` tinyint NOT NULL,
  `course_period_id` tinyint NOT NULL,
  `teacher_id` tinyint NOT NULL,
  `secondary_teacher_id` tinyint NOT NULL,
  `course_title` tinyint NOT NULL,
  `cp_title` tinyint NOT NULL,
  `grade_scale_id` tinyint NOT NULL,
  `mp` tinyint NOT NULL,
  `credits` tinyint NOT NULL,
  `begin_date` tinyint NOT NULL,
  `end_date` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `course_period_var`
--

DROP TABLE IF EXISTS `course_period_var`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_period_var` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_period_id` int(11) NOT NULL,
  `days` varchar(7) DEFAULT NULL,
  `course_period_date` date DEFAULT NULL,
  `period_id` int(11) NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `room_id` int(11) NOT NULL,
  `does_attendance` varchar(1) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_period_var`
--

LOCK TABLES `course_period_var` WRITE;
/*!40000 ALTER TABLE `course_period_var` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_period_var` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER ti_course_period_var
     AFTER INSERT ON course_period_var
     FOR EACH ROW
 	CALL ATTENDANCE_CALC(NEW.course_period_id) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER tu_course_period_var
     AFTER UPDATE ON course_period_var
     FOR EACH ROW
 	CALL ATTENDANCE_CALC(NEW.course_period_id) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER td_course_period_var
     AFTER DELETE ON course_period_var
     FOR EACH ROW
 	CALL ATTENDANCE_CALC(OLD.course_period_id) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `course_periods`
--

DROP TABLE IF EXISTS `course_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_periods` (
  `syear` int(4) NOT NULL,
  `school_id` decimal(10,0) NOT NULL,
  `course_period_id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` decimal(10,0) NOT NULL,
  `course_weight` varchar(10) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `short_name` text DEFAULT NULL,
  `mp` varchar(3) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `begin_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL,
  `secondary_teacher_id` int(11) DEFAULT NULL,
  `total_seats` int(11) DEFAULT NULL,
  `filled_seats` decimal(10,0) NOT NULL DEFAULT 0,
  `does_honor_roll` varchar(1) DEFAULT NULL,
  `does_class_rank` varchar(1) DEFAULT NULL,
  `gender_restriction` varchar(1) DEFAULT NULL,
  `house_restriction` varchar(1) DEFAULT NULL,
  `availability` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `calendar_id` int(11) DEFAULT NULL,
  `half_day` varchar(1) DEFAULT NULL,
  `does_breakoff` varchar(1) DEFAULT NULL,
  `rollover_id` int(11) DEFAULT NULL,
  `grade_scale_id` int(11) DEFAULT NULL,
  `credits` decimal(10,3) DEFAULT NULL,
  `schedule_type` enum('FIXED','VARIABLE','BLOCKED') DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `modified_by` int(11) NOT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`course_period_id`),
  KEY `course_periods_ind1` (`syear`) USING BTREE,
  KEY `course_periods_ind2` (`course_id`,`course_weight`,`syear`,`school_id`) USING BTREE,
  KEY `course_periods_ind3` (`course_period_id`) USING BTREE,
  KEY `course_periods_ind5` (`parent_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_periods`
--

LOCK TABLES `course_periods` WRITE;
/*!40000 ALTER TABLE `course_periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_periods` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER tu_course_periods
     AFTER UPDATE ON course_periods
     FOR EACH ROW
     BEGIN
 	CALL ATTENDANCE_CALC(NEW.course_period_id);
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER td_course_periods
     AFTER DELETE ON course_periods
     FOR EACH ROW
     BEGIN
 	DELETE FROM course_period_var WHERE course_period_id=OLD.course_period_id;
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `course_subjects`
--

DROP TABLE IF EXISTS `course_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_subjects` (
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `subject_id` int(8) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `short_name` text DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`subject_id`),
  KEY `course_subjects_ind1` (`syear`,`school_id`,`subject_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_subjects`
--

LOCK TABLES `course_subjects` WRITE;
/*!40000 ALTER TABLE `course_subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `syear` decimal(4,0) NOT NULL,
  `course_id` int(8) NOT NULL AUTO_INCREMENT,
  `subject_id` decimal(10,0) NOT NULL,
  `school_id` decimal(10,0) NOT NULL,
  `grade_level` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `short_name` varchar(25) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`course_id`),
  KEY `courses_ind1` (`course_id`,`syear`) USING BTREE,
  KEY `courses_ind2` (`subject_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_fields`
--

DROP TABLE IF EXISTS `custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_fields` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) DEFAULT NULL,
  `search` varchar(1) DEFAULT NULL,
  `title` varchar(30) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` varchar(10000) DEFAULT NULL,
  `category_id` decimal(10,0) DEFAULT NULL,
  `system_field` char(1) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` varchar(255) DEFAULT NULL,
  `hide` varchar(1) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `address_desc_ind2` (`type`) USING BTREE,
  KEY `address_fields_ind3` (`category_id`) USING BTREE,
  KEY `custom_desc_ind` (`id`) USING BTREE,
  KEY `custom_desc_ind2` (`type`) USING BTREE,
  KEY `custom_fields_ind3` (`category_id`) USING BTREE,
  KEY `people_desc_ind2` (`type`) USING BTREE,
  KEY `people_fields_ind3` (`category_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_fields`
--

LOCK TABLES `custom_fields` WRITE;
/*!40000 ALTER TABLE `custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device_info`
--

DROP TABLE IF EXISTS `device_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL,
  `device_type` varchar(255) CHARACTER SET utf8 NOT NULL,
  `device_token` longtext CHARACTER SET utf8 NOT NULL,
  `device_id` longtext CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_info`
--

LOCK TABLES `device_info` WRITE;
/*!40000 ALTER TABLE `device_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `device_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eligibility`
--

DROP TABLE IF EXISTS `eligibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eligibility` (
  `student_id` decimal(10,0) DEFAULT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_date` date DEFAULT NULL,
  `period_id` decimal(10,0) DEFAULT NULL,
  `eligibility_code` varchar(20) DEFAULT NULL,
  `course_period_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  KEY `eligibility_ind1` (`student_id`,`course_period_id`,`school_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eligibility`
--

LOCK TABLES `eligibility` WRITE;
/*!40000 ALTER TABLE `eligibility` DISABLE KEYS */;
/*!40000 ALTER TABLE `eligibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eligibility_activities`
--

DROP TABLE IF EXISTS `eligibility_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eligibility_activities` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `eligibility_activities_ind1` (`school_id`,`syear`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eligibility_activities`
--

LOCK TABLES `eligibility_activities` WRITE;
/*!40000 ALTER TABLE `eligibility_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `eligibility_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eligibility_completed`
--

DROP TABLE IF EXISTS `eligibility_completed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eligibility_completed` (
  `staff_id` decimal(10,0) NOT NULL,
  `school_date` date NOT NULL,
  `period_id` decimal(10,0) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_id`,`school_date`,`period_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eligibility_completed`
--

LOCK TABLES `eligibility_completed` WRITE;
/*!40000 ALTER TABLE `eligibility_completed` DISABLE KEYS */;
/*!40000 ALTER TABLE `eligibility_completed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `enroll_grade`
--

DROP TABLE IF EXISTS `enroll_grade`;
/*!50001 DROP VIEW IF EXISTS `enroll_grade`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `enroll_grade` (
  `id` tinyint NOT NULL,
  `syear` tinyint NOT NULL,
  `school_id` tinyint NOT NULL,
  `student_id` tinyint NOT NULL,
  `start_date` tinyint NOT NULL,
  `end_date` tinyint NOT NULL,
  `short_name` tinyint NOT NULL,
  `title` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ethnicity`
--

DROP TABLE IF EXISTS `ethnicity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ethnicity` (
  `ethnicity_id` int(8) NOT NULL AUTO_INCREMENT,
  `ethnicity_name` varchar(255) NOT NULL,
  `sort_order` int(8) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date time ethnicity record modified',
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ethnicity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ethnicity`
--

LOCK TABLES `ethnicity` WRITE;
/*!40000 ALTER TABLE `ethnicity` DISABLE KEYS */;
INSERT INTO `ethnicity` VALUES (1,'White, Non-Hispanic',1,'0000-00-00 00:00:00',NULL),(2,'Black, Non-Hispanic',2,'0000-00-00 00:00:00',NULL),(3,'Hispanic',3,'0000-00-00 00:00:00',NULL),(4,'American Indian or Native Alaskan',4,'0000-00-00 00:00:00',NULL),(5,'Pacific Islander',5,'0000-00-00 00:00:00',NULL),(6,'Asian',6,'0000-00-00 00:00:00',NULL),(7,'Indian',7,'0000-00-00 00:00:00',NULL),(8,'Middle Eastern',8,'0000-00-00 00:00:00',NULL),(9,'African',9,'0000-00-00 00:00:00',NULL),(10,'Mixed Race',10,'0000-00-00 00:00:00',NULL),(11,'Other',11,'0000-00-00 00:00:00',NULL),(12,'Black',12,'0000-00-00 00:00:00',NULL),(13,'White',13,'0000-00-00 00:00:00',NULL),(14,'African',14,'0000-00-00 00:00:00',NULL),(15,'Indigenous',15,'2013-05-31 03:20:54',NULL);
/*!40000 ALTER TABLE `ethnicity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filter_fields`
--

DROP TABLE IF EXISTS `filter_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filter_fields` (
  `filter_field_id` int(11) NOT NULL AUTO_INCREMENT,
  `filter_id` int(11) DEFAULT NULL,
  `filter_column` varchar(255) DEFAULT NULL,
  `filter_value` longtext DEFAULT NULL,
  PRIMARY KEY (`filter_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filter_fields`
--

LOCK TABLES `filter_fields` WRITE;
/*!40000 ALTER TABLE `filter_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `filter_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filters`
--

DROP TABLE IF EXISTS `filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `filters` (
  `filter_id` int(11) NOT NULL AUTO_INCREMENT,
  `filter_name` varchar(255) DEFAULT NULL,
  `school_id` int(11) DEFAULT 0,
  `show_to` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`filter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filters`
--

LOCK TABLES `filters` WRITE;
/*!40000 ALTER TABLE `filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gradebook_assignment_types`
--

DROP TABLE IF EXISTS `gradebook_assignment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gradebook_assignment_types` (
  `assignment_type_id` int(8) NOT NULL AUTO_INCREMENT,
  `staff_id` decimal(10,0) DEFAULT NULL,
  `course_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `final_grade_percent` decimal(6,5) DEFAULT NULL,
  `course_period_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`assignment_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gradebook_assignment_types`
--

LOCK TABLES `gradebook_assignment_types` WRITE;
/*!40000 ALTER TABLE `gradebook_assignment_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `gradebook_assignment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gradebook_assignments`
--

DROP TABLE IF EXISTS `gradebook_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gradebook_assignments` (
  `assignment_id` int(8) NOT NULL AUTO_INCREMENT,
  `staff_id` decimal(10,0) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `course_period_id` decimal(10,0) DEFAULT NULL,
  `course_id` decimal(10,0) DEFAULT NULL,
  `assignment_type_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `assigned_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `points` decimal(10,0) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `ungraded` int(8) NOT NULL DEFAULT 1,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`assignment_id`),
  KEY `gradebook_assignment_types_ind1` (`staff_id`,`course_id`) USING BTREE,
  KEY `gradebook_assignments_ind1` (`staff_id`,`marking_period_id`) USING BTREE,
  KEY `gradebook_assignments_ind2` (`course_id`,`course_period_id`) USING BTREE,
  KEY `gradebook_assignments_ind3` (`assignment_type_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gradebook_assignments`
--

LOCK TABLES `gradebook_assignments` WRITE;
/*!40000 ALTER TABLE `gradebook_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `gradebook_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gradebook_grades`
--

DROP TABLE IF EXISTS `gradebook_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gradebook_grades` (
  `student_id` decimal(10,0) NOT NULL,
  `period_id` decimal(10,0) DEFAULT NULL,
  `course_period_id` decimal(10,0) NOT NULL,
  `assignment_id` decimal(10,0) NOT NULL,
  `points` decimal(6,2) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`student_id`,`assignment_id`,`course_period_id`),
  KEY `gradebook_grades_ind1` (`assignment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gradebook_grades`
--

LOCK TABLES `gradebook_grades` WRITE;
/*!40000 ALTER TABLE `gradebook_grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `gradebook_grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grades_completed`
--

DROP TABLE IF EXISTS `grades_completed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grades_completed` (
  `staff_id` decimal(10,0) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `period_id` decimal(10,0) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_id`,`marking_period_id`,`period_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grades_completed`
--

LOCK TABLES `grades_completed` WRITE;
/*!40000 ALTER TABLE `grades_completed` DISABLE KEYS */;
/*!40000 ALTER TABLE `grades_completed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hacking_log`
--

DROP TABLE IF EXISTS `hacking_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hacking_log` (
  `host_name` varchar(20) DEFAULT NULL,
  `ip_address` varchar(20) DEFAULT NULL,
  `login_date` date DEFAULT NULL,
  `version` varchar(20) DEFAULT NULL,
  `php_self` varchar(20) DEFAULT NULL,
  `document_root` varchar(100) DEFAULT NULL,
  `script_name` varchar(100) DEFAULT NULL,
  `modname` varchar(100) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hacking_log`
--

LOCK TABLES `hacking_log` WRITE;
/*!40000 ALTER TABLE `hacking_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `hacking_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history_marking_periods`
--

DROP TABLE IF EXISTS `history_marking_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `history_marking_periods` (
  `parent_id` int(11) DEFAULT NULL,
  `mp_type` char(20) DEFAULT NULL,
  `name` char(30) DEFAULT NULL,
  `post_end_date` date DEFAULT NULL,
  `school_id` int(11) DEFAULT NULL,
  `syear` int(11) DEFAULT NULL,
  `marking_period_id` int(11) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`marking_period_id`),
  KEY `history_marking_period_ind1` (`school_id`) USING BTREE,
  KEY `history_marking_period_ind2` (`syear`) USING BTREE,
  KEY `history_marking_period_ind3` (`mp_type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history_marking_periods`
--

LOCK TABLES `history_marking_periods` WRITE;
/*!40000 ALTER TABLE `history_marking_periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `history_marking_periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `history_school`
--

DROP TABLE IF EXISTS `history_school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `history_school` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `school_name` varchar(100) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `history_school`
--

LOCK TABLES `history_school` WRITE;
/*!40000 ALTER TABLE `history_school` DISABLE KEYS */;
/*!40000 ALTER TABLE `history_school` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `honor_roll`
--

DROP TABLE IF EXISTS `honor_roll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `honor_roll` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `school_id` int(11) NOT NULL,
  `syear` int(4) NOT NULL,
  `title` varchar(100) NOT NULL,
  `value` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `honor_roll`
--

LOCK TABLES `honor_roll` WRITE;
/*!40000 ALTER TABLE `honor_roll` DISABLE KEYS */;
/*!40000 ALTER TABLE `honor_roll` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `language` (
  `language_id` int(8) NOT NULL AUTO_INCREMENT,
  `language_name` varchar(127) NOT NULL,
  `sort_order` int(8) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `language`
--

LOCK TABLES `language` WRITE;
/*!40000 ALTER TABLE `language` DISABLE KEYS */;
INSERT INTO `language` VALUES (1,'English',1,'2015-07-28 09:56:33',NULL),(2,'Arabic',2,'2015-07-28 09:56:33',NULL),(3,'Bengali',3,'2015-07-28 09:56:33',NULL),(4,'Chinese',4,'2015-07-28 09:56:33',NULL),(5,'French',5,'2015-07-28 09:56:33',NULL),(6,'German',6,'2015-07-28 09:56:33',NULL),(7,'Haitian Creole',7,'2015-07-28 09:56:33',NULL),(8,'Hindi',8,'2015-07-28 09:56:33',NULL),(9,'Italian',9,'2015-07-28 09:56:33',NULL),(10,'Japanese',10,'2015-07-28 09:56:33',NULL),(11,'Korean',11,'2015-07-28 09:56:33',NULL),(12,'Malay',12,'2015-07-28 09:56:33',NULL),(13,'Polish',13,'2015-07-28 09:56:33',NULL),(14,'Portuguese',14,'2015-07-28 09:56:33',NULL),(15,'Russian',15,'2015-07-28 09:56:33',NULL),(16,'Spanish',16,'2015-07-28 09:56:33',NULL),(17,'Thai',17,'2015-07-28 09:56:33',NULL),(18,'Turkish',18,'2015-07-28 09:56:33',NULL),(19,'Urdu',19,'2015-07-28 09:56:33',NULL),(20,'Vietnamese',20,'2015-07-28 09:56:33',NULL);
/*!40000 ALTER TABLE `language` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_maintain`
--

DROP TABLE IF EXISTS `log_maintain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_maintain` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `value` decimal(30,0) DEFAULT NULL,
  `session_id` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_maintain`
--

LOCK TABLES `log_maintain` WRITE;
/*!40000 ALTER TABLE `log_maintain` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_maintain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_authentication`
--

DROP TABLE IF EXISTS `login_authentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_authentication` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `failed_login` int(3) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `COMPOSITE` (`user_id`,`profile_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_authentication`
--

LOCK TABLES `login_authentication` WRITE;
/*!40000 ALTER TABLE `login_authentication` DISABLE KEYS */;
INSERT INTO `login_authentication` VALUES (1,1,0,'opensis','a5ac247f0aa4c5eb3388858c938552c3','2019-08-19 23:59:43',0,'2015-07-28 04:26:33',NULL);
/*!40000 ALTER TABLE `login_authentication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_message`
--

DROP TABLE IF EXISTS `login_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_message` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `message` longtext DEFAULT NULL,
  `display` char(1) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_message`
--

LOCK TABLES `login_message` WRITE;
/*!40000 ALTER TABLE `login_message` DISABLE KEYS */;
INSERT INTO `login_message` VALUES (1,'This is a restricted network. Use of this network, its equipment, and resources is monitored at all times and requires explicit permission from the network administrator. If you do not have this permission in writing, you are violating the regulations of this network and can and will be prosecuted to the fullest extent of law. By continuing into this system, you are acknowledging that you are aware of and agree to these terms.','Y');
/*!40000 ALTER TABLE `login_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_records`
--

DROP TABLE IF EXISTS `login_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login_records` (
  `syear` decimal(5,0) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `profile` varchar(50) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `login_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `faillog_count` decimal(4,0) DEFAULT NULL,
  `staff_id` decimal(10,0) DEFAULT NULL,
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `faillog_time` varchar(255) DEFAULT NULL,
  `ip_address` varchar(20) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_records`
--

LOCK TABLES `login_records` WRITE;
/*!40000 ALTER TABLE `login_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lunch_period`
--

DROP TABLE IF EXISTS `lunch_period`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lunch_period` (
  `student_id` decimal(10,0) DEFAULT NULL,
  `school_date` date DEFAULT NULL,
  `period_id` decimal(10,0) DEFAULT NULL,
  `attendance_code` decimal(10,0) DEFAULT NULL,
  `attendance_teacher_code` decimal(10,0) DEFAULT NULL,
  `attendance_reason` varchar(100) DEFAULT NULL,
  `admin` varchar(1) DEFAULT NULL,
  `course_period_id` decimal(10,0) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `lunch_period` varchar(100) DEFAULT NULL,
  `table_name` decimal(10,0) DEFAULT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lunch_period`
--

LOCK TABLES `lunch_period` WRITE;
/*!40000 ALTER TABLE `lunch_period` DISABLE KEYS */;
/*!40000 ALTER TABLE `lunch_period` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_group`
--

DROP TABLE IF EXISTS `mail_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_group` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_group`
--

LOCK TABLES `mail_group` WRITE;
/*!40000 ALTER TABLE `mail_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_groupmembers`
--

DROP TABLE IF EXISTS `mail_groupmembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_groupmembers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `profile` varchar(255) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_groupmembers`
--

LOCK TABLES `mail_groupmembers` WRITE;
/*!40000 ALTER TABLE `mail_groupmembers` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_groupmembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marking_period_id_generator`
--

DROP TABLE IF EXISTS `marking_period_id_generator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marking_period_id_generator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marking_period_id_generator`
--

LOCK TABLES `marking_period_id_generator` WRITE;
/*!40000 ALTER TABLE `marking_period_id_generator` DISABLE KEYS */;
INSERT INTO `marking_period_id_generator` VALUES (1);
/*!40000 ALTER TABLE `marking_period_id_generator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `marking_periods`
--

DROP TABLE IF EXISTS `marking_periods`;
/*!50001 DROP VIEW IF EXISTS `marking_periods`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `marking_periods` (
  `marking_period_id` tinyint NOT NULL,
  `mp_source` tinyint NOT NULL,
  `syear` tinyint NOT NULL,
  `school_id` tinyint NOT NULL,
  `mp_type` tinyint NOT NULL,
  `title` tinyint NOT NULL,
  `short_name` tinyint NOT NULL,
  `sort_order` tinyint NOT NULL,
  `parent_id` tinyint NOT NULL,
  `grandparent_id` tinyint NOT NULL,
  `start_date` tinyint NOT NULL,
  `end_date` tinyint NOT NULL,
  `post_start_date` tinyint NOT NULL,
  `post_end_date` tinyint NOT NULL,
  `does_grades` tinyint NOT NULL,
  `does_exam` tinyint NOT NULL,
  `does_comments` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `medical_info`
--

DROP TABLE IF EXISTS `medical_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medical_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `syear` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `physician` varchar(255) DEFAULT NULL,
  `physician_phone` varchar(255) DEFAULT NULL,
  `preferred_hospital` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_info`
--

LOCK TABLES `medical_info` WRITE;
/*!40000 ALTER TABLE `medical_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `missing_attendance`
--

DROP TABLE IF EXISTS `missing_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `missing_attendance` (
  `school_id` int(11) NOT NULL,
  `syear` varchar(6) NOT NULL,
  `school_date` date NOT NULL,
  `course_period_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `secondary_teacher_id` int(11) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missing_attendance`
--

LOCK TABLES `missing_attendance` WRITE;
/*!40000 ALTER TABLE `missing_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `missing_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msg_inbox`
--

DROP TABLE IF EXISTS `msg_inbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msg_inbox` (
  `mail_id` int(11) NOT NULL AUTO_INCREMENT,
  `to_user` varchar(211) NOT NULL,
  `from_user` varchar(211) NOT NULL,
  `mail_Subject` varchar(211) DEFAULT NULL,
  `mail_body` longtext NOT NULL,
  `mail_datetime` datetime DEFAULT NULL,
  `mail_attachment` varchar(211) DEFAULT NULL,
  `isdraft` int(11) DEFAULT NULL,
  `istrash` varchar(255) DEFAULT NULL,
  `to_multiple_users` varchar(255) DEFAULT NULL,
  `to_cc` varchar(255) DEFAULT NULL,
  `to_cc_multiple` varchar(255) DEFAULT NULL,
  `to_bcc` varchar(255) DEFAULT NULL,
  `to_bcc_multiple` varchar(255) DEFAULT NULL,
  `mail_read_unread` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msg_inbox`
--

LOCK TABLES `msg_inbox` WRITE;
/*!40000 ALTER TABLE `msg_inbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_inbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `msg_outbox`
--

DROP TABLE IF EXISTS `msg_outbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `msg_outbox` (
  `mail_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_user` varchar(211) NOT NULL,
  `to_user` varchar(211) NOT NULL,
  `mail_subject` varchar(211) DEFAULT NULL,
  `mail_body` longtext NOT NULL,
  `mail_datetime` datetime DEFAULT NULL,
  `mail_attachment` varchar(211) DEFAULT NULL,
  `istrash` int(11) DEFAULT NULL,
  `to_cc` varchar(255) DEFAULT NULL,
  `to_bcc` varchar(255) DEFAULT NULL,
  `to_grpName` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `msg_outbox`
--

LOCK TABLES `msg_outbox` WRITE;
/*!40000 ALTER TABLE `msg_outbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `msg_outbox` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `people`
--

DROP TABLE IF EXISTS `people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `people` (
  `staff_id` int(11) NOT NULL AUTO_INCREMENT,
  `current_school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(5) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `home_phone` varchar(255) DEFAULT NULL,
  `work_phone` varchar(255) DEFAULT NULL,
  `cell_phone` varchar(255) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `custody` varchar(1) DEFAULT NULL,
  `profile` varchar(30) DEFAULT NULL,
  `profile_id` decimal(10,0) DEFAULT NULL,
  `is_disable` varchar(10) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `people`
--

LOCK TABLES `people` WRITE;
/*!40000 ALTER TABLE `people` DISABLE KEYS */;
/*!40000 ALTER TABLE `people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `people_field_categories`
--

DROP TABLE IF EXISTS `people_field_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `people_field_categories` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `include` varchar(100) DEFAULT NULL,
  `admin` char(1) DEFAULT NULL,
  `teacher` char(1) DEFAULT NULL,
  `parent` char(1) DEFAULT NULL,
  `none` char(1) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `people_field_categories`
--

LOCK TABLES `people_field_categories` WRITE;
/*!40000 ALTER TABLE `people_field_categories` DISABLE KEYS */;
INSERT INTO `people_field_categories` VALUES (1,'General Info',1,NULL,'Y','Y','Y','Y','2015-07-28 09:56:33',NULL),(2,'Address Info',2,NULL,'Y','Y','Y','Y','2015-07-28 09:56:33',NULL);
/*!40000 ALTER TABLE `people_field_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `people_fields`
--

DROP TABLE IF EXISTS `people_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `people_fields` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) DEFAULT NULL,
  `search` varchar(1) DEFAULT NULL,
  `title` varchar(30) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` varchar(10000) DEFAULT NULL,
  `category_id` decimal(10,0) DEFAULT NULL,
  `system_field` char(1) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `people_desc_ind` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `people_fields`
--

LOCK TABLES `people_fields` WRITE;
/*!40000 ALTER TABLE `people_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `people_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portal_notes`
--

DROP TABLE IF EXISTS `portal_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portal_notes` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `school_id` decimal(10,0) DEFAULT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `published_user` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `published_profiles` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portal_notes`
--

LOCK TABLES `portal_notes` WRITE;
/*!40000 ALTER TABLE `portal_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `portal_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_exceptions`
--

DROP TABLE IF EXISTS `profile_exceptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_exceptions` (
  `profile_id` decimal(10,0) DEFAULT NULL,
  `modname` varchar(255) DEFAULT NULL,
  `can_use` varchar(1) DEFAULT NULL,
  `can_edit` varchar(1) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_exceptions`
--

LOCK TABLES `profile_exceptions` WRITE;
/*!40000 ALTER TABLE `profile_exceptions` DISABLE KEYS */;
INSERT INTO `profile_exceptions` VALUES (2,'students/Student.php&category_id=6','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/Student.php&category_id=7','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'students/Student.php&category_id=6','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'students/Student.php&category_id=6','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'users/User.php&category_id=5','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'schoolsetup/Schools.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'schoolsetup/Calendar.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'students/Student.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'students/Student.php&category_id=1','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'students/Student.php&category_id=3','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'students/ChangePassword.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'scheduling/ViewSchedule.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'scheduling/PrintSchedules.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'scheduling/Requests.php','Y','Y','2015-07-28 09:56:33',NULL),(3,'grades/StudentGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'grades/FinalGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'grades/ReportCards.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'grades/Transcripts.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'grades/GPARankList.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'attendance/StudentSummary.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'attendance/DailySummary.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'eligibility/Student.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'eligibility/StudentList.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'schoolsetup/Schools.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'schoolsetup/MarkingPeriods.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'schoolsetup/Calendar.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/Student.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/AddUsers.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/AdvancedReport.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/StudentLabels.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/Student.php&category_id=1','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/Student.php&category_id=3','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/Student.php&category_id=4','Y','Y','2015-07-28 09:56:33',NULL),(2,'users/User.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/Rooms.php','Y','Y','2015-07-28 09:56:33',NULL),(2,'grades/Grades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'users/Preferences.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'scheduling/Schedule.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'scheduling/PrintSchedules.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'scheduling/PrintClassLists.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'scheduling/PrintClassPictures.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/InputFinalGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/ReportCards.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/Grades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/Assignments.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/AnomalousGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/Configuration.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/ProgressReports.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/StudentGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/FinalGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/ReportCardGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'grades/ReportCardComments.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'attendance/TakeAttendance.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'attendance/DailySummary.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'attendance/StudentSummary.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'eligibility/EnterEligibility.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'scheduling/ViewSchedule.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'attendance/StudentSummary.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'attendance/DailySummary.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'eligibility/Student.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'eligibility/StudentList.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'schoolsetup/Schools.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'schoolsetup/Calendar.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'students/Student.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'students/Student.php&category_id=1','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'students/Student.php&category_id=3','Y','Y','2015-07-28 09:56:33',NULL),(4,'users/User.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'users/User.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(4,'users/Preferences.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'scheduling/ViewSchedule.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'scheduling/Requests.php','Y','Y','2015-07-28 09:56:33',NULL),(4,'grades/StudentGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'grades/FinalGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'grades/ReportCards.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'grades/Transcripts.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'grades/GPARankList.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'users/User.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(4,'users/User.php&category_id=3','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'schoolsetup/Courses.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'schoolsetup/CourseCatalog.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'schoolsetup/PrintCatalog.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'schoolsetup/PrintAllCourses.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'students/Student.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(4,'students/ChangePassword.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'scheduling/StudentScheduleReport.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'grades/ParentProgressReports.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'scheduling/StudentScheduleReport.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'Billing/Fee.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'Billing/Balance_Report.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'Billing/DailyTransactions.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'Billing/Fee.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'Billing/Balance_Report.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'Billing/DailyTransactions.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/PortalNotes.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'schoolsetup/MarkingPeriods.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/Calendar.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'schoolsetup/Periods.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/GradeLevels.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/Schools.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/UploadLogo.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/Schools.php?new_school=true','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/CopySchool.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/SystemPreference.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/Courses.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/CourseCatalog.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/PrintCatalog.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/PrintCatalogGradeLevel.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/PrintAllCourses.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'schoolsetup/TeacherReassignment.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'students/Student.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Student.php&include=GeneralInfoInc&student_id=new','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/AssignOtherInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/AddUsers.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/AdvancedReport.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/AddDrop.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Letters.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/MailingLabels.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/StudentLabels.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/PrintStudentInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/PrintStudentContactInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/GoalReport.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/StudentFields.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'students/EnrollmentCodes.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Upload.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Upload.php?modfunc=edit','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Student.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Student.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Student.php&category_id=3','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Student.php&category_id=4','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/Student.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(5,'users/User.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'users/User.php&staff_id=new','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/AddStudents.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/Preferences.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/Profiles.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/Exceptions.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/UserFields.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/TeacherPrograms.php?include=grades/InputFinalGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/TeacherPrograms.php?include=grades/Grades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/TeacherPrograms.php?include=grades/ProgressReports.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'users/TeacherPrograms.php?include=attendance/TakeAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'users/TeacherPrograms.php?include=attendance/Missing_Attendance.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'users/TeacherPrograms.php?include=eligibility/EnterEligibility.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'users/User.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(5,'users/User.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(5,'scheduling/Schedule.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/ViewSchedule.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/Requests.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/MassSchedule.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/MassRequests.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/MassDrops.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/PrintSchedules.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'scheduling/PrintClassLists.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'scheduling/PrintClassPictures.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/PrintRequests.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/ScheduleReport.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/RequestsReport.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/UnfilledRequests.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/IncompleteSchedules.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/AddDrop.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'scheduling/Scheduler.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/ReportCards.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'grades/CalcGPA.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'grades/Transcripts.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'grades/TeacherCompletion.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/GradeBreakdown.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/FinalGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/GPARankList.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/AdminProgressReports.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/HonorRoll.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/ReportCardGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'grades/ReportCardComments.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'grades/HonorRollSetup.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'grades/FixGPA.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/EditReportCardGrades.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'grades/EditHistoryMarkingPeriods.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'attendance/Administration.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/AddAbsences.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/AttendanceData.php?list_by_day=true','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/Percent.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/Percent.php?list_by_day=true','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/DailySummary.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/StudentSummary.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/TeacherCompletion.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/FixDailyAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/DuplicateAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'attendance/AttendanceCodes.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'eligibility/Student.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'eligibility/AddActivity.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'eligibility/StudentList.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'eligibility/TeacherCompletion.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'eligibility/Activities.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'eligibility/EntryTimes.php','Y',NULL,'2015-07-28 09:56:33',NULL),(5,'Billing/LedgerCard.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/Balance_Report.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/DailyTransactions.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/PaymentHistory.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/Fee.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/StudentPayments.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/MassAssignFees.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/MassAssignPayments.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/SetUp.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/SetUp_FeeType.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'Billing/SetUp_PayPal.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'tools/LogDetails.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'tools/DeleteLog.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'tools/Rollover.php','Y','Y','2015-07-28 09:56:33',NULL),(2,'users/Staff.php','Y',NULL,'2015-07-28 09:56:33',NULL),(1,'schoolsetup/SchoolCustomFields.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&category_id=6','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&category_id=7','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/User.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/PortalNotes.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/Schools.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/Schools.php?new_school=true','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/CopySchool.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/MarkingPeriods.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/Calendar.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/Periods.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/GradeLevels.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/Rollover.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/Courses.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/CourseCatalog.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/PrintCatalog.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/PrintCatalogGradeLevel.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/PrintAllCourses.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/UploadLogo.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/TeacherReassignment.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&include=GeneralInfoInc&student_id=new','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/AssignOtherInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/AddUsers.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/AdvancedReport.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/AddDrop.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Letters.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/MailingLabels.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/StudentLabels.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/PrintStudentInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/PrintStudentContactInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/GoalReport.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/StudentFields.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/AddressFields.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/PeopleFields.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/EnrollmentCodes.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Upload.php?modfunc=edit','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Upload.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&category_id=3','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&category_id=4','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/StudentReenroll.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/EnrollmentReport.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/User.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/User.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/User.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/User.php&staff_id=new','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/AddStudents.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Preferences.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Profiles.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Exceptions.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/UserFields.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/TeacherPrograms.php?include=grades/InputFinalGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/TeacherPrograms.php?include=grades/Grades.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/TeacherPrograms.php?include=attendance/TakeAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/TeacherPrograms.php?include=attendance/Missing_Attendance.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/TeacherPrograms.php?include=eligibility/EnterEligibility.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/UploadUserPhoto.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/UploadUserPhoto.php?modfunc=edit','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/UserAdvancedReport.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/UserAdvancedReportStaff.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/Schedule.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/Requests.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/MassSchedule.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/MassRequests.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/MassDrops.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/ScheduleReport.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/RequestsReport.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/UnfilledRequests.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/IncompleteSchedules.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/AddDrop.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/PrintSchedules.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/PrintRequests.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/PrintClassLists.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/PrintClassPictures.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/Courses.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/Scheduler.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'scheduling/ViewSchedule.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/ReportCards.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/CalcGPA.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/Transcripts.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/TeacherCompletion.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/GradeBreakdown.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/FinalGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/GPARankList.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/ReportCardGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/ReportCardComments.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/FixGPA.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/EditReportCardGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/EditHistoryMarkingPeriods.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/HistoricalReportCardGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/Administration.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/AddAbsences.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/AttendanceData.php?list_by_day=true','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/Percent.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/Percent.php?list_by_day=true','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/DailySummary.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/StudentSummary.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/TeacherCompletion.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/DuplicateAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/AttendanceCodes.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'attendance/FixDailyAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'eligibility/Student.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'eligibility/AddActivity.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'eligibility/StudentList.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'eligibility/TeacherCompletion.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'eligibility/Activities.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'eligibility/EntryTimes.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'tools/LogDetails.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'tools/DeleteLog.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'schoolsetup/SchoolCustomFields.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'tools/Rollover.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Upload.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Upload.php?modfunc=edit','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/SystemPreference.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'students/Student.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/HonorRoll.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/TeacherPrograms.php?include=grades/ProgressReports.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/User.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/HonorRollSetup.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'grades/AdminProgressReports.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/LedgerCard.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/Balance_Report.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/DailyTransactions.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/PaymentHistory.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/Fee.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/StudentPayments.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/MassAssignFees.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/MassAssignPayments.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/SetUp.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/SetUp_FeeType.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'Billing/SetUp_PayPal.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Staff.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Staff.php&staff_id=new','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Exceptions_staff.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/StaffFields.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Staff.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Staff.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Staff.php&category_id=3','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Staff.php&category_id=4','Y','Y','2015-07-28 09:56:33',NULL),(1,'messaging/Inbox.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'messaging/Compose.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'messaging/SentMail.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'messaging/Trash.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'messaging/Group.php','Y','Y','2015-07-28 09:56:33',NULL),(4,'messaging/Inbox.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'messaging/Compose.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'messaging/SentMail.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'messaging/Trash.php','Y',NULL,'2015-07-28 09:56:33',NULL),(4,'messaging/Group.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'messaging/Inbox.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'messaging/Compose.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'messaging/SentMail.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'messaging/Trash.php','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'messaging/Group.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'messaging/Inbox.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'messaging/Compose.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'messaging/SentMail.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'messaging/Trash.php','Y',NULL,'2015-07-28 09:56:33',NULL),(3,'messaging/Group.php','Y',NULL,'2015-07-28 09:56:33',NULL),(0,'students/Student.php&category_id=6','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php&category_id=7','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/User.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/PortalNotes.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/Schools.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/Schools.php?new_school=true','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/CopySchool.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/MarkingPeriods.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/Calendar.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/Periods.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/GradeLevels.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/Rollover.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/Courses.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/CourseCatalog.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/PrintCatalog.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/PrintCatalogGradeLevel.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/PrintAllCourses.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/UploadLogo.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/TeacherReassignment.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php&include=GeneralInfoInc&student_id=new','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/AssignOtherInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/AddUsers.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/AdvancedReport.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/AddDrop.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Letters.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/MailingLabels.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/StudentLabels.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/PrintStudentInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/PrintStudentContactInfo.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/GoalReport.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/StudentFields.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/AddressFields.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/PeopleFields.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/EnrollmentCodes.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Upload.php?modfunc=edit','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Upload.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php&category_id=3','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php&category_id=4','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/StudentReenroll.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/EnrollmentReport.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/User.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/User.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/User.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/User.php&staff_id=new','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/AddStudents.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Preferences.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Profiles.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Exceptions.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/UserFields.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=grades/InputFinalGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=grades/Grades.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=attendance/TakeAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=attendance/Missing_Attendance.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=eligibility/EnterEligibility.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/UploadUserPhoto.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/UploadUserPhoto.php?modfunc=edit','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/UserAdvancedReport.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/UserAdvancedReportStaff.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/Schedule.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/Requests.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/MassSchedule.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/MassRequests.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/MassDrops.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/ScheduleReport.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/RequestsReport.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/UnfilledRequests.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/IncompleteSchedules.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/AddDrop.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/PrintSchedules.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/PrintRequests.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/PrintClassLists.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/PrintClassPictures.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/Courses.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/Scheduler.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'scheduling/ViewSchedule.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/ReportCards.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/CalcGPA.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/Transcripts.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/TeacherCompletion.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/GradeBreakdown.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/FinalGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/GPARankList.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/ReportCardGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/ReportCardComments.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/FixGPA.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/EditReportCardGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/EditHistoryMarkingPeriods.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/HistoricalReportCardGrades.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/Administration.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/AddAbsences.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/AttendanceData.php?list_by_day=true','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/Percent.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/Percent.php?list_by_day=true','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/DailySummary.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/StudentSummary.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/TeacherCompletion.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/DuplicateAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/AttendanceCodes.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'attendance/FixDailyAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'eligibility/Student.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'eligibility/AddActivity.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'eligibility/StudentList.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'eligibility/TeacherCompletion.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'eligibility/Activities.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'eligibility/EntryTimes.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'tools/LogDetails.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'tools/DeleteLog.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'tools/Backup.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'tools/Rollover.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Upload.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Upload.php?modfunc=edit','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/SystemPreference.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'students/Student.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/HonorRoll.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=grades/ProgressReports.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/User.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/HonorRollSetup.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/AdminProgressReports.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/LedgerCard.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/Balance_Report.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/DailyTransactions.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/PaymentHistory.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/Fee.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/StudentPayments.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/MassAssignFees.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/MassAssignPayments.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/SetUp.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/SetUp_FeeType.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'Billing/SetUp_PayPal.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Staff.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Staff.php&staff_id=new','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Exceptions_staff.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/StaffFields.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Staff.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Staff.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Staff.php&category_id=3','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Staff.php&category_id=4','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/SchoolCustomFields.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'messaging/Inbox.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'messaging/Compose.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'messaging/SentMail.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'messaging/Trash.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'messaging/Group.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/Rooms.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/school_specific_standards.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=grades/AdminProgressReports.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'tools/Reports.php?func=Basic','Y','Y','2015-07-28 09:56:33',NULL),(0,'tools/Reports.php?func=Ins_r','Y','Y','2015-07-28 09:56:33',NULL),(0,'tools/Reports.php?func=Ins_cf','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/us_common_standards.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'schoolsetup/EffortGradeLibrary.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'grades/EffortGradeSetup.php','Y','Y','2015-07-28 09:56:33',NULL),(4,'scheduling/PrintSchedules.php','Y',NULL,'2015-07-28 09:56:33',NULL),(0,'users/TeacherPrograms.php?include=attendance/MissingAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(0,'users/Staff.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(1,'schoolsetup/Rooms.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/TeacherPrograms.php?include=attendance/MissingAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(1,'users/Staff.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(5,'students/EnrollmentReport.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'users/TeacherPrograms.php?include=attendance/MissingAttendance.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'messaging/Inbox.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'messaging/Compose.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'messaging/SentMail.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'messaging/Trash.php','Y','Y','2015-07-28 09:56:33',NULL),(5,'messaging/Group.php','Y','Y','2015-07-28 09:56:33',NULL),(2,'users/Staff.php&category_id=1','Y','Y','2015-07-28 09:56:33',NULL),(2,'users/Staff.php&category_id=2','Y','Y','2015-07-28 09:56:33',NULL),(2,'users/Staff.php&category_id=3','Y',NULL,'2015-07-28 09:56:33',NULL),(2,'users/Staff.php&category_id=4','Y','Y','2015-07-28 09:56:33',NULL),(2,'users/Staff.php&category_id=5','Y','Y','2015-07-28 09:56:33',NULL),(4,'grades/ParentProgressReports.php','Y',NULL,'2015-07-28 09:56:33',NULL),(0,'schoolsetup/Sections.php','Y','Y','2017-07-25 16:23:00',NULL),(1,'schoolsetup/Sections.php','Y','Y','2017-07-25 16:23:25',NULL),(0,'tools/DataImport.php','Y','Y','2017-07-25 16:23:25',NULL),(1,'tools/DataImport.php','Y','Y','2017-07-25 16:23:25',NULL),(0,'tools/GenerateApi.php','Y','Y','2018-11-02 19:04:02',NULL),(1,'tools/GenerateApi.php','Y','Y','2019-08-04 17:03:56',NULL);
/*!40000 ALTER TABLE `profile_exceptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_config`
--

DROP TABLE IF EXISTS `program_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `program_config` (
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  KEY `program_config_ind1` (`program`,`school_id`,`syear`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_config`
--

LOCK TABLES `program_config` WRITE;
/*!40000 ALTER TABLE `program_config` DISABLE KEYS */;
INSERT INTO `program_config` VALUES (2015,NULL,'Currency','US Dollar (USD)','1','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','British Pound (GBP)','2','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Euro (EUR)','3','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Canadian Dollar (CAD)','4','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Australian Dollar (AUD)','5','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Brazilian Real (BRL)','6','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Chinese Yuan Renminbi (CNY)','7','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Danish Krone (DKK)','8','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Japanese Yen (JPY)','9','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Indian Rupee (INR)','10','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Indonesian Rupiah (IDR)','11','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Korean Won  (KRW)','12','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Malaysian Ringit (MYR)','13','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Mexican Peso (MXN)','14','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','New Zealand Dollar (NZD)','15','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Norwegian Krone  (NOK)','16','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Pakistan Rupee  (PKR)','17','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Philippino Peso (PHP)','18','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Saudi Riyal (SAR)','19','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Singapore Dollar (SGD)','20','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','South African Rand  (ZAR)','21','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Swedish Krona  (SEK)','22','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Swiss Franc  (CHF)','23','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Thai Bhat  (THB)','24','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','Turkish Lira  (TRY)','25','2015-07-28 09:56:33',NULL),(2015,NULL,'Currency','United Arab Emirates Dirham (AED)','26','2015-07-28 09:56:33',NULL),(2015,1,'MissingAttendance','LAST_UPDATE','2019-08-20','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','START_DAY','1','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','START_HOUR','8','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','START_MINUTE','00','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','START_M','AM','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','END_DAY','5','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','END_HOUR','16','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','END_MINUTE','00','2015-07-28 09:56:33',NULL),(2015,1,'eligibility','END_M','PM','2015-07-28 09:56:33',NULL),(2015,1,'UPDATENOTIFY','display','Y','2016-05-14 13:26:51',NULL),(2015,1,'UPDATENOTIFY','display_school','Y','2016-05-14 13:26:51',NULL),(2015,1,'SeatFill','LAST_UPDATE','2017-07-14','2015-07-28 09:56:33',NULL),(2016,1,'eligibility','START_DAY','1','2017-07-14 17:00:31',NULL),(2016,1,'eligibility','START_HOUR','8','2017-07-14 17:00:31',NULL),(2016,1,'eligibility','START_MINUTE','00','2017-07-14 17:00:31',NULL),(2016,1,'eligibility','START_M','AM','2017-07-14 17:00:31',NULL),(2016,1,'eligibility','END_DAY','5','2017-07-14 17:00:31',NULL),(2016,1,'eligibility','END_HOUR','16','2017-07-14 17:00:31',NULL),(2016,1,'eligibility','END_MINUTE','00','2017-07-14 17:00:31',NULL),(2016,1,'eligibility','END_M','PM','2017-07-14 17:00:31',NULL),(2017,1,'MissingAttendance','LAST_UPDATE','2019-08-20','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','START_DAY','1','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','START_HOUR','8','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','START_MINUTE','00','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','START_M','AM','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','END_DAY','5','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','END_HOUR','16','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','END_MINUTE','00','2018-01-22 03:48:02',NULL),(2017,1,'eligibility','END_M','PM','2018-01-22 03:48:02',NULL),(2017,1,'UPDATENOTIFY','display','Y','2018-01-22 03:48:02',NULL),(2017,1,'UPDATENOTIFY','display_school','Y','2018-01-22 03:48:02',NULL),(2017,1,'SeatFill','LAST_UPDATE','2018-02-02','2018-01-22 03:48:02',NULL),(2019,1,'MissingAttendance','LAST_UPDATE','2019-08-20','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','START_DAY','1','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','START_HOUR','8','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','START_MINUTE','00','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','START_M','AM','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','END_DAY','5','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','END_HOUR','16','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','END_MINUTE','00','2019-08-04 11:45:17',NULL),(2019,1,'eligibility','END_M','PM','2019-08-04 11:45:17',NULL),(2019,1,'UPDATENOTIFY','display','Y','2019-08-04 11:45:17',NULL),(2019,1,'UPDATENOTIFY','display_school','Y','2019-08-04 11:45:17',NULL),(2019,1,'SeatFill','LAST_UPDATE','2019-08-20','2019-08-04 11:45:17',NULL),(2019,1,'MissingAttendance','LAST_UPDATE','2019-07-15','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','START_DAY','1','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','START_HOUR','8','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','START_MINUTE','00','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','START_M','AM','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','END_DAY','5','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','END_HOUR','16','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','END_MINUTE','00','2019-10-06 16:55:03',NULL),(2019,1,'eligibility','END_M','PM','2019-10-06 16:55:03',NULL),(2019,1,'UPDATENOTIFY','display','Y','2019-10-06 16:55:03',NULL),(2019,1,'UPDATENOTIFY','display_school','Y','2019-10-06 16:55:03',NULL),(2019,1,'SeatFill','LAST_UPDATE','2019-10-06','2019-10-06 16:55:03',NULL);
/*!40000 ALTER TABLE `program_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_user_config`
--

DROP TABLE IF EXISTS `program_user_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `program_user_config` (
  `user_id` decimal(10,0) NOT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `value` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  KEY `program_user_config_ind1` (`user_id`,`program`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_user_config`
--

LOCK TABLES `program_user_config` WRITE;
/*!40000 ALTER TABLE `program_user_config` DISABLE KEYS */;
INSERT INTO `program_user_config` VALUES (1,NULL,'Preferences','THEME','blue','2015-07-28 04:26:33',NULL),(1,NULL,'Preferences','MONTH','M','2015-07-28 04:26:33',NULL),(1,NULL,'Preferences','DAY','j','2015-07-28 04:26:33',NULL),(1,NULL,'Preferences','YEAR','Y','2015-07-28 04:26:33',NULL),(1,NULL,'Preferences','HIDDEN','Y','2015-07-28 04:26:33',NULL),(1,NULL,'Preferences','CURRENCY','1','2015-07-28 04:26:33',NULL),(1,NULL,'Preferences','HIDE_ALERTS','N','2015-07-28 04:26:33',NULL);
/*!40000 ALTER TABLE `program_user_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_card_comments`
--

DROP TABLE IF EXISTS `report_card_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_card_comments` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `course_id` decimal(10,0) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_card_comments_ind1` (`syear`,`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_card_comments`
--

LOCK TABLES `report_card_comments` WRITE;
/*!40000 ALTER TABLE `report_card_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_card_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_card_grade_scales`
--

DROP TABLE IF EXISTS `report_card_grade_scales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_card_grade_scales` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) NOT NULL,
  `title` varchar(25) DEFAULT NULL,
  `comment` varchar(100) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `gp_scale` decimal(10,3) DEFAULT NULL,
  `gpa_cal` enum('Y','N') NOT NULL DEFAULT 'Y',
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_card_grade_scales`
--

LOCK TABLES `report_card_grade_scales` WRITE;
/*!40000 ALTER TABLE `report_card_grade_scales` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_card_grade_scales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `report_card_grades`
--

DROP TABLE IF EXISTS `report_card_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `report_card_grades` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(15) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `gpa_value` decimal(4,2) DEFAULT NULL,
  `break_off` decimal(10,0) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `grade_scale_id` decimal(10,0) DEFAULT NULL,
  `unweighted_gp` decimal(4,2) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `report_card_grades_ind1` (`syear`,`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `report_card_grades`
--

LOCK TABLES `report_card_grades` WRITE;
/*!40000 ALTER TABLE `report_card_grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_card_grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL AUTO_INCREMENT,
  `school_id` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `capacity` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `student_id` decimal(10,0) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `modified_date` date DEFAULT NULL,
  `modified_by` varchar(255) DEFAULT NULL,
  `course_id` decimal(10,0) NOT NULL,
  `course_weight` varchar(10) DEFAULT NULL,
  `course_period_id` decimal(10,0) NOT NULL,
  `mp` varchar(3) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `scheduler_lock` varchar(1) DEFAULT NULL,
  `dropped` varchar(1) DEFAULT 'N',
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_ind1` (`course_id`,`course_weight`) USING BTREE,
  KEY `schedule_ind2` (`course_period_id`) USING BTREE,
  KEY `schedule_ind3` (`student_id`,`marking_period_id`,`start_date`,`end_date`) USING BTREE,
  KEY `schedule_ind4` (`syear`,`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER ti_schdule
     AFTER INSERT ON schedule
     FOR EACH ROW
     BEGIN
         UPDATE course_periods SET filled_seats=filled_seats+1 WHERE course_period_id=NEW.course_period_id;
 	CALL ATTENDANCE_CALC(NEW.course_period_id);
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER tu_schedule
     AFTER UPDATE ON schedule
     FOR EACH ROW
 	CALL ATTENDANCE_CALC(NEW.course_period_id) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER td_schedule
     AFTER DELETE ON schedule
     FOR EACH ROW
     BEGIN
         UPDATE course_periods SET filled_seats=filled_seats-1 WHERE course_period_id=OLD.course_period_id AND OLD.dropped='N';
 	CALL ATTENDANCE_CALC(OLD.course_period_id);
 END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `schedule_requests`
--

DROP TABLE IF EXISTS `schedule_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule_requests` (
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `request_id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) DEFAULT NULL,
  `subject_id` decimal(10,0) DEFAULT NULL,
  `course_id` decimal(10,0) DEFAULT NULL,
  `course_weight` varchar(10) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `priority` decimal(10,0) DEFAULT NULL,
  `with_teacher_id` decimal(10,0) DEFAULT NULL,
  `not_teacher_id` decimal(10,0) DEFAULT NULL,
  `with_period_id` decimal(10,0) DEFAULT NULL,
  `not_period_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `schedule_requests_ind1` (`student_id`,`course_id`,`course_weight`,`syear`,`school_id`) USING BTREE,
  KEY `schedule_requests_ind2` (`syear`,`school_id`) USING BTREE,
  KEY `schedule_requests_ind3` (`course_id`,`course_weight`,`syear`,`school_id`) USING BTREE,
  KEY `schedule_requests_ind4` (`with_teacher_id`) USING BTREE,
  KEY `schedule_requests_ind5` (`not_teacher_id`) USING BTREE,
  KEY `schedule_requests_ind6` (`with_period_id`) USING BTREE,
  KEY `schedule_requests_ind7` (`not_period_id`) USING BTREE,
  KEY `schedule_requests_ind8` (`request_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule_requests`
--

LOCK TABLES `schedule_requests` WRITE;
/*!40000 ALTER TABLE `schedule_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_calendars`
--

DROP TABLE IF EXISTS `school_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_calendars` (
  `school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `calendar_id` int(8) NOT NULL AUTO_INCREMENT,
  `default_calendar` varchar(1) DEFAULT NULL,
  `days` varchar(7) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`calendar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_calendars`
--

LOCK TABLES `school_calendars` WRITE;
/*!40000 ALTER TABLE `school_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_custom_fields`
--

DROP TABLE IF EXISTS `school_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_custom_fields` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `school_id` int(11) NOT NULL,
  `type` varchar(10) DEFAULT NULL,
  `search` varchar(1) DEFAULT NULL,
  `title` varchar(30) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` varchar(10000) DEFAULT NULL,
  `category_id` decimal(10,0) DEFAULT NULL,
  `system_field` char(1) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` varchar(255) DEFAULT NULL,
  `hide` varchar(1) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_custom_fields`
--

LOCK TABLES `school_custom_fields` WRITE;
/*!40000 ALTER TABLE `school_custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_gradelevel_sections`
--

DROP TABLE IF EXISTS `school_gradelevel_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_gradelevel_sections` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `school_id` decimal(10,0) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `school_gradelevels_ind1` (`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_gradelevel_sections`
--

LOCK TABLES `school_gradelevel_sections` WRITE;
/*!40000 ALTER TABLE `school_gradelevel_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_gradelevel_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_gradelevels`
--

DROP TABLE IF EXISTS `school_gradelevels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_gradelevels` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `school_id` decimal(10,0) DEFAULT NULL,
  `short_name` varchar(5) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `next_grade_id` decimal(10,0) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `school_gradelevels_ind1` (`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_gradelevels`
--

LOCK TABLES `school_gradelevels` WRITE;
/*!40000 ALTER TABLE `school_gradelevels` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_gradelevels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_periods`
--

DROP TABLE IF EXISTS `school_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_periods` (
  `period_id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `length` decimal(10,0) DEFAULT NULL,
  `block` varchar(10) DEFAULT NULL,
  `ignore_scheduling` varchar(10) DEFAULT NULL,
  `attendance` varchar(1) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`period_id`),
  KEY `school_periods_ind1` (`period_id`,`syear`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_periods`
--

LOCK TABLES `school_periods` WRITE;
/*!40000 ALTER TABLE `school_periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_periods` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER tu_periods
     AFTER UPDATE ON school_periods
     FOR EACH ROW
         UPDATE course_period_var SET start_time=NEW.start_time,end_time=NEW.end_time WHERE period_id=NEW.period_id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `school_progress_periods`
--

DROP TABLE IF EXISTS `school_progress_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_progress_periods` (
  `marking_period_id` int(11) NOT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `quarter_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `post_start_date` date DEFAULT NULL,
  `post_end_date` date DEFAULT NULL,
  `does_grades` varchar(1) DEFAULT NULL,
  `does_exam` varchar(1) DEFAULT NULL,
  `does_comments` varchar(1) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`marking_period_id`),
  KEY `school_progress_periods_ind1` (`quarter_id`) USING BTREE,
  KEY `school_progress_periods_ind2` (`syear`,`school_id`,`start_date`,`end_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_progress_periods`
--

LOCK TABLES `school_progress_periods` WRITE;
/*!40000 ALTER TABLE `school_progress_periods` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_progress_periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_quarters`
--

DROP TABLE IF EXISTS `school_quarters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_quarters` (
  `marking_period_id` int(11) NOT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `semester_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `post_start_date` date DEFAULT NULL,
  `post_end_date` date DEFAULT NULL,
  `does_grades` varchar(1) DEFAULT NULL,
  `does_exam` varchar(1) DEFAULT NULL,
  `does_comments` varchar(1) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`marking_period_id`),
  KEY `school_quarters_ind1` (`semester_id`) USING BTREE,
  KEY `school_quarters_ind2` (`syear`,`school_id`,`start_date`,`end_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_quarters`
--

LOCK TABLES `school_quarters` WRITE;
/*!40000 ALTER TABLE `school_quarters` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_quarters` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER tu_school_quarters
     AFTER UPDATE ON school_quarters
     FOR EACH ROW
         UPDATE course_periods SET begin_date=NEW.start_date,end_date=NEW.end_date WHERE marking_period_id=NEW.marking_period_id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `school_semesters`
--

DROP TABLE IF EXISTS `school_semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_semesters` (
  `marking_period_id` int(11) NOT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `year_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `post_start_date` date DEFAULT NULL,
  `post_end_date` date DEFAULT NULL,
  `does_grades` varchar(1) DEFAULT NULL,
  `does_exam` varchar(1) DEFAULT NULL,
  `does_comments` varchar(1) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`marking_period_id`),
  KEY `school_semesters_ind1` (`year_id`) USING BTREE,
  KEY `school_semesters_ind2` (`syear`,`school_id`,`start_date`,`end_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_semesters`
--

LOCK TABLES `school_semesters` WRITE;
/*!40000 ALTER TABLE `school_semesters` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_semesters` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER tu_school_semesters
     AFTER UPDATE ON school_semesters
     FOR EACH ROW
         UPDATE course_periods SET begin_date=NEW.start_date,end_date=NEW.end_date WHERE marking_period_id=NEW.marking_period_id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `school_years`
--

DROP TABLE IF EXISTS `school_years`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `school_years` (
  `marking_period_id` int(11) NOT NULL,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `post_start_date` date DEFAULT NULL,
  `post_end_date` date DEFAULT NULL,
  `does_grades` varchar(1) DEFAULT NULL,
  `does_exam` varchar(1) DEFAULT NULL,
  `does_comments` varchar(1) DEFAULT NULL,
  `rollover_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`marking_period_id`),
  KEY `school_years_ind2` (`syear`,`school_id`,`start_date`,`end_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_years`
--

LOCK TABLES `school_years` WRITE;
/*!40000 ALTER TABLE `school_years` DISABLE KEYS */;
INSERT INTO `school_years` VALUES (1,2019,1,'Full Year','FY',1,'2019-07-15','2020-05-31',NULL,NULL,NULL,NULL,NULL,NULL,'2018-01-21 22:48:02',NULL);
/*!40000 ALTER TABLE `school_years` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER tu_school_years
     AFTER UPDATE ON school_years
     FOR EACH ROW
         UPDATE course_periods SET begin_date=NEW.start_date,end_date=NEW.end_date WHERE marking_period_id=NEW.marking_period_id */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `schools`
--

DROP TABLE IF EXISTS `schools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schools` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zipcode` varchar(255) DEFAULT NULL,
  `area_code` decimal(3,0) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `principal` varchar(100) DEFAULT NULL,
  `www_address` varchar(100) DEFAULT NULL,
  `e_mail` varchar(100) DEFAULT NULL,
  `reporting_gp_scale` decimal(10,3) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schools_ind1` (`syear`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schools`
--

LOCK TABLES `schools` WRITE;
/*!40000 ALTER TABLE `schools` DISABLE KEYS */;
INSERT INTO `schools` VALUES (1,2019,'GNDEC',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0000-00-00 00:00:00',NULL);
/*!40000 ALTER TABLE `schools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff` (
  `staff_id` int(8) NOT NULL AUTO_INCREMENT,
  `current_school_id` decimal(10,0) DEFAULT NULL,
  `title` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `first_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `last_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `middle_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `phone` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `profile` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `homeroom` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  `profile_id` decimal(10,0) DEFAULT NULL,
  `primary_language_id` int(8) DEFAULT NULL,
  `gender` varchar(8) CHARACTER SET utf8 DEFAULT NULL,
  `ethnicity_id` int(8) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `alternate_id` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `name_suffix` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `second_language_id` int(8) DEFAULT NULL,
  `third_language_id` int(8) DEFAULT NULL,
  `is_disable` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `physical_disability` varchar(1) CHARACTER SET utf8 DEFAULT NULL,
  `disability_desc` varchar(225) COLLATE utf8_unicode_ci DEFAULT NULL,
  `img_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `img_content` longblob DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`staff_id`),
  KEY `staff_ind2` (`last_name`,`first_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,1,NULL,'sudo','su','',NULL,'joe@pshs.edu','admin',NULL,0,1,'Male',1,NULL,NULL,NULL,5,NULL,'N','N',NULL,'admin.jpg','‰PNG\r\n\Z\n\0\0\0\rIHDR\0\0,\0\0,\0\0\0y}Žu\0\0 \0IDATx^|½g“¬ÙuyÒgy{mt“E*$…4d„>J1óÏ91!K Q \\»kË›ôfâYû¬Ì}_xªÊ|Íq{µíiýÏoþi½Z­J«Õ*ü[¯×›ŸüÞï÷Ël6+½^¯ø:®å»õz¥kó}ÝnW×­V|ÏâÑv)ƒn¯ìïí•Á` {Û¼¯ïl·Ûj¿çö,–ër{{[‹E|Þi—ùrQZí¶þæ¾N§£ß£MñŸç¾ÐúÀs–Ëåæ}~góg´;ÚÃOþs»ü^¿+_›Û’Ç”ßi“ÆªÝRÊ2Æ½Ù÷N«]¹u‰w»n7×»¿›gÖ±Îmñ¼´[­²\\,5Nz^ó<Vº¯t6ýõ½Ëü7ÏÙÎmíKZ´‰¶²xcÎgyNšëm»¦òºùtMn[ƒŸÕ\\‹›þ×µÀüÏçmòXù¾§ÖßÑ¾óÜæëù¹h~Ççîo³}\\Ÿ× ×°Ÿ;ŸÏ5¾´×sÄ=ù½žƒ¼&ÝŽæÚÏòÀ5~®×ÛçñtŸòÚÌcëwZ6ò:òZö³›òåÉ¿gy÷œ¸¿¬!ð‡ZOÿí¹öb¢¤Í$„ÐgaÍ â‡”°*«åZ·í¸hYzÝNÙé÷ËÞîn\0àƒHVáÉ“êx­[åææ¦0‰îØt1ß,ƒI\0m\r\0ìöºeYA¬9!Œ¼ ²æÅìç{L,\\Ÿ\'Ñ“–®ys0Ææ¼Èü¼Ü¾ü^¿‡¿·‘…È?>Ë‹»ÅHÏÚ5<—^l,jw;€¡½áó¢i‚%³hš€™7·…1t;sòï<Çc7ƒq¼KèýÉ¿ M@ð¹kÚÎûòõ^®ýˆcSÈ æ~ç›¶¹Ï¶æzknªžƒüœ»xŸŸC{iÓnþvßòxåçm6¥*·\Z¶º{¬\rØÃ&àpKÐóåþf°ä{ËÄS@”Ç9¯s¯©<¹\\ëy¢Ïy\\[ÿýç\0–wÌ-»Bø{½îF°üÀ¼«©Ãí`Þà[âMÛ…Ïs¸¢Ûm—a¯_v†C±¶lc½ú#†•…[·\\—»»;¡¬;öóÉˆß†u­c\'ËÀ’w-¬:™„Z\nók­Vì¬0\Z–²]ä¯è3wÄ3âG€;ÔGW¡ñÐ®ÚjëÂºÔ;œµ‘\ZOp^ÔM÷Fãgç~fÐoÓ¸åjLjg§²4‰I´»S¶,ÒóÙ_A/òI =_^Èy×µY¸µÉT4ÃØ\n_)°ÄÕz]–K·,	`®š;æ\"\0Ø¿ë]°$±øö†mfà5¸	¸’[\r‚{˜¯-0oµ‚xÑv>Y?\\Ÿ×g<3Ö+‡ï·`È¦aïÎê\rÐÛ¿$øþÎ`æ5ÐÜhÏ¿ÄÖÝ†ü.oî(3Ëóe6çyÍíÎ¬ÒÀË÷yø¼éú9×Öûù7k-†º›l\'¼ª‰y×Èh+ÐÙ¨~<\'&Ä\r÷ÄO¨„»;;¬®n½–¼pÝI>›/VR	§Óéæ™K#&8RBXú¿Xl¥´aµv´ˆ×ì¬\0óv7õ\"ôâòwÛÝ	5‘¹1¨ÃP‚øÞ÷n £w[Ð5võ:5«\ný³ºª_ÇP6£ÌÌÈcïë×Œ€e9F€ª\0j¼ê{[UÎL#o y\'öœçEm³UÀ&S4ÓáùËüœ§Yf\\ËB6°Yð2dýÁÒ…¹^ÌÃ¤Àp\0‚Þ¸ø=àg;u©Ä|U™BÐØ|*Èç¦¹&=¼NcóZp¿6sñ¦FÇãèg\0¼<&~wVÙ2HLšìÈlŠñB€¼¶ÀŒü)póçô‹ïÝW¿7l³Æ#?ÃàÛúï¿øÅÚò@øïfãr7[Cð$E£Â¦ä—ñË6¬áp(v¥¨BäöÀz,W¥\\__°ü/SuÞÇVE=qf•¸³É¶ŒÚ£½yWàú¦\0eV‘ßýÌ»*Ïk\n¬Ÿ9[.>¹M¿’Í\nõzz±P¼Ëäyªdp36…Ü8a0h`0ªÜç&àaÞ™Ï;³ÇÚãÒ’¼®²@åõåEì5äöo;Úë‹1E\0\0.÷ÁBhÆd‚•ç1³€äwzsl\n¶ß¿ØúK^#ê7¦ÈeØ°¼A<Õï,Ky³²º˜UÕ<>~Ÿç¨)ì^g¹½3rk 6¹­m0?÷_êkfmž£f-_fhž«ÍÆ™ìË^cnKfáy3€jžÿç/Ã†eºkÁÍú¨É ’wö)7Èƒ×í\0ÛAa|øÀÂ†µ³³tÐªöO¨ýFÚ]1¬ÉdòÉnÔlg§_»bR}Þqš€•éo~ßSšw˜<ñˆ&Òx·,7 Ëí`»ËE°´L»¹Î†lÛÁ°z^Ü®¬Fx×Î»›ÇX‹¡Ú­ô;ì³²“9ƒFÞ |]^¬žK^s\\=–nos}epâ;œU˜÷HÖù„‘Ûí|jn>Ý`ë®™@É÷dðyj^—‹ØL<žš×W^“Ël\'ŠëC-{—æ†èwäg7+·#¯Ï§6«ŸÍ÷øÚ¼™ø3¯!ƒ“7ãÌð<þznû>éŸß-õ¾:føÝê`³\Z£ÿñÍ7¬LÙþHˆ Î¨ìÌ€[EJ¦™¿ÙÁ¡ÈÖë°ý„ âµk•þ 0¼ïí…ý\nÀ²½¡ÒJO¾Q¼´:åññ±ŒÇcuDƒWÍ,ÜŒæ’÷¾žð¼;x`6(y\0}]ž8ú@ë ûÙÍ×‹ÚBë…‘Yá\'à\nÕ¶J#¤ý2²†\nÛÁ®c°ÎÓ\'@Ð\n†é¾³0*7µ…{D¬BÝÁ°¸\Z«uY¶p”ÒÅ¡À&“Ì›å¡ÓnÔ«­\noñÎ*U´`lˆ+íð±€×b|š?áµo^¤ÚÏä…6hÇsYkÜ‡ýÊcÃ37ë%©\'¸3k1y¾ÿÔæÜ­°PÆ>kª|ïS–û³\Z&»ézë]Ím4™0Hx¾ó&’Át£ToxlSf4~nîS&¯­ü¾æœUoo¬f–…&#ËÄç“M;­³id]\0÷?~þ‹unp\rFiŸ‰Yƒþ]íÄBÌ\ZºàPÚRË¶\Zße#Ô¥×é”½Ý‚J(¡Ðe±»e=¹þ{±Z\n°`X›E)0Ü†5l¹Ç:}^|çþzÀø{wwW(ïÉý`Ö¥Ýq(ÇZj€+~:¬\"TÓü·9»ø;^€jD\0»á	Ò¤­Bã¾.¡$ØÄñ†wê=x•ÚëÒEûÕxGÔ;…±³ƒb¾°\'d{–äcU7 Ô¬V;<Ž|Q®Ó¦_KÍ5ó¾\\-u¿Ç›1ê÷‡ÚÌ\0‘VkžYž×c\\*H¶·žú\'ãyµŠ¡ØØW±±m×c¼k½Þ:N\0,õ´\ZáMÚÅ3ä©LÚó“=cïàž“¼Éäyß¨RÉ0œµ‰¦M¦¹Y¬ž\"³Hxfù—ÕloÒ°µüŒlÓò}~“ýç:ƒ¯³Q|³™T›’Lyƒõ:ófl€ô½Z¯u¿›ë1ÝdSJf~Y6òçfƒØ¶ù=«ìV¶g¸³$ƒ‰Õ½æNÕZ·K§‹—Ë²Ræò|u…GìÆ S§½*ƒ^¯ìïî	°„ÈìÀ•…L²`ª#­R6±´o>ÞyŠArûÍb2UÏ€ÕÜ-³a°¹lâÍì!”|+Xñ¬ð†6™XüÍØ¶`-\n‚w–Â‚UÿK»Lga³ÓîÝª1(5Hó…ãaµ(ƒ~e`ë–Ô»ðaÆ|à°^ŒÓ¸¨ð’­es	{V 3µ/TœÜ¢gzl¶Ÿs¡#î•C,jYxkW@¾aÔyŸ™Tf\rš£ÊÜ<†zfe]kÀ\\,}ë}óBf¼J9lÃëÈÂÖÔ\Z¼©d&dávÛ2SñïYÐ<G¯¹Ìv*ÝØáò&¹™_ƒ™ìaò‚ðzÓµìuº›È6&+,÷Ùñ‘oœ\r§Jƒ­ý¹¹YçþdPÊ*½Y—Ç9¿7žÇÈckf ÌòèwùZmÀöžþã/%£»éÛ†šUû†:[=*y’=hVW»¼î«tœÝ’Êßê±p»R†ýžqXÚ+Ã2r{³ŠÓîvÖ\0Ë2û²`s_¦¶ ¦úÕÜ•<¾ß´^Î€\nÍX,¿;/FGGO@¾Îcºiÿ:Ø\'`5[ÌËl>@^Ûcû–É°Pqåk’{Œ7jd¸ú{=Ü€UÄ¡	»×¥Ì—Ë2›/Ä~‹Dä„ª°è¥È·Âö‚éª-5ó2‹² ôð¬-‚¡ñ|\0	ÖÍË ¿	ñ M8R\"FD6˜¦J…ÎØªÏóºó<f›ŠŒ	±§ÕqÙ …ÐóÅÏv/â”2(ä\r$ƒSsN¼f²°4™ÂSkÀ}0KÊ€¶Þ\Zò’…yË\"·!¬kææ›&ýÌ¼ÞÈM€pÜR“å{|ó¸ÅXýqusœ2³òøšä˜í[†žbQM™ÈÏ÷ïŽ‘k>/ÞÏõ¿×Ù®³é%Ù•<0žè\rE-°TŒ°miâet;lGi·–eg0ø°dã¨ËñQÍIElÃÚ°<½skð„6‹kL…³pÍÅ^j„=×6mžüŒü¬\ZxL2å÷âÎ;‹\ZÝé–Ù4;éÛx:-ãÉXŽ….h±ZÉ.¤ Á^_mêÒíÀ[ÈŽÜëj7eŽ¤¶¡æDí0`N§s!}<\Z—Õ(¥ÛïF<ÜÎÎ–é–UW-TÂV°£²ãS?ÌôøU€‰fèd+	u,3ZˆwÆ:±0;²VÛÙ›¯5kñ:Èãœ7|ý$R¨FVq²Í\'lfÉYÉïÞ°âªBù»&˜5™—ç_Ÿ+.l¼˜B\"ž,2\0~TÚç0ixÍne!2GÌ\0› ˜ÁÖ-Zè²z–ÊmX‚ûe³DsŒèY^³Æ2ågšmXbu2ñ·AÎëÆsãwdfe5´õ?ÿfý§h³Ñ2³/Ä5WZÚ¡6Ô…v“P™\"^…Ýt]výXa<gñ;F&/V/tXB¡jKM!Ùt\"©g~†Â×x\03#ã;OÐS;n^¬Riê¿Ø#ÆjQm11.ÛðˆL›³ ñL±Î\Z?ö8Kå=<”åb^–°­éDÏÚÝÝ+ýáPv¥UµIuû=ÙÛ²Z½UwªóµÆ+Ñ¿ÉdZ&£QYÎf²F—írttXvvC=ììÈ&#b^`aün;À‘ôTôj_µaÂ¢Â„PncaEZ¼Õö×ZUµtãVø=ìyš³Å¼ŠN¨ÛMÂ\0à5éñÍ*·7\"/x³¯ïlGô•ÏÂ.`ÀNÛˆ;ò†–Y …l£™XË¨a2Ù«Ë}VÙ\"X\rVT3«ð[¥ÿYðù®Ýdq3kÌä¤ÊãþißCžsûó<l5˜h•çÁ²˜ÇÝ×æqNTYÌrÓœG­‰ÿõ¿XGŽU¤xlvÄ”Gç—x¢òÀbíö¶6Mœé¡ö,j€\'*á ×-;ƒ¡TÂ^\r¹w°dÞ‘òdX6º{g\0°@™Âs_ÓíŸ”Ÿ›\"ï l1qš†Obµ\\X%‘×ñ<Yñ6£ü®¼ƒ°9Œ¤”Ù4*ÓÉ´ŒïÊxôXf³I$Y¶»bWív¯´ûƒÊ¬PëÒŠÇÖüÇ?ƒ“¼«e?Ü	˜˜çñxR‹™6˜Œk88v{ý2ìDÎ¥XSG¿Ë˜àÈæê…†$Â\nÂSÕ¶°N7<ÇÒpå¹ïƒ`„1Nr	n»æ±ªQyÇ¦í¬¹Õú¼#?¥Fen²\n3\0_Ãýy³ó³Í~,`¾>³˜,ì–o`k2Úãµ›Ûâëš÷çö[.¬h +ã5x4U¸\0:b!üØlÄ}+äqˆ+ìÆ~¯Y‘AÞØ` òµ >÷\\¹/–½ÌøòÆägfkýü¿”\r+ÆS´,ø5 ³ŠÐƒ6,Ùîzíf•aíw´è´ƒ×ÀQ7x³mÔÅ¯\\G¤;a\rfw¨*¦Ç£¹l25ÿê“ŽÖÁÎlÑïË»£w?7ÿ½Y”ŠŒÇs¸eTa«‹q4ãÉm³ÇGi\'íØ\réÇ|:-Ëìg\\î®/ÊdôPfã‘˜G«Ó“\n9_¬ËT*_·ìíïkâ±]!øÝN¤9ŒÊ¸úšì\Z>0ŒJkÅ†TmgËH$ŸN\'e\np¶+6Ò¦†e_à\0Ø*­N·m$Ÿ4:í0ÌwÜÆx—;±¶¶ÉÕ5]½y[¶N\"ü6ž,í *R@²`Yù,çQæÏ=.^Ç^/ž/¢ÁÆóž1¾&Ã¶Û\\ºæ³ÜÖæÆåõ·a‹5##?Ó‚oðÌ?Ï$#÷\rñ³\\(2»Ù¬åjOÍ¬7t¿;Gó{çV?w{}¼;Ë_Ö†<ÙNl 3yò³õËÛP7 tFY	-l§U“Ž+Š†‹\Z;¨^T°aõå%D°ÄÁXÜU%t\'šƒŠ\'íþþ~³5)¬À£¾UÞI3ruóÌ Lo3h7ÇBêb%TÀ¢Í¶a\nsb“ª?˜Æ63ï¾<Ã*3*1H«Å¬LGåþöªÌ§#ýÍó ;{¬ñl^Ã½–ì´†\0;ê¶{e°ƒÚØ–gi¹Ân5+ww÷e1cûr6)»»;&3_Dz‹Þ½¢zÅª<><–ùœ]7Œó{‡eï`¿ìî^½2E•ì…*;.í¸fuÞj‹¥ííî	üæË™Xšb÷:]ÙÌ\"0?›Jx~°É–‰CA©Va`—M,&AÀh%(3\ZÏ§7PÏã q®qfž‹œŸ–A$›DüßoAòO¡¿Ï¹½¹ÉeP4CËÂ½¸OB:>µÑfÕ73¸¼é~\";	°ròF¬{×uSJUA<žM\0Êë\ZÛ)`æP”ð”§´¦T5%Ë–ñ$ÏO×&x¹Éÿù¿~¾jW+94Þ\rÛ€M\n!ðË6j›).r¨Òz3¬` 5‰t=/Ã~¿ìíK°ìJÿ4iøÓ’.4”Ý•;–mXíVxƒ´ŠíNŽ@óyÓŸÒ÷J˜küS“eå…€!:Pê‚Ä<[\"ÚºÕê–%ÌªN/bî“] L&·†C(œa×N\'“²˜MJkµ(ãÇÛ2?”vY–él^VëvÙ98*ýá^¹é_ÊÎÎ®ì]01X§Y×ÎÞ®ñ±bêîº\\•ÙtZ&ãqGR_OŽŽ*èà‘@`F#\0Üë÷J·?(ëV«ììî–£Ó3\"ö“ùl*v<ŸÏÊJê0êâªLF±Ä^»Wzý~!p£¿ÖS·[ö÷ÊÞáAéõúÁÄåªné]Œ\nJ„Yðû`Ð/ý.ö-6	r>·Þ,žGà(ãœUŒu„‰læ;UÐfU£®Y›Þ¨X\\\'#x-çS×¼™A/«8\ZÚo™ÉÆê,˜Jö¯z$a;OTmè„IÆŒÉÌ2ƒb¼Ó«3~>%øLn^Û™¡fÉ²4x»½ü³zgµ‰líg™°i³ñe`Êu¤>‘¯”Ëü0ˆ5ß|ó+Ýý@Ia5¢=tÝðbxR<‰f7¨¢Øõ\Z3,yÍl¸\\ÍeÃÚVKjDhŽÛ€?:b¯¥le«e¥1\\ª\r+ïh\0X <±ÙXhpÉ cF–\'-\0k®	év¬¹ê)aÃ\"©8Ôbì€ ïVC=£¼@w9+ÓI„2,æÓÒBÅë±«Éèžu«PèÆÁÑIé\rvKéôËh4-½n¿ô{½òpWn¯¯ËÍÍµæ¥?ll¡ž…\'0þÝ?<ˆ©NFãrt¸_k’­Ëªª²j×|*\0\0|×T(èÎ°*«V«œœ)Cáàà@ó`)Ô€–Gq!»ÏwdØ¼:‚ƒƒ²··_†»{2 ÄÎÜ.ýA/ØÞ²†^tº*EÄg¨òª-g¥#ûdGŒÏ$ê¬u\nªåZƒXÞ€¶ë6lj‰õ—¼UÙÌàŒP¿£lÁÈkï²—33½O eSÅãSpñ\ZeÍ²žj×ŠYsÈ×Ùžšµƒ×ep“œ*À¸2	Ax,ƒébŒ:wMù1pF‚m0§7_‰7ý˜‹xŠ±Ck£j>n£lÖêšòšUBË¬å\\›^B?ÌÀá#½²PÀ4Y-\"¿#.\'O8A»FXºÌÆ	`Y%Üx¢*\rvãŒþ½~½`¹ZCìÆÛjnK½Ì3ÊgÐòïyP¼Øƒ!†_»€º\"Ò?\n²U¢Ê®Vòø>öv¬€ á}ãª¨º€àG0-ñL«ö£‘<‚ÓÑHªär>“Jôøx/Õ¹¹»)ûG2ºžœ—él)u¯Ûé•á`§\\^|,÷7ÊÝÍ˜Úp\'J÷ð½ØÐr%¶³»·\'¦Âw#±(ØP<li6Ÿ	tì}´èz½6ÚŒzÊµR«vvÊáé‰@Ð\"$c1•µìb‹Ò%Úy4ÛZ­gBWºåèä¬œ¿xYº½A™Ìj{55ÒRÆ\0±-&	ûêeÐÅð°ŒÐ\0y¤ÃÈ¯xÅFÐ,\0»YŠúwÅŒ\0Îò`üO©dy{Ó4\0xy]jƒ®‚ž7ò¦êc°ñµfOù¹Ž¹ò\ZÎàñƒÊŸå÷ñyÞ?Ù´•EÀä6ÈÆ\\cèr{,Ç£¬2ûÞ|Öôž»”£(ªÜDÓoY#Áâ¡ò×b–®ÛÕ .\0ºN³SÝ›T¬‰nž0wÂ»Ëb½(G1\'=xU=aš(vŽ€åÀQí†G>QÀ/«¢¨„°+§æè»šXíÁ¨(Õg«’5wŒLI?ÙIÓVÈ5,T%ÌT7qØ­ðZEÍ*¾CÙpàqƒiº}	!Ïe°aKÙÜ\"â?¼ŠR/±5FŠwšLFx€\n9ù~ÃA¹¼º*ý²\\µÊÉé³²»$ÆÃXh£vs]®.?–‡;@k¬Åp|rVö³ù²LQß=Ý“Gá¾½‹\nê/i;5å…áˆ±.²ciÞ«àká¶as;åðð@j ‚§“PÂ2d:›	sú=™ÏËpw¿œ?QNÏžå‡ŽÇe±Z”õFlÐ5Ïcïðð0l_ë•Ì	ý~Ø\nUV%†4)âºÀÅ-@Y]Q*P²g5Ùˆ…Üsïu’ÆÂœíZ^6˜×¤m¤–®ÏLÆ×53-ÇÖcppœ_~NfZ\\GÕFZ¾®É`ˆ™Ì —9«šf—Mõ4¿‡y\rCÉ¶JŠç!3Æ¦,fì1›²zÙ|ŸlX,âl±÷.•‰©Ÿc7Œº, ;zJWáZ/Óï+r[;xöÊÞTBSjTV	]­Áv$®Íš/Àü·\'Í»O¦îy\"7;OÁÙ,^TARØ1ðäÔ:^!¬³rs»IqàÄIÁfˆ¼ÖÌabs1QŒÚÓÙH»<BŽ Þ^_‰- ªÑîùd\\övwÊÅÕ•ÔÂvwP:ÝAyñúóx9ÂÇòyÊÕÇåñîº<ÞÝ”å”B‡ŒyKûg/^—ã³µYö6ç\ZvŠTDJ÷,fSµ“\\O=×Âlñz}±,Ô0˜Ê|¾,ƒÝèg5p?kˆy’`¯eTÖ•éØ…e”Ó³ó²³»_fÓ™Úóøø àåYÞ$l·D=99”ÂîðŒö½Òïwß¥@XÛFßVÚ<ÃÃh&›Ó¶\Z‰€)™8<Ç™•gÛV0¾P5³Œdm„wåüDÖ¨ž¡¢ÛüÒ,´^»à,SÍÍÖ@™K&g‘Áñ˜c±i°6ˆè«šË›Ù˜Ûä~Ø+šÁŒg\\6ä¦^`®Ë²æû›ñ–~†Ÿãy‹ömã\rö<S*!Âe7¥ÉË4Õ¶+#¸:V–ÄçnT(^*ÀkGPl/Ý²;”!jÅ` ;D.àçNçŸz~U	-j|Í…µì6zÂó\"ôÂpÛ-|?#÷ Ál·‹]{ZT—À¦Eê\0è š‰æv¢zÄááQ„TÛb®•gm	C\Z	Ð`\"ð¶ñx$4ª¡ú<›—ÝAÆe<™–½£ã2-ÊñÙyéõ8hª …ðòÃÛr÷ñ}™OFe1ÇæÀbì—Þp¯÷\0®²¡’J½&È³ÓRûa°FUC(Ö›Œ–/¸—g“ÆCû±“uøIn¨ãÁª=\0À}«À]Š€iÿP÷b_»»¹.£G	ÞÄƒý}y$ïî¨ã¿,»{»eÐß)½îP¬óàh¿Š-F|\'éAíO¬ŸB4j¼XdqGpªI\0¶9“àéÒ0MuÅëXñfÕ@Üdm™¹Xv¼–3ƒÈ²ãïm~ØØhë;–¾Îë:³»\rXÔ\0ÐÌ¨¬©Ü²fap\0s\\“ËŒG!eNTóýv”LL|Îö¸ˆèC²^‹%*N/çÝÞÌæ Bu>¨—fc•Ðƒà‰0\nç˜“LM7¶/nA:lÜ5RZUJ÷ØßÝÑn­Å®²)›¸µOb6òD:ùØfç$ö«é*q”}eFù\rËK‡xÑñÝ“’ó©«WA“ŠèUWk‰ÂŸLÊû÷oeƒÂ^D\nÍáÑqwªOâ´Ì¥&MÅp|*¯¢Bq?9}JVž$±[e8Ô}£I99VP±K·WCEH±éI]šL§e>—ÉÃu¹ýð¾Ü\\~Ð|Àˆæ8žptûbDô{wg7RMTFEë\0P	­Þ1Ú+Ï]«È9£âÍh¹Î\0\0 \0IDAT¢ØÏzä%ö¥‰²×ô·ƒ“%jCh ÃÑO©vúˆŽ§ý¤èØF	c=;;“ŠxY‹62ö»{¥ÓékuzòâÕ‹òêÕËÒÅ;!{ù‘ÄƒEÉéÌ2”^ãÏbÙÇ¿¬–d–Ù‡×›7Ä’àuî²\'Ì¢²Le ñúÎà%m¢qX‡×p³­™]e6™ÕR@~WÖ\\²ÆävdÐ°¬ëÝµ’FÄ¨¦2D>0ó­w×ÿ\\&ZEÄÚ?u6Äò‹\nê‹ÜÆ•	ÊÖ&®ß)õ8,>0Ó°€»CY‡ôÂÎªXM%Ü$³nvžnœP#p(á–†a¡BõEO9¡RÒ\rN§Ôh ×+1\0„f£ªV£{s§1å¥}žüLC›“è¤n÷ËÓ4ÙÏÓ¤¯ÚŠ#â³96,éêä9>”wo,óéX»>—xövv÷Â…¿n•ëëK1\ZÕpRiæ‘àú»ÛÛ2Ã ¡Î-åå³3¥ÔÜFåôü¥\0a2[”n5Èã;<:ÜÞ\\—Åä±Ü^_”Çëë2®Õ-\0Ú°ÄvVÙÁ°?,}>[Å¡^ü”°Q½1UgˆDe…’,fÞqqqQæ³¹l`¬<~Ø-†, ’ M\ZÏ _:€kÝÂÐì‘¾Y}BØqÂ0¦¨tðÃ¡‚T—ÆF…xC(Âky~~Z^¿zUö÷\"2¿Ïœ|cõ¯ë%€Jå¿5×P¯ydÀ5×6kÁq„(ï,ÐG³ËŒ.3›0MÐ£©\\ëë³\næß­®‰¹$‚`PóºÏí·œ-¿O³ßïçÌ¸×r•Ûb™’l*sèÓxHãŠÁ7¦ÃiY>;!œ Ÿô×¥ˆÓ£ÀdTBBÞ%²~Úp?\\Ò^K]ŠúÖ¤êD·§E(×>ñI2ÈF=,¹Æ•î±=„‚Æ:Ïª‰î°<¶µ©¼sy²\r|^þœ¿Ý§&;3‚ov*`¬”ZYUöbC@»¿»-ß¿•ç\"l:ûÇb²ÕÌæåæÊ€5-ƒ~¾ñø8’z4z¸—\Z„áÞÂ|uuU^½x.a¾º½)G§ÏÊ`¸[.®n5F»uü¤~Ð±cp:y|(ÓñH 5äç³2\0<k½/@Óy‘ª\nÐád–ˆÃ›NÇ©¨9~óùTŸÑVÆð‡~(“\nˆáÉŠiá=Ü;:ÄU§llì’\nMèº°=Z‹9’ªYm¬@‘Ú6RÞïÓ’ åãñT`ˆ7Š¹999V>äñáaÙÝ\riÌ;Ž™íé?€0L¶\0e–eÀâÝ,×ÚªÂ’™I¶³äMÞê\\&`ùoƒÍ0>J/3	Ë’?Ë2‘UG~÷˜Ü·T	IƒXV-+\"+ÌMõäeæ—‰…ÇÍ æûâP5­¦×‚âª.™9úYþ‰\'~Ã|•öV3!¬\ZõŒÚ½4!_žl>€…A:Êé,ºÊ½5Ù*è°”Ñ•P«®hdfwÞ!`X‡Jƒ¹„yáä‰ÎÀäÏý|‡)¸¯™qePV|võ8êy5–%…â…RÈ¥.ÝßÞ”«‹e>#°s¦”–ƒÃã²wp\\vv$ìw·:tc1+Öª×iÉ»(Áî†7í{ÿþ½€~>”Ó“cÙÅŽOŸ	G³r}s#{ŽÆ{ooG†ùÇÑ¨ìîËãÝ½\0rtwUæ“Ç2y¸ØRxT&Á\rÛýà3ÂDÔ×¶¹¼x¥..9¡†ÎU¹¿¹.——cæRU%º]õ{¸ONª9`&\0´ÈQlŒê°>Æ»°Í1OÄ‘Ñ†ÓÓÓˆÏê÷ËUZ\0‹WUXK«LfqŽ\0ë‘q8??+ÏÏ	nÝ	Nõ	©ˆá5ÆOÍ6U¶ýd[qÃ0ÓÙ‚ÞØ²@m„\'¹á½FóæþÉf[7oƒƒÄkÍ€âx=k$~®‰ïçïÌ°øÝµí}O–¥lù¤i¤Ô¼jM¦çöxcøD©cÍ³³m+Ë´ž]@ñ³³)Æc\'°®¹ÈžÛ˜[¿øæWª8jÐtñ{T¥ónHÞ)dt¯u‘<ùzI-4¦<TÂ(àg•Qñþnx`ŒÈMäg‰º¦»ï8,¼?ç9V½xwÈmó@çÝÅ‹N@XU?	^ÞU‡öª`¯âª\0´Ù‡»»\nX£2Ÿe>8>-‡§¥ßß)c¼fÔ£¢„È‚ˆ;åõq?@s99=-¤ËàA¤Ýxî.>¼—Wììì™BŽNž4hâ°7þ{x¸+Óù¨œž>S’46¤ƒƒýòáíÛrýáÇ²ß•ÑíµT¥µª$ ò\0X¥t[}µ¬ˆÜ\0€ëá›jªŒg4ËNDüØèþA*bÔØê+Ð[ÆÑñiÂ–`Õ5×0À/ÎØƒy^Êv ¨TÈE€ô|.ö\rFþB¨H2°«š)*u»ŠÂ5,À8NŽOËÙù™Ò‰\0$•].-­9•?ªõÅð^êt DBŽ’È–`Ü™×‚×MSxŸb]Y€\rB™é°6ë8%›¥äÓÏËë›ë¼¦­â¹ÝÕì@³ñ)–$\0ªL(^–oLJqr²\'•6«­ÕÌà>4ûÂ½1‡±Ù˜Eú~©5\ZkhŸ\036,ƒD¦³yw‘;±qò±;h&’™ž\'ZI¶\\C+†v£“t\r*~—©¤Û¡g—8—7¨™aå]//2ž¯‚xUEÍÀäE³é3ñ<vƒ×Èi¥~Ô`X jF‚0Ñî(ˆæÝxØˆ¥\",a>Ÿ”ÕoÛ\\ñRG\'çb[\n%h¯¥ª-ýj>ž(½æqô [×ñéiîÈ˜\r¡Þ}xó}?Ü”ƒã“rzþ¢œ=YzÃ}æd<ØÝÞ\\–ÇûË2ÜÙ+§Ï_–ýý#¶ïnoÊôñ®LnÊböX¦£±* ^>þ“Ã“LP²ˆAQ˜y¡‘ß©R1©Ü³};jKÄë9/“Ç¨³z+û^Àý½Ò‘‘ pŠb„d5“nÕŠ8\r°¥µ{ºvKŸ´y€1,êŸ‚I—«2\0K0éRÉÚÚ{0»RÁÏÎÎCEê„0òlr.µócìïS*\'ª®ªúƒÒÄ—yT_­Åar™9mBT#[\\±ÛÈÿË\0—e¨¹aZ08x-{}úz¯á&C¢mn_–ÛŒ8õ\'y-£f+ÙËžß»yž€}ž”q\"÷g{ïÖ«Ç&\"› 6]©™Ûôž°oÆ¹l~Î•Uà3E#Ó¦¢µ„\r+×èÉõ%õgT¬avVQ¿)vm¡*æšW‡­b“úSi¸\'+–\'[EîÆc	èÆ(WmX\\ïIà»lÌÛÜ_mWíó\"€!FŸ\\e!JÅ`°ŽŒÅI5þë¾ÔÔ®\Z—ŒÑóIYL”LÝñéy¥åFÁ›8Ë’J²X•ûë«òîÝÛBàîÁaùìË¯ËÎÎ„í»?ü¾Œ¯>–»ëåa2*\'çÏËñÙ‹òÅW?ËâÝëWËi¹xÿ}¹¾¹@¡Ná}ë—Õl\\þð›_—Õb\";–Þ-o\'¡[,,ì€ÑG±Èj£SY˜ª\"û1Ú÷”È½‚ËR›ÌÆRaÙ€èÏ»wï$üœˆ„÷Ã9é=;Š°‡N+£j—u4—Èac¨#;l€*MÁÁ(5ª\Zô“1ÞÔ–”ÂbúQ™Âµá¹žØ3«NQÿÝîFåz@ywoXv†$ƒÇ¹”òXãÑŠZ8ò\\.”ZÉ5¯%1<×ãÏœöÒ0Êç\r=ƒR“uXFš¤!3¯ë&Ór?›,ÎkÖÏl‚^l2n6ïÆ\'Oh³þ»i¿ÊíÈý|Šaù=>ó 31Á€•mSùár§>a6Õ@™/…Ò{ÀEÃb¡åJ— <‰ÍÁ$ˆPv ‡‡MP#*až$/wÎT2®w$_»ùI¾TÒØÙ…ò:	&ì=±9´´ûcGt½mŒ¸“Ñc¹½¼Ôâ/«™ØÂóìù+¹ûIggÁ¾Eª\n¡\\JìÔûß”Û»»rzþ¼¼xýE9{þJŒg<~,ï¿ý}y¼¹(oÞ¿‘êôüÕgå³/ÿ¬ìœ•EÍ”§¦ûlt[®¯oÊx¾,‡‡§Rå¨óÞo¯Êãíu¹¹ú(&æÊ±¡\04;Æ)9öÛ’=´ÀQT2¬jUZKwÔ†{â÷ß¯¡::8j^Oü‰5°VÐ©Üª#¶\r\n¤Šj¯;g;ïÆ®Ùï\rdøõ¥¨xØ1Y€ÒÑÉqßZuB¶‘A™ŠY¯îÐ:É9âÆð\\¶¤bb÷:ÜßÛœB1G>”7RëF&`IÞEÆ…³ˆË\Z³z\n€ÌD¼©{­K^j0kfK™á±–½¾½öý¹Rh:%Ç›¿×}Ø.·ç.¸-™¥e–ŠWmÒVÿrŸ6öäjÿÊ¶;®30†¸nc–_ã‰ì6ØëdôÅ\'5êˆ.àgn\"`Ö/›czy=­„û§b†åAŸ‹¶`™a¹¡™{ ÖdüV<csús­Öà¶ºó¾\'ï0Þ¼Hš»y}ØŽ¢­®C%QÌ‡ì\0Ô°ß$k/dPÇkFÚÈlòPno¢zD¯_NNNK‹àÌÉ¸F\0­Ë˜ÚTëVYÍ&ºïÍ?–^oXÚƒòý·¥‹~Ð+£ë«òÛúße¸Ó)ï±gu{åôìe9ñy99{®L‚‡G¥£ÐÞt¾*£ñTã‹R÷æûïÊ||W–s¢ág²é(zýþ±ºÎQÙ£ŸR¡Tq\"Ø°sÌ”¿*e1*¤üSìM»¨t\rãŠÏxæ<ŸÿöwvKgØX°àM”z@\0­NÆÆûŒ•qã»ˆ+ÛS‰\ZØ\0³±UÔòÿ2ÒO#üƒ0]\"á0±2ÆµÚãœÊÅ=6`qéJ÷òí,ùÉØ…ÀàQ–¶°šÅá$	¾ÈH‡ƒæÍ63’¼æ²Ðd¾çU´^ÄšËàcvÂó|ÚL;ƒFf=™­øsƒTÏbvTì,ÓO‘ƒ¢=ÌÆßËs›Ž…&°ûd‰ÝWa^Âü †;ŸQ×7ºCêt5æ’¿Æ©”ùc`¶’$7,Sa®q.! µÑûWŸæ*y°³Š˜w£¬ø•0Øk)œ\ZßÂ=bXØ®Ö0„„—6F¾E¹»½.+èYÊdt§TãÜ»{;¸îÅ3åx$\"ég“2»»/ïß¾+eÝ)íánéíî•ŸüùŸ+Öêþò²üþÿüSÙÛë•Éã½Üû\'åðäE9{ùºì—ûû£‰ýBµzMÊÁáai¯—åÍ÷ß–õl¬tÇûëÒ®v:1£ªêÒÎù,ìŒx#a6q20ÁÄtú‘Âªík\r@FŒGÕcIšNk€hW&\nìGeT¥)UÇŠž[»Š\\ÆHxæ?®C%ÄNµ»³/@‘¹Bg R5Êdsíd¸´ƒô!Œõ¤\"Ù@ì{\0I¼™f :¥ÖÆç9l,ÜË3öô3B,´tB]°úo§ Æ¯Ñ¹:0;Ë¿AÆkQ,­‘×èÍ6³§ÌJž¾üþ¦ì4ÕÃL²fdYh~æû›v.ãA³ŸŒšïþh*àf´q$ƒn&!/ÖØ&Dã—¿ú§uD# ™ªf\nÛœH‹ ø–nša™ò³Gµ2ï1žîînèwÞ•2»²ìÉ,N»pdþD¤{sg°QßîÝ\\î‡lXö”­\":[Ìjsè@Ô9÷û8bÌ“ë˜ŒKK;ÿ¸,f£2§Ôñ˜x¦qÙ?Ø¯‡3¬%Ü‚Â–³‚©wþøXî¯®U¯ý‡7Kgo§|öåò\Zb ~÷ýwe<º-Ã^KÏ½¼¸-á~9}ö¢¼þÉ×eR\r©\'¤Ç<>Ž%þâÙyÙöË?ýâ•w?þPú¤ÛÍ£]´jŒò3©Ó¾&–„ì¨]¬™5€M{JzÌðØÞßßJÀ½V\0\rÀdãî£+ëààp“\'ÛÄ8‡¨2´+J1¥Ô wð&ìéôì¬÷vµqh“à$ XŸŠF\"¸æ¹FzÒ¢g¾çùüŒ´®XŸ£…\n©¥Kw§Éâ^ÙÙß+ÇÇGåìä0œë•ÃÜžßˆ^çmÒ“pyŒf$ÍõšÍ-^—Ðt(,ãÚ$¾63¤§ä&Š¾ßkØ@àöÐ†Ìª¬e˜È¼eÕ3üÝ¾P–93ÅŽÙ±×´[ù]ê“+ŽfÊ—ðO!èFs°h£Ò`-¨ Àä\0ÎTÜ÷[å4…Í©É*!ì²_è\0lõ°ÐJË½`|¯uß¬Ó7w-÷kF&l+²åDPj´¯E»Ìª@mbeæÛúHØ4ˆ¿ê·Ûåáþ¶Œ?…w”jÄEáM£¾9lµ‰p zä\r.–etwW&ÓyùîÇ÷¥;„­Û.Ÿ¿þLÆßéè®Ü\\_è¤Œù·“²îôÊ‹×¯ªÓÎÎ¾B	Fc…6À¶./?èùØ°®/?Êc¸\r©(µFNrkÔùÃ=ù~mYT\"Ô8\njá©B(%sBµÃ±ps·&ÅLQ{K”°™Œ¥ÖÊ¶@eÁ*Xwê^¨gŠŒÚØV¼0yÖíí½€†	€ŸÄiìca?$Z€…ùë\n]/¼Z€$)>Q5T)ox\04!\04j©rÖ°]özr*àðö÷Êþ!y‹Ç5€1*ŸêŸ<ÈZÙa€¯›gz•ÃrÐ4ƒd!Î`ÁZ7€ågå\rÞ `ÁÏêZ~ï†<qNC¾7_f?›\rº²d³-3½L¸6ƒ7ËySÞ³Ö“Ï}ö¸ª}Ý}an¤_ê2=3ÍÝÎùYŸOÎb°b‡„]™½qw?ßëAÁHËAª‚VÕ²¬G›\ZovÄ\nf#^N¿O“XO\r–›\\^³–ÀÐ!Ì)½2©Åâx+˜;+†öeÙÊííu¹½º”GŽdoÅiµãYþ#·cþtB˜C)]T â¸îoe`~÷ñ²<ŒGòÖáÑÃÝŽàœž—7?~W³ewK§;,—×WeÕ\"Çn_†öç/_–£Óó2¡$²*ÌÄ¬Fw7½ÇÛ«Ò¯ÆBdß©‡Jp¤Æt±áVœ#) çÊ$$•7ÆðcÚÝ+»ûûªb\n³²×”MÅ•g±ÝÑgloÊ[­Uv‡ÐÔ¾ÃøÏ†{³ \0˜™âÑP{#‰–û	}&»U”\\;m O£ix.y>ŸqA¹²‘cQ(ÄL€%à´©îZK²\0ˆùPŽóg§åüÙy˜je^mvª„\Zñ\\ƒ×® É¦20Xöþ”€fpxê=Þè³)%³:Õ4«•M²™9¶Æ’Á™‹#<Ì–¯üÎÌÆš*0ím’’,ÇG>3\ZäE¤°añ‹Ùy^Ø·=U·	X4tEÑúŸåhqM.	ª•Ò³Xl&ÓÃ§\0KÔ°Ý3!¬öðÙlZ½w•ÕåÎå€W:l`ã\r-¦‚%!T­ËŠS¥•}.Pbä\rvÂ3øÞLBÙäË…•G£‡òáíy	gZ.¦e!÷ÿX@‹5•B	À|qvZ®¯.$4·9?ðêò²tËª÷öåéÂ¾h¢î\rä\'Ôž	%jZ¥ì•Ë÷üõkÏ\"¥åöšç¬ËÞÎNùá÷¿“C\0•Ï)10Ðeôø¨(y©IÝ8=Ie§u\0+BNPhK`É{8_ÊPMd¹wÌã“cÝË¡°\"!ÎÔ¯ažß)%˜uÀêÙHv\"¼Šô“ñÁó\'Á—až±Ÿkooo´iÍfÑéù™ìuÄ±iMÌæåþOòJ†{æXuÊ}Åf‘ ­\"ŠòG\n¬T\0Må‹êUÔ¦Üê«ÏÄ•žŸ¨¿ûû»ê ˜<@]p¡ÿÏkÐB—µƒYf>D½r^ÃÙ„áû²úiÙ±*ÖdqnGSi¾×s˜Ù–Ù®û°!ÉôÓdX¹È2óó;²ügRdBd V6IÕë`XŽnÏî{0¬WæW\'jXƒ\'dã¶¬nbŒbZB³‘Ôïô€d:èNéš¤nv“ššãŽú^þvö¼ÛïŸÛ]|[s]¬¬ÁØv¶X\n‹?Tv¡™<yNÚÃ\ná1#Š*è“”™yûãw²G÷¥ßm•ûÛ[	6¢à¦‡»ûòøpW†œ|£¢sm	AŽ÷wåæârSó\n/)ã°·s…+ð_\\|·|è\rvÊþÑ‘‚LIÃ‰ƒJåÃ»·eo¸+ð$\nŸºí7·7ú~ooÛ;Á©1™D¢3ìpNeÓnœGˆgÐƒƒ£å\r’ö‚Š‹DR\\Ö ØŒ!\nÛÚQÀP;/™\r›³	£\\/ã‹¶ìààHÕ±…wi.¶E²ù\r§(Mgå>Edü@9ýòðµîeÀ¯)A\0¿Ó^•šYEììw:íKöÅj£v0ïuÙ?:(GÇGåå«WÊY$½,vÿ¢<®a–ŸÁ‰µéµ—Õ¹¼îózÏà— É ²-ËÂï÷\Z2pZF²&Âg\nlN@3òûs»mÖ¦TÃ<ä=¯ñuöXú{ÛÃl—ô3M Ü.>ï’¯Ú0Îåe¸8ƒ—Ô„Ffµèï2ÈiuôT$?æ{Ñ(ì1²gÉ“–w#³ßå÷¹„öôÈ0\\ëÿ˜uñŒl@4í|Šn~2Áµä1ªb°¨9™–5»1L‰hýå*êRíÅÎAÝÁ„£v°ø?¼S~øîwb“xÛ„	Ì8ÁæNíÝÛß“Mf2®a\ZãGíØ€Q½œZ‹­]ïo•§Èb\0@TÙ`ï@5¹ƒ˜‰•…—•‰6ˆ¢ºµËáÁ¡Ú.Æ´^•›»k	yuu]fØ†C±«¨‘l\n:|\0âŸ/BÒþ ìQ€ª!;•ænU‚.85gñ	8QÝ’ö9Ì\0°êuØj1¡1);ÂlÝžeh·Wîîä50jc	O)ÌéüÙ3¥Cá`,	Ì„FêãñÉ©N#âÞ„$|þÖ¡ØþG›“™PXo¬Y¼ˆ¯?ÿ\"ÔQ‚XqPÇõ^ãÈ‰FQu@}ªÞlošËŒÍbÜ››wŒL²°gm(k~§¯5¡00eÆc™ÊD œeÌöÇ|/m·=tfMYôßfjM7š4é{r	sC³ {!e¤õ\"2ÛñË:î¬Q×tÚE<›‰wù¾³1[SêŒ˜{ÿñLéá°Ü‘L}Ý·çg¦ûç{ä¨ïštÉw¤ÎÌfÙ’PO&¨z5é8\\å3õ…÷qPD¯W®.ß—¾ý]Y“;ˆ±@ÑéD,áÜ?8P”õl<Ö³ˆ~ŒÝVBˆWš*Íí­™àÔ/œ½}U.Zµ¼Kœÿ(uFÎˆÄgˆk²áúÃÅG}>›LÅ(NNŽÊÛ7o¢Ürhç=ôÿèŸ\rÕžCÆ€xöü¹Ô2òE\0ÃÎnÔ¸Ú\rï¡fS.¡í&\rG‹]ê%Fï–Nü±\0c/sÄºcð¼V¸¦D_è›æ8/øœï1Ô¿ÿða3÷¬9þáYåPý½}1¯?~ºôt4$P˜ó!ÃŠ\Z«2:ƒ1­Ó³S=/Ê;kí°j˜W\ZT­îQãi¿Í²A<³¨\ZMÁ5ød ËŒ%C¾6ÞÔ¦ò›häë-ß#žk[•Ôã\Z@l–×lßç8«ÞV•*£æwçï?9H5“_às“Y“ÕC¼ÑÕ?ó=1¨Õú$ÒÝ cT¶KÜìb]#Ô2èÖX¹~µÖ–Û•mU\\ç¶6w\r/Pï4Ê±°Òé¶\0Øxô Â{\"’c9‡#\\Ø•Èå¯ÚãGRG£ûòÃ÷(-õ÷eÐi—Ù„\\ÃKíú\r‘â”Ù!šÝ‡Ã:Ü€\Zì¸ý±å Ø=<Ü‹]Q}ážStj±BHtâÌP«\"hØ[0`ßÜ†ðb ×ù‚ØÂ\0ŸÅL`ÅÜ\0DÔ^ç¾Û›<Mz\rý<?=+w÷wåmý¾w{ƒZ;+GGò¾íìž²£6 †…¡šò0ŒeºÞ;.Œò\0qWSê5õ²Z$A?r\n•D®\"`Z3$»7J…+kÙ°NON‚bx£¾ÄÒ˜\'@•ïînïT@PÃ%öl¹”íÖ¬ƒ=jý®\0[@*Jíà1Å³Ê;©qÏœÓþ—/_•×Ÿ¦÷Òæbîl”W¡Bª˜DñºP‡¶5çÌnšÀÓ4<e.ÉìË€•YS¢,ÃYM58eµ2›P²fä6<åi´œ?ÅlžL*Lv2C´ló>³2kqümö¹95\'w4£©;Ú<ÓÁ&Rç—dU\0Ç`™Rro¶-ù™\Z¸8°“ºó€‹l+U•1XåÁÍÔÙëÁðs4qJ^-Jvv^öl&8;<.z¥nÔÄ]´#©QßÎNÏdOUea9—ûëK©XDøwZ«r}}¥Ý\\€EúI«%Õ{Yœ05·º\nÄäL¾®Xm&Áúúê2r)u,}µ	aÝo£RR69Êà šñ»\0V\0øÂ@\rù	9¡æãÞË«±?|P­+Ô¤W¯^é\0ª¡Z¸;dÀ–EÞ ê–W#3Rx7ìŠ¤eBì><8ˆc¿ä)ìÊ€Ç‘qz Lž žÅz`«¼qQÖÆ‘èŠ­šGý ŒòÑá‘\nû¹*ªìpó¹úƒúKŸ#ø8®ç$\"ì]ôP‡†3(â«—VËIã àÞ{j˜f±‡sÀ˜©³ŒqYÎÏN\nHS-–è¼Â›’ñ¤YË¥\0\0 \0IDATÿ%&Ò%–µšMOi?¶/1¯J\"®÷åçeg ³Ü<ÅÌ|},¯‰æýYÞ-ÜoVåöä6˜\\dÉòŸAU¿£º¡¾Ðº*ŸK=©ƒ•w†lhËŸÁÁ\0¡ïk½rv4k«ÁÎ63£´U5Þê\\ä­±`6íK5‰šú½Ñ›û3‹3+ô®°Aôz\0, E¼‘£¢µk\'\njœ/8‹ÄZNA&ú:*„FaÁI9;9­ym­òøp_Æ÷J‹ùðî\r¡ñewÐSU$…Œ`p!Ô2vÃDõ‡ÅJjv)ŽãR*Èr¥‚|$Y’±\0Â«‰šÊ	<ZœEØšWôFƒW‘R9b5¤D‡_P5÷>%˜7)*”bÁöÃb7[¦}.ÃZ`ó\0ÙñF2öœ0ýöÝ[1H@	\0¼¼¼–GuškU¥c_£j^ë‘aN‹q¹gUpÀP¾)2Þ˜\0^j·oìN„=Ì8ðµôöV¬\n–yÌdÕÛ©¤yØÕ|^^¾|×Þ\\«úÆÎp¯ª(àèq¬Dmì~>AFªR4¸‹0	pæbÝÀ\00<Ê%ìË_~!;æhüXÎa »ƒÒ®¥±m1æl€Y~XY8Í|²°û3ƒJ¶eÈëÙkÞ2™YP^ûYó°¦Äü2V–ËhÞà³}Œù0>Ð¾LbheÛÄ‚¾6Á*ßã6qÝ&H¼V‹Ý\\ç\\B£³éŸÄ<xùçSL†Ïl<÷O\0+FAó äÏö«\0ÊX,¨…X±‘]l2‚û:OâS“–U%ßtÌvÄ\ZÉv3iŽe€%ø“õ(\"À9A0ÇŠÒÑeãŽ„hrÔ‰É]y¼½QU†>çèéäèð¦ôtàD@ÀÁ£Rw«ñ£úá!i7÷bGìò·w‘Ú#GÑÃdðÊÁ(-TÀŒˆîÞXl]2Ã`ªAžê¦xÀl°&4µ\'¢Èç›dS{uxŽmK¶Ýq­K)þ‰ð‚g·á \\_ß–cqb7¢XaM¤¥¦<ê™#ÔCjà•/^ÈîämP ìCª_=s}TŸÚ¿RXj^„†,ÃÖØéªr„Ô½ñ¤\\^^*ÔƒÏxÇ‹©/STÇ]1P6žv«£¶(„ƒú[ËˆÝb\rFÑO6‚b^(‚_ù‹e]>ÿâ‹Bhmƒñ’m€çXj/õÈR™f¯]oèdoÖO1,®µ&Ñ´{ý)+«œOmìþÌd¡i,ÏjdVß2a|>ÑXªÊ÷\Z |Õ;£–Û’¿·Ç?;âtÌ—¢Iã¬K\Z¼\0Oy3òîà—g;^B»™75ÝÅÃ¸ÏnÐ­zy|\0Ö†}5Ž\\ÊêjS/?3ïNÞEðR£Ö¡Ú}µN6;31X0»ßcÃ8h=Ž¦ÚQù÷þÝ;ÕßßÛ-{û‡ª‘Å9“ñ]ÙöË[’gã2P)–8”Â|xê\nN¨áå‡;»eF`*¹níÎ&FÕÒÁ¸åéÇýCØõdï™Åù‚ÞådH­‰\\><ŠDsË+§ïzb<0\Z?Ï‹¹ÍdÛ¡¦IõÚàç›‘3?d¸”àŠ	ú„šªŠÚCèµæ¼BïÂ²=–NyH‰¥“17NÜ98ª‹\rM Céí^x(ëµ“eìQ)švGÿñm[<›Ïlë#‡;8<(]ò™¤Âù<Á¨ö®P¹â;RÅg«uyñê¥\089Ê6bØo‡vQ©›D ƒBÚPÝüfgVé½–=_ž_gçR~>ìQ‡§\ZYlÌÎHnCRËšÁçm\"ÏÕ’NÊÎN.3²L,ü.Ëªû“UZ‹ÖŒG›Fë<\0-èO¡¯Q¸i`Ó=•aÙŽei\"f>1`8j7»Ô•š<›é¥&ïNž\\SÓ<x¼G‚IeÌ¥Î¦®»öR°+ò÷°ÝÆÐâÄá~¿œ?¥ˆõ¨´Ù•aþâ=ÕZåÅ‹Ïä-ºøð®\\_}ÐQ]Ó,íN»-\':ØÁó¸(ƒn¯<><–Î¬}Õ^[ÎŽì\"0(S<Ñ\0—üJñV°11yU[Å\\*SÒÂ€š£šU{ã[ |cZï\n©XŠ1á³êì]œ¿!Æ1€ô¢Tl‘š[J¶DäÍºY·avr0W.ë¬Ã6ÈÃ„¸IXQúÕàê5Æ³äá¥<\'¥Êv9¬û†åôÙyØ¿ºDÐï”ñ,*zðNò²©Õvv´:b0>6MÞÇóonnËííÂ1ÎNOUçŒ3¦©½¥“}T\"¼É\\?™Î ”Ÿ¹½ºVÌÙºÕ-Óå²¼úì31E4~R‰÷aß]eD4e&«oÖ\n6ë²qÔ—Â?›ªa¶=%[&ƒP–Õ|½Ÿ“UÆÍæRUµZY#ÊjèS@lBÂ=fXVÿ,›fó&E^×u’äçíÎ‹Æ»¢¢x’ˆ+i2+«Zn\\FBŒ ß‹ÅëX,³7£­Å×o\'¦Ô Æ0\0yká>OZÞ”>Rc´¼3ø{·ÿ# €§^)ÆI‚J‘;jMUv©årª$éÝýãrpx$ÛP[\'ÜLËåÇ²[íïC\\-ÊãÃ¨ †;žBŒÏa“š©ž trx¤Èøøqc9Á–¢Ló&Þ¥Ö9Bµ‘=•n¹ÒéÉ\r^>Ô,˜ÂÍ½†üCâ‚ p•¾ˆ>ŽŒÊ	hÂ³Âˆ¢úBW Ú‰U‹v–ŠÂgü`!Š •ªÄ)Ñ±ÇšÉÃÁnlP\\zÎ±PT:`SVêU”ÌÆ6¶Çù4Â/p„}Šx«XTÖýjµ’\nºx¤\"€õ#ô€ç\0îôðP¶¿LÝOjßë ÚzúÆû·oß¨/ÏÎŸ•ý£/åîìÉÃhÀBéVÝ­Õªìõ{Êb˜‘÷I}°þ@`©ê;C9YNŽJ;íçµÝ\\Ÿþ<oº;?½î}}V·š€d5óÊÏö³,ùÞ¬\ZÂÌLÞ×zƒÛ0®*{ncSÝÌŸ?E8xN„è£uûM:dt÷Ë=\0¾8ƒH“Æy\06”ÿ‰ê	y\0`XJ~­±L#ÿ²Ñ-«•HÔ\n\'?ot÷zHëk*úŸÕØæ„dcb8£ µa\n‡@Le@:Oaô°;û:Än…ãúò²ÜÞ\\Õìéá`±Þß\\•››KŒƒ·ŠÒ3<Ì	»ÆÉÑ¡Þüþý»2Å‰Éïèq\"A´iÔhòâÉDìUHµÝkØ‡ŠÕ97’÷Töw$Œï!¬PLhg(#6j#lQžÆ©7Õ;¦X,‡v§PÑæ!ø²ùÅ&æ#Ë\0IíŽ<¯zÙEñú`ÎïS©F!^B”*çÎ¶Ê+À¥8(ØCýò<ªüÔëfåsú“ÜÝ\']o_ÄªDU2w\rj·8¼/(Ñÿ¡ªs\nëº||ÿ¡\\]^•“óÅ›©¾X\'¼–Ê©¬ç-’¢ôp¯²3\nÅÀ9›—1YÄ¥Q«ÿø¨–ƒCê|E•ZM6úEà¯“³>-°gÆÉxF¸Å¶z«,ÜLÍ=Ë¬¯Ïà‘ßë{mƒÌDÄ€bFl¼Èfƒ¢ŸoeûTfef™ÔŒ3›>~óËÿ­ÔED7˜/³70‡4é^n°)­Õ1_kÀ´dWPYÚm¼»yÀ¸Æ*¡õ\\„´Ù‘Žy2°Ú¦–XQùÚ}YÛ	-ïáPÑûû;¤/êtxtRä¼\r÷$ˆÜøþÍ:Sïáö\nb¤„c<dóñ£À\n†…7OqP¨=Ø`º²3ä@Ù–Ô:â²p0 æ=>Œ\"üS¢8Fqëº]F#Ù¸0–ãÝ\"£¶?È)AŸªø@:KGBº½¼(H\0«\rPLª\\=­›“jˆRðÎ®@0³q•ïÆÓ±ŒÜRk­{\0…Ø5ÞáI\nPxïî•-@²4À…G‘vF<ê$q]QûŠ0Ø`‡rŒiN#ÅWE©æ(XÇ?ÛÕ˜o­©NO…	[@M;<>’Qøq<-T)EåShH=+\0–’˜cL\r³E¹¾º*—7—bgÓy_§‡ÚÎ\ZŽŸ¨;Ž,2„Ì¤æº†!\'ÏÎÊó—ÏÊó\Z±ÓêÐÐ8u3´\r‚~·9²±Â·G]e•Ñk=ƒ–×¹ã\Z·àáüm–’YZÖ’23[6ü—Ø\\S+Ê\ZZ–Ë&¹áožŸØDÅ\0•Ÿ­ñ\0°|£)3’LI3RçÎy°@ÚIjzÎ†­Âêxœ<¦»$·Ã×äÀQ	-UÇÏ»ÇT:ïü<qQI†‹„ç«ùB§Ò`°ærñ°}GÔ/­nW®múI^g\0>Ü•þ¨<½£ýýrùáYm-¥O$7^¾é´ÜÏ3è‰ô{‘t«´ŽvœŒá—àM[ùtà@¿)}¿QaþÜûQ«}%†î÷`#0à\nž+¾C­´mˆq@Ðlþò…ž¡Ï©â™?ÕÜsîî®À‘{ø›Æf¢Þ=l\0úÆ9‹\\ó}ÇµÇ\rF»¥C\'¶U¹Îb¬^RB/x÷3þ|O»öâ°ÛNDäs?lòüü¹Šöô—ÐW¾…½ã8A=„s$žá8d\Z¶.L÷9¶mO*)y‹òÔŒÚï…ú)Ía§zgåþ1ÚF›YSçÏŸ•×¯^”]<*\0¸=A9Ô¦¨†Ê\Zö:m²ž.YF,\'–c³&°yï0«É,Lþ‰ÒÉ’äÙÌL,ƒWós·Ë\0›AÊ„#6´XZ·õgV‘Ý—¼z/6,3é—e”Ë d`0›òË3ó²NëN\ZÀ€ùÔ”Ù”ÁÊ“ägòwó\nj\Z»‡ÛÚ¤ÊÞqÌ­n›‰$ýF‡m®6•RIW¡´;M)‹ruu#›¡Ï^<ßÂ“\'óŽ¨ñGÙ®žŸž–å|Zn®.ô»ªìBØœfsÒ·uü;Æ|¾ûáSfÍ_S€H¸&ÐT›~\'Õø,?iœv£EÆo<$CÆgÝ2‡§Õå©qó#¬f\'ü„Õx1Á°$\Z—`Cá1$!8?sLÛ±Ÿ¡^å(¼¨<KÁuÅFÈßüS²wûOØCH«¡: ÍÆA?Õ/˜&õæÙLz=ÅSˆÊï\0á‡t?€u|xRŽO6¦Eá…~c;’½)@ûr¥QÖçA^_^	PPã;!¾‹ç3fÏž¿T1AÂZ°ge8ív™m@‹5>–g›ê®ërt|¬~>v^^¿z©\\S˜©…9j–½Ì„2‰°à{Mg$Ë ÙM–kË‡M<˜ò½™dP³œ$uÛmÙ}VÏó|ŠUeâÓ$IÖÌš61\r†ã†ÕdN4L“\reVc¯U<_kT¯FëÎ»aV	ó»ódeDÐðÖm7v./Û£ü¬ÝøÞm3ˆiBëÎ¿ÞÔñâpÉd$À\"çoÐm)íåîá^/é¨ ØdØ±?¾}Sïïu.\'/s|=!ã‡;ÕogR©£DÉ-mœ¤5Ê#_\r;Qxú+„Ð»\"`@i-ã!0ªŒPqŠ«8ÿ @Ä#\0´Wö…\nwžkUŠ¿Ä˜ìíTÑÓ†U—¥W/­Ç7ßíª¨ÓéÆÓG\0˜ ê£ÂT.>JÕ\0¶Œç€‰A]ì°M€\n­»{åû~Pý­ãÃ£òñãG©Ï¨Ä_õuyýúu¼T§êx`M¼|ùB Í?Ö@ÌùŽ¨§Ã½½2¯¶NØã{~~®±!=é¿û½l“/_>ðXüGr5•`Ÿ?®ô©¨è^Q¯uìl81,ð—×·åäô,¤½òòù³rv~Z†ÕfEk‰šE¸×,Ôsá5mj²/ƒJ“meÛ“ÑÌ/³¡,&\"ÌLXÌ|üþ¦z™AÏ ØÔÆöùs_kÀr{®R\rýº†EcøÐ»«½i>$Ó>©5µœDî„n¶ã¸\Z¶¾ƒªûà‚ÌÔ|_ÓÇý.â…au3Ú©)ôØo~†} ¬í/~¶QmÞ$nÆST¨NçÄ1í¸ÁGöÀÙuä¥é|AÒhÖå³/¾”]‹ß‰¡råÑ÷ïßJ5\\Ìge:z›Zc#„1M°;­<ÊsÄþÌ¶e‚i£`à:Qúœ|:Ù©V\nÕ†¢8Tdˆd\0J^N\\€*Ë²P	ŒÌ@ÓpÙfHZ­ìI°\'@Ë^B¼g„Vð™Õ@âÓ\\c\ZsÄw1×ÌÉZ Nž\"k…wìïJÐ£ÎZ_ÂÞ¼*7÷¨xqøA„Z ~ù“Ÿ”ï¾ÿQìíäø¸üä«¯ÊÅ‡ŠVÇæ ^CLÙ¨\\ñîíî„\r‘J÷Ø gòìœ\n4â‹„ui½+\n}Q¾úê+Í;êà/ùK±ë¿ýÙßhQÀF?¼{¯‚‰x\0©~ª\"„ÕyÀø„§y­z`‘æÉà0aBÈ­ÄiqttPž=;¨2ÖØ­8\\k²®’µoZÛ{Æ–¯OOgÌÚ…eÍ ÁÏœWÕßu§ü,¿ÛÀe9ÊÏ2cã\Z‡*0ÇÆŒŠùy¹½ünµÐý2øÝÓ©9Y§ÜP@ýT|¿ª_µætx9Âí¨A°‡.ýnª‹¤Fv2v¼¬ºSÌ¬Nò£©³\n˜;lÊëAŠ€6wÔ±LÚùj¯²!‡j‰ÔcÛuhê\\ÌîÊ‹HY@@`ó%EìŽË`÷}œxL:Ýçtçßýî7*±²œŽÊc;UvO\0øŠðGò¡úËšV{V¸ùY\0Œ1ÿÂÛ¶¯ðú«àÊxËf¦›ˆý\Z\0A·¾`ÐvšO^øÆ<Ë¦&Á+*N)àj{Á¸Ï»è,íÐ™€5TŸ`=]Ùw¤\ZÂçËrqÉñö³2žÌ6À;ÖßØÝ&\Z—)qWµjvŸûûG½ƒ;ÝO~ò“òöí[\0üÅ_ødR˜MËÞp§¼xþ¬¼|ñ¼œ—£ÃCì¯ontŠ‘Î3¤Ê)‰Öµ˜$ïG`^¼x®0æü÷ø­6«¯¾üI!ÿñæú¦\\\\\\jC;{öL¢\nðmÅ&,sBÍñäy0-‡qÜ?!O°Xÿ;»C15ªÉ’Á@|á\'pâfÙž•weËAÀL$šIDÖF²¬YÞ2\0e5ÓlÞæ\Z·©©:fùóýÖÎhM50“cHÖìžj›$Ôõ°¼à §]äø+#¨$ë²îØFKy|48hnD±GùÙ¨\rÞ¤¡yBx¦¯qXŸÙk™)qó9\\RÀ‚-¥ZÖFl~ºm,^Ô(B\n80•þÃ°Pí0ºßÝÝ”¹€ØÓF#QÈïüo±$eç°Ÿœé]‘~SÊÛw?ÈC¸\"_ïöªtÉáãp\n\\X¯\nqiòÃ Î¸D®YŒ•Ê›æª´ ’C]Ëwxt¨¼7þF€¢¿•M‰ÅekcŽ0¶Þê®|ŽáZÀ]ËÙÔ»3LIÇõÄ^1\'%\\¯²€KPV\"4,Qõöã$¢öO\"h!ìv%ü°œÇÇ‰€¨t¼˜>ez¶Zè¹¤Ôp¢5aªÓ¾ŽÚì·w·J8¶ê\0bÇBM£&¬É¹°0lˆŸ¿zUŽ÷÷äå$‰üÅ«W¡AT` ²ÕàEðØ#Y#\05\0(ð\\ÍË?ÿó?ËIòåg_ˆ±aš ŠÅÎÁ^9;“½é·m³>¾Le—çQí–µN?°ga?ÓgœŽÝi•W/^\n´ð 3¦0{]fàÈlEn%\n™!YëøSªÚ©VU&|VE3(mXMM`ÎlÎª[f]YÅËf—ÍÆ·)-äÇf¤¬ZË³ÆçþnÆÅÇ|™†nÔ¦j(Í:*7euÌª…Õ˜Ìš<pVã\0,v\"{glKÉv2ï&™òLÔˆý.O¢ÙX¦žêá*nN`¼¤ºŠB÷äÁ‚9É0­³è\"Rš«›ëË0ìÏD‚æ²\\ÞÜ–/¾ü‰lFªCÕ‚\rõq3Êk8º¿+ßÿþ7.*7 \0³ÅT¬áöúF©€\nuÞcªy’*~×VÛæË¨°ÀÓ´V\'Å“GüOT;Ä{ëB$‚qdì|´=¡ö1Zlä0â‹‹£»œ3¨öÔRÅžG„\Z5FÏ‘¢t¼Qñ)Ã?XÖýxRîîôÇ‡k¥…K%ŒªöÎ«2YÆ©Ðl+–²ZK¦ ea{½Zûù´k<žÌ5Fx€Ÿ0¾²X”g\'\'å_ýÙ×,\nïÅ5wbF«†÷ãûíÃ}99ÅXªñ -¯^¾,ßýð­lmßþî÷e:\Z—õõŸ…a<*W×W¥=è«ªÌo¸Céêˆ+Œ‰ŠTC˜§ëÃ3îÌÝÝÃ¨œœ†-±Ý*¯^½T*P¿z}³a@â©9¼È^^ƒ‹ßÀ`Ù°³Ã “ÀÌÇL(ƒNVM³ÝÉ×Úta°ó³eÙÎ2Çï^KÙTÃ³Ü?ÏXÄw.?µ)à—;àFœM¨îl¶s™Y˜Ìf|­Ÿéƒ˜\0ŸšãÆyP2Ìt—ï\r{›üOb³ÓÛÊ‡(lËàåAkH\r%4ÓE5NkáËòpW>~|ö®zØ(÷3t{÷(;9‰lEûGœ“·_Æ·åîú²üø‡ß•ñÝ­ÎÄÐŽœô™ïß+^Š\0CTÀ`S?¾–ÐÙ?<§ÁžqJ5‘ì°-v¶@ä\rAj*<ÐvÈnOÓÕ÷ªkA«°µHdÄâÀæ\0Ó‚åså¶eÏaÌ`v›CNº¡3Žƒ9§s+ë Sîp8(£S8¡&†šˆ2;]LK¸£ø(ÎHüðñB\0urr¶)áC5Ön/l.6F“ˆm@W¹b»Ö2Î³©æ°‹zø\\©7ñ!5”ÌÏ_)ÆŠhûw?(„„Ø-Øj·ÒÇvƒ….–åÇï¾×	ÏÏž=+{‡R/:˜®ìsûûeEÈ‰Æþæ£ïbQËu´ýWLØ(\0¹Ó–ÊúêõKÍe$ùšN%ýÀæ–:—VÅžk<–#œA-Øÿöˆ:ƒŽ7z_—,«q¿¬YùÖóâöå¶d ô÷ˆýÚáû²üËü1Ÿo7Úo¾ùfÝDW³(?„A°Ñ/{ÝÙ¬ÓJåªÁpþ\\‹½ÖÃ’/F°toÒPƒ‰Á\'\'?ç¶64fî´©l“i€`4~££ÚÃMqØ}ÆXJuÔBRpö°9M9½h&º™EÛB=PØ8*Š“—?¾ù±\\~|£¢~„HÈHÌò¯ÿÏ?iÑ*nëø \n½ÕPÕwçX°N§¼~ýJ™w1~E¨04=ª=µ¼ãMÐ(`Ed}ìP]…j}Í#GÏŽZµqtÚRyT?¾8Ã]Ú5I˜¨B3ÆS=ÿ‘s§óòþã…&ñú)°sÝ–=ŠvK#¯à\"Â8$˜bŸšÍT3q\0<©ÊÃ]õk9›—%LwE_¿z%ÐG%ÆŽ†ÚIµ†wïÞË>“¢Â+ª6Æ÷¯ò©¥°ØÏ>û¬\\^^É³û·ûoÊñÑ±Tå«›kU— æg?û™}ê–Q‘c4’Ãï!cöùçŸË`/5]µÄB%\');lWa·Ó×„wjkÑFŽQ#)S­Dd˜ï•/ŸëÞ%›·Iã$ËS®UkZç+FÄ»ÁÉÄ¡iïÊò±%Oý³Zãïü»ß—7{c…å-Ï† ¤ô¾¬…åß\rx~_lŒqXÉ\'ŒÀÊìÆ/4ôß[æ‡pæËTrx\0\'ahÅNØ¬¬ëúÀøŒ…a†åÝÅ Dg²Ã Ù®¬:š-æÉƒ½PVd2	çnö-Ýî(ß•ðâÃ…!„}kçôõ:ZV¨}QW=R^HÑ!|á`oX~üöwåû?üVÌŠ¤jT­ï¿ÿVFWvþ×¯_V¯RŒužÀA›V¥69‹žIôäâmÄ»x¿<Ü?H]´ÞÏ\r ÍdBåÔ\0ûËyZJô9×R9»cAÎ ±+\0ö°‡­—r4P4ï©*úpwWn	ù€M­Öe4žªZ¬\ZÓîh-Êú<Wa@]¢Ï|‡J¬µÖilÔ‡‡²¿{ Ø+ª0Îù{õâEzåêâR,ïêúZ BøÀèîVÌv{ww[ö)û3ì•¿ù«¿.ß|ó‹òoÿí¿U*Îo~û[ºów÷w›Ãm©ùþÃ?ª’Ãßüìgò$*+@Á¾³òxÿP~÷»ß	P!‰É‚éRLU3®*àQBiOE\0±Û1N\\@={ùB*óÇ‹‹z(FWkµiíô)»mÿ@[ç ®Ö¤Jfá`1K±\ni{o“D4eÓLÉkä)0›i2iÉ*³!Ûº|×e-ËëÕŸ¹MN—2r²Ù\'3D €e›‘)£Q-# Q5SÉÜiˆP9ãå+\r<“mÐò;ó€ezšw\03,³¼Œæ¹óY·vÛ2âg°s_q¿ËN<Ð<ê#ax—0ÕüœÖrñþ (›ØruÕÛÔL¢¸Ým$Š«‚îý¥Òr”CØâT÷åâÝ»2¯({Ì5¸Å1,ë¾nÔÙ‚õ0FJ!\n¡\Z’æCzÊP…îN¤n„§çòÉ&[k—¶¦	\'+Gî¡Æ¾[KóîŸ~£ã¿jaA~G	T½!–ŒÜ;%„SŠ°ìR&”‘Q˜G°1ÒWä!ìlM	Ê$ OrñX¹þ·jF©8©.AÍT\0\0 \0IDATì•üÚj—ƒ½C	/ö©°§‘¢Ô._ýUùîßjÃ`¬PÍ©ME¼}çäf*¼’çwÿp[þþÿú»òîÝ[Ù¦ˆ¥úõ¯ÿYjÝOÿâ§åïÿþïõ\0”„_ýêWå_ÿå_–¯úÓX¯ýAØ§3ùñPÒ^Ø\Z*!Œ	•FE­-‡uPÐ%´™3<•:ûèPí¥È!X8)hóáÑqÙÙ–cN ®g^²ÆØôð>Gx&ÆjR­cmæ·I\"2pm˜N%ËƒŸe†æM¿©66YZ¥ŒØlòi~–Ÿm†˜5+›™Œ+›þýêWQqÔÍìÆh\"£ìï¹\'#¡\0«o¥¨(-\0ŸKhõÌ(kC[¦îˆÃ\ZŒ¼ž#;ÏrHnS=£Ö»µ zœNÌî…:ˆÊ…Ú²ˆ‡Z£¡¡||÷®Üß^ÉŽ%P@ÕQÔ÷°ììHmPŽ\Zæ——•‚CìÕÅû·¥Û¢Üñƒ˜\0EïÏ‹ð&á‰\ZÇ±ê“Z/Rm&Š°æhuÆ€w\0dØ†°{`sÂ…O}óã#*FP	a,PEM™/fáM\\…M`‹»Ÿ©øßcúD*#øˆ‡qCå#ÿó°Á:ÇT]úŒiCQ¬ŽúgáuˆP+)nˆ‡Œ’:°-bžøa&äGÆ)7³zP±T;~,_õ•ÆEó jÚM¸ÀþþžBFpjP¶úÅ3BNdƒüê«¯Ëïÿð‡òã?rÿËþ/j ‰-ê÷¿ÿ}ùñÍ›òŸÿïÿGl†„\Z&ûäã£‚W¿ÿþ{µûoþög\n bi[Ìr?¡¯:Ž\rÛN*@¨í”ÓgÏ5Ç?^(>‹¢ÓÓóÒtË.uú÷â¬EæUéQkW-prtx¿½¦ÃËUNtø={\r–Ë`Ó6æ¿7›{Mãñýù]nO&9F3.·ÃíÎd%3Ælºñ5›{`XM#X~õ`Ó:3ÿÎF%ü´³”Å\rPcÂlÃò³ÜFc„ÊGýNƒ[v©f];ï6¦Ì¾6£y€\\„ˆÄ´\"y•Å2$ö£Ú¤ht»].?¼/÷xþîn¥– ~` r\nV\03~\'¿°Ò™€÷÷;¦ÃwÓ‘j¶?>âò)f½½°°³¢\ZÉ{IÀ*5bû–GA\n{í³×¯õÏUÄÍËãýc99?-*9³’€Ã8à§o¨/Ø„ŽN¥ªª:Â|¦È~žµ3Ü)»2BÃB©ÉeUœ¹„a\'†ŠI{•ÔÜ£è^ÙS×§Äw-T\'‹wÈ°?«G‘áÖ_­Å>x6BËœ)Ãa]”Û¨L€ÙDã[âp	<‹D–ÛGî!&\ZNÅY-åêúBgb0ûæÇòþÃÛû¯ÿõ¿j=þ§ÿôŸÊ_ýÕ_	ØøñÞýë_K\rÿ÷w›½TôçÍ›7\nyøòË/Ëö•6aÞ{uy]m¡Øïf‘Ï¸»+ûg*2v¼‡sOÎÏÊÝí½bÈH¢}G\'geµ˜	8:­=i¬Ì6h»S¡6N²JX–3Ëo6ŽgP3äÉMq–™¥ùùY\rÍàÉïÌ‘$°²¦–1Ã`kò“ÕÌ¬I%ÌñCÜ&ÕôƒòçÍkPølk[Â\"‹ItÅƒ‰YO¦„Mž£`CJWCqSut[ý¹û“ûeæe°Û:8X•D¦±,Ô2)GÊ×œ6~Þ\\_”ÛËe>&ö(\"¬QÞ_|ÔnJÅQ³@\"®§³±Ô?ìwÞþð½ÔÂÙý}é¶‰[šê Vb·ÈSäTš»‡GUkÐñŠò·?Eã0Ô¢ÀÂ§ÏØÚ\\e#\nêE-+Îäû¾û^ÓêöÊÔžH`¦*…£²1ÊûIJÞÛl«rg\\¥+›SˆPñis¢d¤_ÅRU8¨•CK;å^ \\ëÆï‡û0Ä¸x^ßÝ——›u;\r±ZØ´.¯.¥ÂR*\Z!Ž\\È\"ÇÃÝƒ\nïÙøÍXpªÎ™I±!Tã`3å»o¿-?ýéO••@HLéÏÿüÏË¿ûwÿN›(ÏqB5@ÊwJ/j·•áàøDTÏþõ?—o¿ÿ®üõÏ~V>ûü³8§‘“ÄQØZÁÆ˜?ƒ–XX]Ã°eÚI¹\"Ž\"cLˆÄ\'_‘šf:v8•â¡BŽBÛ è¦VÒžl2Éjœ¯Ë!ËœÉGfoÌavÂùš\"¾>“Œ~‡AìOÉ¹íbMÕÓKž\rXa³úôTÃ2 dýw£:ÂXjÍuºñ2©VMóó3Hf$f!Â²äýªÈ1w0ÓÍæ®õèí DÌVÈ2jÑªL¡×ÕÍjo&ªÍ”r1÷Ôi¿.··T	r»Øoß”³sÒ-0Yqœú‘Úb>Õ1ëª¸Õ*å„Ú¿U•QØX†{ÞjïÎÞ¾<±aYõSža¨1veT˜ #Ä:ªÇ*<‰q¬kaÛšÌeÕ`’wÖ´K9B¨‘w]vÂfû¹¹¿‹CVU\\/òóˆçlNºæ½Ì‚	DÐp‹.YÖeo\'ÊïèÐ‘ƒàÒ/%)Ë\0p‘à}û‡?Du=		aæ>lYØ°ä1\\‡mqooG6¤^—C(–åú‚x¬–B\rhž5Œå0«Ñø¡|öêuùüóÏ¤2$#Ç1m=Òb´ÜDNzýú³òÝw?–gÏŸ‰Ea+#=‡ìbÜóû‡øyNÿößü›¨qt(	¶ Ås©^ª(ûn¯Œ&q˜óI~#	ÖØöØ4ÏŸ¿T\nnàMê!¡	D¨JöÌÉfœRå²–bfÓ”‰¬¶eó†ïwdÍë)°1QÉ„¡i_Î&ž,ÓMÂ“Ù£ûÍD3–QÓšùd`Ê¶-«rn€Ù‹Öå_Œ¼R¯:Qc‰	UÉªc¦Ê…Fd ŸÍ{}jNV!M‰=‰Ù†æ~ä‰iïF\'ñT•1ƒÐö‡ÑxSE@®üj;âØ•Œçïß*uƒ]˜X)Üêï/nÊéÉ©€éöî¦<;\rÌçòã…ì€Þr:VErínodtWZuÞá\náÍ%ŒŒˆ¨Ù¨„1ÆØÝVŒ½¨ØâøÅñbPá³”òîÃEY·#NF‡](¶*@Ùv*%§·\"85ªCw+@…]r¨eôyoWª#v#ŒØÅHßî71T°1@‡ƒGa¨¿¬ÆUéøü¤<?{Vf“YùÍo~#FFÂ9‚ŒcAªÜ‡w\ZÅ`uÃ­Ãx‹r~ö¬îa?¼S/ë£;›^BTÂaP¾øâs@†üÛo¿ÕYÿþßÿ{mþÉ_èx3Æüäô™’¡	ò$†vtM,Ýšp„ˆŒôþßÿï¤NÿÍßü¬¼zùJy¢‚*ZÛaý0‡\0ZÌïÍí$~ë@k:a8+öOtêcmëìì´z}˜«ŠJ–ƒ¼¾óúÏÀðÃÊß[­ã3‡dËšŽÁØ\0im¢‰–5G\Zd5Ï ˜µ!«ƒ™©ñL0‚±°MKïùå/ùG™ÃYn´;–1‰¨ª„ya\ZNUpÒ­¿wÇMu33âÙV	Í°<Q¾¾	LMJéï\r¬[\n§š°T\"¤ÝQd9LÅõŽ`#$Sya5—ËïTáw¿ý­óÕg¯Ëóç/ËÇ‹k-xÔ‘n¯£zîF{Ôš8Ì“cì§‘Î0œPùrô(/$M¡ò(Â¯àJÙpîÃ¶ÃÙzëð¢&X£)q?%`Ã¾°iaÀ¦\Z)ã&¼Ó \\\\^és†0€•ŒÉW¢4	ÜÃX \0&Þ/˜—ñ\"‚@0ùùñ\nðÅ‘v?\0Ý™\n»à Œõ\\†o‚)G\0u\'*F‘¿X”írzt\\¾øìËòìü\\¦\0òæÝÛòþýGµ±¿;Pt¹ÖÞ:l^ôMy±,\'‡\'N¢êIeÂ©\0¸¢ºu{mÅo‡E&IÎ¤Õ\06ïÞ¾U?ø &tèuë_ýSÙæhÇ_þÕ_‰²A’Â˜(Ú~0PÎ!^ÇÏ>ûB¶0%ª4qe×W·ªO5€lOéB{qèk=¼ö¦,Šve›Sü×x¤ß™\'jÂo½ê‘þeÍÆà`Yðß™-=õ{&Y¾½Ù<,‹üm[rH³•q!PHsÈB&\'Y6Ý3É°-{	ÍpšÞB_œÑÔ”Ñ1âú–cÔö!–™;™ˆ6ñ_S%ôµVK¸\'{2E\roKØÔ¬žÚ )`–Á/J”v¡®*¥6ú„øª¹¼smƒ%R2æöú¢ŒîoËG\nô½y[†ƒnùüó/ËáÙ³òþý…ì[Ä_Q­µŠ]ªÂBS­õaOAV Œñ¾Í©+…£xñPŠ›D½vGé-RßÖTïä$Ž\nÅq’1±RD½¯Û5Ï¯Öd‡Ý¼‹@cl§N“ìD5Ý2TíP	e¯ Ö“T”®\\é¨1Ú‚ˆ\\_®ÊÉéq¹¸ºˆØ)RŒ8+äªšE¡2uÚ<»àRýrx`Ì½,~Õ=Ç«¶X(×î/~úÓòg_}]žžÉnF)åe8ìöÝ‡·åÃÅG­+©µ\Z.\0‘çÁN(^ˆÚ\n3!æj8ŒŠú{üXNŽOþºÞì·Ñ-Ëò;ÔH‘š¥ïwÈªÌ®2\\YýfûÕvÃO†\rýfÀþKÝ‰zh»Ý@wUeÞºóqcÒ,J\"E‘Æoí½È_EéâB!ßp¾sÖY{Z[æŠ	»Û!ƒY? dNH:ùö¶ýåï~¯*Æóq‡9yþÑ2­×›	°0¿üí_¨G!Áž~À_^¾Ê%FƒímÝóÆú¦Ž‹‘è(Ÿ+çn(Ù\"6%Š¤ñ¢6K\"¬*-2çSs\\\n‘Ô«ušÈd\0\nFÆÿaJÖ×ynþÛkœ¯{ýWWÏ‡>g\0­lÌŒÊàãMÉÁ\n²]SÔ×àÏ0—\"x‘ñÅ5Ø‡Õu’u/²Ë¢*²}kf`ùûû¹E1³üŒÖ¢ùiÂØ¤¬»…ÍSü$•aUDöÃð úz*ˆq¿oÛÞï›nÛÜrö{øŠîÅ^H[X]co”Špqö¶MïFí‡¯¿RŠ§ÇÚðøi[ëo):Hîþ*Š	äE›2Ì0ªú	@ \":q@|P·wÒy\'±Ù^òà0ömE}_,ÌÅ½«a˜Œ°C1äp2[¢ZŸ…Åøì©bjiÌÏdvãÇóó`e¨ƒöžµÊâ\ZG!UÀÎ~$Q,-ÃwcÒc.²„o&#\"wH×Š\\ÊœB 0t³°V{ºÎíþ ‘ ú)YåÃíöúÍë6~˜(:÷í÷ßE× *\nF£HØÄ„&\'N\n	ÛÙpvERÎ«{RÔ”^‚;‘A4n0l}ü¼ýíßüA2?äQ}óõ×íÝÉ[™Úÿæ3m®\0=æ, LD•k9ÖS\n÷ÿÕŸÿ, Ä|8P+ýè“¥PA†;M-˜ÃD%­>.6\nDÿBâ§\'½®ÇOž¶ÉCl<0>2ß÷v†’(Â­ÀæÏËØyS7#bÃQ^ÛC4n}d©Ï”x^K!ÁÊÎ¼6¼V|»rêyf^)%ª©]ËÆXc‚Óed|—q×F¾ä³Ih³½YYŠ¨ž¸¦9TRßK	ãåçY¡Ýl‰dSJ>c€ò…×ß6	yØ¾&û:vôê³ª÷bW©¯w_‡ü<Ópœ²£†O+|˜0øX`Y·WçíüÍëöêåÏ­ÇdÞ?n;‡‡m_)\0çmØï·ËË3Õ\"â4Æ4À( Åc¦È‹	S‡.ÎÓ(—ðˆR±Ã5OƒŸGh£ÃbfJvÅ„Q·Z¹GË«˜`4 3†ûÆO¤¬wÌ´~,39H§PªõŠ˜1„µSTNcƒÃW\n´fBl›‚žÀËÝ:r‡lx’:ˆáˆEçH+p«¿Ù÷”O´óð`¿={ü$jç³öíwß¶ër1g*fæY)E\"Õ=ˆTÂüðY53.òNg2ã¸~ÆY¿\'÷íw¿ûK‰øÑKðóÏÓ~øáåcMfJsðFyv~Ñž<y¶`ë	›s\ZsÿÛo¿mŸ|ú©2ï{rÎŽ?j?üøSÛ=Ø`šÅæAW!RHw Á46ŠÖVÖ7ÛŽ’HwÛÙÅ¥ät0	qGP\0¾¤@a·)ëÄ3c|D”·Ô‡÷ú¬$D©:J€ŽTžÿ]×:¯™`@º$%Ññ½ãøÙw‰C]ó^{]©ëÆ1óêýéOR›/Äèë¯`âƒóÛoq·å¦ÿ9`aUÄ\0Ùñî(á‡v€®ny™:ˆfn•%y7Pä,Ô•	ÖWm¾Y$»êž<L&ê—ç£ˆ*áÈ¥YêÝÍu»¿½n£ó³öÃ·_‡¢èz_þ¢\'ÏŸÉŒ)‹“ý~Üîï&2÷0	å‡O¤éÎõõ©ìÀà”ÅÂ\\3¯;ºg ˆü¦‰ª\n`S\0Ž´¤tœ0¥ÙiÕR^Âr‘sE‘/ \'šn™˜Å.¹_$ƒF!»oä¡ñãð8ö™ÀÞ½i,ÎK`jƒÕIëI¨„Õ¬—3óâ>£›ÖZ«J€%_ÞÁÎnûüÓOÄ¹N´ÈÚÉ»_\0êçH¶y˜\\?ÎyX²U\\ê*‰Â¶È§ Ÿ=¦sÿå—¿Õw0ëúéÀsûéÇŸõÈpß?8PäN ˜þ1+¢r˜™´aûò·_¶Süc77Ò†×8n\rÚ`+Š¬ñ¥Áàa:D?‰ÎVVÛÑñcjÃì`nTLÖAJòËØäìÃ’ÉÚZ—0ïûh•URý{é&	]õ\nfÀ*bz\rUW‹_³IZñÄÇ­kÏkÞó*,Ž`úÕ’c^)`—…Õ:.€åV\'WEÚ¥íû~[®ÊLLi£tÅL@1,à.`ù3fU¥ú}Ê­ê=hfYfLu7¯QÑ(]¯[·‡Øø¬ü+ë\nåG“žsÓ6\ZÓÀá4LZL«wïZovßF§mth}«¨ÖîáAô°[™‹q~7Â§µª\"Z\Zoéâúq£ß„2)‹§4ŒƒÉ&¿Ðtª…ÈuG·”+©5[N0š+„¹8‘Ã³E-”\\­)-Ù\'­GcS©:Ðºk£Ñ‡ã`6²˜v}™‹, 4Õ¤°Š£SJNô(ÂÖ÷§iâRþ”˜O¡ÝµØAáÝÙkÎ¥CŒ7æ¡ÌF6®e|§,{OpÍ—ÞªþÇ)Oq2I¯èaÁÆðAâ\'Êxv=jgg©ó…™8\n|z+åŒ.ÒÌøuÿê¯þZ F”FC¢}äk}ú›OÛõè¶}ÿýš\'D·¶híu\'ÅùGï§Ò†\'”=˜¦ö\'Ÿ¦çBj‡\"°óhL1¤^2@Iwàzvv‰ÐöÚþáQT\0¬®èÈÛã¼øQ© ÀÄU×å£”žY®¿lú$ÍœªOÊ,)ÖÉÒ—epzßßõ¾ÿð°ÓÝ~íV¤ƒÍ¾¬Jzªu¤kL‰¡%p.S¡¼¹fæš€9Ó¤%¬è·0‹2çÃ€RM©Š‚ÕÖõ  säïù¢¡¨5iÔ!R/¾ê«`Åñ?Ðf‘¯×f`e^•JV\' M@ßŸßÃ€s2XV$kUF[x8µHgtÑ¹Q¸É+\Z®ÛøæJLëüä´ýôý÷šÃÝa;9?•‰¤ta£Û6¥aAg!1Œ™¸%i”ŒêÆL1?g‰Çx#CŒŽxT°Ç}Ðì4$‰™HŒ¡Dê2P!“.û\ZÂ²¨	$c‡²À†:ÂTvÀÉë&¦\0ÕÜn>Ò€40ÑâJ	¢¨¢†ú‚þÎzB\"}è²ã¤‡Er½4ÑÖW²yÎ¥¶òqºçð™õÚ}ú_¬¦Ú§£Œ2{íøðPfá}êar$e2D(AœœžEÖd©R—ÈDXî›« E\"òµÖÚÞîž”D`:$£ÂŽˆð­Q&Ôï·ÃÃ£öõ7_G•Æ`(@üö»ïdBb>^^_ÊIÿùo> ñÌH™øÝ¿ú½Ô<Ôñ\r.æ_zÀFýiy©>È10,Æ=Yÿ0hüXøØ´Q¨ÃöºÆ“ñ°ÒoD»\\ùÍÀÆ‡, ¯‘XG\0·7gãRØ Ø±ÛmÆ37ÀVœX€¬±­NòºFMjºëÕw™^%1ü[Ç%JÈí®æÔÒÑ½í¥VO×>æo\0«ú.tÑ+aFvû\Zü¼ô2s´8`Åÿ+5µÙ¤…‘ƒf¶d ]øLr±sÜ¸ç`R3ÐÃ™)R†½¤Î3<|j	NŸI—Šj{eÅ°ØïÇíúüRN^ýÚÞ¾{Ýú%†»\"™å8ÃWVÚµÔÂDA]ä%BðZdc\"Ñ„4X—Ú”Šð2»}ï0L\rƒ¯X\rÉ¤D”ð1!‚™\0˜IJ\'£¥k«‘ã2¹×ÿ6¡b¢|„h;µ6ŒÌ~\0ajÒ1Áñ]LÄ¶¬)ÕF°Â½›!S]@±\ZA\'>	L1•xU\r0Þ¹<:8PLãüì4Ìÿ‡y¨³N¤1¥	H2Ð¢´\'¢‹3ù¼8þÕk0ÛÆ=<Èü\"ÿiwH›zZ„=’DcòæÍÛ¶³½§ìtÒ>ûìS¥-Pòó_|¹(W\"hÂ˜R~s|t¬ùÀœ\"Ú¬¨ Lð\0,ýŸ›ŽzØ sx{wWï1×>úøãÍ¹ºÒua¦ZAgådŒ0ÔyVk¥‚A—Lˆ*czßœ\\ª›%WÖcö$9”ô®fŸÝG•4tÍK£kÍu‰’\0«šCˆYQÔ_ª7jŠÖe9šÐb-KZÏnHÐ•ÅÄŽ£2†Rmn*Z£xÕ®Å¯âöP][¸Þ íuL¡Ô5©t\\{ø» ,~,T-ª•pX£t0£:AÃ5oÚ[Ú?Q:·gv¯ü¬³·¿¶Ÿú^	‡Üã££Çròòƒ,Ì†{í”§ïÞF©Ñý½ô°ðƒPÍ5QÖ#Æµ\ZÄ°1L®•Å)\r„•¸¿lH¨›âícò˜ÑïÜ-Ì#îs˜œ)2¸Iƒ¡±¸˜wšT½& à³Þ(Êõƒ	Ð2pÊ\\¸±Û?È.>˜¾\n|a€„´âeßk!Gþ@CÀÁìïA\0RHÒßÃÏ…2ÀÃXxcS*¢’8º•Y®\\1LÐ\0Åî\\ ý„as] €\ZÉ›ÇòG)¼>ŸG“ÛÖTHéÕ	Ÿù\\›$b§\ZP¶±qý«¿þkm\"(D0Žýá@Eö<;XlÇ½Rh`1Ê¦ßlTd\rLPZ¡!3³M¡<l:[Ç9¬ëEX¾oð¨þ¡. ð½\nX&\Z^K±ö°ì¨7Û±i¹°ˆJ/Ãºþk`ìCXRŸn…÷‰Ö3&¡ÉÜhÜ£ /´‹ÚËY°Dä³É´&„»æp^Û³:–íe¶œ“*VÎÕXÌ>d®VfeæÅ‚êþ¬®l4ºÀDŸ¸¬€Ojí.&zP+äf®Æy\r˜H”\ZLìloµ³“—jOòúm;yó6ÂìÃH\' 	9H4!¥è3èüüTæ“œÚ1JIjS7ašd¯A§\"lõ™è¡®iŸ‹[\n¤é[òÎEÖ¹‹q³	Î0Ö0+Ôx¤FMªi8ðôRÓL™ÕôE\\ö~ô#ð|‰t†%hÅ¦mè¿¸uåjE_>Ø–XNÃ7ƒ¹ìKºRDHIÒ$Ÿ×‹\Zö!}ïÞbÌ$Ü†oNswŽbDôWd£T¨üþ^™å6cm]ð^¨¯Ž%[üäø8Ìªõöä)Úë‡íÅ‹—ŠÊ´ìõÚÉéÛ¶±•Žó»±\nÏ)_|pÀ«þõaÚž}üQûÛý¯µù%Òí]Ê§Ú$VBëÝæ9u¨ŸRXO5ÂÁÑ#ùã&“[¹#äÛƒ­ÎñC-}š€W¬Ï`;^ôÞL*Ë1XÙçëµèõí\rÜVˆs¢*!¨‘ž¹%ºKŸB³²Ê¢ü9^«D¥»>«¥¦ùöç?G›¯Š¼¾É\nPfa¾Àê»ò\r˜‚J+)V\ZÔ{Ù—°6¡0XšŽ\Z¸*ÒòžËhíkó\r{¨QN‡b+xUªç†9À6ØÁ‰‚„É£‰Ó¢ð3|/8£ªCÉ Š‰f½~õ¢]^œµéýmlôÚt<jo}ÝÎÞ¼kw×7+vÓû9ÚY-F”H%Å¢ zÈB$‘ñàpOìŠ¤UK\"ËÜAb¦¤m®Ðm%ýB\\³\"m”È`ÖÉ™¼*S	˜1	3 @sÔ<®Òx\Z€åÆ´Ò—˜ïÇ$ÃŸÆÿKÆãg{°/k%Í,	–*Ñ`©˜îI\0 »ñ¬e?EÉrãØÍÛíÝ­,ÆhÈ“•¯ÎM³Ö›G™cGºF€ck÷s˜âj´œˆ¤I¨\"A™YÛ;ýs›úèø3ÕF’Ý#¬eÙÃƒ£èøƒ:úW»{íåË_\0Û¼7k£»Ûv|tØ^ÿúJLG;coÐR@c¥×þæoÿ G=M,ðe>:‹¤ëYô°I.§S–Åx6@‰ê€M•ö¬®…)Ð\nyZÕà%ÓX1ï—µ‡•˜™{Í×õT×ž×ãìzé|¯ e€Ñk%ÐæõËoa³%.;oU3Òk¶ôš£„Õ|ª½:Ð¼Ø`€ª4Ï&!¯±{ÛI‡n\'·â¨/¸ÊvøøFxÿÆŒÄK¤PÈe‰H•ap4’{×\\š0á£ÓÏ­Ð#ó75í¹`œƒ(¨õBƒ‰$K­ˆ\\¤äQM\'Se “ÑNÆ;lkeRéeU\0\0 \0IDAT‰}H!Ÿ½{+½\'ò«\0Î«¢ëëÊ€W§˜qd±c~°¨ø7$Ènf7–Äq8Ûäâz‚âG¾ÏŠ“6šS¡ËDÊu{¡2:‘ÙEÊ\r‹<²Ý×¤ˆ çCjÄ,|ŒJÍÕkÀ)\"êêC~€—îœWÑÍÌ’^ggWãŒÈç\ZÀp®?LÛA@éDQ9°®È)Åæúæ\"âUé\nÜã•J|p÷Á#¥\nOf]ƒ³m&¶¢ù˜×ÃwxÆ6c¤ö°ŠšèPc‚™¦hhš¶ªË\\YðôVè†½—Ze¡sFk7üC¯ß¾Ñ}Ž\'ôLŒÏEF)B­g‡iñ,?y\"ÅÓ«ŠÅG~|òô‰|¢ƒmÉúæ–Lù€©à×6¥Âû03üa…ó³3Ø5ØXÃoE9…êÁ*Í2ëš¨LÇk<Øqø¤\rRX*À-IKHŒªÕ#uÙôcùóu]k­RÃ*?cþ•\ZjïûÍÜ?€jËž2	+²š&V´²#³ÛFÛúy­Œ¤„òÓ á»¹;,T¥€•åÕã¹–ÝªúÕ*`™ò½Ê²¸Õ&÷95@É}\\=h—:d.u^SU8wÙ™IG˜Ãl´ƒßª¥×Íõ¥2×ù‡üÙÉ;•ò°ór¿Ú½û}>Ã\\Üú]u†\0@LWEˆ6Ä04v*	,©XQFM”¶@Ò\'ý	çäWMU’\"Q¾ù¼]_EzC€\0Í$àHè¯³XÃ_MZ™Mò<¥L¯æÜ·LˆLá‹’9ByGú‹T8>\rÈC¨¢N³%¾˜~(¶FÄeƒY$Ï¦/K‹ ÕUI\'áú\0”YSr‹`#|ç¸dÑÚJ6¨(â™¨J‰Rpã„+\Zù¡5ÏrA˜wü\0Žä×ì*ÿ\nÓ”ûC}”ˆ\"Ï€Bs˜€ÇæCÔ¯¿ÙWðäú­¾çÔ%vø£H0å\Z´AâoÛ¢Q+MGÂÈµàFHÑfECx&ÂcÝ\\‡a†Œ4©2X\r’á/î“jñTB`pê‚Š?o¦Z[^KvéÔ5là«˜R‰Mu™<|è\ZäŸM‚Q-¾…Iè/Õ\n3\'ß¸Í6#k½©ÊÐÌZl6â\0°´‹d¤°›xêóW¿™ÿÍ‚4Ãªk0êî\"u€*eõ@Û¶­%T\ZXÄò…hvØÕ©r©SèŽBâ#Ê\rBoÕü\09˜ñÝ•ç—ççj¢J÷r°\08‡ŽñU¡‚À¢\rIO*KkØ±Eóó:Ô“e%ÌÆ,JhHˆL©ý„Ú‰4øQØÌî+¿Lw-\"‡\\³Ž›NmÀìá&Nå¡IÅ4˜Çd!R†	­m’8ºJ†~€ »e¤-°sÂ¢£øp”@„Ì–žTB/+Ò¼6Uç`ðIc>Š\0†(ñ<H|Ufþú†¤ #ÒF\nDl\0\"Ï€ŒŠ\0,ž«æZ¶ÞÒµ\"Œ\'Ó?˜4‘VÞW¾YY\n\ZjKf9ÿQVt7–2ìKsZ=cƒ„ù3v$˜ò0”qeH~:Óþð·«×Þœœ¶gÏŸGÞ×áAHÑ†#)n0¾Ú¨VäÇ°`vª}<:j[ý¡ÆÀÚXØBÕ7´ª—€U×H×WeÒ±ðùåb©1¯õîgº®¯U[T|ïCÇ¯Ç6x;Šþ^Å—¸ašºÕ…^)¥}ê‰ŒÚ˜²#-\'\'yrc=\\móe“Ãì¡‚‘Œï³pxÈ^˜f¾F¶;¸Üêìów;Fo]Ngƒ™ÍÝH)ÊOü(yOZÔÀŠbeÄùš$g(§é­ÐÁ†”…›öö×_Å,H{˜e–9÷\"ýuüVÓ&ýsÞ­” ™~3ŸUjC–°ðß\r³oÜÖZ€šÚy©e™ßéŽHßjÝ…¢Äàd\Z†#&\r“½\'§1fL@‚“±Ñz™•®\\/ÀÌÉŠd–K‡ágÉDÃLÉä@€s°QSùÁðiÆ¤+ÎÝÔ“XÞtžcRó?àùH,‹7rÂÂ²±Fð†˜EîúnÔÉy·\\”4ª\Z—_…¾½*2è¢*J“‡dÛd¦³	 ½³¿§È!I¢[Û;‹´Îe©e®Ÿ\ZDü‘Œ\'\0Œ“\\/æÀ›·\'ÊÓC­æ¥dOdx=Öø‘Ò F&4¥ H\Z`¢:_;;Ê[m°Ù\0«ÍUmraÈÇ\Zì“yRÝ Õ\'äõV×‡çD% ¬ü“•ÌÏß÷ÊèªYj«ÆøR-,»uL’bã\\<,#™¸Äm@óÉüùzsôäÎ—	˜2mÀµ„¼ïè€¿ëÝ ëhs”Ðç_æ+èneiu€+À|gÙ?cp%§Ê¹ùŠ>qÊÌ×Òùhà@r§º9Tx3ºV‡‰[€yÝŽ®e\Zd|­,T\Z¨t\'ë\r€ŠÒ¦÷)M9rJ;hÁdþ¨ÕçÉŸFÄIr1Ù¾žS~Â½„Ï*€SN#Ë,¢¹* „©Aƒ ô	²4=™.\0N?ƒU\0V°ûÒ\0;ÆNL+Óä¯”C	&•›ÎøfòÕ``šwèÀÝr³6£ˆr)\0&˜{àñ	ü’A’a.G2¥ë	\ZðšCÿ¶|Î˜]RÑ4\"+ØÈ\\ÐH\r1Ý0Y¯F7ùIsIóSÒÑY@‡ü•\\?‰Åø¡66¶ÚíøV FÔœ¦@ÜÛ?T:†Â>ëqLþ­›Œ9#®},-ÞØ0[PF0À¼rZC8ÐÃÔòZ7Ð,4Î9Úð½®ý=ƒI„×U×UdkËfž×¸Ÿ±1ÅnŸ[>åšßE”°úwÌVœŒØ]\rï9êc]8Ü5P)‹ÁCåaú‚mŸV´÷w}>>£¦–¦­ƒíPýYž4FçºÃx€¬†*Ü“iI]”]1‚äWä˜g?@sÂùCßA\0S‹#D)Ì­¢7*ff±çÎK¦:þ vPÆÓ‘Õ¦Y(ö„Ï+„–vÜ\\,hùP°P`’’qCa³êÎ\ZH6AíYÄêätÎdVaFþ\"kš®4éOåLR(]Ñã“3{Þ¶‡ƒô™©jTf›¾¯ÉÎq¢—Œ£d…‚«¬5slìË”;½ôË3J‘×ùœ‚8ùœ,W¼Ø±‰B¯,È˜˜a‘ÊMÏe-®T	q½(‘8‡í•Ï–ÑQ³#|Šœ)¬„1zitš¥œO‰´{n[õ9f\næƒ€öÔ¹‡‘Ã©ÎNG:‰¥,”Ý½¨Ud`ƒYÃ—hEg!@êÑ£gm0jLø\rn\r4€|F÷¢Hiè.|þv0¬SÅ\0mDÙË ®EƒSü]?ËÊØ\\•D˜=y}s<[Ì+Ûòuê~\0¬Š²fUu‘WzX#	FMŸÄhh†Å÷XŒLéšgbžý}£º‘¿K[\rXvLÜêÀÖcU¦Xwß‡#>Òd7KãDÞJ9^Á]2­Ypø¨ð3¸ÛÍF‰Ð\0X3˜Y&ð!Î§ÌndŽ“= ÷$ ÉÅ»™Q)€˜Ý›¢`až­¯G^þ/eªçîÈý¨*]s./Ûéêž“¨Y¤pšc¨Ai¤8À2¨?£{-¥ð=‘ûÐÏÃuÄ„#E`Ò¶‡ÑRž×#7\rà#Øzð©Íïg&Ë	¾ØÐ²„‡¡t\r~Ë•Û;­ç¦—\'¼Ø$Îõérw]˜u©¾iÓ“É¹Òf€j–ÁØ,	ùë(7âÇQ\'q5o\"_|‘òÁü€eò²+\rB\'-Au…2©(¸Ædó†cSÆÅóáœø»˜_çggúÍ3“”òæ–ÆƒTy(©b}lõÛÖöP\Zï´œë­á”ž‡l¬«\\ï¬>nG“iE(ª*\0,ª)ìÒð={]„Ÿri2\Zˆ–ã¢×KìUËüÇîëÝÏVK©®5oH~­‚RwÍVkH37™„¶‘áCO\"³­\nXFS£\"Ü@¢¹’;š\'™ŽŽOvÍaW1Øø¦’up|^.–…½0/Ólð@û˜­ùuƒCeoÞ9÷®ÊX´Ò\n¿ˆÍL+MÎëkM:þÖ®‹©·ÚÚ:…ÌìØ0qégÑÎéFGÅ¯¥ÚA\nŠU³GVúØ9W8\\ñƒ0Ñ#q2LÜ‘4²³ƒµ€÷„Àƒ‰…ÉH@À_`Nx’Jï”BÁ1`V<öP&èÀLJf0÷¢›‘bÑr2¨BÿHU„É9Ž&ŒÆ%ZÞKÂ9ý#˜Ì÷ódÅdÒG…ƒ[ŽðŒôi¤³€Q}¢QÔ*ªµå;$—fŽO€¦i”òÈ‡•…Ö”ÏàoŽëŽÌoæ¢$ I8Íkµâi$ÕÈ¡®\Z2LZ9Þ%BygbcyJ´u]›ÌÏØˆ¹/™è$ýæsäßü »ó†ýZÑ€¤XþãZHÚ…ÚüVR¨LÅí¶JÆ{?’^ñé‘ß†ã}csØž<ûxnm(e„h+c§ºÂ%ÆÄÆ“ŒË›M%\'u,ºV­¨úÙ\nvN5ª\0VMDãŒ×¼Ë.37__5;½–•‡UiñFG§ª^¤\'*`VdJ§‹ŽTt{ÑÍ+/#ÀŒÿ8Z)f¨*Xñoµ{ÊŸjz·ô°Ø±Óa«VvÓKŽœË”ÂGØ)°ªa£°÷^@C<:	ãø×ääõÉ8wµÖýÍÈ¥\"ü.ùcò¢fíöúF]•å`g3h$tŽUwÈuã8ea“ýŽ¾;×¦±ÉÐº…î´!¨<&HåïJéhœôìôÈÕlÒÈ3¹	yÛ¤EtooGÅÓDI:tß@‚h|‘¢ÁµR\"¤¤Xò»R)‚ÉûZ¤¢Da?é<kÃEÑÜ¾²êðUýá<\0™ÇgyfäbaEwç0;5a¬¤ý¤ŸøáØ$Zò£\ZO;¥>Ñ·Ñ¨žoXIópS•y‰bjO@ì<üa|)î*V;L‹k—dK˜J/À$tæ½]\\·Y4€èÿïnn=ä9_Ó}§ß—òƒ”*ÖÖ”PŠv<ýÔÊLœ·¶I«3\0‹zC´ý;G1ÜhOŸœu˜³¶=è·uŒ‚*)Mðz“·«ù–“¹¤êfïµdÆdÀ2T@«æ¥ß·ÕS]9~†sx¿ë·æs6\rÂ\0«Ú«^È9ÍªfÞ½øŒPØÒ!=A§ÑvAWHh‹ÌeštEþ´‚‹¢[EÖ†e«¯ûû€ŠâÝëâá¼ßWæ«„Ä¯d/ÛxLÄ(òrØÕNONBwuHÂ×ø/Æ4½k«ó‡pÃ¢p.“¼‰yFäP…Ò¡”Ê±š\'â.v^€œ‰ºL›‘,z“;tfòò™Émdº‡fTFÇ·mLHþa®1uY†ûÉMÕÌ€®È;m{\'X-ž!ÕÍ©FàÁÒ—	ˆ£\\žÌ÷\nÙ\0Õ/² Ó¹lŠ^\' ™¶jaÚ¹Àarœ’;”þËp “2o+è¡¶\n¨ÃŒ”©~$Ê›Ø@!¼/†NcD$UÆÜò\"œF7!ÙÂÄ|”\0¬È\nGB(@¸\'V\rà1>šgR0ÿ!%K6³í-•ŠiJ“^ï-ÕE<6Úð.¢A™ñdÏ£«E:…\ZùÎfRdøèóß€\Z0×Ž)ãP£›€ºÑ_×÷¬½Ãã(ßy˜´]À\rÞJÈ\0¡µ–©8\\“Óˆ*{2ð;|}±.LDü·Mýê§®æeµläZI6g1¦TFçõÈwMn|ÞJ:ü<}¬…¦{eVõ]ä3\ZšÑ|hâÂN*íti7ìÄQ#~AÛÜÕ¶õdðÂ7Ý¬èo‡»ÄâŸ™.ºÀN’Áì LóÜ|Dj¤ ¤<Ö8ÚFWŠÊ,\\Å×Äçî²Ð·§‹›<,|_ÔÙœÄwcª»×JÑ3¿.&÷<™D·`^‡µØWÅ.ªÍæ“‰˜ÊfçÕÐ4\ZouµQûúœe&\np9Úƒ4·+qT&²S\rùbä#-|”2/ãY›Åò™DéT·_³ú(êk\0ßpl\ZøÙ.|šä{-flODûž¢­X03¿¯Çs\0âöë†Qrß¡we,‘«¹­|7h,\\o€øíGâ!ÝÓ‹öcé_aáñ^¤¢Ö3šE:ê¢ü& @­€%W¾¬½öøÙÓ`€ùÆ†Ò(ÉYÛÜP<QZ©ôûR&ÝìÚîþ¡Îƒ¾<f~‰düŒkX‘!n@YÜK>³jryW2àïy­×õÂ¿Ø¥vÐc^_«xáqªlLS,™žÞ êk1éz]š³œïë±û\"+»©&¯Uõ aLÙRªN+ŽZ«6¢ð€øF_c=¬:È¾‘®mì{1eõ ñ`»\0¼@}ƒ®Ï^”EPŽ…Þ]iÈ·Æb†ÙÀ²æ“6‡ÿËG;ÀF;€1ßIGµÌÎ7¹\0C1ÀìUÌiú 6Ä¿wT\ZBÇù†\0N\ZZsr»îCœe–akƒ†Òÿ%ÁœÊèj$‚ªýùÃL¬JI‘QIšNîH¥àGfgª¦R`kS‹g…ŸOc‹”‹FsguDPÑõtÖšÚ/üY)ZÇ1¼ÙðGC=¿Ì&	À\\u.ü4©RË!zÇy4¹lÍÂ%±”`^€+xº‹{ù‘mÐzÁ¬8æŠŽæùZô”‰œ~2Eò‡ePÉÑÞ`ZQ…€¿°g“	M£™ˆüx©efH$c\"åÄéÞß,œôø»´éï w½ÚöŽƒ	Â0ç­íïl« \Z9e)Ýuëµá±ðX×MßcR7Þ³é\rÅs¸bˆç¶?ïczMš…}\rb` é´Ÿ 2-ÿ»‚Oà‹ôŒ®:Nî‡FJQu+&¦ÄLu´‘½z\rXL¶\'¢ÏYÍF£qµ¯è¤<ØZxivj±;Q5p˜/8_WV˜rìz¨7°ÄbÆ™ýîõ+5EEy¥7“/K\n8zqÐ’\rO>Îô^…¯LÖõ‡Ûc±àK¡¼„Öë3Bß°:½(¥ƒñ$ÎC’W~\"þž=H»‰ŸˆÆSÀÄs˜`¢…^Çyû`@ÃC–\"ÑÅ™ 6 l†–x‡G`Âì…‰ÐdŠÅï]WÉ9¦fÎ|·>w>Ï¸ø^Ìh¼	ÚXEÒ\'™ÞarÈÄ”Ÿ5üK^ÎÙ	m°ˆ€Öó«Ž:FuXŽ;>5†€Tfì¯®Ëi\r^¾N5yp¥ºÓ`<lŠ´\\R¦j\ZS¤Sž÷Éß²jkl$+‘Ö@¤µÒ½]Zn·þÖ°í1Œ<0\0zk°Õvß,=ëÉ};ÜÛmë¤”èù-“F\r.u3¯Ì©Z5^ÛuÝ¼¾*Û2¼+aYliîw­\"?\'Ž¡Í$]EÆcVýpEÞVßdEV!ç<§þ‰EfJ•I^| wÈî\0ÖÖ&aðj;ûZ<ÙMY+VÔ¯ ,…Rˆ@l}eAo\n~”ŽD˜[ß•æÆC»8;U]áèâ¢ÝŒÎÕì¦$²ð)Ïá;P|²¤åÈ¿›¤op†ŠSÖ¢xñà£™êõèJŸÅ9\r°È”ëG(RdzéÖŒv`Äñ0GQÐ¤@\0b!mK^Uö”3ý^Ç#Zˆc]ÌO¾CÌH–Y¦g(i6Ÿ%{]I¨Ž+E\"‹3-ÂÎz?Oo<ò‰8S}#\ZCx~™µ‹½Ì™SÁv\\ˆI¦n>©s¥ÈÙz´ôR‰M*gÚwÃgÕ„”{¡›²‚ñl‰0FÁ2Ï\"*2(‹Ñæ¡ÚÆE¥¾DÀ Ê‡2üŸà\n¬‘|¬H2¦ L\\‘áHƒ\0ô•<‰ÚÑº	sTžf! ¥èá€¤ÒAÛÞÝ×¹‡;Ã¶»¿/’ž‡;{ÁL©€¸½m‡ÿIkl!ž°X‹fºf7›h‹jÒyÓwª‰-¶®»š‡U™³×µÌ*nø¹ûµŠÆ­eŠŸ}pïR•F¾Çœ„ê\rÙÜªàd†å×˜ÐQ‹Žw·œò­híÝPØôƒÔZBƒŽ¹\"¿oÒ;Ã‡Ø o¾2IÙÐm.Ô\nÂôÀd`ÞK¥D&cÐM2åfÝ	Ôšëôm]ž¶«‹sù(“¡³0uw˜„’Œi¾ûáÚd6dÄqaâ1±™ÐøÍ\"YQh.³‚HàîÞŽ\"|\0Åµá‹ê·Ý]º<£ú@ôêA ¦{Åq=ØR£NåÄ­­¤‚(x;‹ÚÅ•¸6\"rîÓÈiÉÆ§*+2\0tÉ¬Éh»¶|÷±›/&jCt¬ŒmÀÔÚù’ÌY]‘¼ŒÆÂu»_¡wW~+ˆ£f±ú	LIh¥dÂ¯šb\02‹DÓð?;²Œpˆ÷in¯Ñù\'º7Gº|05+¶^eìrÞ€¢Ã•yz¡Þ‘šô*1¢þèñ}ŽG¯ÇÀÐö-d˜Õé(Ë­ˆ@Ë/H­dv8‚eLØÜÚj›(3ìî)B8 ‰íf(_I\\Wž•áãTMêÝ¸íï%`k6©ëåCkÀk¿§Ì´ªÏ±ºkÌ¬ÄÄ;Ž};èùŒY/óÅëÕ@(ë+Ùõ£+Ë9«zí+68ùÆëXid5±ðÕ‰Çƒ´¼í²BÒ³\"v¤WÎƒUýT¾\nžÐ|×à¨Ï§à›î*V}Àú ¥\0É–´H+€ñlÐ¾ýöF›Qj`ÁŽo/Ûõå…²ÛeÀ.BE”Œs&+õePwÆ°`<cñ…2ï©Uy¿ÅF»ŸNäl—Sz†\Z\Zô°	ù2†½NäLcžu€¼f‹{!T/?›D£sL¦pæ‡OÊ\n±\ZoéËGž–Í=FÈ&“öo5FÈäÌ™Pn©âºd:Ë×ôœ>cÁ±¼ó{\"›…É±/Ù¥¤#6¬Š(#>ÇIô³c\\C~‚eÆ-ðìˆò²ðæg:ÛCà0KŒhZ‘…Ô?´ÏÒ…J«|Zìi¨RKr´<±Uç÷³%/œî™“U<o§ë°9hÞãƒÄB‚§¿ÙŽŸ<U\"éF &‘¿Êæv?oÃÝ`XÚÈùÚê°Ô #…ý<¶>¼éûÙÀLNn<‡ú¯Wçûä:øw5?+«ú{’™Ÿ>Mƒ—ðÕ‚Z\\&¡/Ði	¾®ÉWªE½ž¾ƒ[0˜ð±p\"öe|ˆúÕóµáÃŠd¿÷Å=y}s¾yÏVMÝÊ}0‘ÈöÁhˆâX%ÀºE–žrø<®.\0¥q;??k7êØr\'‰ÁÖº’EiF€Iˆ9€Ós_qýÙ@ôîz¤	Í$g<\"ïf.°ù›üØ\r&)´.êôB¥ÀR¾ê²’izøÎcJð¾¦Y†éñkà´‡¨ÝKUÁGl\"2‡Ô•:ÃÙB¹¨fLFtæ]ü¤°à\nãLoðf¨ôŒ4©=î07›ž¼uáh~¨ÃB‚ašzº>i?Qh½\Z¾¤I¤xnÅ|(\"ÇV±xÖeêÅTQ¼Ô`td®{kH9f‡ÏÕÓ¦¼¬÷M¤e{*/þH‰ÂuçÎÉÙ>³[Ï–yqE¥Bè¢Éu€Œ*tÂ\0\'4á‡ƒ¶5Ø–:ÑÄ£ã£vrq)­¬þ`[‚‚¬^“þsQµ °<ÿ¯¹\nu37 ùw—´Ôà	Ÿ‰\0CŒ½7›ô9ß¤£b‰çŽÆ?kýZe~ZËÎÃòâñd5Š.gâÒææ`r6¦ðÛy3\\l³‡ð*²¸ü°ÐDaóâ*`y¢zp=`Àò®eòn^Å€f†W„Ù\\wGÑà-ÌÝh´jo¢·È*gb©ÿ¹õ¤Ë>ººh½y´ gÃºîÃÔÃ \r=çƒaÆÖâFž††§É¬lòyñ;qp€ÿb+rˆ ûÜÂwdÀ3IÙq××ûš€ª[K‡4=˜T,$ÕH:X!í‡¼Ó#	¶$éáÔ»âyÙÁî’ªûì¨ÉÛ²ADöÇ‹lø`tžˆ,r×.XjY@†Y#Èbåº\r6^XZi&©žw6oSòãRâaÀJ`8µ*ªëSº&ï]`™Á\0Í5\Zá3”»d±{/Ufå·\nybœìäŠÉ¦¶X€[$©âó\\n°œ?µð3u€9s—@*ªÎâvÌo¾oÆþ­‡Ðb#*Šªèö°\r·we\Zîî8‘¢áYŸ_ÚÖÖŽ´²ž>}\ZY²óynn´-ºê¨<kYäìµe€‰ûŽ5YYTlK%Ï¬·$]ÂQ×.ßq\r¬7-onÝ5ÎõäŒ¾ÆJ0XÕ|3B\ZÙº´Ñ¨ì³˜œÑTy®…n0¢fóJnÖyX¾ÿö€|ÌÎ|ñ5ÃÛƒZ‚Êßó€˜-Ö›öCð½h‘IG‰\\›¹|XŽÂ°Hò{ûöD‹Q	šS%Ž(8¾»iý\rvàžº=Ã¾ð_%Äù=¹½Ø2ÉÃRƒOŠ’³lƒ…†.&&cAZ€Ea+çBFYI³)Q¼½=PÎ\rï± }ƒPþáñgâÊÜMÝs€ÃyQÈWÐ *\"ÿLãŸ>Cµ=S¯D\"‡1yÈáÊEˆþ‚…åuÕ æ–‹ñ÷FÁg–Q¼`udmû3Ž¼åØ\'ñý*‰¢„AâîX,”ŽÊB‰ô92ƒ‰‡ŠÅÍñ}\\•ã¬¦#}QNõ0=ÃD¡Ý–˜©˜m0ÐÏ‘ûRº^¦#,’uÓ´‡ýF×š\0iïÓým´;VÌ„ý¸BJ«øfÏOÏmm]9X4½½Ÿ7UÑ|çþ´=ÌÛþÁ±|YÈÓ¨ž“vfäjm¬)$Ç¹\0\0 \0IDAT­Á«Ërü<*“òz5°ˆªI×õ\'™UysY¤’\r×ç^Ð¦Ÿ¯ËëÐs¥bŽAu^ÖÃª&SEãJýïj:ú†ªcÍuxº IÔF›/n¬ª5øF+J›Vôç†*öu2XòÉdA­ww”wzX—ò\Z˜ç‘%lJK[k`5úÞÜ·«›±€ÑŸ¾ÿ®¼mk´_\rŸçÇ4ÄÑŽƒœëãß·ÔáÿIEœÛ˜ŠzøäßììÈ9Ëcq-“û6ºÉd“ì6¾/òª9S)\r\rjé\Z¼Ùå1¼H³P4+ûÆÄA}âAæ¦LHý;\0,6Ý`]Öº¿GÓ+3Åúà¢ð˜H¡ÆÊož/P‘ÕlP[Ÿ)l)dã{jË\"x±ÁyA˜µsß2“èl”¸6ÅLZ„a‰­KR˜$ØhÒ!ðV­`è]Å‚•˜çm%Zo©v4P\0¥ÏEâhO‰·•ŒFV1¥à86K\'Ñ†àêz0sJµ–!iW¾ØQ´s£Þ“{²@k5>x®íyZˆ!¥ŒjÃºæÆ¾ÚÍ±Í@Ô?{ÖŽµÌO‚[}RZ$›¼”¯NîÊn¼Ö\ru-ÖÍ¿ZZ•L`“9›tt§nZIžµ7‘\n’þ®×k=]«õ°|áõª[QÙŒÌ7^O¯½_Ù¯…ëÎÏÚÅ²=µoÔàc¶ä›ã}e§ËïsMÕæÁîF~¾·z\\P6Žk{\\4žN9˜^Ó‡öêåOíâÝ[ÉÊø$¥ëƒM±¨ñQp,é\\N×#µ«çß\0»-ÀÂ®èàCè[gÉIkbdwè1‘c”?6¡7@Áå<³†ÚåPºI*nfñ+Â#zhäO)ÄŸ;~8‡#©¶\"Ñ7…Øq¸‡ åÒ(;¡“šX`Æp-Äˆ–š9<o0ðîéÝ”1Ò|J\n*¦DÃ”>Ò,i²ÜFMi21~^Ý9£9ˆÿgeMs%$…Ão#òu©__,\"¨+p]îÑ(G}:àŸ\'š‰¹H	“ÄÃ_ƒ¯Z#‘êu©Ëy\ZË~Ø™}[QsÊØÁ¾®)¿ÒycC:<:n›ƒ¢Õ”\'ÎjÁ¶2o»;ûí“Ï>k›}Õ§ò\\h2Ë±¶PrU„0‚(¾>¯oæ•Ô\r½Z#ÀŒ•uu¥§’?ã‰íUÂdòÑµüt^gºWû±U—™ø¾Š\\FÑ˜a\ZÚú~#Õ.-ì\"|ÝâFKªz~M¬R^‘Ý7]mï.(ÉtIŠß«“Ï÷4¯´ûÞj»8=m\'o_µd‡GWí†©«ËÐ|¢D#óoÐ?Ò¸õzíêœ¢éM\Z:	4,&~äkJÄs­QŽ3Qï¹ž´ºÂ×Ež×ëÀ…™Âp\'ÌG•pX*†ˆ»<kFþ(ô©b)?è¨$up`Ú¬=Œ1ÿ\"›=òÐBçÊžÌ+•¦©‰Œã0ö€§óŽê3­TÞæ£˜y6gõûÑq¹Û:Âä±	”ŠEl§¹ç¿ídçxô\\ÜÝÙ~ˆ­Ò<œ¦¹Ÿ!tØÊbÑ=D©EÐPƒçZäté:aª©Œô	Ò,Ä…æQ=±`PŒgË±\" 0£âÙ€¢öAõÍrc#@¥öv‚–Zöˆ”Æû ­°õ’èÆÙ¿±Õ—âéÑá£vüäÉ¢KÒÑá¡˜7\ZlÌ3®¶U7ëºÑ› ,vD5ò‹Ÿy]þóÊcd×]Çõ8uœª‰ØµŽü·­ ƒ®æ±Ë\'ª»˜oÐ µ˜d¥`¹\"¦ÍBv-3&`ì¾Á†ìt_L†Ì’®ìHf@‰8ðýZò`°4`uSL \'LµÃ,ðgüw°=¡5mµÝ>ÌÚÙ»wò[Mè|ruÑæ´ßŒœ*ùUîîÚóÊ¥R	ÆXµ{fƒ^Ô—Ï<zô(‹Ž#K`æÚˆ2b2ý³ò—Ê²¸¥>ý\nûÁ4Öé“Ãÿ„¿Myd9Ë<0ß¢aš˜f‡&‡çÉ)ÂD5Ów(¦uÕ\\#o$uCÐ.-§u2ó¿uJÄt¸ÞÕý¼ü¬<ùÛŽyƒ½÷¢óŽõô›éXŠzÆ3WóQuÆ-v\"ž½•ÔéJ-$Ý\'~¬0‰Ü©ŠFù^›Qœ,ý¬5VK!Ò·ìÏ9\\\Z8ÖcãËT¿¹Y’lE¨È>Mk\nÂW7újÀµÙ†{»íéGÏÛñÑcU/p<X®üŽÃ­-ý?{ ˆ±l·WAÁëØÀSçº×¡_3ñ¨Ö×AÏà¹m02¦˜}×óÔçÝ=¿ÿ®€åuÚûê«¯Þ“—ñMÔ…nsáT/«|fX¼„ˆà¸‘ªÍ¶\nxÕ”ó`pü\Z]1ØTõy=Øuáø8¾æòZ—®5¤>`¦ýÙå•ô°0Ò./NÛ›7¯Ûp«/YZr®H]^eÄ-T8—\Z°&àrìzk½ôÍ¬­‰9a.ú3Žùþü›	CÂ©üY‹n1è$…©2¤kËFDY¡J¢DP0õ§`q™ƒ$vÞ í<j›Ê-\n€ŠÝŒ$Ù\0\'VÀ‚aÕ]¶;ù4\'H3 aXÑµ0ÉìûT£ÔL\"T¾ZÎ\'?›äuwçX ×è…À¿\rZû{ûa®Q7´˜Ä¡bA“\rÆ•ïÁ†‘áÁ—¨„Pr›6úºÖ¶‰†$jD¢\\ALð\0)X*lŒ\rY~Gj4³ã\n÷Æg$E•26ZìR©\rM46E\rÕ2üšljÞ€aazþ	ˆTY ‹Ås¥4	£Û{ûí7Ÿ¡{¹ÎŽà$*ã>Øêoµ-\n¥%o@ê5XAÊ|µ¤þ%ÐX\0…ÓeÒ}á5f¶[¿oLèž¿®Oo:¾w“ž©çÇ©kRkùë¯¿^H$W¶QoÔ¶¤/Î»žÕv¹È\"·¦R9ØJ=\0[<Í9ƒ \'©ó442·C>\"J²‹‹MO\\CÖ­ÕìÒÙ\nŽ•-†!ùú`|H–ûÕõm;9y5cTT#óßyM˜RLšìžÂ¤¤Æðêú¢m®o¨o¡Ç\rÀ²ä‰Ì¡•%r~î“Ü«:©d2žÊ/(Ç(í»9EÌ,2tÀ]¦\"\rue¦­“å>£yÜ×ªäÑI”áfAZ?NQa1ÁÂäPç£8æ´8<Ñ<Ã…¹†%E“Ç6Í-?§EÀ$•¿fi8‹ë1]$¬r\'G5I¹¹Õ= ±>ìTtí­\'+uÛùrâsøqâ3Ç\0‚èã·lm¶†Êg*:hc\ZR-“œFM\0§Z@²TÒ¬\r Ð²\nýyw¢_ ÌÂPô EeZÎ¾§Çá4¤²¹–ñ8zÏ{&?Œ(á“gÏÛ\Z¬#œòý~»8=kGG‡mog\'šRHØ0Ìµ®5á9èçç¨£ç¾×”ÁÂfŸ¿çÏ×uæ÷ŒÞP\rPõ}³&Ï‹ú™J&`Þ{Ìšm¾*’\Z€8^èõ€ÝîÇë5ìLÃ‹š‡ÕeB¾1©¶“ï¼›ú!TÚÚ,3«z¬\n¬Ýçå‡ìÁç7“{t;ngçgjÑE–9¢xìlçg\'2‰\\ÔÜ…_gÒÞ¾z¥´„ÑÕuªÆ¸¬­„Ù¢Õªõ\rÈmö8‘ÐbzÈ‡#<šPºû]lè,M4	E»Aƒ\ZMP69KÒU*åGÒº‚ W¯È0—ì]˜f<€‹0ºÑÄX6éÀ;oÏæž7/ÌBŒ$6=§Å¹Ã\\7ïÈ•Ç²wzÑòÚ5°4‰³”ç†ì0bw¤•ø^£Ê\"´²t-™U­È5`¬àÏFiR;ŒÏÙ·&\r-™³ôZL¹b‚\'ø±ˆ$€åÞíä÷¦LOGæ×àDQÔ<b\"Áó Óõ‡hï«LmwZ7ÚÑñ£6ØÝm;;»mgoOEÐJDŒÛöpØŽö´¡ã~ÿå&\\×g]õYÔÍúC€ÄkN7ñÚô÷+›ò3÷Úóùüê¨X³`Æ%9¼Ks‚ZBß/TÆSQÐ a©»ž(&Æ2ãÕÎ83¬*/ã›4ðT3´;yÝæ‹Ý×;¯ØS¯KK»×h€®×àûïÚÜD…ÈGâöÍ›wÚÝöä¸¾”@Jñåù™ü8>•{õ0UéÎÙÉ‰^Ço!ÀZf¨¾~~Ã\n¸g\'r\rœG…¸ê?Gaó²ÛÌ÷Éoqä‡F8ÇØÄ”Qb(~ª(õ°–\0Ï\"	ÖØÂ°báø3øêCÐ\rVepóõnp‹œ­¨<ðsÖvvzê¯kÎX*¹$z×ôó¬“³nŽŠr*Í$Jr¢octºæ:)b3œR@šHDî‚‘6ù¯”G…™I•Ê…ÏT§*8¢\ZPZÅGêChþ/ë	å×\\21Ö©1ÁÔì‘uÆ?îÒ:Ëò)ÆÌ>K>7y ¿,Tn¥NAš\n¾²TEÄïùG©‹ô¢5Ý=M16ÛÎpØ}6µI(vdR¬7n›Vu“¯ãïkõçÍÀø|×UâufÜðØzMñÛÇ«›‘íyTö•@TÖeßò@,ƒ”9\"IË¨Ù†OîÝÔ“ª¢wœØù/ËÎ–ºp­WÔn½ŸQ[M;¿™gggVâDÕz“]p­NôÊäüÀ*ƒ2˜y×¯¬LÔ9âéC»º¾QëqvdÌ6®!¿ó“e Ÿ¾i4J%©”Òía®U_ˆ¯(²Úý$9W\0”ÂÝé”õÃgr/J˜¦Ñö<s8¥Ê`G3ýÿ`X8fÝðÀ‚9)÷¢k2Ã‹h›f¡R+‰þÉ¤ÅQXüYÎ#\0”õ,²÷ Œ;Èã(\0N?Ô¢žŽ“ByNäÔ³MßÛÂ•Ú]žøµÞ°Î?ÀV‚yý¼ùŽý?\'…æ\0–`SŠâ¥Ó_‰À`ƒ9Æ¦ª\\ÔT4µ³Ü)ÁÈBóÓœ1RÔÕZ•\Zø­rZ4ØÈ6\"	®›Vgjœ›%8Ü¿Ô<j$“y1£Ð<”LIc \n€ûYïÚCo®Ü,ÒaŽèI˜b…¸	ö÷vÓÑ>k–ßôaÙó±‰Á¤®\Z ãu³(‹B+	ð<5ø¸:ƒ“«ûzÅ”J8ü¹º‰ù³šsèay72\0ÙÉ^®/¨ÒÆŠ”^ôq.yˆ‰ÂÃ’JVš2fY]Pôyß»À,†•|0ýõR+§K7«­]wu\0üïº“wSAÙ‹Å‡3¿ÂõÍ­Âþô©ãšÞüúJu[è^!™Ì½Â´Hÿc÷_ïõÚùé‰®j%®†Ö=…{{M–âü&¤c0ýìËX%è ˆù&Güi™-¥5(gHME×d*haöæÊ¤¨þ!@	‚Jê$@@¥B8…éÆs¯f©‹‰=†­8rÕi™šÌ²Ÿaaú}™ƒøˆ(àÎBë`<)AœÏÕf—}Zöaz“‘Ï	SAÒ%\n)‚†r&ÇHD˜¦Î\"‚¢8*)\n3“¶X²c~i>)\'X™êø’ÑjcÎ¤TR#¤KŸ\rÿHTU¯åÌŒ—i\'Î4Œ6hSîQ>]ûby]yz7Ñé@ž‘ú#ÑA5ÅTn&èöÞ®6¤Þújô0Ü¤³Î@MSif‚rìl\n³\nµ\rùù2¬ŠAÀëàŸ0ûý<ýlüy3éîqŒ^;‹û.fie]~¶Õ- ñ+’TÚLJ›2³Á÷ºæT\Z^)_6å7“1Øx@$ï9J‹¢&Ÿs‘î¾ÑŠ°õ5€C¾ìP>OµJgýºÅQû^*³¬`æï.ÍÙ&G-ò2t€V{tšÌÚåù…tÉ\'£›v¸·Ý~øþ5¬€IÑdÑ¸;³äFBòØ;”œ¯™³0ð¿²ÅÉ¾ž†B‚³wB\"‹\\Ç¡lÃÅ¸±ë§À²ÏÑcºÍ®ÌË\Z1l$ÀG;\'É¯”	!x‡¢TM—\rj5Þ©÷l)Âò¼ÎßÕUàskã!ÁU‰,%‘!AÚþ/orvô«PÎþ^(+¨óOtÛ¡/$€¬¤Í•Ð,×$~HI—‡ˆ.Éa¸f\nC¨…Fé?j5–%7¡,£VP5Ë#=s2dm¸†\0³0	†æW[q«íòÐÎ÷ÆXÇH\rC21V‘ÃAFqbu3ôé1þñ›‰9“c·ÑoÛHÌ LqßŠi÷7×UReÆkÁsØsÇk»šq^kÕê0Øx}{xúøöµú»]ŽŸm%\0G|[kïmjiJ×õoµ–ÑÌàã‹è².úæýù\nj•qq3üÏƒàÄì^|þœo `5ÕœÃâk]ì¢<.“˜¯ÑÇâ}›.LÎÊùN½‡…‰šQ!¢M¤T’ x¯F½FGÚëm6¹m/^ü(\'(\ZXç§ïB¢¶Á¢ÈÖôîË(“2•TI*\Z-Ã~Ë0¯Y©jërÑjßôµ8­^Éw¾1æAçQ|íÉLÔN—ÙÕÁØâ3*ç‘ð`¨b0ÑÝ,¤ú\Z\"é4r²œ›ãgl\"ÚL¹±ã»HÅÈ‰èÉÉë^¼þœ7\0ká¿P³è\0?-ä•õx†*Â^š¨Ü¥9Ruçh1ª ÑœaŠBª¾³,Î›ª˜àJ€žœà21IÌÝP¤0æj¨6ô(áIß¤R.¤›ÚiÌ=G=}_5ƒãÈüSgìUuè¾AÃŸ(ºš¨®ÈÕï[¸£³ìŽÖž>~Ôv†5žp½§×Põ9Õùm–S‰IeYuã÷õVP3Ë©Ÿ³/;Æ,|vuí×õ]ËØÂ÷ùž™µ×u½î:ÿX>IwñVÊ¦Ý)Sºh[‘ÐH[™’#IÒíIuM#wel´*Ããû¦ÒÉ?dîu«š~`—õø˜u÷ñqŒìêÛ2‹º¼;\nV1C\"ÖßÎß¼SO¸·¯^¶‹sÌ?ä’™Œ¡<ª°æ;êä^ZOÖ;à‚}wr–ÊAN^©K3¡[[‹²&ûÿP§\\—Æwä1æá(·‰²uzNá¾h¶%D\0ÿK”ŠË‹x=ÿÃÁ Òò¸aº ¨Š¤nM¯gT¼¼ÛéOFSçŠZ%ËR÷E×\"Œ\\§åâ‰M%ØººÊüa)ŸlÍÌ${PÎæ¯JgTwHÇ˜HÀÿ¨ÄÚ­~<R\'´f@çQttY5!F•æµç=²ÙJH°Sóù·RÕ!ûsJßÚÅÌñ¦Í=zÃd¾ñož}¤ZLÛ4•5\0-Æ—†H%?~c0½oÃA_‘ÁÞ,Ä1]ÞU7l›w0¯5–×[5½º\0çãymx7øxÓ©Îñº»˜RÉP»8ä¹ãûPªT¬Ù œ¼ÒÉzf;Ý›´/Ê7i€03À¤©N5ïB•ÑÕ›æu3;ã9‡ºš¡(«YÈñ|]õÕÝÆèÞ¥Õ\ZH¨\ZâOé©‡œZ?õVÚß~ÛÞ½úµ­÷æíòâLê\n8Ü‡Û[b`0%›0­Áö F;‹vuzz*ÿŠ2Sc^ÎlIÐ°èú\ncðehG\':\ZI)OHAvs» _™jI(¥¹FÔ*êFÄjtõ…	”1p0i§+Åƒü ×û°Š¨“åvÆNÙBv	6µkãƒ\n³Œûó3ªó*&uø$€Žh™æŒ|W\0.Lj‡ï-L¶ÐíB|‘(Ú`Ñ)G>´ôÁyÁ*Ñ3Ê›þ#³mlpdJÎ’IèÙàc)™õšo«‘p*ŸW-[Sº‘Ùè4ÎA40Š¢ï£P|uEŠ\r”n\rð‘ÞÞ¨æø+7úíøÑã¨Ý$\Z<½—³}cµ§ª„E³Û\\8u£°Ij6S«‚jw×µQýVu½ÙEÓý®ÇÖcPŸ©?ë5\\}e]¯ßÓ±Èt¯¦`5ó*…ÔdÍ|“®)ÈAkØÔ b UÎbgÜ>,Ÿ×l«~Ï Âkü8ì„Tˆ‘Ý ¨”~œz_6÷ÊhŽ£5¹‚¶A“î&\nË«Ä†_=í„4&ÀiýÃ7_·7/~mkí¡½;y#p¥ƒòÁá^(_Îæ$&æÁÁaÛßf™ZPwcu&‹ÞLÆJ¤Ž*Mäó^Øüæš%ô—©áœŽˆª|Y,ŒÔHWú‚|O÷Ë†ðÌ)Ú±ß…ã¿ga¾ÒzÞ“‹cEt–ð‡Ù?â1çøfÓ€—îƒñ]ÌþHí)© âr{­ÒùÚ÷d6BJ\\†….éèlÂ©!àaÃ_%õ…ÔYî0å0¯4Ÿ°Ìœ´°ñb­DÙŽÏšç…Ô\Zæh¤Jð7ÎqE.W£¦ÐŒÐ¥GöaiÝØ¹Ÿ2Òæ¸MDÆæþ0qfŒ¸ÏÉ=Ì‹~˜ƒöì£)èîn®õƒÃ>J¸˜ËqÞlí\'¬à`\0îš„•(˜åTÓ®n„^—õ2>—AÆ&¤Ý?v·Ä†û¾Z­ÇÝëÐïÛª3™Xt~öâ¬ìÂ_2S±-YmÎ:e+½óÂáäÖÃòMÔïxw«ƒå]·*Žvme£ïÁ7WMZÓJ¯î\0b4éOñ„¬,,ÊlðÿÄhÑ”‚E€TÌ/ßßÎß¾mç\'oÛÕå™ØB4ûŒH r3ggçRSà=\0KúGw´•«Xÿ’s°d2h’‡‰Çøá÷ãßþŸëŒ†¡VêÅe0¼QDÁ¥3dÄÌ+ÄûÒTÅ¼ÊÂæúì_˜ïHœ¤_ÒÏßãYƒç‹7XQ‘§åã£ÙUwlÏ5ûFbÒ\'‹âe,çµïMÙüDøzQ¦”m|t:Xf¢T=‹’šê{	‡þ2QT\rI³ÀÃt[0%Á*)M„HŽµ?Of/\\/ÀOó\rÏ¢j®Ámû¯x“‡YÝ’d¼&–†SŸÓ£›;ÕîíîµO?û\\…ÚW—çíÑÑq;:Ø]4xñ]7_¯/¿g‡­\rÞ¯@²\0†Ž9ÛµbX~îÕšé²$Ï›J*êg|ÎŠž_Œ…	’Ö?ýÓ?-Js>È.DÉ—Y³ž|¦™]p0ÔdIFæuNîíºÀlË~ÈßÄq\\¦Ro¸ÞdV QÞ÷dÀòƒ«À\\¿ã¯ì!¿R˜ø®$¾2oRkøñ›oÛÅ»“öúÅÏmccµ,º0+êµºÒnTBÒS\ríÁPt\0„][	€Q@íI`…®T°&v]~Ü	Úl€…Ä5«MU:=õŒÈ]JéâxÔéfŸºìT#uÌ”æÕBšŒ]—=¡ë&à!J{b^Ô	U\'¾\'¸Œ®-»èxrºÙ—èEàg`VìîÓøé(ƒÁôÓ3Ó›e©=’HôôyÃç„s<ÂrÆgüb	Ãäõ†…KÌßÝ1é\n­2Cëi‘‘`ççX‰ye”0@3‚ÞLl5DNŒ#›ÌW£Ë(\'8È,¼¸¤{8mìwÚã§ÏÛF?D$?zþ¬=>:PÞUw^{Ãõü¯î?[3 ¶‚IwmU,0T†V×[—Éù»u½Õùå×ëq=Ö¾F–Á§–/tñÁNžDEb_X½q„#Bœƒ	ÀƒµDrw0+µ½Íy\\éÎƒöîäãw¯½RM®Ç”Òÿ¶éºp¦gB!ï›–z™=p.%ZÊGî¬´˜Ì\'oÞ¶ïÿé›öòçÚøúª´íívrííaF{ûíúŠºÀ­¶··ÛNÏÞÉ·eS˜ãËäMé_3¬Á Þ€”·Z”Çb‘Î{Jù0¦{~Ì²KßS-;Æ(NŽj-&CÑÎâßÙù™1rÎ›Ÿ‰Ïm)hÓzO8›‚~nžÄ.V•ü>)K³`_*\'ß›ÏÍw#*º4Ùa4ê¢£0†2¡´xù¥†Ü1~·xIJŸ‘Y[4¸lYÿç{’O2§ÌÓ°†ð`8Úc¬u=Éžô}	†þ¿àÂL$G®¤‚Ø„æûÒ@Cœ°æ6 ‡/ëú†^\0*éaþ ñN\'íáVûèùó¶¿3Ì¦©K]uQ÷yŽ°ìCª¬ÖëÚkš¿½†ê}úùùsuƒòùëç½þ¸†áç€¿ãu^ïA ë6_ÿEóÍõ*PÕ›Ó„ÉD¯Já|c6Oj«úz‘fD>ŽMFß¼ÖÞI0^\0 î\rÖÁ–y–Ò2^PÙîµøÞ–¯>»›ÃG§ýÝë7í«¿ÿÇvuzÒ®/ÏÛ»7¯ÒA¾©<\Z&È†”0ÇŠR_Èu`Nò>ãÅøœž)­@~¨Õžü`aŽ…Æ¾ µ¢JåVvav[ß—wpíÐ+Ë\"â(»‰°}ä|e‡g… çŠ\\jòf4ŸóóªÏØ•UO(/™•éçòäõØ\nðç!/í\rÃÏoe¾lšYwÖê÷¤Nóvó!‰±¥ì\rŠ©0`RHd²§„®Cþ’\0,-\Z%†Å×©¾ƒ05g²€Ùc\n`IW‹Tƒô·ÉÁoðÌDG,«\09@6µ×TÜ•mÅTé—úbQú:h˜~«ë1ü¿5¶·\'ï¢°_	ª«ms°ÝvÛÑÁ~ûèÙS5œH÷ÜƒJËKˆ¹[Ÿ—7}¯[¶²$‹×ee¿Ë\\v2ª¯Õ5TÙ–Ù¯ÝÇôßþ]Ÿ­‡÷¢„]j¦P$v_Å}aÝ›1U¶ÓÝþ1¸úšÍûw*óMTFäÁ¨\0h3Øy@Ì¨ü~õµÕA=t\"oYk‡\"ÀtÚÎ//Ûë—/Û×ÿømc¥×¾ÿöëöâÅ/ÊîþÝï~§î½D«n®GmggO@F‰Îµhÿ´íïEyj“ª=ðçdÕß+M‚šDA™4ÖTZÈšÖüð7ùADòjÀBNíì²ÃAP•?VL,Ò-¢.1³#?,diüÌ£©+Ÿ\r“TŸKR	ˆ\\z¬ã™D¶¸Êz\"sRLGµsWu&¾vY0ÕRDÐ> ÎÏ3w±ðbç†¡¥l1§S–z:ì£TH;¦LûŠ¢\0\0 \0IDATBmFÙð\nÉk5_•6Ø\\>\"›ëX\r®Hÿˆï“$j©lºÿ¨™$Q6½lÇ¥àñJä’)0\0ë’–¬$ÆÌº[¤cðu™­­gðkÑæE$ùö®M\"Í…gLÃÔºŠ«$‰&º[íèÑãvôø¸îí+Ã?rì8¿˜Y*Ã†¶üÒã\rÚM¢\n,uÞ×uÛÝÐÍ”*ÈTà3ðyý¹zM]«æ§­›z½Z§îKèE»˜°‰Æ>¡Á¡‹ ~ß@â	æ(EïV˜8¶ù»®.+qv™`½ï8›ŠšeäÐß7úÁùú?tš˜,ù±B íæ6Ú¿øéûöîÕ‹Ö_]iÿù?ý\'™_|ù…¢‚ÇOKÑa:Nínrnm›ŽÛ!\n‘©ÖÉõÂ¬1ÂïE9zË)²¶±Þú(2¨+p„µÈ¤=Ù÷\"ö´Ôb1k§&oÊüÉ€,´—´Ã¦$ÊlvŸRÉ¥ÿ`)\"öDÓ„Îš>?k›û1Ù#õCÒL3–ê\0®×~!\0,†RÏµ1ÎiôõÓ.›­ês0[}ù}¤©µèðoåB¼´4?\\t.=1Ìê(`&-…Ï3¦ÑQ\Zmý0[IcÐ¥nÐ=ÓTdC!N\\Œ½ù@bSñ¸-v˜{¾9îû(óñî&·ÐÃã£vq5j——×’”¡àþÓOÓv÷w•ƒÅ¦æ^’q~€-*ø,K=°×D]Ï›â&!´ÌrªßËì´ºg¼nMºxQqbñÜJéM5ëû^ŸÆ¥÷G½ËùË¾Éz•Á|]}3óšÞú†Ì°TÌ›\n_`—1Õã;JØ–÷wù€›\n¾u\'©;€Ù–wT›(Ý‡¬ÏÉ\\ÀŠþ…½v;™¶×oÞ´ï¾þªõf“vwyÙþþþ¾ýáhÿÝÿðß·÷Ç?ÆNÏ=Ò8U¼=Ì¯á«ÐÃ_CÞå;.=âu>`€ÑwnMæddZgï@i1ÁÂp8‡ëÄl8:âdË)I°d“Õ pŸÑL5\"vò›)/kYÂc òq¬5{êyõ³æsÞî‘`–éæ–vÿŒžéþ2	Ù&¢®;Xõüè^”:RI–˜¤õ•Ý“¸y¯äbÅ\\\nó‰m2UûÑ•Èà”Œ+jq°S0¾d$ýÍ˜ùQªï#]B:ôáÓAõ!Êv¢.ÔƒçŠ7F1Æ4a€JÅH?#×Š[SŸ†¸=”D<¾mýJ£[*ã\0‹küüóÏÅÜû¢7–ñ+LòÆDöZ©ÌÅk{°;¥»ÑWRà5©Í­hÎU°ë’ŒÊ¢êúô¿=*0z=šXÔã¿ç~ «Se<ÎÈuÇì£‚V@*’ús=¹ 3,£w’z3u‡²«‚X½žÅb*¹(5ÒçÈŒÆ»JI/\"›¤ËÝ1Ü»ìfjÃº›´/^¶ø¶µû»öê—ŸÛ?ÿÔþûoÕ\'îïþîïÔµ¿\n…©nÞ€¦Õ£GGZ8°°ë««6¦}9£³[0`¾=´ªëëíèð8vê•è:$·»hvaêìkµïg[àGYâé”O¢Ø–	­Ò5Š\r63£•Wþx£1ñ;SWÚj.Ž:Ñ}ïIæP(sJ¹!Ó3¼¡)%àa®ºLÆö8¡`Ûj³¨¡ÔBQ6|hˆ™è´H3ÍG÷ìÄâÕÈ÷rbªæd6–uD‘÷|«anMRab‘…Ï=`Z2Î0²`Q‘Ÿx-î[Èð±yná¿3{!zkÐ’Ðr*[ØÅæu{w#±¾þ`K\n!œ—–ô\0è_|©À\r>Md~˜“~ö¤Íp½ð6+ñ3­Žñ:ïý½ö½Æº|,“ïVÓ®bI(ÞxáïTË\'®;**è9÷R×‰IèIo€¨\'ê²¬ÅŒÎxÑøfêÂ©f0Ãb‚×ó¹ý ý]ˆÂþ©bZwŽ\nZ¥=¹}]Oä:P ¸>G6— Íté	­“zq)m¬›Ñe;}ý¢}÷O_µñtÚþÏÿëÿÖ ÿñÿÏ‚Yá@\'}€«€Èîî¶R5 ¡æÐ@¥…³º&éš\'O·Ýð[¹‹‰ëcRÞÞdáZš~Ð)2Dâ¨£<æ!ÝžÓ™{sKë±lå•RÈ³©vl1¯l½Î}ð·ÇRÇd‘¦¹i¦dÿ™wáX$¥fÇd ¾&ž™çÌÅ ãS¢ÌÀð‘ñLL@ËßsÎœÍ1q×D`K£*\n°c¼BžG¦*À³)ÁÚB=Bþ*Æ/ÍH;×Ñ¶RÑõì¡mõ‡rºÇµÓßÅµ±\0o°œþ©‡•ÍW¡•-”1<N\n–HVyÞÆ÷ù:/¯¯”ä‹6_gç—2Oq´°¸öÛþÞžzÚá¾Ü#Š©>±EÛÞkÜëÉ,ª‚„Ÿ£Ìß÷<0ÈUÆfÒá5é{«D¦~Æ ØµdAögý¬+ÙÕ6_s¢hAWô¬(éâ;f`ž@]p0Ô´ušÉ°RÊ. \ZÈœÚÀßuÐer•âJ3»`æ`€ª» ï\"µ|Äç\nP©`˜ÒÝdÚÞžµË«ëö0¹k/ú®ýðÝ·m°³Ûþ×ÿí—“ûüw’–¹ßIõS]q$>¸¢º@À]ñÓ““è|’`€.7)=>`sÉ\\\"ùbÐŠzCÌäuš¸.º…c˜{	S7²Ýñ£a–â\\Çå¬†žÈñ\"\"¨ñŒöó(KMTù‘$vYÄa2.ì¤„¤¬Å’Å5µÌ²tL¶yû&?*jþÞc°\Z×47R”/)½˜Ý•:“dÕG1Íu’55Ñ²MYÎ«`Aé„/R1·«H<Î|)ºà¨WtÎ78æc,UjA¼ôYÁº¤Tª±¿\"Ã¶Tzƒ¼KÊ,KÐPåE‘‘Ï8(GoFÀ	ßííHzkü–ÿŒR»{É[=~\"m÷\'O·ÇK©a\rÿ\Z›aæ;27Tk¨¢e!²×0ÃZ­ˆJLBþ]7•J¼V\r$þœÁÍkÊkÒ„§Fè»ÀçÌ÷QÏW×³ÎI-ae7õ&L¿?(õ ÛÅf]ˆÊ|‚1Äÿ•VzršŽúB=.þ•]>0WÒ/3©½³øš¦B:b=à¾#½¯Ã÷ÝX\"ðn|ßÞžœ¶ÛñD\r)Nß¼lW4¨Øè·ÿùßü/íúúªý‡ÿïß·9Ñ93Ç·øS3R¢{ëëíööF¡ì`:±à^–zäÎn;8Úo;»»!ÜÇBjLD\0x\0+ÂòKß\"‰é„Uâ*~“4	i\'ÅkDáÔž^•ò‘*q¾ÌW’?3ÃÝPC:M°»ÐJGŠó\'4ÇtŸE®h¡ï=…ÈDøHÂŒÈ$@ g&_R€’Ì•LÙàZpºûÙÉ·4*3¾Å<¥,,Ëk›\Z6ÒÓÑ(ä\\v÷\"}„¸ß¶íía›NÜ_0$‰WW#G$Q`\"³4MÅ„D	4‚‘I Ð„ÿ‹œ)ž¥râÒO†o,ia°ÍôFV~¤Æà#“¿š­Ü´W¯^IžˆqÖ¸aæÍZÛn·­Á°}üñÇÒo°ˆqX¶jbL¬›Z\\¥äÌkÖ UÉ7›]râg±`Æ±Ù¾Øt’=ËtN?™¿[YU=·¿ëû¨`éu¸XnU_AÆ_¨È\\¿èÅm ó{v`{R±Øì3º[&Å&¡Áß6ùÌ¼ªÍlEƒº˜>V{×àX ¹¾W_« m@¬÷S#²˜	?_î41¬‹“×m<\Zµ·g—íüŸþM{÷öuûÿþÿUgh²Çi\rF(Žov×›ÛÑ¢ÜF@=¶Ë‹Kæ NöÝý=i]ñšXìJ$ÞOB8ÊzðS…¹j\roV»|Ï­ºæmŠTMÊÆ\0Z‘eM)N8¦cÌ§‘øXL	.€\n¸	ìQÎ¼½•ïN5ÔjÁ­F.*±EÄïó™¿‰NÓ212ƒŸEíùBâç‚õâªÎë ¬€^7DÏ\r®›ò›Ø\\c±’ŠáE\0`ýúê×vpp¤ à?™NÂgv{×6¶HÊE8oSpª…+«ÑÍ(uØII`<Qnå³\0÷< +sé	èñlÈ¿ƒ]YÄvãHƒ~¼VüÜ09é*Î&„à#QCü¦h`)!eu­=zú´}òñÇ2Ó\nXKÐ\nÆê.UÃZMPM}¯\'¯ƒ™’×†Ÿç©ìŠ{1Ts®Z=Æ	3)ß»ÁÎÇ® Y™›¿/7™îfõÕîôÍøw]Ì>°™K.Œ×“Çæ£u–ê\r\ZLþ%6çâgÞ·½îëõõW0«(íA¯§‚í’E…ÄHõÇ-é+‘¸™|¤4Œïä— ?áÙÉ«6¢Eýl­ý·ó7íÅÏ?·¯ÿô§¶Ý_oWççíâì¤möIUvTÝF«züø¬p´bÞ1^Ð}@k¸»#§«Æ¼…Ï¥¥69‡RŽA”H‹•(–:»@ûSTŽ	,Š¬Ž<G#eM«`X\rBm”Ïá›cçô¼A0N¼YÙÔb;…lÍË/ÄÍf\05Öh½v°¿/³„…o•øŠß`ÆËÎÏR†°+Ï¡Å ¤î”LÄôia¦Òg\\c\\sÎBˆ×#4Ê^ˆ	>{öLÌ”j0÷û{Ló©Ô†;;m°»éòßE:Š˜×Êqr_ËÖúˆê\r·T¤Ìê“Ë³ Üh3»s£B‘õ“bM*:±—É*M­\0™1€uNòñëe±øÆ¦\\Ãa{òüyûø£Ôƒ(!€¥Þ“µ63}}¾vÏíj†yý\Zh<ç+iñ÷ªK¨b‚×¯ñ<M6¼ÖlõTög«©šÕ=ÐÅƒº¾ÿþæ›o&¡o¤ÚÝ›ðàØ6õMÉ+ðÔ×´àÒ†f;?Çâÿ—@ˆ…fd7{òß¦±ïSã÷ë«lrvA—ë7z¯Ì.tôš#œÅBþ\rE¸„Ë/.ÎÚ|z×.NOÚÍíCû‹¿øËöÕŸÿÔ^¿xÑzÓ‰:ÌÜÀ°†ýðíÌ¦Ú=]ž„›öòG­¯‹]=yô¨\rˆ\r1fÉ®æÓðÿ\0V,&ííÍ(ä×¥ª…Øim5\Zµéø®]¶‹ós™,h.	‡üÀ¸”io?KFù®\'&ì€B\\˜“Óª§gg§HGÙXL|6º¹y»Ýž?ÞööR\raµ\r·:·ÄôfÑÒKã,³4ÕN°4Ïf½ˆ¶æB—;Mµ†Ï¦³ŠëÅÜ„}¾{÷N€¥ªƒõu%ïòûää¬M&h©‡~:ÊžÒ£’8_Ì‹þV_÷G¥?¨&,¢¹47]§UX_úüÈfÃÎˆ\nÂà¶wvÚÞþ¾œçb]l0™’â(\'ŒV¶ñŽoÛÅÙY{ûæµØ°ÌK\0k|ß6··ÛáãÇíóÏ>SWp´ÊÈa£3Òû&žûl.“¾½ž½6«ÑµNÌ˜êz©k²2-û¥ü\\ì©¬ÎìÙkÔxáyÅïj:~hý›Äh½»øÙ`R™G”jš@×ËoWÊ\0+½t”›sÞ7±x€Å·T”mÓÅT¥æS™òVæe¶g•b»:ˆf…zÈ2—\"Z‘rxP?˜NÛÉâ}«íôí›Ö[ÙPW“ï¾þº}ÿí7ía|+ýóþÆZÛßßk¿þúR‹`r§âdtÛ™ÄDÇØõµ †[íã?i‡Ç[/AžÅÊu†ˆa(%`‚m®÷£ë\nfŠÊO‚žë>Ð»ºh/_¾l¯^½l—§\'é»\"?*¦…Û£ëký›gt\rs£¦MÀD©Íƒ\Zç@[\\à0ÃAŽS˜ªºK•´8SB%šó</LÂ½Ý¥üÅo¿lG‡ûrØä§ÛQÆýFj¨û™9§Ë›H0LÆ>}2r”ã¼ºº–î¹\"lä0]ßÊAýý?hƒ¡Ñ(fïqÍ˜åb´‰¿¾V\"+¦þs™çù\rÕR€D2Í[øBòß?øè\0æ}I‡ùmyøè0W*¥±½£5ŽPo±‘ð…2f`/àÄæ3y˜(j|úŽ:Ô‘ÌoúÒ¯ÅÑã§ÏÚï÷»¶\ZH¿¯ï†/0O™¹½M*KŠKË/”bïêÛ­›zµxêë|ž±åÙW«ªZ9þnµàüœ}þÛ¿+‹«e±¦]ü¼ØåŠÄ©ÑÎ¿Ð^ì\\ˆÁÆàæ×*«VËNT£ÚÂ¾p#}•—é^—oÞÈîòBô5Õëí‚S}ÏÇsH\\r(¥ƒi‰?$ÃººP(üõ‹_ñ&·O?ý¤]_œ·?ÿÃ?´ÉÝµzþïF*±fÑÝøFQ»á¶nåêò2TJWV”£E+òÁö¾œø*$Ér‹Hô#‚%ý9é1_în\'šÜ€Ì‚þˆ\0\'êÙ…o2-9A`bkbwDª¨×ƒip_w4Æ@^Yê£Ùg§4Ýx”G0›´iÌ›LI@» ñS\r7ZOb†Ô¼}úñGíËÏ~#?Ì‹ç…Ìo]•%Õ?Qæht´vô“1\0To\'‘|{uyÓ.¯.Ûë7ïÚÊúº|N(ÒÙð<8Ü¨_©î}náƒZiÓ^kgWW.\0ÉeÂ“#†ã¼jnB\0ekƒËëmc=¥„Ò/E¿}ñCb&ÂÜP^8~tÜŽŽ4ŽsºG“¡[§\"ý,íí»wííë7z°<\0xìì´£GOÚŸ&°¢[ŽÛžÉ}/ö5ˆ‹M«Ôz}ÖµbKÅÀfŸ’YÏ‡¾Ã÷9¾A±`ý¼_¯`UM>Zxß›TÂóÒéhÁÂ¾ýöÛye7¾áîÄ1ì²ŠoÄ;£/Ô`å‹á!;šTi¢ß7…4c2˜ÕÄQÛÜ>v}@õ&«yêô`›Fw©iEu >+àˆžxZ(,èÙƒä?P\"}õË‹v=·ÿæ¯ÿª]]^´ÿüÿC£\rm¾NÞ½Ñ¢Pd:)d7oÛƒ-9YG™<\n€?þ´=~ú¤mwÕÞI\"*J3gg´âR£ÕÚ\ZEÕw\0B€\'oßµŸ~üA\r\\zœÝ8iµ›OïÛyúÌÔ:=ëàpOSÓ ØÑŠjØîÆ“…b¨Ê>ˆ„­e–tšo,Ì?XÊ<†€cqxp\0¬ïçŸ|\"=rî‹××²}XèKaÈ‘Æ ‚$BR”­Æ«\Z‚\rá3YQû5r—ë¹¾·×oß¶ëë‘\"x\\ûÑ£GòÙ©=>~Ô®oGÑÈbÞÚîÎž˜ÑéåU;¿¾J©˜Õ6%°—Ò2BûŠù¸I6<€0|´ídÜÛÀðl)p§–tOª;òÙmïì©a+¦á“gÏÚîÞžrÅ¢[ÑƒÔ2˜ëƒvqyÙÞ¼z­M)ê­í]eØo†mçà ýö‹/Ûî6ÒÈÁøµÉ§Æ¾\\í¥~ÐkÙs¾ÎõÊŠ>.•	y½U‹¥ëúñZî’‰\nX69w¸%–ýKM˜ø>Ç6˜\r.~°ª#Ô\'7W³©ûZEÚ\n^ì¾\0£¯ËÚ¯óùš«QÀ)\r5[½N¥¸ffW•9ú>\'×îA4hû×ˆ\'þž\0,L/ky#“<o£›%„^œœµW\'oÛïÿê÷íþö¶ýãý/íž®9Sù·°&”tÉ?VWÚöp»õæíí›7‘N€ôïÖ¦œîÇôÛ\Z¶Õ­ØEg$}Òf½,É¡>Ç¬a|\0t€ï×—/ÚÛ×¯”„8Üê«¨öôô]]ß¨¬êe)ü¯]™œ«•µ6I’tÞ• K?Æi»½\rö\'gtúv\0ÜÉý$Y^–\0Q‹G\"&&fvÞQQðÃCÛÝÝiã»¶;´Ÿ=XÃTèþóU#>3ÃïZHÌrØ¦~ãgS\'ì^»ºµïø¡î\'íôô¼h`±¶ÞFwãv|ôHI|}äˆÁÆø!ÝâÑá‘\"ª/_¿n9óã>ð4ÍzÑŸÑ¬Ç¦íº¢Å˜óêíj<­ñV7Å½¨Lèo*š¸±9PÔ÷ðÑ±\Z¡nm\rµi!!ÍÆ!ÉæšLÂ—/^ŠuCõP‰ %ýîþ¡òü~ûÛ/ÛöÖ–’w ÐøÀŸ¥3N\05`™­TÀ©ë¢ú™¼^½¾L\n*¸xýTP[D=ÓB3NÀºf¨–¯­ZmÃzÝvÑô¾þúk	ø \\´ìT¦UOîŸ×ªÿÈ U£š\\4VH‡°»Wûµš›ñùNÕÃòç|›]_”o–×½ÃpM5ÿ«;ðuß§Ã8´{Z,3<ÙY<;ëõÚõè¦oÇíþî®^]´Ã£íÀ_ýÃ?¶›«3ù&·¡ÃgÄƒB6“ˆð5I¦r6OÃ‘M$ÐêõmóD™×÷’1¥4H\ZìsåÊ¢j\"LgêBMãÖ‹ÓS±í,å\'ÉW6‘É‡,\n9F*mÁO3}oMì†Z¼Þjä7eîÒ=ç#‘4òœ«>ÆšëÔsEï>Í˜µJÍèµa³\r77Û“ãGòïíû<$[¼&3Nvä«áEú°&w©ëÕ[m×#$Yn¥]õõ7_·³›Q»¼¹UÚ	ÍˆþiƒDÑu6ÓæÈ²aì\rwÚÖZ_2×ã)Ò™6 Æ6þU˜éFhÇ£ ËÚØ§÷Ö S=HÌ\rŸ\ZŽw¾G\rà>ì‘äNÒ†Ûú7c¹s€jèb[Œ1zÿ\0Nt´°xV¿üü³ÒFV×WÛ\r¦ëîN{öÑÇm¾ºÖ¾üüó¶3ØRúˆ:<“pœ\r_yvÞÔíâ¨kÖ.“‰ÆëÆŸ1àÔïÚl¢Ñ5ãüYØìïªàäõkp­kÐÖ[eˆ=¢„Õaþ!3«^¬éš·¢a¥œ>™?¯M“ˆ‰YEçü½j‚ù5Å¸hâPÂ¨¼ÇÀz7ð®áûñ9=Þ=8vuHúuV¥Ëº÷°ÀäÃ\0°Ø‰UK\rY£QêE›É¼ºk×£+™Lß~õU»:?i+ø®ÖHlíìô$ä“‡CÕ€Á¶n(ÅHå’‘À}òøIkë›mLr™åãŠžz´d	|V!þwÃâ½¾j7——m|;`Ñ\ZuDàÌªÄ<®¯å†=1‰#BvO”ð^í¦`n(eÚÁ\r—Ñ8ÇpD÷ œñé7“°šêÙ!há•\0,\"˜8åWWÚîpØŽZŸâé¤=}úD<@«>op¡åé&|ðÒ£I~…kûåå¯í—·oÄ”nïÈß`ñL0~.ÎÎ#]a>kƒÍ~¬j“v{?ÎÔ6îó4³ò³ä	v«Â9@©ºT®Ö¶¶òG*„BêÍvpøHXÕÆf?ò¼æ­míl·ã\'Oæ2cŽ)Ž\0šÍ£záÕË_ÛééIÛÜÂÕSÊÅúÖV{òü#¥5l÷·ÄöÜX—¹%s:5¿êÚ©D ‚Xuñxcðº1¹ðgüÛnŸ­ù\Z«VS%C?jaKmeÙìÊ©×U­¨q2ÃêØÈ×Eh›Z¾xû|âáE>‰/ÈP\'¡|›ËN/>ØC‰^øx…á®9”ŒÔuç¨*õ\\ïÂÄÈ¦®|¯&¶Ök¨»Fh)M•mhEëtŠz#[ùîf¬vï0”—¿¾`}ýç?µEÅS”\ZzÊçXQ2nuhLB×kÝÙ?h¿ÿý_µ½ýƒ6™Í5É×7ÖdÞq­±`¹–p²ê!fsVüUWWrø_ž\n‘¬áœ2÷WpÎGô¨\Z¯Ÿ+…Ín=ÄÂƒ\Z…š`5ÔXHØ!a~(jK¯Fž‘ºC¯Ë¤S;\'fv¼¡™zèµyÛÛîövÛßÙV³YÌERmã^-?	!…Ìü ¢v?‰zG˜ ×„£úôì¼½:;kW×bX 	›\nÀ® @¯-RGÔùfÖ”rÂ˜ûøµÈ:×f&½34ÉV¢fmUÁ°6Ä~8ÿö6©{‡<Ñ?Ôe©P ³wþÝCkžŒx\ZFPÐßj;{Êã|ÀšNîäÓÄ‡Å&´²Ök“‡yÛ=ØÓïO?ÿ¢}úñÇ2õñ§-ò¹ØX@­Ò-ÙsÙ–È‡ÌÂjþUs±’[;u\rW?™_·‰g«É¯ÜªET‰C%+þŒ_¯yñçaˆªîÁMÏ*ÀÕ0UÐ2â\ZÔ˜@Ö ¯ì­îFÚˆŒÍÄ²`ü]çCò!à30ÖkõŽãk­×R&ïÃ6ð_‘> ßÎý´ÝŒ\'Ú¡oðµápÐÎÏOe¢]ž¶‹‹Óv{}­^…ý>½ˆ6ÑšINrÌL²çqä®­Ë9ûéo¾h‡ÇÚYDÚð¿,Ø+q²4I™ÔD$—oG×*ùAuáâü4ÚÕÏQY¸K?æ1I¡w’5YýPª2ºi·ÔB3jss‡ªCtªañ’¼\nÐ1Þ£ÛQôÿËgaÕM>¯IFTSHúG\0 ŽhŠuAÜíþ¦ØÕ|Hk=Éí€\n`1†œpP1rV÷bbJ|ë™D§ºëñ^½~Ó^XW*BG¡³•+Œ¥_O\n\0þHš²Â†^ÀÞ¤˜j¤Ôr*Õ‚²™€›b¸˜a‘gEÀå!ŸÍfÛdó!àä íîî)UÎ8æIò¤Q@ˆŽqÛÆÖ0ôç³|“TŠÙC»¸<o/~ù%ê<y>ä¸õ7Ûöî~;8~Ô>ýä“6ËƒµGzB´@K5ÆLU0`t­£J@\0—j	y}Ú§å5X×¥ÍÖÑäÀ\0ì÷í:²%d‚S‰N¤’,Õ88¯ÿæûï¹gœén\ZØÍÝ¨4°2;é+U”6ÔP)Âñénô68˜)Ù”ó@±“Ã^UMÁæ[EtÎQ¯¯\"w}Hœ·2©z,ƒÇÕØÀnpøÞãë¡AçCKfÒÞ½yÛÞ½9úÙü\0\0 \0IDATz­ˆÎs4Æñy¼øùe.·y4»$atw§¡·	`mïµ@	§Së6Ü9lž<SÉL¾¢Èû\"-ëP€@¾,§ÖnïH\nK	6…ä2…Ís®·ÍÚåùÅ\"ÊF9\r‘»¸_ØÓ­|0Ê\\\'E#¥]¸GüÝí]$ÉBâ0[²àùµÑ”õu>&*¦&LL’)4ç¸¾‰„ÐµUÝ7/ÒV?“æùãÇmk3$s +øv¤z¨I(@\"æ¬Ž\\3©I0~”	Q×9ÖrrzÖ^¿;UŠ~-º\Z\'DÕŠ:Š¸1M7Pm¥¬†ÅÄÓˆþŠ€ÕôŽTž™TFWô9éë+c=´ÖUØÜÃìgâëªÀ\r³u\rüX¤3pÿ«+Q£ØßÞnk[›mesSÅÔô\Z„ÁI!–*]ûuûþ»ïÚÉ»wb~{‡Çbež<Uâ(Ó”k’Z+M2C±¬Ž{%u#¯Ö‰×•×F]ÓÞà\rL5V-›JtL\0Ðò5T¦2@Ö³×žA³²¬šª±pºñ|›sF;±ŒtœWóÏNzÛ›þÛ7íã:rQ£„]6çÏÔ³ÙFhšcñÿ{7£ðo„D­ú\0Gµ½UôÃ„ª²66/ªY*Ág”)^4ê.V¨g7ç‹¢UÚŠ_\\\\¶_¾ÿ±½üáÇ6º8oÓÉ­üUÃADøÎ.ÎÛÕÍ•&&ÝrDj$1<i=ÿ¨\rw,AÉ€¶NývpôXL‹Ò•‘ÜÞµY6ˆ{Ä!¾\"À”™Œ€Ál¾¾jw¤Y\0@ww2%å[Àï•‰©±›mTÉpç¦†Š‹ö¢hS<$®3\"rrÔ³8\0«¬\'$q–ë±‹±_‰vB´;F†<L)œØ‘Ñh={tÜÖ±[Pq~âÏâ~c³@<!ü.ãñŒ97™àh‹]^Ý¨3Ï»““0_IHÅÓ˜³¡Š’ç°ŽD³šIÌÛê&~¼P#¥aÒ€×@‚¯æ\r·–=ñ_Ê|ä3$Žªºàÿçë=œd½Ž+Ï,ïÚÛç ’XJÃÕ˜Øˆ‰&öoÝ)‘”›áÔˆF\"E\'zîÏµwåºª»6~\'3«îkq÷Ágº»ê«ï»7ïÉ“\'OB;xƒ¶*„Ñäß BØéÒ_¤ VaÌXÝ=ÿ—¬ôó×3;9>°Þßöž?Ó½n÷–lc{[)äK¯¼j»;;Ök·UUåpÔ{ÉÎÚVîÜe*—+QUÉM%xÐ3Žö´ü¾P”A/³­2(–VŽLÓ\råfä©¥+†t”qfÎ…†ï–©rÓS¼Å‹\'¯“È$?D^L~€üet,K©ü\\˜F¤Dià—73£vþìÍÄ¿\'é®×›aêïÎ¾‰t%qRyY]cÔe›ëŽœ\Z,!šß^Í;‰–òæ}\0Y$ÊäGMÚ™\09üýÑ`¡y:øäS;~`ç\'Ïì‚ÉÏÇ\'â9ú”«—–­Þnk$S­rm½VÃ&×SØ>Xÿ-\ZBðWjÚæÎŽmll\r‘²)˜$‹\\÷°ï¥—C¯ÔÑâ2\"±@¨ê$¼ÒÅ1¼È©4¢H4\\¼ž…¥IL”[ßp?AL„g:ßøgæ£Ú\\ìHê„SCö\n…Šìö¬bªHµâšÅiIlè5‚5Ï¢š–%žSŽ;óY‹myYÁ‡i­q%á|\0š\00q_ôþ*øôìñhªÊ!2?ƒW°¯%U•“{Å¼GÒÄ—Z.¢åsá.Ê\"é4:úžLe„rÙùÐ\nòâ~\ZÕVZ‘œ#åÃ8-÷â²ÐYZ²JéBÛZÝ¶ä\nœkÀç$Î®«v|t`}ðž}ôáÔ|½½»kk»¶±¹c_ùŒm¬¯©Q£æ®ÐÞùZ¯I“åõÙñøúÎ=us/\'ER\"L¿Hd–4ß19«L7s¯–ûþ&—ÙŽRòE—±$÷^	nR5åõ¨5\'Ë“y!ùbå—°®$ÖÊ‹ËË›.!g¢µ”5”0sÎÑÜì˜AÏÛR<5b‘(p…Â7_\'G™ûæöÍ§_1qœrþT‰<¯¦Ó?Ç¯G@»Ñ¾À%‘¬‹‘jÅÎ.ÎìàÙ3›â‹5èÛùÑs;Bu~aûöäù¾Öuµª{÷nY—ÁíFÌ.ôÐÊF×ª5mçÖmqX×TÃ,ÎµGÞÎ‘÷«eïdÀžQ”ÞIåú,/Îm<èÇ”(‘® ²S²ðÖ\Z1iBCHLÕÃƒ)dç[›ßwöê/\\è®tx„\n× MTJ À²¨9ßâÜ*xþªª[)O™²#ÔÒt‡¥°RÕ{ðô*ž#	Òqþc]¼©˜ÒX.Þí\n®ÓÓyîÍÓùZÜ[ü\Z4á²·…©©µÄÔ‰ÞA93¤¢?D®\"ñy61B,{sp=^Ÿðé;|”ï:-qX<¦)HÊ/ÍìäøÐŽ÷ì¿ÿ­Ú½ûlkçŽ]Ïª¶sû®ä0ˆ—VáÆšBª<w‚±ô|®EB½å*æ\ZåáWîùÜï7ƒI“üz°Ê½žŸ?QX¦†Y…ÌJ\"×”Á«œ¹o\n23Òu\'ÂÊ ’pPG-lw„ôSÜ`©»Êyo,*çMˆÇßùYxÊ\ZÊó†d\0äêeì»æÒå7#6\' )Ñ¡Jþ„Ô³…p“Å%i/“»•\n§kÞ¬ü¬åÃ“`’%0c£Pq™ìÛéÞsk1Fk4´áÅ™\rÎOíhÿÀž2MçØáyßÞüü;özmk¶êªú åó(è@^SluìÎ½û¶¹µ#^\"½©2VJFvp~žÊ„»à£$ôN‚£\"-õ–…¬H}@zf2¤ƒ8¿ä®;½8S!A’‡±LA€´d ÊìÿƒHï´ºB­É§P¢çÞ‘‚óK<ÚDÀL\nÄU_ö–:’y€ºó@ÓÚ[çåÎ¹U5\nûóJ	~Ú”÷ØTº*çªx¼2Z¯6”âqÖ¨Õ*Òž…Öeÿµø\">ùbM¨D\"–­K¿¥®‹¿Ù´VÌŽäú\\O¶2µéÞo1`Ñ*ä9-C <ZnH{K+´\n\rMgšYIßçÓ§ŸÚ\'Ÿ<²‡_¶íÝ;Ö^ÚêêºÏêä;·bQä2™Ü¯yÀù³Xøêçº.W´Ê4.ÿœÙQþýf`ËçTfFáñ£$‰äzºî\nƒ¼î<œ3Èf›Ü|ÌWˆô8]# äeäÍ Æï©hÎ€U¾aÉcåMIÒ=½‚nòUeÐ*!-;77¥²N8”Ñ4Þªºäd×„_·ž“ïq2KV%ÍŸø…”ªçî“Ò·x0|ásÃ \\;wD:aýè¿·ýÞ·Þlf½¶e:8:°çOŸÙ“\'Ïìñãgö«ß¿g­Þ²}æ³¯ÙƒwTªÆ…—¼·ä\Z-	wvo{1ˆy¦5%`>T•Sõ):ñªA(ÞéMœpÊ{ èõ–ÕóFÀª6¼ü[êppiû‡Çvz2P#1ã•Y=Ë=×¹>)º\r³ôRÒCÑx}¥S¾Ój©!˜;ž÷\'G~iÒŒîíätU•ÂNé†[±dÐ!¼<¿Š(švßpËaÎ¤¢î6ëŸ`ƒÁÈfçå$ê†íd:¢¹7G•TÃU!Ù™[8«H~ÂëëZA^¤m\ZnávÓä¥¼ô.¯,;òY]	Y·iÄ•8Oyl…´DU…Ëju¬ÑjYö V[‚Öz­igç\'v°¿gýsz#Ï¤OÃ7Þ*.@ñ	‰Öë¶µµiÛ;›V«{†à0Ë÷Z÷\'×ðüPŒ£Ìœ”®G‹ÌMÀTO¹GE%·”@&ß£7ejW>eÀË`˜._¿|Oþ<ýßüæ·Rº/ÊŠ©(ušÙU¾a~HP\n\'qÉa%\nã5óœx÷È,áÿÍ›qó¦å×ÓŸ)Ÿ nDežN¢©Dr²KÕ‡b\"\nåq®EÅ\r^˜\nZËHJ‘,‰ƒÄ{`_u³	iÓÌ®à&C{ïÇ?¶~ü#;úô#\\Äí+þçš¦óéã§6Õì§?ÿ•Ÿ÷íö½Ûöú[Ÿ±éõTÄ)A$”&‡‰X[Û»šæ›C6óžŠÒí\Z+]¬kHYà®†}{úø±¬s1OeWã›’‘ŸÚéÅ¹žÛÕ5üËÌÏìäøÌc6ý¥&—vrvîÓeç)ÅS!£.î&ß$Ï)ÇcxveyÉzJï\Z\" yæGª\'ÏzžKr\rŸ\n„y^S*qëP>Ðo\"Uí §…0pPð\"¨Ù×gX]+\0QQ_âÁ§èðwªœC|§èßÔ5U4°Ýî8±/Oxþ\r;wŸàºHÃ¶Ö7tÍmDžH&fSiÙàÌXT|ï?¸/ÎÊ=^ÝpÑÓGç#[½žFÎ3X¢*ø&‚¬µëŠžÛÉÑ‘\r¢2|}BÍliiUiêÅ­{Å}÷ö®õVz:¼Y mìxfavZ‰Ü§™*–ÙSÎþX*AG‚‰DEùså{$À)d‰Ò2¦pï2^d¥2_7`^kå×¿þí,óø„jyñ|x]ˆÿÃ¨C\\JŒAºy‘/¤UúQo`Í€üO„ÅC¼i}›®LCQÜ„šJ7…:Ü\\-ß[ƒ+ÃGE7LÌ¼6ª/sô\'¥ò|Z‡‚xÖ¦¡°l+XßÖm6‚Ÿ1›Ì¦6\rìƒ~ß}ïvöäC;½8¶æîmûOñßìàôÄNÐHYÓ>y¼¯r{³×²ÎrÇºK{x÷^p.¥B4#“F¬®oŠ³X[Û”`T6&Õ¨UÆƒ—¥ŒÆÛ_(%ÔŒ×ñ¥M†c;ØÛÑ®S³jÚDøiŸž©zÆI„G\'ýñißÞÿðc{ôñ;8<¶©aN8T:Æ›p¿”JÅè(\'ë%þ±êl&û4JLp¡I\r•™úô(ù»j¼ªS„…Ó\0ÁŠûIÕVoz[K®Ì\r÷bwÂÞQZµ6ÜO\Z¹é¼P f8-~^X¿°NŽN„Â	nô€úk]Ûáñ±]0„ƒÔ”é7êíôB\r?¼CýšL`î´»º¼bë¶µºfwnÝ¶;·o©y{euYr:þíß~.¤wÿÁ{óÍ·Ä¡žK‹Æz§Ò\r\n_FlÚéi¦d»×U‘&S_™RÂ“£c­=Ú¶H?}¹Öt\0Ð*´º¶\".èrçî-[ÙX×gà^µ‘GLhƒð±°rßdÐaeš{!¿7ã@Æ…Dðlòç2›*÷ëCH¹3@åï¤òïÉq•û>\\¿Êo~ûûù˜/Ý–B­¾pÍ)\\!oŽ–*òÓ›7%oŽ~Ÿ9ùÇ	š§(1oRùAóß¸Xñ;1Kþä¡MÒa£†Ÿ·ßt/u—ïë¯…Ÿ8*¾Ÿày¥Ô.×%½Mø€³|½âŸiÓ¨W¬æî¶6¦¬ôÜžþèGöü‡?°ñÞ\'v:8¶£ëš}öËbßü¬=9=³\'‡ ˜ºŸ]¨4U¹²V§i;[»r*¥JFðÑ\n›ÙÖÖŽíÞ¾k¨¥³¢þÇ†«Æù7¬áÐºmF@ÙÅ…·C‘¯ãþÐFƒ?ñ——uÿž>{fŸ<ylï|á‹vÿþCéÈ~ðÏ?¶GŸ<±\'OŸi †RhÍ6õ\r¯69¿p9	ûZƒ\\Ñ-EK„ËAßZôÑ1–J>ãpb¨ã§¶žôBf¸pòìA4:‹h‡ô®*`\ZXü\')BpX:é©ÀÑð¼ Óµ*þú2Â£zÜ·3¤#˜öáûjôÎIÚ>^ÞoNNEJk,Wøe¢ZyIÀé£½Bì¾g.Çðt‹ª!Š÷^»#ùÎÛŸ·ïÛÝ;w´.¹?ûÙOì½÷Þ³/|áRïÓ8Î!€sƒœ3ÌÂb¦©ÀÛåµ;¢V@Xôb±MÏŽ¾E·Ž†õ{Üë4í€âNho¿ûEÛ¼{Û®àÏ¬jª“k)‹iuÿ\\ó¬cï—Œa±oJä”ü^X’bÉýZ—<%_u³b˜ÛÍª`^×M)¯™¸Ðë&AWæ®ót$án¬’¼Ë‘œ‘ÚŽÏŸË>Â„ÿIÔq\ry±ù:¸Ò £œàT`òdÐMÐiâƒ4ý—ÊùßƒP\rm‘« Ü4¯\'G¤@\Z6\' ¡.‘®Œn2ë`C­1³‹çíãü®ÿä_møìc\\]ØéðÚf®½ó_þ“UÖÖíùùÈNÎÆvr>TÀl/µlrMÚ´¦24©¨¼°oefkkv÷þCÛÜÞ¢òÓ~¢ÍœÔ+#¡Rí8» éxŠÔ€ÊÙ`ÄwÍ>}ò©ííÛK¯¾jo|ös¶·wd?ÿù/í÷øÐŽŽ„:)³SÅ^_ÛéÅ…R/øÔðØ0¤‚{ïFJw9B–Ð°Ï¼ôPêú½§Oí³¼F]¼›Œ4û”´¢2	OÕ@S¥‰Ð¤–p;&Á&›‘ïM\'V8¥”pÓ	XÍvÛ\Z%=_ãþŒåPAwÁáÞž&ÌÐu@ÀBÍŸÅŠñdjÇg§ÒEA /\'vÖ÷ËY¥.?,tp¤r¤§HF4yš¼”ˆŽ×‰nOº·«Ë©­/¯h°égßxÝ^yù¡mmmhýüæ7¿¶_ýêWöî¾(Ó>,pTA0>>=uZ„À·¼bíåå@z>É_/Ü5¨2ÃK®./‹3£˜±³³k›ëkâ-ô±ºw¿ò§vïWm*>·nÝjÛ*—S›ÖÔlË\0’&QQ‰žÅäÏdqm±§<ƒ)ÿ^îÕ¤€Jî,ƒX¦}el¸Iü—è­‡—®òo¿üµoi‰þˆåfe!ßø¦C	+ó—Ðƒ\nSO<\rãuÙly’æ¿ýÿÝXÞ“ •h*S5N$*Õ¹Ïw\"pÍUL?¾\"@¾@ä*‹#eyus¾º˜pÎµÁhv¢;5PVîUššO7mUlpðÔ>üÖ·íüg?¶Ñóm0ëÛt8³ÁuÅZwvìËñö‡§‡¶wÔ·þÀ+~½•®]sMUÉ’»0Œ=\raqmnnÛ{ÄqðÞ A>;Á!Ñ¥z	pRrì”¾Aú#Ñ\r0\Z+}\'_ôû¶w°o›»›öÖ;Ÿ³Ÿþä—öË_ýÞö÷m8œÈ£ickÝvv¶åÛôôøÈ~õÛßÉlî¯!3ùÊLiþêûÏ÷ms}Õ>÷æç¬AµtO©èUÏþÀ–—»¶Ž—»tNµ»Ö2©†€Ç¿á÷Þ¢b‰|£îC2h	yë{\\\'E:Ie’¼fwÉ*ø»3Ìvp!¾‡¨³ãc»^Ùht)Yª¸-¤ôÂ;²ÀI‡T-åOµjµfÓNN¤<_ÛØ’ÍÎÁþ¾¸$dêÊàz*t9LmsuM}´^áÐ±Ò[¶—^~(Ý;ï|ÎîÝ»+¡î¯~ù;>8´X»³¤C€ûGöb0P«MwiÙ:+ËrMåùSYaÑžƒMÐÉñ‘ÝÞÝªEšA\nºÜkÛåàÂ.ŽOD|ö‹Ÿ·{o¼nS¨«ZsV·\Z)aË»”ÙN²»DJe¶s3ó)¹­ògnê¯Dä^Í ”à%V‚¢ñÍyªŠ\0_¤?þÙ¿	pd¥\0(ï­ˆ-}¿$%ÔF÷ ÀNVÊ¨n”ñß««ÿy4fcâÀkÂ‡hœU¨€“o‘Þ½\0~	Ì&.Z¤\"E¹šˆã+J¸…íÅª„#¬›§†*Šq]Òë„ƒ\'\'c\"­ìÖojc˜ÒAöŒùuU³fÕÎ÷>µÿé»vòóÛå³m6Yÿ|l£jÃN«5ûòŸÿßV[]µÃ‹=ßÛ÷	4âöè3ƒ@í)àôûŒúrŽ9B*O-ˆåHÅhc\0\'\\ OŠöË“Ãõûš\0s9JéÎS32—…\\¯*pýä_f§\'g¶Ü]ÑÆ®W›vŸÞ´¥ž÷ý«™ýÓ?ÿÐú4iãÁÞ&õ\"U^ô­Á“\rOOí¥ûìáýûjú&%£É\Z”C°Xj7åMÐÑGaUµÑsAk˜“îÕí¶­·Ô“õëƒQ`Z^róaÂ2îµ¼0Žr»žÓÓõj‚ðú#¡Ï‹³3õ_Ò0Ö}«ØùplŸ=Óóîu—7wwÅýþÃ÷EØ¯onIr°· 1¨fH\"üe˜\n©ûpdÛkëöú«/ÛÑóç²²Ë©RÇÝÝ]¡­/ÿéÿa<Ðóyï½ßÛlzmK+=kÕ›¶º¾¡ª+­CK«k2äkòyHã*¦ûE{Îþþ3Û{¾g[Æø2td²à©Ul2<·ñðRô­w¿dkwnY®‹òvÙt\'DJ˜÷;G‰ˆn~­ä°2xd*™Ýe€ò½ëYLùý™BŠ\nÈC§p2Î÷Éï++Œù~ð(xs~üó_ªJ˜(ááÕ\'\'¢ûšû˜\'y$Å¯´ïÕGðHçùª‹ÄfoÆà\nX6@û½JH	UB®Iµ+a HD)¾f<³Àû¦7\"xTüäÆ.‰ƒÛø*š{ŒÕÿ¡A\ZE Èê›~gïò!ø°Òk«]Ñ>¡hnýÃ\'öÁ÷¿cg¿ø©`Õ+‹fƒJÓNk-{ùË_ÑÉ÷\\\'æ©÷‡†SÄŒ<æ\r6¬ß?Ÿ#x•ÍÍÛÞÞÕÆm6ôI%Ôƒ>÷Y¤;ÍÍ×8^ª‡Mƒý1ªö)›j0TZÂÆà~±¨Ï†öË_ÿZ…‡N.ô[î>A¹_3úH:={ôô‰}òø±Õ:Mùd)xK‚ÐwvJ½n¯<xÉÓCMÉq#:\\2å”yo;UÛnÝÚQ*ÉK·iä®f\"”Q¼s­Üx|¢ÊÅÊz©Ô	`n·ÃzlÑL<›)`]\\œÙÙé±Äºšd„¯×xäª¦]]Ûþá‰ýîý÷íj†qâ²­¯¬ªêKòòÊª=ÝÛ³?y¤qðÝÕeyÚƒ„àPµceCš»Ã[¯¿a·¶7¥•Õí=}âä|µn»wnÛK/¿l_ùÊW4;CZÎ—#!Ì­m ¤£|ž‚‘ª“°Æ;<ÜSWVDÙ¥#¢ÛìJG&ÝLÈ”v-ô€5{çË¢€5£HA–@eüÚ›¹çfïÑs˜zî]öi 2ŸÌrÊ\na~O)}È‘¯—©÷Md\"^ÜL-¹Žüž2 Þ$ñ9ÐçëG?û¥DWùƒy*²±IR£Z­Å°‘Ê/ˆ¶z#D¼Ri¹Š™þ)•¾«>Ô[m¸‰(›ý„¥OLº\Zøœ(z‚wîó»ìo(äË”6K¥>½¸¨$b9\Z#^\'Ó]µùÄQ^—*QµÆBhhƒ×:\r›žÚ¾ÿÛûÑlúøkÏ°d™Ø…Õíj}×>ó§f_²R\0YøÙõuÅ£©TÏl`*K \r<U©õµM5>«ŸŽ\n–*YÁCÈ©€™€¤hî_Õ??Q“3–¹x¸Ö\noŸ¡LO/ã~XÓ©½óù/ý<ûä‰=úÜPËÄx\ZÐjUYÍŒ¦cMÆ6Âbcˆ—MËôÈÑÏ(½­JQÑ”›+;??S\0×ÂàÙ[·oÙ+¯¼¤€Ä/\'P}s°À	Xl,ø<Jöò@×š‹¶¡ûŠ5Û]¡î‹tI1Dƒ€@jxqz&ò$\nÊÄÛ‹kÀ2ùý?¢QEêýf½ik½®5ÔËGÿ`Û&\ZßveýñH›ÂÍ\0ŸuqeaÉ<\Z‹OzõáCu+Ïûvy9”DBòÜ˜Þ<Ù¿ø%ûÜÛogGPJG†©®³Rµ†\nÂî¸J»ÓþþsqS¤ƒ´Wä[µ–-u|Nâl2².ý˜òckÚ»ÿçŸYgc]Ýü¢)º¡özC—(*ƒÐMÞ¨DGe+ë2¨$J•z¦lìÊà3G4A7•h.ß“Kþß½_dp/9bÒ¿üÔSÂŒ¤ÝÔ@yyåÍ<”qFÒ^9g¾q¾Î\"‡žªGÀB1ìÍÀè_ÚÊµõ\Z\"d‘«Åü£±@Xé6¹u–Â·òd 8¦ýF^{yçd#¤zhÍ¤Èv#àÈxÂ#$±¨¸YEÃâó§ÿbŸþàÛvýÉ‡Ví#˜Ù¤»l×ëwìå?ý3«®®¯8¾Úù±K wiÑ‚|êi©ir8Ýî’æ²©Yplh¸Ágyn!èœºØÍóSÏ²]Ž¥Åáó0‘ …®ŠM±²¾nk+«âg®ÇSëŸ«’Ÿci×Ù(ñZÂF‚Çóý=¹tZ¨¾±Ã©*míT¥²ÛQ€˜NÇÞêBQènâ~N8{®º¨’ ŸçèŠü4E|½QG•IÞ7‰ŒÑC±á´šmkwáƒ<ø¡ê‡¤&ˆ;Q®Ò‹\ZÂ	¤èÔ˜Iøá‡ÅôzK²hÆÏ-Y£Þ4lt¸ÿ ¶n¯+‚œ÷›Ò/Ê„ (W*4ˆGã %Õ¤a¼V±ö\nÖ1¸³^Ûl\\_Û~ðûòŸþ‰½òº¥)B’Q¨?´.\"_m9gMöfyÂßHõGí¯v£m½VGû¡z5²†]Éév÷î]ûÿù¿XU>é{‘CYã“|%Ç[‰Ü¯ÜÃ’k*V™ue¥/S8~&Û¼ÊÝ<ë*Ò¿ÌdÐúc«D}ú¾h/ºÈ*ÿü“_ÌrÃ–Ä·Ò¿¨08Ê«avmQ)Ð„‘¢)rÐ¼% ƒ\0›ŒÊz@Vé‡2‡ò†A–ŠlÇÎ%SÂØ¸	u³¯n~STüó`£t1„j4k<\0\0 \0IDAT–yí¥(-£{úQå{û‘ä¹ùqùí”ëúÊÚ½¶Ua~ôž½÷°Éû¿±êñžMjW6é®ÚòËoÚËúŸmP«‹C¹šŒìü„é5~O/YT¡Xfmqd?Ò¦«¿#Â›”X\Z¨†óWzØSî–­²k”&ÃˆZøRDPˆr:*kNv|Ááƒ0úcÃØ5{\\iåã§ÏUaz••ë8Ýr~sÀÀ¡ÍÇ²7š2Ô“#(m?-kEÕGZ08Lÿ|/Žš—árÝW~S­t/,Oá	òíB‹Õj[¯·bU™šÐ\"ü|¨\n»hî\rî¬¬7Wq_=:9‹>Å¦‚Uåj¢ë¦5Ijjö˜\n­†j4ÿ [çÏ˜M\0n7Z¶±¶nCmµ!_QºGeõõ7Þ°ßýîwöÑGi‚h™J!¯E/!Á“{X£W2¬“±¼AöÀ@\rª²ÌVi!i¹\Z­«¡­=›ûÖ?9P€zõÍ·ìí/½k3d/\ZÊZ·\n†ŠðÌU_ìí²ÚW\"–¼Çó½ý‚DÈåA¹·þ9^ ‰ÝDW‰Äòµ Æ©¨›ï“E´›hv„Ê~ü3é°Ê(ê\\[y¡iÒ”Ž·\'f™’%\\,¡7žÁ™Øäâ¾I9[§¡ËBD—ùoÞx\r)|Ãâà6)Ï#S¾–åó[þ¸–|(eÄÖõ“îE»K>L¹zF³±N cöÞÄÇ±kXDÇªW—6=Þ³_}ëïlô»_Øèã÷mÖ©Z}ó–í¾õ®ÝþüŸØñhbýñÀš5SŸ!-3r÷$nwD0“¦âµÎçG[Å_aüW¤âˆB¥E»ôÔ}›kUéwz¥a®¤¤±òE–$®úìuJöœòp<úpRÙc:H\0b“VžõvvFšê½z¸_ŠDÕ\r\nÑPÏ±Ò$U\"hò½Ô\"@< Èá•¥owRºïÄ=bÑÜ<ü®“–¿CøyP?~ŠƒªÅ(­vÃ§I8º$ÇM2“•ðéÉ±8+:f`ÜGûû*àÌ™%rÞGíD¨áÏ/„xÕÙ€líÞ]²Ê™Šâ=Ô\'©5×·¤\0\"I†tj3«´ø¹¦míìê`€ƒKzTÊó”·}ü\'tÈž!­¥Ñëiãî €uv¦×e\\Ò´z×4o³*5k7*\Z7¾¾¶/¼ûe»óÊ+VÅ.(zSr“\'rÊ`Q—D]XJÀ‘Á#9ÝùÁ+<·3üÎ^à=ò¿ÜgÙ›œ×Sf^¼G‚\r­bYîAt’.ÞöœgNY}ï_~â²¤`üó4‰–lÏP+„5Wà\nôåè›>:`ìÔçSyY¨¢!ƒ±ipªÖ°¢…ËbêHW¦jã>[\rU´£\n‚“65–!:1\\š1#{°ò&Ï…¯‰Àò¦é8‘48âœÓBu¤ÆÞÀ{mW”¶Ã¦>OeÔ·G?ý¡=ÿñÿ¶á¿³Y½bÕÍ[ööú¯Ö»ûŠ/U¢ž^Ì®&\nXðÝe”æ-«K08“fˆ÷@§DÐ\"\rBZàÎuÑ*ëâK•ë¹7²¡zà5¡Jç)Ëóê^x[qß ö©ÔbÞº:;>™°g£žƒT˜8ãm,îŽáå|tPü÷n+í~æ÷X‚ÌhqB¦Ð^’x”k u„ÃòvOçD £‹ªq4Äw=„Eq*äÑ%(`ÀŸµ:ŽÒ$®IÜTIOŽE¾ƒªä0AÚ<\ZJßÆÄgþ\0•Þh*\0]1ž²º¸.Úm¦ÎÉe²Ð^R)¦%ˆ@Í}@¦A\0Eà;‘Š½#‡\rÒIú	3ËÈŠ»\Z–Y3\ZF­3áÿ.Ç\n6ýÌNO•†ƒ2Iç÷öžk`Çlr¥éK36è‰fÍzëö¹/~ÉÚð`¤Í¾åì$xŠûœâ¹‘ezW¢¡*@’&šï§+VdÀ2†ÜLí2Pò{	ŠR]ÍòZ²GYöÜY0ãÐúÎ÷þ9V¦=Þ=¦ˆ)ª’\Z{AñA$ð”Fˆï^Òì«2j—)f\".é».\r¥D(ß³àl8y è3P)P\\;’@­\n_ð©Âåª}#-rï°Œ›Ã÷ëUÉ5©¤ÈCY_,ÄvjB¸Ú«x•´6£*ÉøªK;ò}òýoÙÙoaÇöðíwíí?û¿ìdV³³¼ÛÐZh¯tº¥¶fÆ)>76ºý>¤,Ö7˜Å5Ä5¡Î&ØphEx?Ñ1\0Â¢í„ßáVÄkÍÇ¼gñþGRCm~D¨ÄN¥Lwf\Z=ˆL{F6rÉDä¾øª<5½%66Rö3\n	 —™hQÊÍ×Ý@¢Í*i!×àNžËË=y çd¾ûŸ)¡úI“d£œ®|øbËk¢Ã\"`ÑÈ]s-M¯ÆûkâC_AŽ\\?´yú}n\'Ì\Zæ šzËi®ä6ÒÜU…øÙÇ	‡gå¹Ã7q/if$–1+\n\\ínOXšöùR\\ð j©!8ÃU¨à²°Žu¨ÆZÍ.N/äOÇ]ÝÛÛ³utZW3ëŸ+hq­Íxó‹ïØW^ÚLv]ƒ^)žÓvÕ…_y0—éYÉW•ß“((=âÊC<Bùoùšùµ2ýL®+Xõ7V\")9×Æ Ül±“ƒ÷?|ûç«|Ã´”C¶Ð.‰ÏÒÍk•i\0ÍèšA!#i–;“ªVITQÉ[½qšÜõü¾Úv$±éyEYšÓnï%~¡ÍB9\\æ¸TÛR3¶ˆÔ¾™næÌùõ²Ú8±/Ð•ÃR·c¡×N¯7º´j\rmLÅf£cûÍ·¿aÇ?ÿWÛ;>±ÿð_ÿ›í¼ò†}z|&=ÓhtnµÙD„/Ä,Õ! $3æà2à³ðÃ’6§Û³úòh[!-”ÆÍ¹+q_\ZVáÊÉnü©.U>góf\Zëéµ\'v¨[<Î§LÅq\rÞ‡C‡×b²ŽeGN¤MTë£›Ÿ¯%ì§äŸ»<È49G	éíÜ‘A”AÝÉ÷••%Ø•Z}o¾\rxÏm\\z=wt•Aß•ÒNY(Xà|ZMÐnîšŠ÷MÐÃŽ¯;Ø?PP%p)`áºzÉ\Zrþ{Êµ{¥’\n(i\'(äUP-û€â(€I°ë.­HÅ&+}:xãóËá‚8¨ªôÇgbKCÚãÁÞ›î‡CÛÛßW0æóRP`BN¯Ù°½\'O¬£àHCß|÷‹Ö¤s ÕñÃ_Ä#Y\01ôÅN›)_R$™UÝäµ2­K·Üß%—•¨)ƒP¦¡™©ÜLõræÏÝ¬J–ÎÝ8¢B®N–\Zýíÿüö|.¡Sr(œú¬ðõ™+ª]Ò;¹ke~ ›ƒ¬à±ØåàZ±Í¬‹Æ\'ƒ\"ÀP.û+÷WåÐ <}¤“òæ èjµ–fùÓ\n—kÉë˜sREaysóºs ÆBkâ¯QæÙšSñqUôëU«M_­W›Ø“ŸþÐ>þç²Y­aï|å?Z¥Ý³GÏ÷ÄIú\'V§/<á§µ¦õÖÖ<`5[’BPXp‚µnk++\n\\lÞL	sB0ÁƒlN6›„®W^œ˜L/&\n²@é¬æ0ô‚bIV_™)Â¢õçÒ‡Uh¨§OmaÓ«/q<ž#þÌgðÀ-g’°—! ÷=8,µû€–8¨·šBW ,UÝ® ó9øêJoHYè¾@Ü¤·iÍœ‹×&õ©·iÆ¥”µGÐ¾t³BxR*‡št}­`Åg9><VETÁ#úR%AV…¤Dpg\0}?•*ÒžiÀk·¥gäb}EÝ^ “B#QàÎ4\ZÆ=ˆ{3·d8Ð-‹r€ðù¹ý³¾Æ–±·x=\n\nØöt\Zu{öñÇ*–tzËöò›oØÖÝÛÖR[OS•w¢¼d>7;dï”´ÉÍà\'AF\"%¾/÷1ó,@åÏñµ²ï/A@I —ÿ–û.ƒRòÆL|D0ÑÁBV žß’ŸûúßÿýL~æJB %3<?-oä1-]Ýá~ò;ô‡PõÉò‚Y 3®¯ÔüÊCÈ¡”~cùYoÈ†MnD•0F‡3J]Xíö³IÆqbç©à×ÓiÞ d7ÉùDmœÒX0!«§8Î+kj<”Ÿ¸ÃxýÖõÄFÏÛÏþñÛ2æ»÷à¾ŸžªµBš ÐÒNÛƒ¡ÒÁ—^²Õ­]cÆ°;0ºj¤ ÎX¨V«;Ì S‰! Ë1Õª¾‹îK¤d‰‚³*ÄgÍÊçá¡{ñ‚ûï¤)hMDýìJ´NSP\nþPƒ£7öÐÙÍ¡?\\æd¹GˆZç£ÅÊà$,d3÷\Z?)PiŽë½¼Â™œÒò*¨·ZqšÒŽéÙÁF$E#Fáv€k]|û\"ë¡áÀjè©&cùàsýx|Á;)ï›ÍG•­^~08\ZÍçÍ!“©\"ÕOU÷<÷–„´–—}¼‡N»Ðß,÷“2?Ý&@t´……Ç\n’îáZ\Zèž†xßªÙ»ÑÔ³&Øƒº?ýàC]ômëÎ{ùí·mmc}LrmßB<Jâ=ADI’g5?i€|xù:%¡Ÿ-ÑTIÆßDVùz°Ý3¿\';f5ŠØ¡Ql´+…ÔH_¡~íß¤¥lnƒ[	_‘/MíçÒ{G_²¨ú4Jõ#ù]Si‘ˆÛÊ*mÔExó3^Þš˜‚·u•‘JÝ¹/á§X~@\'ßÎ’²žÕP</9k„|LØqb<9mÔÖQªò‹‚Œä	Ë³s½ÌásÓ»F*\0ìf0*I}†Ž\"G`€ÁàÂ~ýÃØö­-k·êöÉGÙéá‘]AŽÓ˜|y©S•ë®µÚ¶ùàmß}`“YU†s\n£ø+Rd7ïôæ# èb@°(f „¦Jåj—<„ã5æyþý¤ó™&ÛuÎtqlÃ¨DzRêùðNÏCHN‘Ò•§i>³ô8‰ªò‰•š\'/„ŠÎêx¬6$ø v«+Ý“Æ³Óá\"ßyà›Ïõë!m´\"µöû±.©Ç%cÒp¯&S$\0im¤áv˜¸œ“ÊÍN`Ìõ‚ð”?Ã_a¸âõÓ$Â}uM.¬\rHsô¢ì’\'}8ŸHd+êý}r›Pãº,i>+º±ãÃCI2’sã5Vi›:9SZøÚç?o?ûÙùk—Õoþœíe	4òy$\"J4™_Ï<×}Ò7\nÜ7ô•	@Jržç^¦ze°+Ö™É3óEPs3ÐêõÒ|NÑ„üá¿ík3qåÚìðpU,LE{ò¤mŠQåœ€ðJ ¯Jù÷+m”•¯3±ªˆ\0W¯A	”AXô:üW…ƒé%1Õ˜E\"Qš û>)pI4‰«å\Z—!ð=`yeÑå\\ÓOh] ‡ÌëñŠ\\q;Ãk‰K‹<5D„«Êæ§?r\0ù@±0 7ÍlïñËK{ôÛßØJ§iÇÇû¶ÿä©]œ*¸¨³?Òf¸Ž¥u[½÷Àvï=´³þXª¨‰”PÊæN×º®~¢JWðI¤jÜsÉ¨Ø\r@;‹ªi. 2-&­–ýoŽ€šzjÉó€×AÏ$Ž\nAä8†KPTIÝ˜¦C#øõŽ8G)£9×i^éªü\nqx%L*y¹ºúÔ\"ŠùìØØÈØøðHž:öHl•Yx,f\0Ò‡Ú]riß!ÊO{¦c3øÕ^Åšv<ás/ëèK­\rŸj½°ïMÄá\'91dQå–t DŠ%lÒGÅr«éd=é*kÊƒ8Úm©y]¡µj]®µš˜#òÝ‘*MÜ‡ûûŽìä†˜td«=\\.êšWøÎ»ïÚæÝ»/¸&¤T$×pÉí&JJdÅ\Z/]Qr­ó¹µÖç-‹@T¯=e *Óº>e°Ê?ù]-´›ÉYç^Ë\0‹(=×µ_“ß£Ê_ãë3_ Þbá§¦“½Þ‹WTáB—¥H¢BDN õfã˜Ÿ°O~B4MLq=ß#×Ê.<À’H-’¾\'r~Í #ÔI’««\n‚V4çïéWKÞA>Ž+K½YTU0,c<`ùÄ¥s~,ìsƒœÖ\rÔXøš*j:¹•Û»B¹Ó¨Ycriç{Ï­=›Ú£þ`ÏÛøì‚N=h¬K]£n·<´»o½mWø’Wé×ëÈØMÞ[ò+G›ƒk\'¼Ž£\r6£ˆHÑÒoŠkÎ1÷¹Xee\n\'$FI<ã3‡>?¦Fc4HŠxé|¯çœ˜ë³ò_ó,çNØ ».ÎS3xO‚¢\r1Ž`dlTÖ–:rÂ÷KšpèdóÌ¸f/08é®`‚ˆ´ÓQ;‹($â¼#ÃïÉÈ‹8‰ê3^*˜±é	ì¸ŒŽú.î¬‰Ô\0Jò×ËóÈ9„\n4È0:mqRÿ#ÆU õ‚†\\Èójÿ†’ê¾>«3/R´(HƒE@S›QØ=Ã‚/ìÓGth¸_X[ä?î®èÔ@Ž¯½ù–2Øf âï<³’ÈÃ:ÑqÐJdTf!eÀ*Ñ×a¾Y%J+ß·Pü9Q›‚c¬2 eÐRk^|AÌ-`¨Ô«éžï•¯óë3à´§vUi…ƒÈ7šPsznxv»¨“Þ­ƒå?eNÔñZ¾ Ýïc‚°ÔÝlh\Z0­(jlm0^ÉÇ\'y^ËC†uäƒSÃ@7´€èkqóTþ_U‚8uQdZêÎ\0ÀôÐŒE›$¦mÄ\\=¿Áš?hÊï!ü˜è|æ_|êÑÀ*ç\'öéûïÙÓ?’ÈÊÓ‰Ò1\\\0hÉyðÚëvçÍ7m0½¶îò:ƒòD(ðâóÑ3Ç\"ÕàÑ‰¡6%‹\nž”Úx³Ÿ8IbÏD\n°´i=)w-o²ì1õ™û…iÔï¡³™£µ¢Bìiš_—6D—†ƒ BS×T\0aS³y¥ÉCô5aü•£HüÁ#oHsÆ2~N:»¨Jó(øÜìv}b2b\r-õïÕ†5Tà×ZŽ€Åƒ{7ì%À‚Gý‚ ®ð%åÁ›¨\ZÄ¨-¤ê!-TSqXØ)spB¼{ï#Ü[Kƒ/Xg4qùkpkSÏQ¢zF)0æ\"Þ\n]®c6ìŸÚÓgOíøøHèš\n!š‹É¿Ô³‡¯¼¢ª$Ïf~ …—\\2@x†âD:÷^°B\0î”M¬ðr¨Kˆ9KÄ”¬‡—¬|ßüÞ|>‰Ì@§dL7¯‘ïwzÇ¯ç2ÖB\"ÀL¯+_ýÚWgž²9ôöÔÊ—¸FrÇ‰œ7(_¸•/N3Ž,Ge^9PEOÜCÈ\n¸aÒTL´°BdôG¿B™\Z(Í‰EC§Þ«Z—P•´×ßlœæ¨ªÆà¾Z+ÆCQ%4‚.DÞ€ü7kµ€£ÀÜBV½R—SucÖ{pù¨-\'Gýszut6s§ƒ¼Ý‚£{ôÛ_ÛóÇŸØøüÔ®†}õvaF7­U¬ÑéÙÝW_µÛŸý¬öG¶¶½kW³š»zNÆr€ç ˆkòq@g¶NÒ0ª{l8!HD§4C{J8GqÚÎù\'9iøÔ^SŸû>½œK\Zà‹TìGQ-²à›ráùÂYÜÇ¤ù]–‚•4eÞà²re7^é~Jêû´Êpr­Yožây¡Ér¥½|Üq´iUÍõ[¶fh•tÊš¿ž\"¨íq\rªrj`H¤ºâ°®Õ˜Ÿ‘gÌ/OÃE#¥…Ì_Ô\Z@Ò\0ÁÎ×=xÅÙ‚¦\Z-U\nU¤’¬À©‰`5©	ï#î¥Qku‚£©é=ä”Q1»8;±Ó‹\rQåßÞÞ5ú67·l	/¬­\r¹•’‘8êXÈor_Î÷g¤w™¶%Šâëeš˜écù”H©D[e0*T¯Üw™b–©cÎÍ43ñyøäk8f±Çî±òÕ¿úš\'Gâ\nœdõ@ÃnñÅ/H~©Áu\np%a)ß\'—˜ ìº ©Ž}]/é¥vaå¨ËCWY;æÐ±œXCŒØ&âÃ„Ü´\"\\Ã%wüâå]àd¡üæçáÚBÎNx$çÚ2`iè\0K\"Ëø:\"×Peƒ8Qõn…ãT_­ÒP¨Ù¬Új·kýÇÙãßÿÎŽŸ=³Ëó3»‚ÃÂ\Zš…ÝíX½»dwnÛöË/ÙÅhjë;·ÕdKYžqôs®		ÂÊ±M˜ËeÀ’‹²?ÿ)°@0;o˜Á†ÏœÂNÝh¿pŸ„)S%mö@)³¸_¹Ásœ—ÖG(þ¹\'âU‰ôÓ\Z>ÇQõb*·&… SU1yyÉ=«ÐÙå©/„7\Zz™t\nïBÀB|Ùj[giÕ@[nu„*ŸƒåÊ|C=c·jÎÃXé³\n~ñŸÒ¨h=r­T\\‚—“ºÒÅ0¾G\"×°ºñMïÈ)û,S©­ÏYñÌüC£ë#%”Þ‹ ZÜ÷ŸÛYÿL.®X ¿|çžÚrp¨íl¬Ù­—ÚêÆ¦¦R\'}S§s^ìÒÐáäÿ‚òY˜dðÊ@q3èdê™Ï\'QOú!¯!¿\'Vþ=ßWqE4Î¢0f¦«ˆÅH¤?kNï÷Í¿ùÛÐW\Z/ä	‚Û¡›_˜ŸBŽ~jó‡ÍÍ&§Æý¤\Z•…eA¢2oÊºBg¥…îU>N\'NcÍÚ®â?)ž ¨Â~J¯I?M-Ú4dSr\n:1V]ÉP1_Ñ‘`ªQEÌÁ.b6e«g(«_nÉR™Õ¬NµiŒˆûà%»|ò©}ò›ß(`].¬J\Z7»÷RAð¸²bk·nËäªÂ|Â-‚æBEÀPÊÔê(`ÑGÇ}2;ƒú«ñÄ¦ã‰Uàg¦¤r¾É²gŽg#ÄàŒˆñ¤n\ZO¥HãÁœ6œD#‚Þ\'ÜsÁ°JHOJ·2n ÞPŠ&ŠÍ\'·ËëŽ”CH¶â¨X÷ŸvÚ…4¶¤ë-;N;ðù8áÑhAù¸úFwÉÚˆ5¥Š÷4º\0ŽTè*èŒLeô: ýH!æI“ï™¬˜Â“k@ä?nš^ÄZ«	)ëÐ®ÀÅúX{¸+Ö	Y‚ÖhÔµ¡Œeªk \"	k	zd(ç‘Aè£\\{rt €¥¾ÈAß–êM›ô‡>ìâÎ-»ûÚ«ÖYZÑ|Ì2À—t€2‘ø•ÔL8‰¢x$òÉõŸ¿ç÷gðÊC?3™›¨ìfÚV¦{ùç|bbâv®­\\3¼_ÊÈ¢<\0NrÏV¾ó¿ÿi6…^]´ß°XXÔù¢óž±€Ø™.hÂÈÜüË(•\Z7ï÷@‡®‡žÄJ «j…~<ëÍ/æ±ñÀ‰˜ý¨ˆ¨ã	“}}ÚŽ×…ÝåTd¨|¾–ê(á¼HX6¸Nx äÌp&QCˆàëz$·ŒYäñ¼nÊ%æºœŠëÄm7«úŒ=Z;hÑ¡;´¹¼Ò±Öù©}ôË_Ùþ§ŸØõ /NJeNÕî’u·¶l}÷–õ6×­ÞìZgyÍN/ÞZ#$q©ûGzÑ¦£Ùí§o›ñ¥MÇSI,úÌ%A™äduŽ„zLQ&JjÑÐGWYõ€åÃjA)¹ã°]‰‚ŠÈwÜžö•÷/û%iCGqieŒWÐØä>Þjc½h”ù¥RÙÑP¨“Ê¬†0h’NÃš=¼ÐW™J!‘¦ÌõÀÀúòEïÊN*ÞK…! ä©ªúgçðuÝPý…Eºš^d|FU¹ÃIIºCŠ8.SààUáHÙ‚·\'9™ìÈ”/ø˜{\nGý,åC\'‡‡Ö\rl4<·ëË±µ˜¢=\Z«€±ûê+vÿ­×¥ã£ê”A#ÑM¹éKô¥g©c³Ê7ÓÀ2€eÐ+QY¢­r]äÏðû|†®-¯-×„\".$78,Ém‚cË€•)!ÏG(4\Zí+ÿøý:%­žóDâh¤œuíN\nJ•R\n—žÇ«3rGÃiD\rÐóôlÑûDJÉiIï!‹ÊýÝ9]…T¢ÁWU\0Af.\0±\rYÊB+O}?5¼j\'Ë¢%\'NÍ	¯iQè£E%1‘ˆŸ˜q¢ÏG~º”éå_jv›C>F¡XÆõ€ùoü6»²^·c½ñØ>ùýoìøéÚÕ`àž4 ƒ•UëmïXg}ÃVww„¢êÍŽìDP›ka©Ì^‡’ÁF:Qªš}Uq2™ô<U5óAÆ:Í´ßK[[-Î1ð<R×‘)“¼9´ÑcÓë âÙùDaÞk®µT6×	Í\ZÈ¶½Ál¥P^¢+¯êª&ìÝÕÔyIn¨–FÏÓ‚D¡Á§ÖàJ\0éÞ[]³J]›ovÖôâ¢êëO•ÕXËpÈÍƒéÙƒw.¹é!÷B÷S–3‹Ž›Ôçiª’ä2×BKóïSk‘Ê œ–#©9’”ë\0ß_B#ˆóg}Þ°œ‘¬ÁÌöžë³ËnúâÔ\Zd.Ã±,¬×ïÝµ—Þù¼5Â¶I7‘P~Æ|ö	6Qéà)”ì7SÄ’k*ƒL\"èòý2Ø•²PepKÄž™OVè½nÑ:—´†þ=RÎD^ôšXå{?þÉÌK†è™¢Œ\'9ÎƒE¤áÊ)á¨ªCnôA™9yY‘_iòGXK	XµCxY{](›\r«SU(ÀQ.ž’»¦#‹+sò8‰§{~â€­èóªØ›¤Êït›ÈÓ\0¢Ö¡¯þß¥Æ¦uÞ‡T°áø»+á¹_ÑˆM¿›V´l­Z³Oß{ÏuZšÏ\0\0 \0IDATŸ<²áÑ¾]žŸZ…¯³ñ¿wß\Z««¶~ï¾Nrî7èSeîŸ_	M…MéW1V	R¤OæYrÝU!\n×Ù}ài¯of—§ !ã™œyJlì–ôŸÜ2¦„žœNºÊêÙÊÐ¬\"áïxèÆ}Ú$±ýs¡NwÕº\ZŠ1ÝCsíXI\0ûÆê„é<-EWÆ^_]2xPÈSãÀÐ8É±aY¿Ãiáê!Ÿ)\n\r×øÔ»0V÷4ÖŒÐk¤Ìã1Š÷ðÀ\"˜Dß(7ˆÆo¤ðO¤™I\Z—Tîi^çü »/¨òIð&Àƒ¾Ð[#ÊC®\'dÌat²ÞÓCO	Zý³SyÔkÆãÅ™\rö¬6½¶õ­\rv¯|é‹J‡¥oSŒä—2ýÊg™ßë\\®5ùÿª(fú—œRò£‰Âo¦eºèèÖc…³\\+—ËVLz	‡\n ¹°çåé÷‚Ž\"kò¨|ÿG¬¹-|mrL:§±sZÙ¶CTŸvU‘üWùAX *‘s’ûNQÀ¢\næÃ-ªâ¹¼¢ŸŠ©‹ñ0úÕÜ¸/o\\žùzJc“³)ØnEáÍ²š50Õ˜“|V\'[=ýb{k‘/úòÁd µ”Ò™œPÁÍ?µŸžFã“t{yÝ?¶ç½oý£ç68:´áÉ©MáýºÛyø’-míØÚ½ây/\Z¤•&ilú¥F}Éz%¤l®—kq©í$‘Ú×^ógäÚ¨\\$ó“M¤ ?9¿ Ê*ú,ïÕâÀó+6Y.l>âKZnô5¹T¤R¥Q¿‡üG%ŒkYYÝ]q”JpI¬k³Ä!ƒ<Dè5ø0‚#ÃQIÝHñ@Y¤°T¼F­Ñ¶Z³c-Æ¶7ZòeÏV1ø<Tøª<…¥Œ6P¤½|:•ö:9ÏgžW¶c]ó|AW‹\"“ó«~¿Ý\Z‡ûã)áBËÚW%Ò0QgßÜyCãêë\nú*4áÚ Œ¡\"NK¤ûÙ™-·›68>¶áá¡uª[ÝÜ°•;wíáç?§J3ô’w*‘Õ¼èÕØ^ùÜ}e(‘PòàÊ\0È{Ü$ÞK„æ †Ê¾,/ª,ÆŒ%ò/Iöüùô6‹Pâ‡,°\'hŽü|ºÖï~ïû³|0/©º}3æéääü‚/ñÍíU8ð9™I˜á›Ç–‚\"©Uµ&2žÈ5M¾Àqò„k ‰5G™Þd´õ©Í‘‡êÆ¸Kƒx4ŒùCMM ŠòêIZ´èdÔÏkËô5\\	™=ðº$€\n¡ºå¢:I ×U­ÙÎê¦MÎ/lïãíèÓíâ`Ï.Xx£¡ªZk;;vûåWm÷3¯Ù	­\"“±­é>ß´!­­­«=‡4‚´‰×ÎÅÀƒSº™O08EÀÊ\nÝ<¥cá„ZD¦æsø,8¸NŽ8O‘DÉ<Ò•$pAÚt¬¾?ôuâŒB\nÀ5´Ú=éÉ´6ª\rõÜ%\'¨u#¡©›äQæ÷…œ<ÓØ®iÇ4éòªÄ[«e\r¦`¶Ÿæ\'ñ:\"¹)ˆ¸Z|[·TÇã¡#Q!8	_ìD30a(„Š¹iUTŠ*¸ÐL m§@!‡‰µŒ6¡³PXï¨à¥¥óä“Œ¬ª‚S€ø3ÞðÏíøàÀ–ôŽ/Î¬MéÆºuvwìÁ[oY³×“r¾\\¯Zãÿ—œr\rçÒ²âï×å&Ø(ƒ†£óE•±ä¼JT$tú®üž]ñçÜç)ƒñë÷ƒ`ÁƒeæT÷¬&­£‚ƒcâQåÛßþîŸo”›‘¿ó¡®®Ä»6L ª&\"Ë\"åH¦ ôà\nGAŒøesË)QŒŽŠ*dÅ¢);YïúÏf	Z(\"+š¡~gÿ–à+ü€x\'YEÎÉÉü|‹j…]AëJï’‘í7Ë‘‡äQµ€ááÕ”¯Çµe5q{}ÛêŒ-?Ø·ãGìxï©ØñÑ‘´64¬Þzø’½öå/k>Í­§çg®ô–˜{à®-­®X½‚O“ólDù|\nîpW`d¡H6#AÌKøs„h^ÝUª-³º…³jêàøž†¹Ü¤Qõ…œ‹97Eetx\"è…%ÙLŒ7™»)^£åD8-W-Íã#À³y=Ð{4+´aÿÄ¬0Ò	÷ú¢éz*Â¦pŠâåèÐµîÊšœ1Z½ž|Òø]Õèä¼|ÎM$…Ô®ÜƒžMxÔlw¢pÃçR‘ˆ Šü²ç.7×ÏúÊgïÈ0¤> %íF4gÈÁYIrâ®¦¤9jC“}Œîp| ‰‹Á…ïÙÉþ¡-Ã‘1|åüÔz¶õ66¬½µaß~Û\Zí®xÌ¨`òw®µä¬ò¾fP»‰°r?äëeŠ™§DrIŽ—A&×Hò¨eð,_;÷²f#Ä!™A«Dtùç|_±T¥ùà×è%ÄqîÛ¾Ð?èÂb’Höb:(H‡Tmr›ï©Ažà<ßò“\ndFuƒ:Ò?¡à øY£^Êæ}²§-£o-÷`gS‘¾,\"tBÍä]dk]õ6‘ò\'QÏuòç	D­nHò=>ÿÌ-P<h•0»|°yúÂÿp··nÛä|hu<¦íøùS’G¹Lp\"8Påyç?þ™0\"cÒO˜HÜni\'\\¾YËk«\nXs®‚™Ó=ç<r¯Ùô¢¦×B$»º[Fð…¤nÓ©œºÿku}<a»ãz#=Ç€îê¥Ç.V	ïU 	q.œ+Ém¡’wï«jL¢Aª@»•ohõÜÕýYçFÆ,–ôpWpÅ:GíH—BV46¬ôŒPœ·:¶´º.›iN¼­êv #Ð…X9\nü›¯]Gð8wbLè^_Ž¼H„I)ªOÊÉõÉuK„ªCv!0õµÓ}”î¹ðUGÑžB‹dçð”d¥­g -–œ‰TìôüÄž=ÿÔgçÖãÙÓó8ØæÖº­lnYïÖŽÝþÌk\nØpÁ¹¡3`d@(ù×<¼¡çÞœBŽR¥DT‰®Y#‰´Ê X´¤Nò{ùþü·üÙDxN½ù3]ç÷Îé¥»N/(x QŒaÍõ«_ÕO—$ƒ—oÔ¬žeO—§cœbíƒHKÞ@[(Å§3šnÝ§G¨‹“¬R•\r0žO”¼1I“ü@%hlV\\ìÉ¦s„ài(1-AÄ¯‡\rp¢ˆ¼Y‹\0åfiRÓ–Vnil‚Ò\r‹é¾:B’áÐ×9ºl ö÷öÔX_—aZÅ¶·oÛl4µññ)\"2ëŸž™Q§_°ª\Z\ríþk¯©™–1_ƒÑH\nnLüèSkwº¶¼ºfmšiyXéy\r¢RõËy%x\Z\n\Z~º¡mòê¡“êÐsSÙ\'k@-U¼àê-øCÎïƒ\\\"*…Þ\\,±Ó…–Æs¼°\\L,é€Rg—´ÀËH¤»C6lî¹Áô¸¦™‹0á6yÆZ´²(Ü„.L(V6Ã>—°ŠF•[èç1é&>·‚·ÆµaÄÃRõ9\"Ò<`aáààBg´kŒ·Ï¢‹Öc”Þx‚›Ñ!	âŽFg¹ÖJƒXqžJ¢Ù{EÎ·:\nb¨^=­hvâÅàÜž>ýØ¦ƒ±5˜+8Y«V·Õ[¿µk+»»¶uïžä?~X/‚¦gPJÄ’×š•¾ò{“»Ë —Á#ƒQî©›|Ô¼‡‰ªòg=0y€Ò³ˆª¼27Ædÿ³ŽÔw*nšûæB\n½£øÚ7¿ùÍ™PNpòœR\ZäMÊ.	(»«UT¢SÞÅ~aÂO…ˆO‹_)¥fˆ &`a{Å¢ 5ô>2\' ¥Šg\0¨JÌ\"‰ª‹\\VånªBÑ—r‡òúæ‹<}i9%:•íg‚îHeHoæ=‰©Æ‡HÓÀyÓÍ\\ÞS5=<éXg¶±¾míJÃŽŸ<³êå•\\=ëÝ–íÜÚµþyßúÇ\'šJÜêu4L•*æþñ¡6!„;¤r··¬	ÁT\n%˜Ë¶m4kSÍ:‹ŽN,LÖQJe3Y\0)`)«ŠÂò“¨òsà!À}wdémYZl®Ä#*5óö‚žœÂnZÄy[UZ&Wé™s{™|>Òuñz3o,Æ\'_i-×PèË€Ýp›OZíðœ¥àª¢\ZG_žOŸ¹¦õHÞ_pY.ÇP:\'i×j°ð|Çæ(]Uqö¤i›\n¡:&àéBÜ˜Žµ(£GÄÂÁ»òyšµ¦[Õ€à¨:ªTÚ!L‡¯Rá†õV!H{àBæ\0Òxòü‰ž<·†Õl©Ù‘`ô×[éÙòæ†íÞ½oKë[\n„ÚOÑþ“ÈªDþ‰œ38e€ÉÏ’ë½lEÊÀ–)¡·¥âÍx¿qåáS¾ny¿Jô”kIë\'¼®Ô¯{å3¾÷=snsÁ­ªÿ•eÈ5üõ7þJUÂüü.-ææ¿{jÆ×\\3äb:&lØ+¦îÎIzW³hœ Güm2lB¹_º±¿ºÛ5ÐÒ-eò4‚—é[ÂYEÝØxå©‘?7\'Õ×µ¨îè:E:¿ >‚áÖ4J‘\\ñ­bâåtIŠjd}žîv5jßh¶m£³l£Ó»¼ÀêäÒZ«K¶±µ#S¿Áé¹ÚuÎÏN¬·Ü±µ\r{úü™i\no¶¬?ÛöÎ-ÛØÜTƒm\ZåÉÉsi7›vŽƒ&¤%n£´8lhp5×ø®a£ù–Ï^¦rXˆyx‰Ðf×yxÝ„é ‘<…Õ^9‚°w×QîiJK¼‘ÛGÍ~Ÿ1¬óþ·ôtçù*è1{°ÓóJ\\\ZFºÿ¨½	>ðMð_’4„ÌDT,$ü¹©†`üÔz.xægãd\'}Å_¾ø—\n‚¢°/b8mLËn¶ÜêE–kµ†8§D ‰ÜË\n‚†ˆ)Iò<…‘žÐeÜÝËŠ¯5Ç0\nøJ—>0¼vb}ü¡]œhœ×&£ÄH£iˆžŒ­ÙëÚgÞxÓ–W6\\>VYÌ˜¶¡G+‘MDùos”Á\'Óµ›DyÆ€R†¢ª à3–ˆùÅX‘«ÖÏýKF“=–þš‹ïËï)²D’Êjþîþv>ªžpï©‰~i,.ª°–ðï\rõó¼\r!{É™©¶&‹Ò²÷¾¹1œWÀZ©„½ÝáŠ²rzPÝ(£–7»6žZJ\"m…G6r‹KóëÕ©ÆàBPÍFÄ€­îƒLY¤™n‰3‘‘¿—¶U|4å\Z[¯Tz…ÉK·|_¯Ó±åvÏª—×v¼,$Âé¸´¶j§çvvxl“þ¹<×gf´9è|4²­Ý]ˆ¿sï¾¸,ùFå,È˜ÇûP±Ëë„Ëà`pKa÷³ò”‘4U:¹@€ ^%â—NOÉ-æFbCkÛ-ŸI(€hcòú3fLÖc¨jÍ(Ù±0ÖÈ)G)x–¹‡¹[	óºjÂÞe4“,ÕÕUŠlPa¿¯ƒÂûþÐùÍ4‘š~êçÓk“bAZ7%o 2ËÛ¼Y×Ïú½ÀÝâÒ$…–³åÈSj<ÀHIAˆ¦*Ä¦÷\n_Í.þR7Ú‹Áp/\Z5ŸOKH V:=P\0rÝ\ZQ§<ÍÔ|&Ðõ/ýovqr`÷nÝ±Õu#È]œj½úÚë¶¾²)[&’UÊÊà•w^kVê2=Ëg™`å¥˜ù\Zs¤XŒäJdw3ÝKú…•_[ 7wU\'ÿ›AÐoŠíµ(‚©=Š, 3½ÿñ­o)`ñƒgÊ¯]1QG•¹Øùg\0¡ro4nºø¨š-ðÞcªIÌ~9ŽÔàp*ÕE:äãƒðý‹›’	™ùQþ÷Sš‘ïîà%a”÷ŠôˆµJîE¾“X<`\nÎ«ÉÚMÿ4Ð4,-üóÏO”ç€^IÚ¥à·¸hmâcÕéØúêºz½Fx’©d‰Â£¡ÙéÉ‘ì‹Ÿ¹}gWÈábti[·îØÑy_)ÕÖÖVLŸ.z8EP5Ëfe65 É9)¾Íô-5U¤¤ÒyŠúýÃÓÊSát+ÐÂŽÁåéÉA•<U.&?ü”7ÎŸM»cu0Ô¤?c„:éS–ÓŸ‰Í,çk¶¶º&?vªÜ\'Œ94xo-l^G\'…WÀ20Êô¯ÓSjMAÃ¹)×m]”‚ï$ ëD§bBedéØªt—4ÄÜn*9²[!ãEžà\"åLÇ|j»PÈ˜žƒPi=¾V]ÿ„¥8ÀßÆ,Ä_üä§vqzdî?TQŠ!¥%;\'¥oÖíþ½‡š -·MÌvkHÉåf¡ ±P	ÅŠ‹&5§3ndW‹ý²˜x3 &bS’ùÓ3ètN#¸[\"bîU˜8íéû:¯aîwq(ï\'©2ß“ An#ÿëÛßUl›¿ql¨¸°´å´´/¡]ÁU¼ºðP º\rKpYæÞMó+Þ‰Àiï©¥pc„¨äâ§W²‘¡Ð¡»WçOäß3\Z«¯Ï¼qš´S06¦Œ¯Qz[†R–**/¦¾Ž8\\û!c@\Zƒõ]?Æ§ô.°ôâ‚×9wÓÑ-ñçåØ666mueÍ&c6Ã•R8þÃsür<P:x²ÿÜ.‡[ZîØÊú†Œüvïß—Ç»†Ä… ^Ÿæ•SÐª;âŒ¹áâbòt•©\\<ó´ÚíÉ{èß£Ù¼\\Øx+:é‹œ÷“n+m‡²{¾ðXÊæiÖ‚)ƒl¾rè˜í)8Z­ÂµÑik0*]ú¤²â)\'rÕµƒr\Z>]™{¨‰B8Y„\ZStÐgµºKVk3Î}j£þ…ëÄ²Ù>*ÙÎÏEAEC<°°ŽIHÑ,q/cF´SÁÝú†õ\0–ÏþNÏ¼°á&=ÖÂÓ3ó)<>|×Éc\rÝ ÀÐ`˜FKˆ\0FÅò¿ý­MÇCÛÞØ’ÍRoyEf…RîvÓÜ¿¯†x†Â«jN¤yáÖ)Ï³p¹wt”ü×M¾ë&OU\"+ç˜,x)Æ”.×d~ßonâ—´ƒ_ÿb6@\"?9üF•^‡Oˆ*ßùGóUtóÅjp>AÂ–ÑU4rx_°\0¼Í7\'\ZbGyÅ£;¡ŒÜ@Ïâ…±_ØepA£ÉÈ}ËeÓë¤AH_ŸnÈ@Í„™›j9K©k\nÒ‰4Ò9_x~sòÆGÖ¤”T]øªf¹4ÝáæRÈ¦6%ÙšøI!¸\ZŠ »Ô[²µ\r›]áR1‘¢‰zd6èŸÚðâD¥õ^þ®eãk³{÷­\"¡ãjSªNP÷9´Dð/Ü[wpÇÞ\'?©ßOÊ–ä0?Îý|„õÜvqðˆ³t)G.&×Ü¹84ù3ud¦`}™ÉO‰4ÕÃà…êne\\oˆToÐŽ\"×I7²#Íó\naÝ*Ó+s¡W;Gj‡›ƒß#¥¤â)r\\^XUÙ%7»=i“¤\0ov´&05ú*<L\'Ø8³&yî®a“£CT\\A‡¾)£©^4ÆÌšu8Ú‚‘¢=d8¹?XfÈ*ä—¦ãÝCÉNà]*`©ùŸùú_³Üp­UíìèÄòÈ:Íºµ-w4í-ivåu½&ã¾Û·oKšâ¡…ÌM¤”Ï¸|Ž„J*Ë‚êðªã‹dþØçëd‘9ÊÎÃ\r„Eæ#ï³‚¬Ï ?tÚþºù^\nbA{$xâw¯÷ø3ÈxPùöw¿ãÙcé=p?L«ŒÒù½Š¬ónÎçˆÊy-Šà<\\(è\r¬Œª§à&¯(ÚÄiMÑÆ»\'wL3Îj?ŽiA¦}jøÍ`ÃZƒqV…«§(>í9hX×,ÊC!/Ë5°:iœö!7¹¸ž¹Ç.Ž8=õò*èêòªuZq<ô¶q+Fh¥®àf6D,/w;6U*`=´:)a¦Œ&§m¨èÃ’É€2Ñ´ã¨êPÓóþŽ…â\'”‹qs1q¹hscŠÃ*Ú—ü ò‹y.+	K¡T7gªîò‰ð-RzPó&hÒ56jÅ—ò˜\"¤Éâ4”s01åæäT)!ˆŽŠg¢rdlÖŽµ2òCœÚíYQðMï/$p‘v\rúvqNÐ\ZØåˆtRVÒç÷TyŒAÍF\0@~’­b\Z<[d‘–ª «“sq+ßªUÃþg¾Ås\0Ùˆ|â¼WR\\’\\*š>óòâôÌöŸ=µµUé„ÜñÖÂu¶Ý¶ÕÍuÛÚÜÒ½Õ¡{µäŸ2p,Ò,ßIã$Š’|#ðü™LïóÙ\'@ItõÇPÓ¢ÊÞúrH‰a«®á³øÈ…”s¸®”H.¥Ôòúrì dMy°ü¯ï|[{øfÅ-/6ky³<±ó¦WSw>È¢S·âåóyT…û‰–qõj”ˆ¥ºP¥Å=äÙxC‰ñsÊ\rá<‹“Üy	L>4ƒí<˜EÊÉiçf4.’^Dsÿ¬²`F~1õÆk×Ð ¯`3x%Ñ»ì½<©§e>h7rŽFO/-i³uÛ]ñLò¥Z\'á¥<à?ueg§‡v5Z·Õ´þpD¹Ôî¿úºµ–VÄÕÐF\"ëš¸~-˜àoàþ8m2˜€°(ÐDÍs `i{¿Ü;—ƒ8JòA¦žš•ÄÑr1ÆôdÞØ^òÙ…§g®ªmÜ[ÑSçhIZZ]³n‡BBGŸˆ`Å+“ú6 ‘©L3µ¡¡§gêÍi\nUxaX×çš&ÒÔ›jSáÞUë-iØºKërº`¨N¬ãþ¹î‰/]îÒÿÇëùx:‚<¯GI0ç Ê	ÌjÂ‡\'­Õ=”óÆz¿G½N¶ëïxîkÎA4àsp#­5ÕìŒåo\Z$58Xt;\nZ²»ŽÔ’³¶º¤!Ê‚Í¦uWWmcgÛÖ×Ö¼\"«€‡B¡ÅÊ ãû#[\0?´¼8” \"0ùï¹¦3&×•Ÿ£Ê”\0Íç?xÆâÁhaO•÷(ãÂ\\Ä*äý\"ÿ–¶ØYÜâ\Z}ÏE–ëOŸñ|ëÎJ¨˜Hˆ$ªJ¨òtÎïq¨FŠD?›Ûãù+7¹TË’Cø[êÝ]]¯*‹8:èñm)0±“»I?uû0ˆ9cTpi¼ç\"mõ\'³°y¦k€Ê_ÉG±)!Î}ÌÐ¿%¤ÅÉ.]Q\\+¿£È€HäÏ™þdùPªê´;vÉ@Rø¥h§]NÐ]Ø¨®`FXm/¯ÚÆ­»¶¶sKZ6;rá) wØS¶\'eòg2Qj	’›§qáÉÎâye+Uö\Zæ”è4ð<˜_»ÌàÅØuX‹{ïZ¹<¹…:¼$Oá\'´SMë¬¬Ø­;÷T)¬# $-Œ\"Â!Ù™=Ù!¨ L¡fD8 Ê7\n\Z\0ßxúï¨4‚ÒÛ]»¦x‚^ëÝUÉAœsÄ~gh§Çv´ÿÜjâKy>ùºrgÿ,ÜÖMÈT2‘äÆñÍë½Ü>ÑÈluƒcS(‚^AÕ+±\Z®\"„_³×¦¬×‰†úŠ]ŸZÿüÔ6ÖWíz‚äb\"1)RöÊŠíÜ¹¥Â„á£æºÎ@•A©Ü¿/,ö‚ìNÄTßeà*3©8ùZ¸Rr”ÿ®`7Þž÷6àDV	$¼pS¶Ö¥¸Ù?×¢è”²ŠÊßþýßI8š0#4Ç§ÜxïTFíüyŽÀòÔ	ôA„Ÿs$àœ„¼‡ŒÑ².–Áœ6°ÜÖ…\rŽx|Ñ/¬m@\r2¢®¨²¼ÛúFÉ4odÞp×”,`^›{ÂH‘Æjpÿ¥œäaJÏŸÏ§ó@¦|>\ræ8õ¤Ún\Z¬­L“ÁÈ.‡Cø¾W\'ÿèÂ‡TLÆ\nŠ£XÙÚ¶µÝÛâuwÈ÷*Æl	EfÅV§NöXŽÜ7*ˆc®\'%î‰5ö,ÆZÍÓ:ôpQÒ Œ¾ÏœòìÏz27Ö+½W41\'×–÷ÑªªJð»woÛÝ/û˜4R9£´Í½hºÐÙé±ž5éâeÈ6X/š˜£á(®>gípß—–—4\rþÊzVoÑ0îœ˜&ÙpÿA¢—#{öøŸZ§Ýp;$(=sê¡MNÁF“™ÆÒGuº+N#D5‹ŠtÚÊñë0\\š©#ÓáQï»t^T#ì	\\nµk@š ÝÓýC¡Ë••ž»Ø\"¨©áÚ±¼¬€µ¾¶î2#‚{ Ú‰20$Ú-¹ L‰v2¸eÐÉ¬$?g¹ÏKÄ–1!*){É 7ß{‘6+ËŠ\0™ \"A_çœ•B)i™òº’`f•oüÍ×%ÍVB@„{™kÎ#-Õˆ]ÿ Ö›h¥.¤$ð´£SÞÑ7œ*cÌáŒ8A=Åóëpµr6Tòa€íðXªv‰7X´š¸b6lždXÞèìŸòA‹ŠJÙœô\Z’…*ÁÈõ>\ZÇÄé\n¡«ñäX¥ R_¢S¦¶¤:¤_³>^ƒ&×¤×ðêè°?Ðt=ƒkCSVo[kuÕ6ïÜWËÎ”qã°!åœ<Ò›X¤ŽW¤šDâÎÞ‰âûEW¯¢Y¡*.ù	RÂ<sÁÐó5yüç\r¬>½ç&¿1oÀföÞlf^}Ånß»oãñTk€iÓâ4èŽmz1t~ÒõZü\Z\\ÔG®#‹¾ÃVÛgÒÎE¥\r×ª„üW©ù¨x—t¸¸‰L5:xþÄž>úØz|ØÉH/Oõ,ò öò»;?h¢M½=—nøFu+åÜ1¸XOOƒ™‰À¯LWü®DÀûÝ 2Þi‰Lç°9z¶\'¡l½N±ÄE¸ RÒéz§£€µ›`œ Ñq>çù^ìŸÍ`ûaJ<³Å\"[)ÑY¦äúÉÇ\0\0 \0IDAT¸2sº‰òÒlŠkËýöo\n]ÀUdCž¦.z×æÿæ½¼^Ðšüæß~C:¬²œ­¯cg2ÿ-?´>”\ZK}<U²Å´ç\"cK«Ò„PÈq¾é¼i¶¦j\Zb@Ðìu{šDrüNÐÙŒ¹T÷…“DlPOc}xkù\0Ü††‡âïç~Ü0JL$ÉÁjJ°_¼‰#§jÃ<:ÈPŸÃ\0äc¨$ÚÔI}¥´°	W¢~ÂS›/]ðÈ´ã!¤ûPÀ&ôÒ´\neînÏ6îÜ³.#¢ÂÂWA4±ûz°×˜®5²èsñP‘UxÌrÔ{Ž]àš¿”Ö*+97Ê‹á´¾Ê)4¹F¼\nì³µ¨Xt³IúÊ$S¹ûðmß¾cç§çÖ?»PúÇõÀA„#p5ïÙÔá9™ØéÑ±£+®5ÆÇIÓ¦Ã\"œ-–W%iwˆê]66°°efŽ`«Y·áÙ©}òáÖÆqƒ»+éßl~RúAõZÍþj²î.z/\'E’NŠ´ÖSâ…«†ø`MŠÞJyãûH³X½õUozŸLíäù¾ì‚®gµ­ñúÞ²ÖBguU‹5—­Þ»ÔÏ%Í‘×´ Eüi\'7u3°å÷¿\0P\nW„ü¬™jf@,½|íùÂâÒ>t¿3qm\ZŽXï¨2*Ï™þ{t·à¹ÒùVœþßýÃßÌ’ìò\rºq}”Ä¿…F\"€ô495C}µÞ’à‹Öxi˜ÈÿÕ<ë\ZÆÕ»wwè±€ä³JµbªJŒÞrC:oýà5ñz×f“Å¯ëäõ¬ž3Wè;×á\"Rõ„á‹¥JÐÂÑ­ˆ]à—\0¤Wêê›VRªÞëF¥KÕ(oNV·½Z=å…ìVÕ‘”—Á\nÑÜ‹rpî³ð¸2úgÇC›ár ö †Ttm›€µ¾n³0”Ÿ¹¦9ò“.N!ÑéÄF “(ûCw	\nr‹´þÉ§rxaªäÆJK_wŸjh-†à@ b:ô]pc \nUX}C$:*…Ç¼r_õÁøÒ¶··lkkÛŽŽŽU|òô™}ðÑ‡vxt$’{uyÅ^yåeÛÜÚ°åååPñ_™.\npê¹£•«V—IÕ6ñ;«rlÐMjÝÁÔÏ[:¶ºÙs¿÷ž>³ÒÒ@Ps8®SìÈÆ JÓl8DBWæ›{1û17³fi*ÅÁjÙwZ=Ë‘Â‡¸]*eŒ l)°Ö˜\0¾º\"iÅ¨ó£?ÐÃÎ¡²†é®®j¼×Îí]—ð( ,d\r‰‚çdA²g€Ék-Ö¨:R±D0É_¦XT¸¥ìŸ‰5³7ï·‘|ð^ô¸ò ær§ìäšÊ€•)!¯´(pù%3àçÉ¬8¾ñÍ¯Íò‡3wTj%\\*\\%é.Áa*U	ÍtDðOâÖ»(–]{•i¢·öx°iâ$ø¼¨âùl¶…Ý„<ÌcÐªöÔgyißõA ¢«ë±#1:ý›Æì;µÂE! $¯%µ}|®<‰äÓ)m’è‚û9ÔAÕ¿ªŸ–µ†-õVäóDûLNV‘¥.©\Zˆ[è ’*WNpY™1l<´FT˜€Ãë™­Ýºc+»·4°BŽ^aQÃ€%G2r3ˆ¡Líáó;Âr¿0-ä0y\"\rßk¥š2¹sÛ–ÅÞqOå(\ZA1WäØw5c£mÒÔ#‚…p0Ÿž{\'Q¦†uLíÖö¶†–>yòÄ>ùô©=ÞÛ·sŠ*ŽÑöDº÷¥/}ÑÞ|ó\rãÇ‡‡vz|ìdb o§ÑÖúb(C6¨M:§Ýn˜	íAµ™}…TÙP¿s˜â–A0¥]‡…ï•âkµ\"ñ¢›ç©=À!G€lº­sr7<ÿäˆrÏ€²rC³†e§ ÷AóÑ£±†4ÐBÔîèº\ZØŒ3w“éÛP&ˆ#uÁ\rÌ··m÷Ö®õV–•ö\'JvZc¡\'L„SþÛ|ý¦c^ž¤f\",‘RR@%Ë –ß/þ7OúxBßšåÇúI\"Ýcc·â‘îÿF¥1÷_yMGáx\rU:ëVùú×¿6c&qVškéAý;¡¥s\r\"ý¸M®]H”Â‘™)Ä\"’©ÊüÙŽãéŸ6[A¢Ë#>š°E~§z:`÷¦n\nŒS¡œÇŠÄ5R‘+µÊTI›5^¾ž‡€pˆ*Ñ¢\r€’·Õ\'F›ÀÌÔ¿ˆk$UDÆ7¹µHÀÇkrÚ6[uyŸ×°Ð@á=‰sšáF@s¯,*á†Æ~µ×ÖmûÞ<…cd¸½ª`N«Je¢oPVî‰Ï/!Ûà¡XþoŽº¨ÊæbÕè+‚€jÎ[ùÜI\Zq)ø	èþú>±FqWa*¶ˆÈ¶©Å,Hî{ùÌA«pQ\r,[š-Ûßß·OŸ<µƒãc ¨˜\ZŸ!»	X÷ïß³W_}EÏÍ¼ÿü¹õÏÏl@šÍ*ý£Ù¡ÁZÛÜyMZ}vrfÏ?¶ó“#UšïÞ»c÷^zhk[üðIÉY\n7>e‡Ï?³jü»W¤*1¸$F|ipª§½Ü»œ«˜E\nÖus>žIÂ^¢ÏëUMw©{ÚŠJ?4V´GMI1A$PÂ’UpeÕª­ïìØ»wDÎ{gB¾nH<¢ –«7õV™úå÷*DË]·òçóÐN™J™X6Í‰Â$LŠõä¼”_gú±{@ZTþÊ×ô@ƒ“Ö‰ûÎ÷9hšYå/ÿòÿ™qQÓ+¯ÎeJápÌUÚùbN4†B=$TÌ²ÊÀfn]Frnv\n†Wio\\Eîh€4˜žœŸW	ÝI3o\\Ù¿hªž…‡9è#	øäPÂÕySòAIš%WßÐÎueÉZ#¸™Œø”ºÕ­	)®¬G¹SªyÒ­-&ìüC¦²6MÖp\ZWô%V…ÂÆ\'\'\n^4÷êRá™¦×Vïôì¥7ÞÔïX¥8Ò¡Íi,‚›ç(T©Ö—x°‰½åäÅ€ÅD›äx*…<;™ø˜€Œ=ŒÏ”L´I”w\0ñ§6ã\ZT¥óô‘ïeM®üÙès«)ØÛT ¡%\roýQ êhoO˜{Þ¿°½Ã;ômeuÕ^zéUx¤ƒkëkB§ URE =ÒÂYA•^F½·Ú¶±½k[ÛzÆøÝ{öéGŸØ5ÖÇveËË=»wï®½ö¹·mmcG(ŒØ }‡V\n:ù)$­g–¦ûÊ+]ä«ä(?‰vVntÐ÷­‰empJBTác¯u¨VGÐ Ê~‚n·\'#>®cxq®µÃ}O®„°º+Ëvÿå—mu}]ýžhEF¯æb_–H)ÑRÉEæþôCÈÁ†žq´¿•û ×|®‰%§¥@M9RÅt*?E¦”1C×V’ùººçÕÆxðá&•QùË¿üï3y«_;g‘A$O¹JÆ¼B57K_è$»¤XúdÛL\'\\…½X’jã}ê3ø®¼–ŠLÌiËÜ:[O2øyÚÆŠNé\nAJã	‘aYËÉ6YþÕƒ«˜ùC™Ûß,lD‘eêäðÃÑ,ž›¢þBã×51Åý×³¡XžÝRþºSò©”#x\rONdæ7<?w´ŠÃdó¬n¯¿õ¶¸«\Zpg\0X£M†S8	y¥Už‚²a8ê%ÅÀŒà¦@gr,õÅ\nâãÉÞ¸Ãl5¼Õ«§\"”çƒ&|ðÄµxŒšòuR×3ä&%}0B\093iÑ†çgvvrj‡‡‡V©W$^Žmww×ÞüÜçe‘ì~RS»è÷uÏàª(å“F~üÁ‡Ö?cÚXÏpcwÛ¶ïÜµ••U»^Úû¿{Ï}ð‘U&#[_]²ÍuÛ¾µkw¾lÍÞªÐ˜ü¹4ÀlB»3%	áÐðTNÅŠ®!h ¼§4Køžz•0„#Sß¹Áe7..ÏÇÖ)@4Ýë­Ó[ñàY©‡\rvÕNŽ¤îï4›êz­w£i;wîØí{÷ôy³hâ(o¡%,¹¥¤:’‚)Oþ9S¯X\\’ƒÌêbÈÊ÷ÈÀ¤½Ä0ØPŸç¿#5)ƒg‚·1‚1°¸ÃA	rYåu*ÜF9Í0µÊ_ÿõ_)`-øíž;9rkvå§ª½¢ãØobFR—QîÖ´™0m«WàÀÇ¸å-ä­\"hÌ!+¡i¨HîŠ÷òf\\ˆS6¬Ï<äWºG²Hx}|nW›y=ÿ›K79¦ÏSEÐ4Úx2âqÈŸJƒh9?oq¤‡M·HÑç\n^’7ˆy+¹\0ÌŒ%©ÌX\'FK©X€ª¾Ñ²—^}ÝÖ6¶Ýb7`2HîyŽ^W•0NKª>VÍ½ÊB±!~)OÓêûôG>Y†ª\"2Ò.ªvžžûìIŸ¤ìé,¿àÂ¤\n§}$íVHy	Vš(CJàcÚ4I+¬Šàh†è­NÝ6„ÞÆ«©õ–—íåW?£€GäÌ„º«Uuðûþ³çv°¿¯g·¹½e´ªÐŸÈ\0‡n«k£‹ýË÷~`Óñ…ín®‹÷Y^_·õ­[v]Gþ°äE>RîK¯Éäxˆ1g>lÁ¥5\n4ÁC–éŸ÷°º6kžNñý¡,×¿Ç|ÆªwÏ<Vñ9ë­Ê:\ZY÷ýÙ“\'Zm­23lÙæÎŽíÞ¹+T¦Q`JÁœl×^	“Bnçz½ R˜9å>È{›Ÿï”DðMÒ=3‰ú½]jáË¥õ‹/¯C×Kf‡íms`_X›q\rz­@båkiÿãÈ\Z\\7¡GÕ6¹6òC‘f¡Ça{Àr7KŸ”âÐËÒœ¶nx§ßåÆé4i±˜[³Høè®‰¼¯Ò½z\\ Þ[…Üò&ÓTÚuÆHH=\'ôÛù|@]ÐªæVµ4q¢úÂò†ÑÂ¿|Ž ükº©1@U†Êê‡‚®\ZvißYx&e¯¢43Ñˆ#Áq’ZhÂŒCo)X«ÕPé\ZN‰Fpòx4Ñâä÷VÖliiÕS¿@©l*/*àyï¥~R->ÕGUÐ4ÃÐ7¤ë±ü¡ÂšÁLégÈÔyUa)ÙÑsE€% \\‡¥EŸz«œ}ËµËHÑº‹“ÔÑ¯Ö–Ä£ÑÍU›NuS}]][”ÁZ×vrz¢Š«ÚbÚmýŽ^\nÒ^¨kkÓÆ¬»Z]šµ†*u{úñ§ÖœX£j–òº½•\r«¶±ŸÉ6\'¯¸\"_€p‡Ëµqà‘2gž”òÙ±Qq[U™U¶÷BE\"/ž¹#Žtèu%wêükf—W×Öe–AgI2M&·Š}ôáB»¸ï2 öÎÝ»¶½{KKœRÖ?ª°ÇsÈM3ePÒÆ¿ÑÍÀõ”Á\"QPŸy‰ŸÍ@•_Ï\0R¦„ù32Bfø5åÞ“R‘¢Ï|gGÊ‚þH®M3#\n×[Þc\0ïû÷ÿw3o©Yx”\'D$MÌa”ÀROüTZí,Ežå’}Lt´«ÇPý[©Ãò”R61Õ€äau“–y3¼\'ÎðÎ“0˜u!Ž”¯‘ü¥M¹317/ž\n§ºV¡I’\rdkðTâ™æÎ©ê¨¼xþÂCï£©60Èïqæb¸AÑ®”.ªŒ9ã~CD+0‡ú[-Œ¯hº³%I8 Êe„è&…|Nœâ˜ü¤SÏ !iMåA^*°_Æ÷‰h‡é‰ÞCÕX6¿¹qç\rìQÕõ‡\rrúCATgª’C1õ|(€Dñ„þÀNR\rkðŸ[^^‘È“y|pfJðl:3¡º8Ä`«««Öh7•æÑ£ÈH4œ†C\rü˜NGJ1y]†S€°@3í6ö6x‡\r\"]ã3ü\'ê]äžI×•[Gß~hðzB02§ðÍ•ä2Mî:‚¯L²9Io9?€¬ù:âcl–5ÚÝ@>ùäÑÿËÕ›ýX–f×}ßˆ;Ä‘sf×Ôs³Iš¶DÐrSlqj‹´DÂ0,È2M\Z°þ6LsÑšl¶&Øò‹ýà0`Az³‰’šC“ì¹««ªkÎ)2æˆ{oÆo­½Î=UY(dfdÄ½çžó}ûÛ{íµ×™•òø¹ç_R°å5fs¬ÒV;Œ@	4Ã/ÖhöXpÄný@™L0{ÈÉ€\'Å¯3Á,G>c¿ÌÔû3ò…ÂpÝïæÀåký‰\0ÓÚzÝNøÓ÷7kîuª\n	s–×a‚¦`Ÿñ/X‹Abe¥E‰!ËúrVPSZº`È&S\n`¦WÂ^ÜXƒë¶8¢$;¢c˜ É{ëÆÈ:,k÷\\oþ8ãd›”r\nþ\0¦ ¹>³Œ)q”‰	›±U¹í\r¾‹j ÿu¤l&ãõ…Œ _ý{×á(nSYÔ˜ÜX*£zx…ÝhºÌ„É­RIç‡¿w¨¾rg“f\\\0~âmðr‚S±yÝa¶\'ÃðN&UZ`â(f”nûÀ2Ðlta[Õ\rUÀ—c7¯	‹Ý‹_¦pÌ`	K+–ÈÑk“eEš\ZŽRal©,ðt	…u–É.Ôøs1¡µ¦·ËB7–°0Ðe½¡¯NÙ‰ªÔ˜óÓãv:›i~pm¼ª Ø>ÙÜÔü :X<£šz+tÕÉX‡*¤(Ê:[ºt§ZÒ@¬C`	‹2žž•¶UFùé”yÖlveÎ°é[Ñ˜ÒüÂÙW9ã¥ÜË\"-÷|ýäËX†²dXè„=÷üó2)‘¢âtšWÄ£‘òr£¢3¶TäÜÒ&‹zF6r²’~v$.^¥<í…j2åg’¨äµ’q%Cê—ŒýÐüO\':]\0¬2Ú?ëY^ï?\'þµ ©³®ú‰RÿúSÎ:0sˆ–ÎÊ?ÿçÿLFªáŽÎ;Z—vù\n¬,£\n3n+Â–½J€²™RM-J€ç2R(àÞÝ2g.” Ý¦•ü†ÇŒ	\\äïžlé\0]Úê—>JZÿ\"VšObåIƒ¨œtlÊ#™ˆGWKxT”{3P.9ëFfG“€E6›ºdvÉ\"€ºf\\r\0â±ô¢#$”bÇ„p”ª×kœ\0óRÚXü‚hIÙ­f¹2,¤QXÜ!RP¾º–F”6Pi™ó\Zl.I¸YµX\nd×¢­@¬’9ÝÕÉ·De~FªR!°L2ž’Ê(KŸÃÃ‹xÁŽ·\\3žmW’AæßÉd¥hKgjˆÃ‡ŒQêà=§3ŒN§šµÔçƒŒ{v*YžsävÆ£¶Ž\'áxM%3\nã­­¶ºÐÝŽJSiÙC4V\\â\0YáFˆŸÕ®¡°‰.5X,¶¸/];#Ã#Àjý–pdÃBîg`µ’é.>¡„-¥íäõ–F_g=¬oØ4C6õÃöâ‡^jãUÆÒÂH\'»7½B]VQæ•ï@eÑ–„—U4í¦r/WÉ%yr¿F? åïý ”\0ÜXýr.û+Ð\ncY¦Ê¸K¬K?/Í1ãÇ}/H¥.%7Œ²¯ÉüGœMÅô\"9	‰U~Ó<ü³ÿçÿ¾ÎQR¯”Ktx¤QTã-R¨v(§0–î’\\zøš¼É\"ˆ§Ë\\ƒÁŠ\\ÉÕò…Ê	šyB0˜\nŠÂÂ–Gea1ïhWo”Dx)2B6:à\\_Eö> Ék§M­Cf„×Ü&±ßcñ «\r¸^›T$×ÆƒÂÝµ8­åsÉi¥	ÒNg~žá°ÞååíÛ·ÍøEç\n’¨flI/H¸gš•÷Ç¨NVÓ\rHø\\t15Ô\\ŒlLr7Uúè33:UÏÓ)ºŸ­}¯Ú¦ôÓåÚ—Ü€ŽQò;aÎCAâ¬”9u2Ÿ¨XS(/0ìŒ×ì\\Š¢jÌTÙO ;;¶Áp©Í.fm™šñ¨mlí´ÑÆF[EJxç¦H¼:lpîAÈÍ>øÙa€ðJ‡\0¥ºÇÇ¬Ï¦à>¤7mgÓSg‘”k+^\\\n§ÁU…©I®{¬`,¢2øz-Y³-ZþRÍ`Y¥Õ‰È¬ð±Ö67Ús/¾¤rs1o·0Êzkbâì;bÈÞe]]%ðtÏ<Q©pË>MaG1Œž ã†‰øÂÍô¹<äVUÒŠgWÉP»j¤à¤š|à­3¯›=’ dæ£‰ÌÎFÝÌòAàƒ5ãyù,)\ruÐþ_ÿçÿQ<,Zð”$\nsOxE·:9eeIU£Å´`U\'}sÉhìA‘¶Nv™\nhV\nZƒËL€N¹l1\0œ`9QV‚€Þ\ZFÕéJ;‘F·}…’„OÏ1A~ä„–gâû&Ãuz–ÏœÄ’I¶ÀšÁc?\0žOóuú–­¬¥¾J«…‹îÓhhkª\ndMœ´O`Hzf\ZˆšÃQÛÝ½¡ ¯{@`£<@¹õl§<Ü®®$Çb`Ýfà?1¯ŽàCaEúT‹Ì¹Ü*Óågµ`ÔEs&ëlÚnAü;% Ù„è—6fÕë•\r›|2*KáÉJ/}.bvŽÏêøèPô\rÀõŒAÖUfÞµ<P†Ål £Q[7n¶³vë[šA%S»Dšû¢lâÕqöH¼’®VeÙd <^“ËýìÁÚÅAÎæ–4òó[˜\rŸ1”-e37•Ô¤Q7¸ºxU\né0-Ïögh`-OÆÂ}çæ­öü/êyç`Èšb­ó¾>¸Úç¼žü;«ª1\'ËŸE™`\\Ä%,éw•l\0øEûÒ]ÝT4‚&ÊLÖ‡^Mám1I`xÅFºƒÎìpøù¬ëdl94’]{PÆ¢’ý=ÔïtÜHý¼áÿßþ)·´t Ø`“êì,¤XméåH›À…LÀø\\˜@mÉ€K $à²Œ‚I}7ábÇðuÈ|ÞÄdYø¶y8™‡H°0‘°\\˜ëF»S\nÙÀÓ7Ðµ9§Déf°œwu{²£€ðŸ†m.û®Êüå®³æ`dù\\²¶þi‘@õžì­tÒs“y?äf8±…è4¶þ|¤‚]B˜×¦óêªmmï´õM›—2ÄÌØ­qÊ–žt,ò,Vº‡0É7ØÄ“‰ŸÒè\"æ^)`™ª`ŒÐäPî—ŒC1´2¦K‚({63Î@–¡SžûMû½ÆX¸6ÏRR‚7Ñæ©Ì*÷/¥B:šÎˆÑÙ%#“|aú·ÂA\\Òú ¹	¹teÔnÞ»×†kkm²¶)¬jXdO–î\rx{nÔ©6¬\\g,m-#ŒâjóÈÕÚrC#Yº9ëûŸn°ëŒ\'ymê «æŠpÑÂ8`»r°hT“a7ÖÛô\ZzÆÝvÿÏuNÑÎ¦‚”}¼¨_®‘Z#Þ¿’¥+˜Õý×¬}š¬×Vv&)K±Ì3A ƒDæ¼¯‚{¸T…w:È§ÔsfÄ¶rƒg¡ÊË×³G´›tð/„	úA°_-åuÞµ\rþ×ÿåäÊÈòdTŒœà¾#Âîûðþ®€#‡fëVõ©ü}p’‹U÷JŽ¾èYMµ0ùŸÀ…4¿s¢0w¥«›í?%ÊrLÂÄ)9›‚ìÅåEœz¼t]rÎ1a¢kû™Œ;»¯:VI«}²´®×(l,ß£T\'JJüL\nÎ5«,!‹›ÍÌâõ}áÔ[”µÁèvvvÚ­wdb!KTŽK\r:ÛEÛYT¾ËK¿‹^ƒk;}îL1ï‘ŒQ÷©Þ”üUn¦S< ÎgMè9KÁmgeÞíE§ðaë¡mÅ¿óóÖ³ZŒG%øKqóÂe!@\rÜc­©Î›ÍÉz(Ý[ÛÞØ_±•	F¼ë›mˆK6:R<÷2|i Ê›âž{m¡—t÷7ÙE¿¾625c¤¢žL§úê*÷6&Y:Ï]©4îí\\ÜáEªVðÜ„E¼,îÙ|ÐÄ³ºyë¶ÊYž\n&ñ.Æ‚Õjd\ræ÷À>Vˆ 9@ÙNtêÈ^¬w¨ÂªzÝCNk×•]©’¨C³ÿ½|-æ}`?Á¯{öº‹ƒz?…»F~‚r²+}ÿ?ýŸ?{mË\"ùHüTGC\0Æ\ZWÐWº_à•®”	¡æßh³ÔCLYÅƒ`ÃIVD™øÀªMì¤âñ’Œã¨>.`EðS§Jøyc.HzÞ,*?%Mcx@tÌ¹ýÈŸà’…(2k/Àåû¹†¼žË+—’9\r“ûilÞ#Çž“Ý‹$¥˜ƒSþ\\ƒ€u13ð®²=òÊ°ò ÉLúª¤}ü÷NY¨LµF¬´±\nép+Þ¡¼²æBhÍ‚Ì)H¶Å3Ö	Z\ZìÍ™š3>û\Zs˜õ+-sÔ+ðTÐ„®QÝÏ³³©ÖduÍSdÄðÔÈªÖ7å6t\r„’\"~\0â’éµ°ž2¨¢§€£ÞB\'!Ã\n¬CØKáîYV¦Kš’‹r›_Œi}ecW\n“€ãìjA $Ô\Zå°¢´„^“ýþƒ¶±µUZp>´¤R% ïÕÇZ³á	\nýîZÖl~WvUåa‚^ZÖ¯‚KeYìyùGV@J)š©­µÞçÉ÷õ«\r\'.d.Ýso¸Êþ\\úYaå&ŒgåðNïï­Ü¼æàŸüƒß¼ö\0/´UÙ17Eû5/’´0³LºHó¢e™%5`Ø4¶J¯ù?->€`[}Y|Î\0-§+K)I×Æ­ú Ô¼ß”ÏÍs@\0L«;ÄFY^†I«Üå¤n¼hÎè\"‘ÛbÝ®êIoôOœXyð‹“‚2ÓøT®­[@Üháƒ½õ»,	œ´|?›ûöí{:­e^Aç‹Ñ °@fà*sÐ<aYp%\Z¼ŒâBYš+¨.:/ñ)|OÖ)ë5§ótúh\'«_C\nBÊDßçÇÉžRáœ\0\0 \0IDAT×:>>ÖâÜ@½6!Yaè\\ÞH?g!=¡z%„ ƒ«ë¶&­«u©N¶(ilØ¨©²ô|~ ¼=\"ã106\"«jÀ\'é—k€“–ùRm¨ª$òsÆøø‘ßÔÙ¬ÕsÍÒi¦l”¬36 ŒµõvëÞ½6Y]—Ù„ñ\"”4ë¦¿~ò>	9¼\\È¬Ã>LA)ŸC<¯™\0¡5!ZÎb¦6¾‡©²ÆsO“1%€$“gÊv®:ž¹–|öà§žJÞGy¬J|è—‹]ÀúÜïþ²²Õ³Ì_Ó†±ƒ7Ý8á1ÅJmK}]:ßÇâä×êšg’ðoR,°‡ht¿¦ õ¥%±X1Ð<¥f‰Õ‰46 Ï<·ÜéÆåF(ZW_È’—á5¤œ²í|6‚6´Ø¶^´ü5\'Vÿ$Òü}•Zˆ%×’‘ Õ?í®—Þk¾‘F>z½$J\n<.1x«¯¢n:iwî=PY*-ð¤2\0UF•ÏSÃè	94êÓ\r&—ÒèûˆÁYü!\Zöƒ¶³3—ÞYÜ]›ºžKþÐx~20¾ÓT%Xê|^î¿;ÃÈ‡ï …öUwøµA;ŸÎkÍ‘ýhæ¥­M(É²ÖÛxƒrÐ#QÐ–\'ë\"[´çzüªÃ|m¸\0~2Aéf™ûˆ¢,Xò?ý2Èe£õâÀZ‘wÎ&Ì!á®´ÿçû•ñªµ†Lò°\rÀh±ðÚÚjÛ»7džÁáåáqs±RÎçÐTð¡¬™Ç·˜*X(Bè0å¹ôœ™û{/k¶Ÿ½õ×±«%±ä`æ÷+ý[ñÏòµE ZtD	êù¾ì\\GÖW?Øækùžì)=·\nj	T|M÷èóŸý•k2l”¤‰=‚Õ;T·NÂu2siè6ð¢šjÅHöÎ•¾‹U‘–ŸA-‘0QŠ¹C\Z‡¨‰lœN8YL€œ:¡æs9 0­ŸòSÂå­ÓNïÎ‹—É|Ü 	z¶u÷\\|]ÆA½0[ÖØ%Ä&¹Rä\ZÙ1wÃvdõ@³Pû%•Ê	ñ½¬?¥³F|ÒsÖÉI_Çó‰2e¨Ar#ß‹Mù½ÐóP&\"#‚¯1«ŒOqb]QEmx9•{K²KÔ0Ô}…Ócr$eãVtGÙ¼¢ÈÒ¸d†V¹W”\"¡2v&ëû’?Á*ò‡:dðýoBgÎseð£àÐ]ÔÁÂ÷È„m÷«&åPHžØmu¼&J\0.9HCJ”K$à­Ý¶sãV—Ý,6¨ç³	}˜Š@‰\'‚he¡|äk²¦³1]2{b kB®Ej¬°Ö`ªÜÊX2,‚ÖëŸ€µ¹ÙÖ7wtð:XÚ ([\0Ðe“ï«ŸK´×è8’¡ô³îkÊ)¹@Õ”É¢Ác,\"²AYÇ8Nu¤’_S^/ïÉ€z–g	bî\0¾wÜ&ÏÏæuúA*Ÿ¥Àbì’¬K&þñüú5t4·epÀ2¦Å”9§½of˜çGá¡è/•æ:Ç¦K.1,TI\'cu4ÃÁm~:-ØM°¬xà¹=Në[ÙPG%àÑÃwu¢ñ\"tÚpÛÕéˆqlF;AGëfË_R^zãq=\"•ªÃe=ødYÅ3ÙNóˆƒ+eîy˜ìéî¿g\"»Ó´÷\0»tµHætOpÆQR±Êì:–°›ÁÑø70¬?øae½\0i+DÕð“ëz¿TíƒÝÂ-uXù×û³«àNàe”ãÉ\ZƒÅ‹Êõ·ê\0æ~dñü”\0£	U`¶²j5>Œs2ŽÄ/Dî½$Ÿ­³å¬š2ò¤ŸÃ•C8S(ÃZÛXoäª76dŸ;žg;ÜØi·ïÜ­FL\'å\Z¼ ¢º²Îjò|gççÊ\0Õ €Ë÷žLµÖ{•z¬=\Zk¬M‚`ÏVæ>kÚƒŽ#]â	3„+\nXRnÐAá½áÎÀÀ)ÙSºzA–¼Ž¤±=ÐS\"Ê¬Â™Ÿ§¿N|m‘v.ë¯TY$õÜ$­TäNýSŒGƒþ$\rþºœ¶KE“4AÑ‡^¿®pÂ¾Ï‘æý©™ÞšÝõ¨\\1þñç~U£9Ò¨¤´ZáaQëc‚	žbvïÚA‰Ûû÷ÔÐ’[/ÙdR88t\rÇ¨Y?‚sr*².åCª”–ÒbÀù™JúãôØ#šÐOž<nÇÇGÂr$Wö£È.Gi\0[ûÄÉjB©Ô³ÝþÕà°°,é\ZÔ°ðXÃ¯\\wJ7ËÝø†:¸Êk/¦òSÞñÚ9]…WÝÙäºƒqèÞ•$IÀk¨‹uaÎYmÊ¦~ôc\Z”Õ´æòæº¯îDÕhTa|üLH˜l82Ne>ƒ:|°ñ«qÑï¥¬ã¹™ÄWc8uRû@p#„,Då\nM-àÀ\n*ÕìÈf‹š‡7™Ýr¼¨Íêà€_Æ¬*S%mÃ5·ƒã£6ã¡÷Jƒât®\'£U}\r¼uçÆM9óì=Û×}ßØ½¥õ¤L¸²—3sŸwƒî?#Æ§ˆb<ÑÚcíàè$‰ã*±òü˜GL¹0Y™_ØÊÆ8|ŠZÑ•]dJØ“­­kE°\\àGn•®&±ÕáíH52¼Dò®Ù”_Á_ó´öj2ƒ¯¥ùü¯éúùCÍ@ÍºÎ!K°lQ8™Wpá¬õÀ3Ñ`K9œ=ëÓõÈR-·ìÕëoQÖJRN~±7jÇÄA|þwQò2þé&ØŒ¡Æ\'ÈZ^›b·\n×Z6!ÒZÜ‹²N÷Àê¬]ÌP¥,Â%Ò,â¨¸›ÈJägH• ÈkÍÐuªîÙ§¹h>ì:3*C\02kÓÓáA¹Aí×Ì\ráŽ¿‹±_–×N=-¥ãz™0®¡gWÝÃd Y°*!K69‹7¾§9/M7ð]€†yÐù=7?‹Ò²´ØëúÈG?ÞîÞy KM	Ù‰y¾PÔ:{œò5“÷O†”%qÄgˆJóëNÀÕç-Ç\Z©-h^«{Ä÷Ë8ƒ²´¡»\"ï<ñy ñ‡m}c£›…îà äÒÀN/¾×dUš  ‹Ö:qÑ‡˜3X2,än¦V•^µá‡ÝDmx@wÄ9œ¼ñm:¿Ðà0]nmÙã  :³ŒPÍSZmÏ°ÐX¾ž¿ÌS×::Oh¼fæAÓvçwÊÚP>”½—óylLäL­±Æ¯Ðj—Ê,œ<>7J¤pºJr9ê’:*š`ÆoBöN™çÌµ&H$xùÞúÚó¼ƒI½¿ì¯Ûü\\‚b­öq¥~uÑ_óÉ¨ÞÿïiF€÷e/-f–-wäŸ!^‚JÉ(Øãs¿ýó\nX|<E¶S²(²Æ‘6 øS\reÚËñIWÁ£1£Ù~oŠÀ”wâÔÀ|Æ	Ø³‰jVMf«/p3/TƒŠþ•EptpØñ`Ì\Z5†É„ò\07²Ó‡tjì‘!÷Eð¢”Ld„¹ÑùZX‚˜ÈÕ\"qCû¸T,Ì©Ð?!L’&÷±°þ\"qUá“%Î<÷ByÖ¸\nØCáIL0’`š“.é?W\0ƒ]ÙYH„«ü ƒRyO\0QFB†²Èi†D%B\rLƒõ‚f:dÈÉj)DpzÁöÖ©èÊ®—¾¼h³suçm™Ñ®)®A5÷WúZÜ‹dk\\Ç´\r¢‹¼¹ºÏ?º‚ë›Ûr–ÁçO,fõV×m«EI*>”õøuOË-YøÝ 	ôç  à¼\'“BˆQT	ãJdc	É@²é”¥”Yo0Ò<Ûd{P-¨*Ö6ÚæÎ®TS¹ïDOª\rÍ;J‹ÞŸµÜJéd)r¯ïhº;Ìúê\ZU¶\nS.uÝ4Á€’±eåºû‡iÖu0ªuÌ,k=¯ÝßGiÚôá\n]o‘l}€z]ô×&±Â‰MÙé½bðùßþ…Ý=›\'q1²éødÀÑŠ’ò¬¹(µ|€\Z3Ñ\ràV³‡¸ùª…-I_$umƒåàÄÚQ×¶AÐ‰Qúí”Qt5ØZŒöÑ2 ú‚M«E¡98Æc\\’I´Z¶Éœ²suƒå¾ã²p Þkô¨€×k6$`õSVá8ïóWËÉ×hz˜±•Åàhšý†ÆÝ{Ú‡?ôÑÊý@¹‡Ê°6%H 5èlºF_ãýÉb‘[&`éþÔ÷¤\\äçr*óü’&‡²/\"ð3b›÷5/ic2`nÌ*2$)g-HôÓÃ²6\Z÷ 	2”Žréé±>Ëúúš®€]æd\"ETÕFBa•†ƒ¼µá]ÀÙåƒ	~(‹Ê¾ÍR0‘ÀÑóF+­8h,:’èê\'Xq_ÔÍÅ3¥g|,ÒÛ;aùô)ýOk³ÌyÉF=¬½­²v:wiÄú\'#S°î„ñjâCÆévz\\Œg“5Œ>_À¦;ô³Ð6R$°¤ÌáL2Ÿ9k&k+|2ù.Ix_¥’¯go§Õý©ùAþÌ)™v‚Z‚¿§‹®ÏÁÞþƒßúñ°tñÊ¨,ñ¢”|JÆ™C¹ŠZu7“Êœ.`R¥H ŸWUÃšà>a™é²Àzñ‚€¹\"I&èõ$)¸pô’‚hñvŠ—Œ˜,tÉÝ¡T57+‹\'XR^#7GBnxä9Ë#rÍý\0æ(à š‡š Ûÿš¬Ä{Þn>qÜ\\”id™–ö¿û5q\ržtßÚÞmŸüŽïRù‹‚m€gid•ã2V‚ÔV«»Ég–*he­Ê‘œŒ\\»ƒ³‹®D¼nžm¤°0ìËûšv€/¤[è°Æ‘)&`©9Ó–\ZÚW—Óy»DyiÇž¶0)2náuVI…²±¹ ³ùím•™“U¬âG~É[Ì¥˜Í~(§à\\a8º±³+ÕñÖ¦UÆëÊ°t:Ë¹™™f«W ‹Å5uŸ8†RS ¬„÷µº:Öaû–À•‹û(·‹‹¶¹Ž•KÆ`:æ›lÃ†\Z|^ßÜP&Hé©¤ \',I#‰’ÐÄÿ[e$CÁþü¡å@LVž&TÿàJÀÊºO6ÔÏ°úYW?«zæ”µÝ`ýàìu×“F©Ä‚ëÅgŽ*†¯ËÍ$A¨_òàR<vAPüƒßù%røJ›§’7­;#,šœªl4©,ï;\"‹³ÜN .ø$ïä/”ÎyÜ!®.^MZF´–•B«T˜Ù(¡°\rº\nONŽõ»T\"j–ÊÌ\r\n>ñ\"‚ó>DN\0äú²Q“IÉ¤¢ìÙSÏgóôÉ…Ž–3Á>0™“©+Á:7åhÿ¸éÌÐ×ê¾cÏê¨§Ö™´ÜrÔ>öñïQRÂzÜJ£\n¨ž¬ò7¶k½‘‰”1’•å„/üª¿éú\'+Ÿ›gl§]ã`Ú˜s9×À•BMáÚ	Ác6o«k«íÖÍÛmuÂhÌ ]Î®Úþ“§íøð¨]žŸµ£Ã}¿¨\0š‰œéûÈžC¯ºQAv±±¹Õ„‹h)CZ†…ÏÉðJÇky(®žš-è£C´]Å4uµ­!7³¶Þ¶vnxrc4QéÅHk4rÃl¬á÷Ÿ=LÁŒ º_€ß¼\'|8ukâ(S~eCqÍ:Ègó„Ø£¾CóF›+K‚\'6’–;×$#ÞêàÊÂK¥í \rG­r©f…S7´j;#à~àyIÄï	XüÙ%¨ñ3YãY+ý+ÿ–µÝ_ënÁ¥\'}xýkËªC¾¸3ÉEçðuf_\r3Í¿úPQ@ûG¿÷«ªðqxË‘”ÇW\n‡%…«*q2æ´JwY¶ÜÁÀx`•Þö´x‘¥NJéæ“;VõëŒYlmk©6,L9)jDu4R*‚ë”vwÆwß|ªþÈ„‰Ý‹n\\RN“¤½Á°ò>9Mûu»]¢À<¼þ‰£Ž›Ø¾¾æœvI‡ûïåÈÅIh-°,—š£öâ‹n[››jV\0~‹ð*oFŸJYXy­dFzÀUPŠh4¤N¼d‡ù¬Vd©…?--iÒ¤Ã‚\"r´(3ÔÓSO$P:Ý¹s·MèÜÎ/¥úùöo6Ürèô’êKV†Åù‘€¯9Ä%«Z´—¨xØbumM¥›—ÑP²Á\\»ü-)fÖEâÚ0± è1CÁMg8j››ÛmyžñX#<kÛ›ûÃlckS-bÇ‡íàà©! 7XÜò˜òÙ6ó««#½?÷(B~éòö×%¡ÖcD¨mHíäÒšð•‘Ï¨NÆã6\"+³©÷š1€ŽÊTjm&ìgg•„€î.ç£ÐéxØ#a	V9œ£$%ÓêÃ0V	1Ñ;•@ÿç³’ÑeÝd=õƒxb\Zü½ŸuiŸÀ=«LŠïã@¶œ•cCÖ£?‹e£´¾ÁbÿÁgÿž¬ês]àÔ®ùª\\„íÙ«%\Z=žÒþÉ	D9Ã‡gtFkI|)æ¨ÛUš7rËY^R†EIár%3þLi‚¤qp—gÏž™IÏ’\\pNH˜X^ri1²ÓàýåÏL LJ›t9Ý»\\/wy\0Y	Föô¯~ªì\0E7²èó³\n‚eëFÇ°}àÁíÆ.´Y;‡V #Pk™%¾üÈ½ÎÏ‚K©?®{œùÅ:®#c8&è!|\rÂîê(r·ƒgOÛÑá~;>8n{OLaY^j·nÜR ¢ì›ŸÏÛÙá±Ê¤éàBeS\rdUèX\0PqØÚÚ´*\'é¹gÉž)±‹©.‘ÿçùüd>t\n§§É°†:`ùõDÊám€.Æ¥tä6w¶ÛÆÎ¶Ì)”÷|ž³Ó#•¹ëk\ZJ;çºPY+óOÉÜßÀ¡¤ƒH0&Ó\"èäÐéLUQ@¸lÊ™¯:‡0;±þ›œ|®s\0]·Ñ*³¼íŸl–ÂBf4möjé¡Eƒ)¥ 9,û™VÖl¹ôüE})Ž`~¦Ÿ=åu°ò÷þï)“ûA-‡gþ­xt÷þFd¡^šxd\ZðÝ4¼4øüïýªœGUúô¤XDÚâkU.êÍJ¨L¼©ÈM”Ã‰.lAªš€–QÛôÍFžV\Zð¤à<,×\nXdX¼þ¹Üwè”ñUæÆÃÙßßAðôü´]‹—DkÝT\"²«Þ—T²ñ™U>kRzþ­ZåpÌÍ³QQÀè~ºÌg›J`ê/–à\\	Nþì¾ö6•šõ>ñVÛí;÷Û­7»’0²ÆÒd¯Naÿ´Ïµ¾ç5!RžF×Ï “)ÆHls6ßå¥²\nþ—ÊÆù©tÏ÷Ÿµ½\'{íÝwŸ¶½gÏ„÷A`£’ý .A¦¥ò•õ0@vIé>Ëi2Æ°¡µ­¶³³ÛöÑq§ó;é€¢ƒ§ÅO ™™,ÐÑŸ7…CúiK™GR‚Qr1dtþ4#:Ã\\¯‰Œf{wGÙ ºËå•öäñ»²[\Z\\¶{÷ïµí7Ûí{$c|ÁZ4T3ÌÙ\ný½ÃíéZ c’k“‡ÅÏ¤0±Ü–Ç£ðôÈÃ§•Y1øL·“lƒÎ¼ØëC²ÌNM³›Ü…ÎQÙ2D1I‘Èî)÷²ûYNW~àß´ÝáÛS´H ÉzÏšKÀÊžHËºN°OV—u©ëœ/Üå5-W¥d®õbn\r{[þ‘aAgZjƒÏýî¯\\“rs¾»tëK›‡#ÐVNÏat’,KO¡\ZT8*ÿ#QclA4“Eê¥¡$\r¦‘Œ”~_ƒ(-d\'”iÔ\':óûÏ4çÕuöèfÁU¸“˜ƒÑÆ}1oƒ;Zt|øiíÃÊ©›ÞÒDìú§4]ÚK=U‡,ö.ðõôú4†F‹¤ê°2i;;7Û½;wUZ‘Pª,2÷ôæ¼úm÷a-JùÊÆr­\\Oi°\rY¦hJ°\"\0ÝìµÓã#aR\'\'§íõ·µgûû¦’\\XB™loue\"š\0Š\nk+	ÂŸB¬‘q#ÀûÃãÓöèñã6œLÄ¢i&\0ûôT×ªfBç¤l÷qð,æ•aJ\'þ\\_ër`ƒX_§4cÁ;¢[ìŸßÙÙnÃõõv8;oÇ‡Ï¤1vûÆN»÷à~Û¹y³Ý¼{_NÑp¥t)	s¸ñ^Q3`}pßDÊD¬°ä’9Lx³ê†hTA½äk—óöÎã‡:ìÇk«jX¬,¡;×ÔŽá˜Áiè °!ã^éˆ—]Œí,dTFW–Ô?”ú‡X²ïÅÁ¹À²ú_K ì¯ã¬—~y—\0Ù?Ä“\0¤Ò.•@¤{YÓ-ÙCÂæz’6ÂO‘¿†\ZÅL§yzR}ù‡dX†•KàZÑìdåKUåø$ó	ÇÂ0ÝÜ‰‚É™¼AibK—ÈŽÎ¼\'3d6ið|”³ŸÒ,/6îË&ÙR•i©0Ðu!Êöì—Í•‰¢éÈ¢½f\0ËbªÍWµoO½ ­]éEÔŸ?K-ù*•ÅxÌ‚oïÏŒò`ŠõX‘UIPËæLúÜÕ‘T -j?«OvzM6°Ñî>xÐV\'*vp@>>n×ÒŒ:“}Òh7FLWˆN–i$Úd(xòg(*:Â­Õ1„–\\\n¸åŸûìü¤Òú?“—5ÖÏÚéÉYÛß?P;Ÿ÷:?±„3GS\rUPm¶b¶¯¯¯j>~ô®q74—$Ó|Ýžì·\'§ÇmJG¹d­\"Jzl:Ù^|Ç“6Bx?Á“S½.ß3Nô™é2RöŸž¶w>ÿl>³JAE>ÃA;:ƒµ¿ÔnÞÚmÏ?ÿ\\»yû†°¥ÍÝ›mûÆ¶º±©152p%ähpçBŽ×¡*ùª^I¨1øžÂ\0kCúæôô¤½ûô‘\ZÃ&`“Q!¸ˆÑë@Dà{Á£‰E	ÒvÉô˜ûÕ²/B¶a˜9U–•Fœ¥4¬ÓL!ØÎÌå´ª™’æñºr‰ÂháÖÅž·>\0jvÅÌ·Ä4¬ú2•Ð‚9°\0ê¡TæðÌ~p€»Ð=sô¾SÀêgÉB4WÇØDÔËá7i@u}¹ÈÉƒS©ÜÂµ\"Ë‡\Z-{JŸzÜwÐÄŠ¯,þŒDùD˜£­ì± ®)ã!ÇGÇpIsÚéÀ³á½•BÓ±ô]XÝ/0$7T·Ë•ò´ÿËÜF9<ÞbvyÄàú74©w‚|\"»Y—Ú¥±19°™8‰‡U##4/²¨/KmucGfªœ¾¤É\0ÔÓ“ã6ãÁÕð³ôÇÀBÔŽ¬ù^£\r2˜%¸˜KÒ®¿²˜íŸJ°Š|à§É†3æv¡&Ð¥k\Zªv§Š™Ýv|)kægVå$hDØ€këkmg›ñJ{òèq{ãõ×ÄÓ\"(jRa0hÏÎNÚùÅe;Ã)š÷ {a©øF\ZâåP£¼¤´\\Yjëãq[›¬©Ì»yãVÛÛ;©öcŸøUÖû0å/çí¼…Pf•áK³©a£5j7ïÞl[ÛÆ¸–Ñì¨ß¤Û¸YëtY¦&N	ðW­ùeVÚUâxý¡A0!%3Ü®‰0µ££ƒv|zÔ\ZÒGd¥ËC5\Z†Cfým}cMt¶FåÀáDàµ90ÒEr”^ìuCÜærKN¥›Ä<ìRnqÐªJVçé’¬ãdiúœ4DJþØüÛø„Z¹¯\ZÚä’Ä¶ÝŠ2­¢9Ä™I\r©žAª*I“/èG‹k‰\"­¥º»ñû¿õ‹š%L„Kê\'Å^¹[÷½\'×¾©K•¹‡\Z…ˆÆ³‚™”F È`ü¦1m\"7Ò×à22ieØÂ¼XFªÅ–ƒ[¶VEð†+)årÁò‰¯óÚq°IÀÕÖ”¼V*‚›ƒ‹‹ºd´ùéBÕFJ·~ŠÛ9•œ¶›»eRg‘0kæÐåèÐÜ7²<Q¤ÜnüðGei%õMF–(é4Ý±´²â+‹ž€¥4»†Š…§‰LëXœ¦p\\”ûäÔÏ—³³»„lðSú©Ê¦#,ƒÊÖl_0zSæ·%¤ÈûÏ§0Øí&Ä÷¬37wya©¢v¥’ðÉã‡Úä³38Z§íèø°=Þ{j‚ÆÌòPCÏ—ƒë¶t¨ÅuýdeØ6)™4ž3lk“I»s÷®²‘õÍ-uÉ”÷Ÿè`{þ…¬§Æ½›_¶ã“c}®lèù#Bè££·5’t1ƒÔËt\'kmuÃÓuw8µ†™5\\5HY¢Ð\rs‰hí\\Xõ•kÎ¡À=•…f[í	ÙC8K†-xîö%ðd†7nÝlëkt×”q.|\"{‹5U_SÕâ\"\râF©¬ï¬ý$%ù<|¦¼fÖ2ïcµ	ÖYÿÁ¥‘h©õiR€ì¿.Ãêæt}H2§¸,9jÿ\nD“X“kÏ5~û×ö::WùGuô¿HÉŸc3¸vÆb­l¿!’4Â•‚ú4¿˜.@6Ñ\"Ê‰W)-_ëé‹ÒFrGÓ_7\nœªÆÒ•Øž4TÚåu2ù{<O¹œþƒµ¯Cž/$‘“\rÌûòZ2g±Ñà|ƒÂYb ›\"‹A€±°/cŸb˜{Âlž´ÖU\nTxÜ±	5óW&§0 §X_a¬!WÒEö¼|_ÌZñÚê¤p*–Âõ) ×P6W¡±\Züe¤Y\'÷ÆŸÇ€;*p¿fírŠS´1?‚«)¶L“\r<<3KÏæêâ2¬@ÏøäÈå&A‹û;==‘\'à³\rNsî/Ù3«£‘¸w?j«+Ã6©à¿±±¦÷„-¾uã†ÌT·nÜÒ`ñp©ñ‰\0\0 \0IDAT`0l=j[ëëú\Z\rCãÏ³©Øð<ƒóÙY9“3ì=oÃ5P–¤±Å¤äMÏA¥™N•Þ|&ˆÊ4#È,á—ÃAJ†%ƒßñ8$èMñLœÏ•a1ä-1Ôð¸øùêÌ²Êé&Ò”À›òYäey§ñ3+3dCçuÈÒÑÌZ4ü3é\0öïvä,&„¥¾~0Ê­ÀT°B^\'û³°ú{%?£`^ûÖØ–]Ü³‡½wŒYfxŸM€ÕëüÎoüòï‰¯‚O‰Üa&‘‹Ê@ö¥º3J+çîæ¥íë`çù®~ªy1³I¿d7U\Zâ2ž¨¶OØäC‘YÉ	8å& ”œ.;sÉk$ˆ!´Üë&.ð¾‘`@ûd{¾AÇÞ;#y¨ù¹,gLv½‘:ÀÌi-\Z9QÃËoƒóïšZÛ“ÍÝ¶{ëN»qû¶J)a¹Úý½½vtp Õ€»;Ê*afº«T/–þÂã:ø¬ý“1 ¼T ëƒçƒ\ne~åm˜Mwr|\":ƒJõ\Z¢4eþnŸO0‚ D`.;P%X]ÏæL\Zk1j\',Kž˜P¢¥GÆhÎåŒ B‡x&‹.2ò>d+\'Œî@i89nã¥•¶»»«àN©„û™ÐxÃÞ„škœ¬‹ÐÊà=W:·\Z†R„mÂò¼i(<­nK&6ZÅèƒÓ’)ªùH‚óx²¦L­Ë®ËìDËŸMJÀrÊæÓð5áê¤LgíàèÈ´žk¨;ð¨.ÚhÙ×¢MIóˆCey¨&Ôæöv)þZ‹#Z’âL–Âo˜ÉŽ”xh–rÉ—EKêW©¤lÓd[‘™tÈ³¾ò™ú`~ÖvÆã¬¥ÖÝ¯@&:¬Ê¢Ã’½ëÌ)ŽC†js:Ù™Ta•0üæßûïU¦üJÀðÂ¢\\*ÊƒæK= ¬4/Ã¤³òæ“!¨tä/”Åˆcp—5]‘BÛ·t–ç,\'Ã¸ü9ÿóáÒ¥‘k°t!’îêºKÒ6”þl\Zt1£?¥àŒÚCY*9X‡;fr^2<­\"¶¥äÒg­ÌL‹d\0v÷g”ü{7)¿Ö0n7vï·/¼Ø®+m…9^õP0Ëq>mO÷T>á~óá}XK/ù‘a&;óÌàz2)¢¥Èyu¿ùºÜz*1³§%&à¾æ6ù¬pÝÔqOgò\\Ò6c’°k2†	)@A²M¯\Zž„—ñë÷©Àè˜=ø iêÐBã‹g}v¬ë!qot½R-Xno¿ýV­¬èš4þƒ1íòPàôÅÕ ]#‰¼¶®{HÉF`2\\`¬„ \nµÂæõÊR;…[6=3°­¬Ëõ™î\rdO­5Í:ñ‡H…“I\Zþ0Fö‚I,Ì•ÔÜ†&8,ÙÖáñI;8>VRð\0@‡}¯j%áIÐBÈ²Ö7Ú›7¥b¢à\\ŽÓ4®´&ûømÏr>™‘©®(úyÑ¢ÃŽ±ßœ´ämô›½Õß°öÞöçKòÒÏŽ’­EÏ¿Óý¥¦ŒRÈvGcÃ\r`³ùy®)†2¬~†’SÙ]^×\"ðYzä²DñUãªÜ}hÚ 0}ÚxAcÐY@ž&ÓåIX¢xUj¥LS¹ Ù5O››B‰”¬ŽE¬ôÒíF—”‰I„ˆzFÉÀD;GøK»ÈDèL¥“q&^,;™&ï“ú™×J[7Á*™¢R¤P•M™~[4º€›[›mgçF»uç¹v÷þæ\\7éðà ­ðsóv|°/•Õµµö‰ïø„>+˜ŒK)‘%†g­.c×à`°¢ßk©$í*qç¤óêl´Ì0L+Œ{Æ¢œ-Xw]ð4‡EÝ_0µ¥ùE{º·\'¥äŠQk C-¯´³£S­	ºƒàHÜSºœóså`D¡¹Ä3h*–Ôp^[_oÛ»»íä¬iÐ(ýèp²¡4R€\\ZS ²h(ßÚòTRG2¨©ÍÊà7øHEyÑNÈÜ¸6ˆºeé˜¡‚»´¤Wh\rt	¤”‰9<9X¹Ü^>Ržƒ(\"T×Wmu}MÏ÷£)’Ó¥Ö[Ïm©0Àd$tÁ)‡×Ö7$ÛCÆŽÉ†&HdxlCÓ¤i Ìj7Ò;ýàã}à,5ìCôº©›^‰÷ …ÕÃé‘<w-øèà$\r™	Ôš,ê?#|»Èàdš\",+)˜)KÕ½sE&ï©úÕZþÜoÿÒuÒÒ÷—UÎJ8AŠeš–xÉ\0ë†+øŒ#­»vý_dg2E-¾H‚qL:\n	|ˆ(5te˜º‹.áhSF¹“¬œ\0Þ*~˜1XpWÄmYæJm!–YD)Wó7ådrÞ?¼%¾/Ù“YM +°ÕÕrÊg€ u÷îƒ¶¾yS©ûìÂ›®Ù³g{ê8]NÏÚŒÒéúJ~ô£ÚLJŸeªj=,kÕ/Ú½,a?•RË83mébƒ«¤³I9ÜÔ0öX“3¯îÜ—° †ÎÛåñI{²÷T›èÆí[Â†ÀžÌ¯©@(í3:£ŠÀgâÏk£I›Ãïºnò®×fDg” É=%û¦{ttx¤,E¶8HV—yŒ‡†Å\Zl¥-Qj‘9AØDø?_/ÓS‚%ï‰Þ<ìz•7ÂºJ–®öh¢LÌÊ<OgèÎd-S­g!Çtâ®®0\0}¡òŠðœ¢`Q6<õšw%c¼o°4RÆ\'B4As}½ˆ¹l^î¯»¯üTªžÏ\\Á´g®B€]$®ú‡¬öui¬ñÌß¿¦•å”ŽVöv›ê!xbHþž`™}ž=Äš¹ž¥;RC¥Z¬ŽcM±Hªª$½½EÍégÜ8½iaîNÇ®º¶m—Äåxy`:ü«,ßó€•Ý°Í…äO¹”¿³àYÉ¨‚G…4ÊMRJ®ZÖ•¥IÃ±Á:åT¦Ã žE#º‚L1{øZEú\\kN\"aMUÒ%sì:mõðû‹&ÃÛ:y…\\‹yëÞƒöÂ‹j›;’ÅEEôjPâ)ñ±dVÀi8íÎŽÁYVéG7ìŸø¤¨	tH•V«{k\n§•ÛËž§—¦:F”bü“ëóT¶Õ}^NÜY™Ïø.\\B#9\'nÝÏg*¯d&>Ÿµ³½½vx|¤MwÿÁ•L\0æÈ¼‘Hž…§1ö3Uc¾ð\Z úz`^\'îÉi;=:Ñ¾Õ†ÚdkUšY|&>£?|Ns€péG-·åÕIÛÜÞÒF$\\º¤­‚\\¡ÒËø\"Y™5\\BØú¥›Å ÃbÝJ4r¸€oepÁÔ\0ñŒd~)c@Q”Ìj©ÉC“	\rü(2œÅG²é½v$›Ä±KTž%4ð<è>ÈCKþ»`ža²;eOc²Ošˆ÷Tþ\n*xj_»¬»’O@ðK^KMuK­w(„ßóç¾~—‰ÃàÙÇù~—™e[\nÖq¿úáßó‡šŽÍ>VPÿÜoý’ÏßDûÂ†ÜAée.:O1c$ .å¨¡È_YRõ,4&‹ˆ–%>)f:bp÷œ;‚—%`dÓ:ýôIžr5b}Ö%ò8?;iGÇÇ\"<²Hù\Z²¼>e‹Å_§­x\rv|W&è1É|ÕÁlš‰Îµ©,-f¸êm¸WÜT(66ÛýÏ·ç?ø¡v÷îs*ÿÌseÀ|`3Ù3ºf0·§íbzÚNÚþÞ¾Àmst\rÿò_úË:m¢9Ýµ³Á*×<\Zzdˆ,¬Š£f\\8‘VnÑº²£–¯	…tõ¼àÊ¤BÜ3;ÞEi\07”<ò¬Í‘«–Fk;»7,Ù¶°“æp”–‡mŒy¨ä†Ì‰ƒË…‚ƒt°Ž¡§œµãýýÖÎ-]M§Ð–]LG,É¼am}UôÈª”e\Z½÷ïZLq$Éãõµ¶}sW,ñ>/<+tÚ–l9‡B©22¼ð»Ðí?´@¶¦uoD©aä$üz?Ã’êHQÌ	,à¼šQÚ7++íÙþ3]]Ãˆ·ð¥¤¼÷¶D\"Õ`¨¬Ñ„ìk9<s\rÏµÕuÍ6‚M‘½£J‘L¿×³N©8¸\Zt3ºyÖÉrøgOËá‹³7ÔXó1äå÷|Þ¯¼±ô«³gµzvw‹ gòµM}Ù§ž¥ùæŠÍS§§GzÞ*¹¥­fg¥Á?ú½ß¸öæ[ˆ¿I²´Zðý7NÉ¨´¸æüœvZ‚Å2×÷JK\\ßÈ„³¸©äµµkóÀß	·+Z)o‰Ïñ¾z ]ö°TMeX­6´UÔ%*Ë0FJ¤x)p½”09iÔ-B>Äÿ†Lq±*Ï*,\nm%8.Ë+í¼€og(ÁB’·sg\nwîÝo/~ø#ú¾ÕÁ!íû¹(hBqmOá ]ÍÛd4ôØÊþ~{òî£†v8\'ŸéûàÛü\ZZˆ­Üe+\0t©M´æê.*ˆ—ö–¨!R†]V¬ª.¼3Ž~[Û6QWÊ€<\nt&9dÊfdf¤Ð!•Ps¸(½å|dác—*õ¾ŒX	È¦œ½€’a\"ò2ûâJ]Pš•#t$éXaN2ÑÏ(XjÈ´ÈSû)åµþ&Îœ–WÇ¢8 Ê0düçêR&\\>››ÂG˜+<CeBQ¢æB¯L²è#ØÑ2`¸øLV·ˆÂ®³	—V\Z:§QQe¦¥ŠLJ÷q©µÃ£ãvtx\\Š#tÒÍz·ûM1»ùlþr5GHž{b‰0½áR•àOÆ´±±Þ†«ë\Z³‚;ZFÃèÑB¼qi¸$Ñ€Ësñ+-uàJ½T¸,ÒM¸1ÅTxÒòŠH¹@DÉÕÝÌ$5:ˆÞc`\\\\´+W=åS‘ô\Z°8ZfÜ„ÂP“\ZÅÊ¿ºÔT‡‚ßš‘“h6\nX©)ù¢Ó¾Pß¼H’á$JöU!~l}²š7–)\ZØUØZØ\0ñºÊ²ŠzÀeæ+ï×O9s³”\"Ö©¦ò«\"|,Ô-VþÁ]ØÙjeWKZA\ZÉæ™}ØÈBåÒÀ—Ü:j‘k<,¦øb.$ÓÔÅ¨­¯n·[wî¶|ì;Ô–fñ¥ó†\0¡J`ä¨/íË÷ðÑ;*›6Öm+u¸·×¾ýÊ+–»÷N»}ï^ûÞïûT›Îà¬€qÊœëgÈ8N§=÷=[Xìd\rß®RBP¦UæÕ•CƒO‚!÷@ÕZøKr¿T\n²P$Ó3·«	JÅ¨÷ø‘Ýp¤)Ö+\\.5qŸt/k¨~éê²ãŠä™Uf\'ÇíøðÄ„Êp9‘Ìé3a7™àœÂX—£þ;wn¨³‡â(f|62*©T	™ò]$fÒÍ%¡Êy°½9KIÄíuž+ÿ{Üª*ˆÂtÉ† =œœÚš÷È°îÓ§OÛÉñ¡^{8ä@kVeßò%PL*)ò^)Åkw]¿Zo²ÝƒÐº¶¡Q7DczÌý’ó“(ŽùZùŸæA¤ÓmÏ¿QFš=¶ÀÅËº¼’0÷GóÐ‡²¿çd(HÑ¹-P?‰Nî‹^¼ùÚn¾¯Ÿ%*É©`w/ß#ˆBÎòmð¿¼Œ_ ß,ºÏÀg\\Ã/’Êæ÷7ãÖRisc\0±>&8t<*]1ÒË\nX¼:ˆi‘*‹©ï§;” –²,Á6§Š·‚äµAûênò9Ìÿ˜™çSß3SûÁ[8DøßÁÜT½­gÍ ’2B4”ãÊÝûhûè\'¨Öaáî0,|,%‚(I¤ÓÇ©ŒMû³gOÚ*\"wÏNÛÃ·ßj¯|ë•vçÎöÿÞ÷´ïÿô! Íãn¯ÛéÉKÝ\nÜé\0‰zq}¥ÎÌDÊ°h?Í›…{rrr$ÌˆëPçYcÍ1zD¨Ë|J7]n¿tÓÁ©±(e\\ƒÖN°fó7î/\\.˜ð\ZPGŒqz&nÙááQ›Í°†³â¿ôU9‚%=ÔÚëP#–—Ûd}UÁ‰ÿ7w·ÚÚ&e£-ÛzKîÙïôÜF”|1e×ØÖƒñ LiÜIY×òK|*eh•ËÑ¬5†ªDu\n&°Ö÷Ûéña[ÒšW®iaY÷y¹¾ò0¯a\rp`Êt/u4ËG@üQED	Ç\nX@ãa	®VUÊB’= TOˆ_pæ;=›ÉhÔN=‰’19â¥Frq¡`(¦}Å—ÎÎæÅù«&„]Å©¬œÑÏrÀ1ÆÇ¿9`Ù˜†²3cyšÙ”9räÊÉ`K©¸š=41TE|þw¬‡ÕÏ¢úÝ±~†•¨œßU—p^>„.NJŸ‹Ñ\0^Ãæå€ZsFnÑÚ†^¯Õ›WäÁ¥LÐJP%J‹–Ÿ‹ŒmHKnpž…¯r€º$„mÉ>¿‡2‹÷µ\"èÀ˜ú\\É°Àq¨o• O>X«µ~÷ÁsíæÍÛêÞºy§#Ã(S!…’ áå©q(>6DJJ¶—¿þµv|¸ß˜N ³:Ü{Ö?z$}¦¿òŸn?ü™§!mù0 •G%­ÈC¾ðÌdø09A¡	°ñ´xÊE¨ÿœû i”*¸<8ÌQ•ØÁùÔzÚ…1pÝy*gFHh»;›L˜E~Z–¬Ê¸çUúé{ØMœküµÓ™‚8ãÂäƒç& ùâ²­\"‰,\0|Ð67×ÛæÖVN0Â@%À>J£qÉkUcA«âwÍ.yv\"_*Ž“2\rÔd¢®§½9ÝtÙX•\"‡è’iÆ`âZ¦¯meÔ¶vvü?zØž>z§]NO4Þ¶Œ»u¨É=ZA¬|>\\Ýè\"èJ¯\"YË÷¯J%iÈO–[4!Fˆ¤áž7…©ö\ZÍÁËbÏƒi(]ðßƒ¤¥©d¸yæûÍç³¤Ê6“ò¬ÙÄ@ByÞý’=AÊÉø\rÆgNªq¯`¬³¬)WG\Zœrg³3f5avð?ûkê&Hå¤^`T>$ûmÑ úÊ˜jì\"™n¸°ŸêÁOâ2ÓeDRtpf–\Z;|§”ŠI\'°ÔXÜ	¤¼n§çÔóé³q§­³u\rõ@ley×cæ”­®g²L‹b¨«Àpl%F¶ƒ4ïÖÎÍöÂK‘á)„¿S	:{{O%­Â&?=:ÐuPÎ‘¹Ð™‚$©Úýò²½úò7Û›¯»Íççm®9É¹¤\\®–WÚ_ý¡i?ô£?¦99²•éÉ¡çùdd‹ ®3@€Ê”vþ·…ñkpÀdÜ“€³F…3ð:çP\rÎ;W€NÌ/è$ŠÑ}á¦…:AÕub¶¾?uÀ¿1|ÌýT·gn†>$ÒÕ|RIÏ‚yÄ9žIe.×®:¥£B4#Œ,^_«ç‘2NÆ®èl­XÊ¦dý<MVu‰·ÜæW5i1 YÊ…. \rÀ?\r(Œ\"Ùò,£5~å@çìaÞ.~Ah}³íÜº«Fÿ«ßør{óÕ—ÕL¡ÛÂçT\0¥¬NäŒƒÀ@‡µBð³zpÑŠE¥xî\n¨Êô‡mmƒîóº†¬Eçæ×à{À7Ö7u_:O©šÀËr°Ê¡ÅZÒ¸UÓÆ«ÔûÃ0@ „4Í´P-Å“ÒÖäY§ÁßÍ}a¶f\\;ˆ!šðK×ÂhãÃéç8hƒ?ø_Ö\'ÓðeOê8\'T?óJ4Íé*ì¢$ý³žòNÀ@Ùë äÏò»‹\\DÏ,1™[‚F2]_ï!ÚÞÝuu^“›G&‘°§²dgXˆÀš «@Šj€È˜óÎxT]¸ºay.¿8ykC¬@êÛl÷¼ÐîÜÿ@ÛØØRÖÅF“æùÙ‰Î¦Œ–ÚÞãÇíôèÐDOµ|m0Á÷>{Öž>~Ô½û®ìÚYCJ“Á L§í¥|¼ýè_ÿqyïyÍÏÍeRÐ½´«‘t`ã›Bâ’Zi{¯ëê£Ç÷’g¤6üõµ0þ.‹’ðüLJœÂ\rŠ£jœâª\rÇf\\ë@aá×vÉ\\Í\r®¡ç‘;2~FÝ¡r\rGúÜ\r –êáœ,Œ,†™;ÖÆŠÍ|)íÀêøLãáJ[]3íÄÁÓÃíh¥‹×\'VúÂ@ÔeÖŠGÂ\Z!PZ·Mêp¡ ,¢	Ïô›Óàº”<‘-)ÂKŒõ¬k-¬nî\nç:Ï÷Û¯¾Ü?|³?CŽy¿ÌYPê˜ÉP8{F@üµ×Fb=\'Ý`	[qíüÜý5žUäÓ8¦Dtwu²`»C‹à­­nXz¹2;ÊàUÉ:™jÓ‡m¢tŠF[†°]XÊ)å«¿6·ôM§ŒÍÂmÛ#7~¨9Æ³ƒ+æóu‰’5…¿¤,sˆ£Áä˜\\]¾¼Xwþž“*§µ¬\\J>+øU‚]l«ô½ÕÊ¥‹“ÅžïWë]SïXÍ&Ë‡ÊMÌCãæ…ë‘˜ëK—B§_1p]‚øa„è)`±<öè¦\rîVÚ²¾I¶ù—¤->xÛ;7pÀ¬À\rÎ¦&ÝaüIÉÃÉr„îùQ»}cWR¼Ïö<ð[X‹ƒë`ŽnZÊŒÞU+&óåeûÐG>ÞþÚÿˆFxTÖ2wW¦£”HÒ2Bå2žpÐj>+Ÿ•§C)APëþdž!¿òL¸÷,t°¨ÎÏåÀ-òš_cÑ0«û®Q-¯>§\'¬Ó.‘Á²Â=¤€zµªgsµªÅ­³Ò—07øK\"A‚[ÁÍ’Ìå–¹nð4¶Ô}Ô@q‘D£˜@çL¸N­çož3X›gip>2\r6=UÆbvoÜÐ,4}N¶­(*‹…˜L “Àdkk[Û\Z^o+ÏXê\Z¯ÛÑþž:[Þy»½öÊ·Úã‡o·¥%ëó3g™¹¹ô±PMÉÚ×ÁBÖSãs9PS¹Xº’é†D\0)\r)i—˜™­’6ØrüMŒ§©kÍ’‚6Vv½®9¨¡Éµ¹—Ùý†‚Wšnàg¢Æzå Q“®‡™¿çPe½vå¡DM8U†õl£†<méÕ~îI¦&h©´(ì\'o¼8Õ}Ê÷3£~ÝÛµ<ËiÄÙYÏ\"à¥•½¨íMHì¹“T-œ’v¹\r>&0)ë«®dÊR^‹vº4¯Ø-+—KYPKm{{§­oí¶õ­vóöŽùÌgÓ£%w•sMïïï?m/í+í*­Ÿé9À#£[A4tïKžäñãÇÿŸ=Ýæµ±¹ÞþƒïýÞöéüávy]]\Z(„Õ\Z®×Àó=¤2ªŽhWK`sQD¢eÏõÇOOºçc†E—.–’d†s‹¬Š–ð•ä`ìÌp^åxEuƒÁ¥\0~£NäÙ™ºkË2¢  ^·™^“’ãªÏð´4`ÌgZÅ$¢2Æ¬#‰ª³çìåëï[†Ûß·˜®èÓ;<aaëy	ôák8\Z·É†;j”ýt\0¬»àñW72¶@â†\0Á‰”(¸®ó££öêË_o_ûê—ÚÕSZ2×3`U!5˜ïr»¦*›TåP¸RÿV#d%]ò];ówdXp´†ë›\Z™JÒÇŒ²¹Ü_\\Ý··vuý²p«=­½yUeyÀóR®;Á«_½\ZTqÚ†C¨Fv’\ZCG‹‰©†²\\WšBš¾Pç8%øEü>¾„ÅK1Ø¶pbéÜ ëg?º¹Âõq\'gNãÎü[?ÓbªÍ•Ädæ*)b0­¼g‚²¼©y¹é\\G‚\\‚¯çßë“&)è˜gÔlœ5ŠO*”‚\"§.äÍíÝ›msû¶Ç?°^Bº¦æÙÏÐ\r0i`0˜òàõäð@óŒ<¨Ý7•5ã¯ã{e¥­×–Ïæí·ßm‡ê,>|ø®Œ>ó™Ï´OýÀ§¥ÇÄµ1ÒæM¤)m“HÁè4¿fàðU”u>/ŠÓiëueC…°A•atèQÕöô²øªáug¯€¢5ª%¹æòUDçêÜrÙx]YECðïS*\rÂ¯,_s>=—:å\"‹rPhmdûb2\0®ì¢œ˜yl\0é¹’ D\"›\ZiÓfÍdMe)ã©	uwdfÁâRþTð_F¢xMÖbèbqßÜ¨#«µ¥i\0o\"JiÏRN|ˆ•PÖˆi†ëA;C¢™÷=G[l¯}ók_nï¼ùšˆÂWnš¯5‡‘@ÁÏ÷aëŠšã&¸€n2äZ‚­Ê~©û¦j2OJãÕ6Ùá€µ}žL`„C›¬Éçàóó‹ÌŠ¤ÝÝ›-$“4öd2U5Ëˆ¡K4:¦¿5I€qÔÅÜ®…6Á•ÑkÞsÉ¢ñ6\n¯âÔ–ÕL#u®uÓ]›¿Ôÿ2: …V+¹ œl	ú½nræú\"Þ§6¸º¶Ýè©DÝì’•©›ÒgÄsÃX€þ@|/\'‰1)}hÉ(;»1/„«Ùèaw“ŠËÂ«†(±^Ï<›“SZæ¡ùh&øu»uûvÛÜÚiƒášYÒÕíî‚Šeq¼È:xohŒ¯ì=m§ÈÿžÊdóÆZÄ`QûO·ã£Ã¶,Âióë¯¿ÑNNÏµÈ>yÒÖF£ö“ó\'Ú_ùþOIÂ…@ÅÌaJ[\0Î‹«ÊL=?J¿G¹g*¹Ð{’C‹qAIÅX˜q è”GPÒñ£\\#`aøÀÏHƒì\nACÃúÙ:ýø]ÊÊBV4YM¡µ0	eå_‘þe1Ö#	sáaXè*=˜2ÀE‰©.tíÈðÌLRõ³OpZ™ö¨£¨ô¤wÈ¦Ø	¦ª\\+âïUùþ\0\0 \0IDATòŽ”1¨(ƒ%+2	Öó™Î0h4ŒÑç* œë#ðQšy8ÛeûÕì¢MF+ÒÆíå¯·§ßiO½+@›3S»pf{3§Dã\n‡šàªã\r_Puœ4SË^XÆ9Õíd]¦õx&ÕÒ.VÓuœ	Ûî€Ê Å‰d<šGõáÆYºŠÐÜ`¥#Ð…±=rRºâóË™<4˜NY%IÍÏ!“]r½ÜSž%û^±€¦iù¢ò³–$š¶Ágÿþ/t%aXæÊ´ŠÁÞNýì*µtN®tÔz…®Ü¬ÌMåH‰Ê%³Bi‘_bÆ×¼ XDô	X‰â|oÞ×DÏÒ&/,G¯%‰‘…ý\"Õ6“ØƒÝ(\0`È¹¢S]wUŽ¼ŸÀù‡rS×._h±ÃS:Ö¼S×}SI`ŒnÕT)ôôôX†°ÄÇØ’—f£àZÏž>v&s9oo¼ýn;§“¶´ÒÎæ—mgs£ý§?ñ“íû¾ïû8F×ºÆœ„Ïi4¨7Ë)>âjiK*‚,T‚v\'PäÓ	Ï!*?ÙäN\ráÓÒln6ª8s’L©€E;]óœ`‘Îl‚ ù3÷ {—þyî¼+¥[\Z+HŽŒ­5F¦ƒiqÇãX€ì†/˜!„ä×‹ç§r2»ºJ˜n˜V\\¢¡7¡lÕ`K¹ÄãÐZü\\²ØÙÆ6r\n`\rƒŠ55àM=\\´Ím©†Jc=v2aöÒ…hô\"àg½ùú«í›ßøJ;ÆqvÎe»Â¼¢ˆïŒ^\rLg+ƒŒäqG¨ïñ^qè ØP\"HHYˆ Øœö…È¿Š†K<—Ëûˆ\Z2Y×½–ú	÷ne5p88$yS27\r V˜ÎA¦Œ\náLØêTKJ2Ð(s€¤ü\'á0˜^ô=#ó8EW\"˜]ñ¹k\\G*$¬‘³6ø½ßüEîüVp	1¿²Àûˆ¾b¯{—›˜9²¼®×æ¼ŽFª‹”ÍÐœÐoÃgÁå}UÒ•Ê¦F*JZ™”Zßë¢[ÔÊz\0J7YDfßò¿št– ÙÁiÁ\\s„›ËP‡¸ÿ\ZïÁˆƒ†mlÄÖ4ûw‚DÌžF\n`®³0p ü?::ÔCÇ\ZÂ+šÍÛë¯¿ÖÞzë\r—™×­=ÚÛoûG\'rÚÙÜl?õwþvûÔ§>eyeJ®™9\\Z”š\"RºìU ˜žëî2Ž˜ƒˆlž™Î\Z{)¬DŸ=ÎÆt®(?Ë\'\'§£Üs@qÔÖ¶R$A>Ù†Àÿ\Z¸–ñé™ƒ1TJxï\Zª}<ŠƒÁ÷ÅÚ¢¬c³Žd½Å†²Ný’ÖëÂâj©Í¯ag;HIÓcÔê°å3v³vE§á€à¹Ë@xeYA‡^’\Z\n…}jŒ¦\\¢ØtN¼á‘=Ý{Ö^|ñE]çTÔp0ÍâÍ¬²JÚ€˜?úÂ¿m{{ÛõÃü4<ÎDf•„x4¶(Ù–WT¢šÀi%Y.¥K§Æ‘üØrŸqÐ¦2X_ßPàb‘Ì/É„ˆÐÅ/$°æõ\\E¹„”0\'Y-nÔ¨°ÖP4AËûÞ°Ž÷ë’ƒâÚjµÌœ*ûŸ‹†¢‚i×€1l¤}_Ùº9oÞ“à‹I <ÐíùÃÁoýêÏª$LÖâõäÖ©%XÒ\\Ìæ{”ñ¦ïáJUŽè(ê¬Ù«šä£7Ý‘tÔI¨›ÞÍûâ¡Ô\\!§‚f¹†¨kS«º.±‰cXµ¬L÷Z$÷E¹°.šKC9CÚTI@I[r¾æÂÀö§+x.Ç´`­£ý§íäÄ¼+M¾K¢åLdH†™	|ðˆÖY8ƒAc|ã+_ùŠfÞÜ}÷ñÓöÖ»E \\\rÛOÿÔßQ†Hë‡mÜ…FJÏkLg9)xØœ„Áõj¼H™sï€áÏÎd‹ÉýE£K\\ÊC]%§¥ÙÌÅM{Ÿ\rºîmuƒÙØƒ%°c2Â5J‡_?_C/H¯¯PRxpöX/Êi\0c\Z=â_!¬WãO“3îñE»uë–2\Z:g}52Í`†‹µg¹kñ­¤YVÖ$|‰ÀZÆµ„²“€%µ\r×Veyöö»ï´çŸ{A¦Tx]Ü[Æ[d[xA¦M¶É„ÃQûÆ×¿Úöž>)·YÛßßkó»çãr›*€€E×²¿Í#DÈ)÷Lm9ý@©9@ð,D×1ÕX-Ž•3pI¶Q5TæL¶oã	Ï7:\"ÑÃ\0ù†÷&™ú`Ê²®u0ð½tŽH˜Ï²DâPÕ¤é¢{ïà“½È¸Œ_ø.¶PÓ°\Z¡G¡éÎÅ+ëéiE\'P·JpR`èu2º’/3@e’¨:¿ÚÀÊ¬¤a-ªEð3Z`É\'DþW¯Ôóž]§§2Í$*¸+i@n„¡>í“eõACÝ•<Ð\r\r0ó`8!ú{„§ôÇçeÏ9n~!6¸Úþ8¯,·mÜŒ§±uÖø:Y‡®1g˜ê¤fâžÝBº2¯¼òZ{úì@\0é³ýãöÖ»ÚÙÙ¬ín®¶ÿú§ª}Ï÷|Ê[^ƒòLY‡F•3\"ñÏ\näNÖÁg)—®^-ŸÈæ´ô¹Z*\r	’í¯qéÃç\'Ë‚_¦èn¹H¢.Ø‘šûbP•lz!)Ìa¥2°7—ªÃ‹`Óãääº’a\'û•ô\nŽ!oñ‘,¬€U];ïY;­¡qÏŽ;&ë˜n›3¦¾>Ñ§—ÞôÒv_h|G\\ pTJéÁ²$„+…5ÏœâíùÉÈ „Êû¢Å¦¸g-!3dq\0:¢€ý”ÆÐFÎd±÷ôiûê_üE;=|\"ˆƒÖf=÷t	:\0˜ÒÈÚÒáWpd•qÒDû°>=\\3Ö¶TTWPP5Æûiñ8Ðááq²VµO˜î]„Ò™×$;«\"\0;&C*Ùš*KÓ™WP,ÌØûAf²íE÷ß‡¥ïMêàB%*›¿t-i~ë×þ‡Ž‡• ¥®Csj`S\'»Ò²‰3\ZC€”IE%bWmo9áº[å½ë\ZñZý²¥ËÔ„©«0‡”ÿ‹J„Ž»´¸ã„d!×Âû9+bqšÒµJÐÒ5KÓCËàtj :¸;Äh‡9Zü<€:³Ž’)™ÏÚdÄ©wÕŸí	‹Z‚Gvz$ÕL?Èúi¹›<—èúDøÕkß~] ùko¾Ù=ÙkƒåQ;?Ÿk±SæÝÙÙlÿÍÏüWí»¿ó»<aOi…Ü†nç7SrRàÇ#X&ÙfŠÅÙu¹ŠøÇ¢\nž•ÀH,9rC:}e\0¢Ô^e¢;¸¶TÉq?å†3‰æ ]ØÓ5+§Ç`Wsle”A\0‘ÂäBÑ6lë~§O¥#-{xE•ý\0”ÛÓÁRƒÒ¨uÐ£”×È±Ý„ØL¶I3¢ü„c¡å®Sòhá©ºSeTâ²5;X§\Z¸AemMî?réá€ «I0•-m|”3<N$ù\Z\r•©Š¼²,RéŸ|ámïÑ¦MˆÞ\0ˆ=´˜]:î•,pß¬.B&‡µš9cü2Þe,H^3ìI/«UQ1Ô¬â¤¨:Ç‰ò™]¸¹³QPàu”é²Á.ËÊ>£CuxQÛLY2L¨iÍÄ¤lÆ±8ø]r­NbÌ›IöÏü¦è*R²ñhÔàwÿþÏ©$ä&mðUé	‰É¨„%õþO°SvTc:µÃˆU]íwþ”æU½žÀ£Òç}R	4\\tLÙ*ÅG‚¹ô«jö+Ýc.óRipÉ¤×«€tr>fuïÁs:Ø´DüðH$øOíŒ°ã!´ÈÏÏ´P”í0èŒöÑÓÇáãQ–¨ÌaqO5XL;\Z›*N±—_yµíí¶o¿ñV{ãí‡:/4ªàÍug{£ýÝŸùéöŸü¤AX6¥†µ…ÚlHj^“²Á¢)(EGŠëÛÆæV»;Þ\'4¿çtqTDV)¦r¤éâö½²¬¹²#60–r›G\\=¯éÀÍ÷çãûÌOC’Çæž\Z –1…_é™<ï¨Ï&(¤T•G‹WÊ¼6˜ÏÁ”\0uŠËíõ…ÑÐ:P…éÄÄ©#x•y‡`ŠZ›:ÙîÖzÖ,˜¥K-)að¬·’ö&@¨£¶´ÜŽž	& #ÃÈÂ.ƒò¼•TjT-{Lš_¥Ášzç·ÚÛ¯}³=zø®‡d„.çÊ¸ÔÉ,) ®Õ¥¿ƒŸ	uVU15„.Õµê„ëÔù&à£<1Q× %úÃ*ó—öd}O§§êÆ1h¯’œàK÷¹Ê2‚•^[ÀyŒ]ÆÂÖ²8œ$¨)•¯X®Yü:ôÆ1z]1\rÌácñw„Í$pÀb=ü˜Pð‚}ŽŽŒìÐÃßx¿¼êÂx ùú#6Õ­H9©À…ÊÁµyùš}®Ê÷&sÈMÎkk‹VJ@N8˜ÒSw	ùETçäuàÓ WùAº>XmçSÔ–Ûí;wÕM¡­\0¬Š49îÑZh`a‚;`A û!» CÈøÌT×R¬ˆìëN`eIzåOž´?ÿÒ×Ú×^~¥=;8Vw’Â9úöæFû»?ýSíãÿ¸¤n,Ñpkê†ô’J)4ƒNÅU!Cá\0Áh-õŸGîgÆsTB•	„@—–åšŒÖ›QEdukü†€Õ±¿SÖV©Ã©fY¬¬%e½¤ÌÁ1AÏ„\"€ÖB‡ŒgÊ*	ÁX&ˆíyÃÈm¨$¶™éä9Ù	(èS³Ð	æ¡ÁxÈZ÷œäÉTµ.kÈ·\rTÜoÊÚ	lðâ»¡¹…æ:äÑã‡ílzªîšðÃdo¶4¶Å|$Ùœæ{.Od±ù¥ÎùÕeÛö¸½ýö›mïÑÃ¶¿÷X™fædnû[#.‡¯†³\nûræÅ< 1%î·†ú—è3Z¶®2\\l}sGÁTX¢—,\ré#zi.\\~8hœØøÎp\'\Zýõ’™.lßîK÷°î±\' ìž•ä…ç Ð¨S)èê\0†Õ^F*²SÓ˜Ñ¸É—0YPN´´Äs’æÄËƒ\ræ”¨››²\0±#?ƒii@÷~@Ìö{SÎÔÌP:3]:¿pÎp$¯Q”2d]“áÜX•©qs)Ó\0/ÛÚ°)vvoµÍí›š¶;Êé)à2ë–6­ù*\'ôÇy0,Zø•É$?lp…#qŠØtlÙ™«ÄXâÉãGb7ïììÊ4õK_}¹}ý•WÛéÌY€ÚàÊ\"—ÚíÍÍö3ÿÅßVÀ¢pÕ\"„KU:éîX’½ßJ,Ù²(\nEîCêåª$qú‡AN>÷C|­ž¦=Í\0á.’£qð\'hžã>s^Œp—€z&Õm„´J“!‡ ZÁ€CªXó.É˜à¸(¹’u	ÇÐÁdðyER[Uðx·¬¯»ìž¾ ¬?ˆ .R~d1\ná\Z:C qúÀpp›.ÎSy2FÅSe§ƒq{åÕ—ÛÑéQÛ¹±-Ë{4æ™kŽ1¡\0Ÿ©È±‰­ÙoÌG²¦”)+F\néT”˜7¿ýj{ýÛ¯¨qƒžx¨ÀôúÜù,â;•´q: šÜPß©|0+Ø35‚àÉ5¢»¹}£­­NJzÜ*&çç¨gxm©s{e½dm’¥¥ÄØ–@x‚*~ØÊp£)ëH«xŒ­ãVÑk-™¤H\ZæMè3{--µÁ¯ýâ+–ÀÙâpLÆ,@»RŽåAg!9#Š1¨£.¿ô{ôƒ‘Fx8¹+EÌÏsòfcY_ë½Ü)`¢»/¿Ê\n½ŸoŠ0’\Z¦VIh„uñg*³òõZÚ™h}ãæ-Ü\\]Y®…’ìøøD©8cB×WNË¥†pbîÐÆêº6èÒ·\":Xñ€`¶_ª$1þÀ;×ðóÑþ³¶÷ä±ìíÛ÷Å¹ù—ø…öÚ[ï_‚eíà~¡Sý…Û·Ûù·þóöÒK/)+ÎW„?eYÕŠV©Ø9‘Ä´ÕòºÙ\0ÕÊJŠíÝmÚ(,$a_•ýØ,ÄïÙ5Eª4äÞâð­«qqòœ(“Yäh‰‡^¡xEšôX²˜bu¥ë]±Œñ¾Ü§<•ª\nW\'â9IRÝ÷˜9È\'À?†±X±Z4Î¡QS~/Q9$æè¡!‚+[£ù´fÉŸ9ýËVØÅ\n~Km´6±‡Àå }ýë_iÇgÇíþî·UÔN5D½¡€E¶îÏâù=Ö«º¦ê¦ÙŒ¬W™^uZG+KípÿiûÖ7¿Úž>zWü-°-I3¬¢ƒ¤‰Gaüo¬CÉ\'IýÓx#²<)ýå#I ÚÜ•FDã²>˜ÅÌ‚C?P\\À­µ–g$µ‡\ZdëÉ‚¸¢`„…§gÖ¯¥}Ê|àt&‰$~)È‰ßVÌúh¶‘£íULQ¥¿ùËÿ]GkH‰fb§q¦LÀŸ†]]\"* Po+6àm‚“G©aÏ+/‘˜ŸII HÊÆ-VnçXµ9‹KÁ©›ó+ÕË’«èÀcävá³T†áQšð••‰€YÚ¼·nÝ‘›\\vjla‘þÐÅ¼={ö¬joBäTX(\"èe»8ŸªÜ§Ú‡x1o7oÞl§GGV´$Ïgò<>8>\\Ct¥ýøoÛ£½=Ä!ÕúOF’—á~äù´¿õ“?ÑîÞ½+ ÛŽ+˜XæYeÖµ1‹ù{U?Íï÷³SÇ\r¼2s5ÎeO^NjYÌËJËÚl®8,l$™L5™ÓF)ìLØƒøb\0°èÖAuÅÀÜ)¾Î÷©,í)tïW¼²~[[t\rmf\n‡mscS]M6kV­i˜€‹]šmö¡	º‹‹Ó[A£:?£@\'•M[§û(t£#´°3Q] ¿¨µï‘T7¾ò•?o\'çÇí¥¿Ô·ÌËªœ½	‘{q@öš}Ï}+ƒ\n°:gP˜\\µwßy³½úÍo´ËÙq»žÁ…£sÉ¡K÷0äÏ©Ê,sçBÝáó.Ä4•-\rðÕhQ9mþ”É³c‘¤	Æ|»…}\0f	?Œî4¿”‰K°r¬ƒG¥¦È¦,>«p*¬Ù*ÉL§” %›º0o\r½$”uÔË”6]*n[¿óë?+=]àù×“‘m’´	g.(,}\\¿Š¬™T5ø‹8”„`ÉÈRzªtëq-T”FŽÿì®•Hc”Jì­Ò£ËÌ2zƒ&ãr\'µƒ*k÷Öí6^ÝÐB¶àÚéæ…H”qŸRD\0·¡®N©Àç^@ÔÈx_Kmk}CÝ@¹5a8pÑvwv´±¥¾pr,²àþÞ³öðÝwÚY§íðøTœ«9A½:9*ÔU½jßùÑ¶ÿìoüvãÆM’y°ÚXÓX–\rUÕ\r*-2•-=Y™þdN½RU•t\n+@sd2/WÔ<ýH\\ÔÕÁ«ñŸq‘MsÉšj`G£.)QX\"”Œ²öâžîò‹\r|ŽXe¢PT¶°Ø|–Ð!ÀöÑ>gÁÀÜÈž>š³“sÒD|70/ø8-C¯éYÇ©1ÄPwÛ<$Éãè2C­SVP:Ä\0ÎåD$)² gã¾˜Ÿ·/þÙ·ùå´Ý¼}C‚ŽÃÉF»@\'à=&jÔDVÚ^Ÿ®Dœ½Ä®\\ˆ CÎ’7Ì©¾þê·Ú;o¼Ú.ÎÚåý0fðœ¹ŽFŒÂÐuã¾ùÞ‡æè/\'¥‚èžs@±Ž¢?\'H§ä Ûµ1]}^žeÍ:òúŒge?ûl$(è\0ÎçÆT\\?ÇÛ•%‘ ,`wVB…)es°ò!¯§²K¬Hì|ö7þš‡e•@‚˜Ñ‹˜¡/ªèJ‰€l\"ù¿…>ŸlÇÁÌ]\"²@ì4á›Z©8%¡6—¨\0•~¦ôãÃ$ÒÆg›Ô/Iý :O*ŸVL”x™ÝÊ°Ý½ÿ\\»}÷¾ð—”‘Ì*\r¾`¤€gWb:%*ŠÛ%×6;¸ÌXÜ\0ïüÎP³üç®.µqÈ&˜ÜúT˜€ü×ÎÏÛÑÑqûú·^oï<|ÚÎ>êt®(+@‡ÃUûÞïþdûë?üCmks«;åøMið)ÆhXÀ–Q69:ü>Tân*	\'!CN;¥J*l°u§ÐfZ©ÙÃq•~žÊ‚‹­E«»Î.e.•mÑ]Ò˜Fé¦ÏÎ<÷i¿Ê4´‹/‡¦ûÿqÖmÆ5¤[m6!‚Æx\"¾¥%¤M0!eXãXÌƒç€‘ØkQk£äŽ©\"à.Y ÑPu!ÔVÒdI7²¿È2(K	*üÇÿ®]/]´;÷î´›dí“MIÍ™r(BgQ6K0Y³+Á=¸ [ftŠ¤ƒº]¶Ço¿Õ¾ñÕ/µ§ßj—sk¦3ôL&ëÞ^†vhæ³©#™-°a7;\Zžž‚‚b\n‡\n\Zâ‡›úy†×e+/S’#¯ýšíÕø–ýÌ†\' kmií: ‹bD2¢?×”\nY/ï÷u5Ä{$`	;ëÉz\'ÈË—Ó“STA Òw”5Ü#~	3(7cPiÝ/‚R¢!˜³ê³,2¢ù¼¾>4Q7:à®Ì®Ê{E\\ÍªmÏß«¾×é(15ø%>µ`;×ß²ÿ’£‰<›”Æ/\rÇm÷ÆöÂKÔ<;›*`)•.ú7NqéîÈ¢Ê§ 5}N\'cZŒ50v\"½#fíÕPhMù©ðò¢í=~b³‰ÁRÛÝÝÕ©ÿ§þÕö¥¯~£ƒeH\r³ÌÎ4æ	ýÀ÷ý¥öc?òÃm}Í²¿	ìÒª/\\íz`\'~õÕ)-ÄÍÍÉL\\†L9›D’¬ìXå%îÁ’‚.žg&=x\rÛÅÞq‘€ßjä*‚0\rJ<å×‹ÈãÜ_‚\r‡€ºEÅx×s$¨]5‹ùUFžòr°¸—t£–Õð0wÇ|\'p*‡NqxGòïµ)ê¨˜4@+\0Ï‰¸0 p2+ºëP÷·ðÕ«KM/L”ù»4VÙ	ÏéÚó†nê¸møË_þ³¶<Äâ~Ünß{ÐF#ºpt]†y´èc®Ò«+3kÐ¼ásó½\ZÒ¼vÆÂýš·÷‡ÿª}û•oÊuhepÝÖ„ß‘T”›€+œÞ<0K}«Ò(ÎTÆrBÐd€í©·‚-t\r”I×È4\n†ÝCf)Ë8V™zÑgÈp•¥…’Š†çÄ3RÙI¢2tÄ­’ë\n,1#IN\Z~9Ô¥\\%$ŸÿÝ_Q—Ð?³êæIhŽ¸rÂŠóSoOÄ¸Ò{=S\ZÔ]ÓH*ì¢€GÕÁe+.Óš¢÷§ÄÌkkb›à¤H¾x\r-ò¥Ñ\'5ÌwŽ\0gÍ7ÙØÞm÷î?ÐéËµLçS\ZXÃúüX©¯®jS’5©D¡4”\r©òu;><Rp×M\'A3¼‚%¯GËÞ\n×fGä=9Älâ™ É¯|ã•ö­W¾Ýžkð6âý8…° ÙÔŸùô÷·¿úý‡.=Hïe6Êç^ÇÉ\Z~“×`\":JQ •Ÿ…Õ,ôÐ1ç¢—ÒŠWÉ„¤ˆÀçr7ººRù›îŒxZ•= ]²;kÎ©ç¨LÜc9?î«8i³Y[%ÀõÌŸFë+úÔÍóîwÓ(©C†$Â±ÁxdÚòó±9Ð+·úx›—NxÈ’@ªÃ³ÒAuE¥¥^2¼\ndK\nV*›ÔŠw‰%!Bxƒs\r‹g4¶ƒƒgíÍ7_o§gv¨Æ§qu}»MÖÀ²¬’Í¡#9/‘mL:ÀÙCÈž† (ÎfÜt›hŒGËíÕ—¿Ñ¾øÅ?j{Oµ\r²gQ|¿ñ$³ÃR2$˜%X&Ä²JpÕÊ~¯xJc9µ_rïLØ$Ëâ~Øg\róÜâÙñFÁ¦•ñKé¥Äý$“muømÈ÷0VEØ¬ý%¨Åzˆfq5\0ÓÀëI×‰âhð~@„\\³> @»\nX]•ñŽ\npxœ÷äçŒ¯¸Uœ2.Á.ßŸÒPDÄ28 DÉ†™Òâ¬ÃîV)\'A0¬DdŸ@Ì\'­µÝ[wÛ»Ïµõ­­\Zf6>E6˜|©pt6h÷²Á\0ÏÎÔ\rÜÞÝ•~8AŒÀÃ)!u‚’fñ0½O\"ÜŠl‹Ô6h›ðÐ•:a&oÞ^óíög_úZÛ;8hS´éÁxèÞÍ/¤R9&½ÚýÐ§Û¿ÿÝßµðå	µ«DvéF÷…[ÇJoFM°ÄüN÷F‡\0å4R¿¬¢C(p¨Š6×Fº7§&YäÂ\ZÕi¼p3Å~|‹ƒCYAa&lÑ3/Â£?Á«0\rž­¸QsStÏkŒ‰1:ýZ˜ÃŽhÔƒÒLŠŸÌMzrD‘,^˜7ÊäFˆ’tL=æQ‡\ZGíeW\ZªÓU˜‹Æp¢·µ¤,‰ax\Z$Î4Ð={ç7ÛÉéa[ßXoÛ;»m€_ x™žÉªš;òîÖJÇ]Xš3eÄ\ZÙ©€»_`9Â‰çíë_ûJûÖ·¾Ù.ÎŽV”£ÊeJb™g´¿\ZdŽ/Ù·pu?‹ï¡ýUóž&]LM´ ïc5w„çÊN¶ÛÓÂžjÍØ	È‡“ä\nûæÐ’qÁì]#¡IôM{,yÝÁDSÔ<\"`ýÞÿ´—IÄõ§\"h-Û¢¼÷C	>ÝB-E‡œ²éþåDxF²Ó²Lzëi¼Æà`·ˆ9-‹÷gÚAÙ%`9}ôSÈâ´Å«]¢Ý[÷Ú‹/~X5:âq	¼dõ¸››Jt§¥Í†=88èZëX*ïI\0\0 \0IDATn‘b#)ƒü±È×\nX°ÉùEÀ¢È×òC—œ†y²éù¼½ûèq{üd¯=|ò´½üí7ëd\Z´iáEdc+x!ò`–ZûO~äÛ÷|ò“Âdt/k³Ñ}KF%Õ„êzVÍª¬°ÔÖw=Zõ,re`%\'bý,?_ÊÈX±É]ºÕóóü.šŽól#‹lìËƒ1&:L|M|eó 8`xMH—Rh¸¼/(ÒÆ\nlþ“=ØÌ§}h\Z)Ÿÿ€ÃœgDÉ-?BÈ¸$SöB™G)…ß¸”Sy…$g AâÜnÇ=[s‡ÉX É\'*	yTo¼þZ{õ[ßh×K(wlJíae´*‰ñ¨ÉÚ¤­mîX)A™ÄàÛŒÍËá«{\'/Eà\rv+À5`˜¦ƒð7_oÉæ÷<l,0¤‰—Úù˜f©•2Þ-§§g\'íw^¯:üÜç4rºŽ=‡à|e™]‚¬3˜R-°ül×àª½\rTÒñ\":…0F™Õ£N:d´FmæÛ}OhÙË!šw]ÄÏþÆÏ]ë!V¸ZÅâeÛUe‡¸-R0„½>/©ÊÊÞg(‘.€Þ¼ºY¾9•Éå+6_juÀ¡Ii´K;Œ \'ºµÊ´>°oëëš£“*w}¤ÕvûöÚžICš±³:;A?™˜3áMš²Ÿ¢ën™.ƒÊ”`	\0lä)„È%·ì¹Þsv1õìS¹?}ò¨îïµmæµVX„×íõ7Þjñå¯´·>iGP–‡eeDJÉÁ3à’/.Úêh¹ýÍÿø3í“û˜5—Ð”*\"¨cí*Ñ•:{ŒÆ£4£Kf•Ÿ*‹£ñ™¨µV÷+Ø›éÆ2S\'Z·Î¬–j†ÔC5WiQî]2mÄ1GµÙBÍ.37w`À¹Rý:ˆ…ƒ©›Êô¸þ0 ÝÁvcaM¼ç€¸‡pï~r¤qBä¼míl‹mŽÕAí¸Ý½2w;£gnŒ•!p€‰ù‘VIèž€Åµ}éÏþ¤ý›ó¯ÚÝû·ÛK|ICôÐel`\nwŒßíñ§Súðd•-3ež°úÕ”2W°+ÙÊÐ—rýÍW¿ÙÞyõe96³”09©dTE\'Žj$ÜE1*	Æ8UL‚¿kDJJ¾Æ@	ÛðÖ¤“V*¡”â`“à@9|¯*\'°,ÁæK&óçýRB²OºÄ¢Wäz’]·ÍA¨ öÙ_ÿ9©ªö¬n§Èy£¾bd¥¨îïÔ‡[dQ1g5‹5bz}l+D\rÅ—˜K$O(Ë«ö,£7|Z­±ŠJ\'Rº;q•&2-/Ë`gçV[ÝØm[[7ì’sI¹qÜÎŽ*>·[f£pU±ú£ÆpEN\0|	ÌÝà|-5Ùƒ1\0íNÍ ×&²u§”¤;ˆí<#Í¥wµÔ¾ðGÚ¾ð§Ú.HÙeIâ.™f‘MÖ(Hk;›kí\'üÇÚG_zQ[;áO<hH‡î(J¡|÷2“é¨o¼/÷¦æ¼#YÙPÍòDŽ(C2!ñ²–Ñî2Ñ3Å<C•Uæño¨TÈÒ«Àx\0HÈ	v\\\ZDmx•–Ì.”R+e)g°˜LP>yÕõ\"ËU0)©dÖ–êü.‘99Ã˜V°scWã(‘ÝáµàÍñ,Muy¢¢;M³‰rÌX•\0l©)mŒ-‰pz}Ñ¾ð‡ÿº}ñ‹¬¡ö|ì#íþƒçdYFÛÚÝß†È.c±å@Æ“µ\\P~çùg2©ƒE\rù‹Œ}Ùž¼Ó^ýÚ—¥/P¼löhôˆœ[àªë9Î$f™h)f¨+ë,RKFJ­”E£¡p\'Ê9\0ËËU}Á¯²‚«%³Ð Œ:2Ô¡°•YÎµÞ*«N¦—Ã6ÄRaê5‹9øýßøy1ÝÓ\n×ÜTÏ>I$Ñòæ£k¤ØŠL½K-5â\0•å_\\,EÔð…ß`½‹¶\n&r3)]”ŒUÀ¢“Á©!=ïž\r<…ÀÆ&Ë¼-µ—^úH»}÷ìðLÀŸDˆ›áÿ7míj.»o\"//ÚÉÉ©¤f•E©3Tm„ñXÀ<éìÆêªAÈ“c-\ZÉÈ Ô¿†hßR{úø±”FÁ¿v8ÑQt\0ïºhíòÅöÅ¿ø*2ê²!èŒŠ´z1kÃëÖ6ÆÃvÿæÍö£íÚƒû÷´ÉÀlDZ&Ÿ™ÁAÍç™HkpÜnÄö{tlŠ‡ãÜÍÄ~Gq ìR…Y³)2´õ:”¬;TäšSÔ€€®,^Ì$„mÔóP–zr*0_æ¯\0«¥w•MÂ÷pÝ¼Áïòj‚y=É\nYK)˜9ôøÄ!ij°	:±BÌ 66Úd‚“ó\\P\0\n›7oÞ’–¾€y@ôÚÜMO“‚,ÍóøxÖ4oÒÅ^A_-Æ¢ñ˜ÖÀ—öÀÕ¼ýëùÿ¶o¿þZ»{ï¶h\rˆæ‘áÒØÞÞRIQx4Y~Å/ëª›ƒ˜ÏêXWe««&»Ñ³˜·öìÉÃöõ/}QòÛ˜ó¢­EæI£æ…&A,=­=¢ucu]½WeÈ</T]O3E4 Ò¡²á‡\'XÀ\0µW“¶s“•HyS•†š4±óQw@þ¹–ÒeOÍú‘¸¦|OþºÞÄ×Öô*ó[{ž÷>ó¹óP“]vÛŽ\rƒ›L°7H5BZ†DM‹ÐMÒ¡V‹DýDDjEI”(M0ØÍ`í¹ÊeU®¹nÝùÞ3îy¢ß³ÞµÏ±“©|¯Ï=gïoßû®w­g=ëyÒðs(²$	\Z‡šÎ¤g2ÿÃÿß(ò0MCŠgÁÀAs(gže*\r²¼F6ÚÄü¬´¨îë±í›ˆ\Z9.4ÒSÒÉ`ÐF”•g[ŠÔ|9Zº~ÜXý¼†02ÁMc#”«›L—¶áŠm\'Õ„¹„î’—\\êh:ùÓU\røL#ŒL—Îs	…×­’=1l,ÞÑÄÊ´›\'cëž«¼¯p…=ßévìôèHúëpyPÈäT>>íÙ½‡öÊkoÚqß	€RB 3ÄÀ3ŸQ¨U.Û‹ì»?ü]¶»‹ÆvU%„ø9Zx®-AÂ´<DôHåEœX¾Ø®ì)0Þüp•i×‹^\0óÝm2+©\"¬µ§\nî‚“º¦ê\"&â*›>º!yâr,PIVÖévuoR ôÁäáz„‹Huã[…Ú(÷õÙ2™PPv\0[H[<G—3£Aw®‘’u:›¨¤oÖš\ZaVsïÂM2ð€ŸT¹É+££O¶¬YIÒ×hXRd-p]^qëBJÚRA™ŽíÅ¯?gÇ\'Ç¶‘`Õ´R­b}mKVÇþ‹!éÆ†eÁ¿4¶â{ÍU¼yàÙ¬sËøâÐ$˜ÉÁYëÃiîåýwíñý;vüèžDÿVÈµ\0ŒsP)ó,ZYÅ34Ï`œ†IªtÆR¶åÍŠDMdeíÜÖGp˜ Ò1á]®/—RÅ„F>0Ug’lÚ|2†×Ìi7qgœ¹èÄóS\\úÝßúµUd:ç£½G6\'€jé\'à‰¯)îÔˆôVtùs?çu§ãSxK³JGÓ&Š´Xò)=<{°ç”AÓ<à°˜Yê¤éq21H‚ú·LÁvö.jLF-r9xd\n†Ê’íãÆ»ƒ2ßw	:ˆÒÒ‚1]Èi¦ëäøPg	8Ap1º¤I®(.ÄÃ“£#YvÉr©Ä\"žÙÃƒc{é•×ìÑI[é³ŸÒl”&rVÍå¬Y*ÚSW¯Ùw|ðýÖl6\\[*i|­1\r6ZjvDçGxž\\{ÏHµº‡š›[81U(~rúBôY:¤[ö9ššô\'‹pc\r%³i?OáhYa7Ÿ€t2JáyH*Cu€{5EVgàÀ?­SF=ÆºþV˜ºadqâ‰¥ƒÍ­ \\ÉÒµÂÝûPÔ‰¤m†\Z&™Uc£%9ŸÍVË¶¶wuÏ+õºÏ&Ö?Ù1å»):ÞØt±É“º†‹2øáìã+Î:w¥\0—Ó&ë!äyf”Ñ¡ôâ_³ñt(¼³Ú¬«£L¶>[¬¬Þ¨Ë¾ž!kcmŽ‘„\'y=W£%³¯x•Þß»².ùÍþQ	–qI>Çƒ;·ìë_ý²ÜÀ©¤\ZÂÁ®¦²1qäŸ‡øá¸°˜)\\7™‚ö¦2«”mÆ%`ßÿE¥›Æô¤¢âÔ5üÃ£¬OüÌÀÙxþŠ‰J³^ßi¦6‚\Z¯å×›µÌÿøÛgzX¼Aàç¥^¢ðuÂ]”‘æz‡é¼ôi$ gØV€iñzqâ=£¶ö”25™SgBäÐ«µ®nšë‹Á¿`¯ƒÉhd#_‘;óÆfs°[AI`Ý½:—URZêß’B©\\°^§›ð=\'tnn´¬×íH‚ƒ²ñ>Rpì\\î6ty2ÊJÞzóMëÂµÊm¶ÌÚÛïÜµ7Þ¹mKJ\r~’2ËVA·ªT°J6cÏ\\»aï}ï»µà}¸ÔÕtRFbíìtBŸÅp>½æžâ÷\'N]J­åÎ9Úœ‰d¸\n1DÊñF‡{t2``à¤,›rQÖ`Hõ.¥]‡ŒïkcEƒ\0Å¿³€|HGŸ¹MSZ¡n Ê¶`£\'\"YV©¤n÷\0šAùÊ.þäPBí“àM¹&31Åë[cÞJT2fW:Ý½–ñà,ú©4ò²‰ åÖbŒb½øõçu=fÝ&‹™»Fk®Î¹b\\×A–\rž¤MÏ¯½£oÇ£#åVòžž“eÊfôß·¯~áó6¶ÀËg/Éšy~	ìL”ïIÿ+ÆÝÖûRx™ƒóIJf1Ë—¨0Ñ .–øS®QKÒì]Nÿ¯ ìÅZš7°ýÃîKJÀç«•àÙ«J£2ðä#&8ÔþW¿óÏDõ¶8ä>6ä®õEK»ÈÉ•ÒJ@¤~>iÜDTnày3Ö ¦Ìw]vçdDfå^êTãî(eODC\\ÎtÏ*®6\0)4Ÿ·Í­}»xùºÏ«%¾ÑD¨ç§µ/d2À`²	°.2žf³)Ü7n.œ›Õ|iµjY›\nƒs®æêõÇSmœã=£±Ý¾}Û^}íu»÷àÐÆ‹•\r\'swÆ‘àœY}°,ÓôEˆM†{	X×oØÍ\'nZ³U×\"gCdÜ„ÔAw_©šü…Ád2rNvò¦«.üéåâÙ|,pñ²’ð?\"x¼h±[ÜO¿8˜ØØ¸‚*kÆUGæ³®$J@\Z\'7!”SCC‚u¦¥RUZés±¬™¥äž«OÌl•øÒvwÝpÈ¼$	àÛ[[2V`Ã +]o6%i¬I„ä^Œ°ž­Ä5“Ÿ\0]j²L\ràNm<äÄG1©BÈÖÎ­¥ ŽÄ½tG|!?æÅÅR–¾\\ÚÛ·5GxóæMÛÚÝÖ<&œ04hØÞ‹Ð\nua¾°:æ¦\Z€vq:ßkÑÕKV{ióûqáB~>šày<Ô?^xî9ëŸ2Ú|2’ûŽMÜ7´W•=\'ïF,§q_RùÉë†,z\"sF)§Ž]r­	À>‚X@8‘X”D×[¿§at7¢•¬µÆôÒDÉx²Š:‡ó(ÏÊÕà©{›\\—b¿fþå÷OtO÷|Qb[ jéHže>*»4\ZãÉñ åÑÙ±\0W]§†)å\rÞE¤–±8\"ÒGj×¿ÿî\nEÞ%S[ \"ÎUÙê­\rYoí\\²|²ØÖÄùˆMãl¾‚!Ñ2Íøuu#Ã¸“qÞ`˜ÈÙïõµ¹˜“£\0Çâ¤æ\Z$ª—Ëë„%SÀðùáã#{ùµ7íö½i`Í„\'y7ÀVÂ¼³D†•³\ZØC6kOß¸a×®^V;\ZHK¸/Õÿ€â|vÙ½Û\"œOØPZò’–ñSÏËñò` SÀèJ®Î)F}hÄ3û&àÌ¹Ÿ‚2Zô×sfÊò”Î4&(KúDDå{|f¨ñž”Õë€J²\"*É4ÞäÍ(kšÈÖæ¶_+52ÐŠ\\aÈN¤¢)w?¸¼™@€oe$¹Ÿ¹²c× Ÿ	T’6®K\0;UÄ3*Ïâ•• É%®éÜ^}í›vpp`/^°2NI( ¼@w¸Þ°J½!)tÖÈt€øò¡þd¤’ž%}dQR1\"çüÃTÕ(uîƒ‡mØíX÷ôÈÚ‡,Ÿ¥l&\0³We®½£€æô×c\rê~ÈÔ»Õ†ZGNÃÔ!à	„cÙ±/ƒûv>p‰Ò Z?TtåË:ÄiZp°	÷¤*²Ý€åqÙ²ðëôÌ˜å÷*uKy¦¼fæ·~ýIÓ=¼.LuRîÔ ±G?EÏó\'€F,<Ø¹NO¯ÔALöZµ×àzJû#ÍŒq]öœz¼v¬¸aÅ$S#6¶^k%}©R­a7n>%-¢ÅÒYÛ¤£Ž±8AÍYâÞ–Å¶éƒžp(Úð0¢©W ›M›˜M²¹±©Ùª^§£±žA¿«ØPÄöœnàd¬.V¹T°^·oãéÂúã¹ýå¾bw&åˆ…³§2úN…¬UK™Y”V{ú‰›vãú5µã¥±.ö¯ä*Õ“ºŽ\ZIÕ‚à‡‡\0+¦5™ÇZÀ/Zêè—\'ý{£LÆÊ…Šc>a2é9ò9¨wŠeîhÉYI8žÅ¿+“’’‡{‚Ïè^\"€ˆÊEâ±(ƒ³%5©oäÜD_ õÍA®ÄËä}Ü„²{kc[Y‡ä]juËIrÝ©Œl·$£»æ¥ìR:ã®¼þ6qØ\'&Â„5º.×TE ´yæ(L)5W°Û‹E·n ü,Ï¡S­ÉIÖ½²±jÍš-˜ï9Qd wÊa)a`´|Ï²–1¾\0ÿQ£%QiÈì4V‡G¹\"ŠÿŸ¤ñ``?°ãƒ»–7\0xx…	O2ÈþåÍaìäÀ×Ó>jI%§lœ™ÍDöÌ\ZÛ:W¾Ÿ8>}@ †JBÀÒšœÍ¥‘6›0ïª¨”ßü]£DŠ/á˜´²	ª¾Ð—ÍBôº³¿õOq6p\nüraRŽœÕÖA×çä\nU\0¯9¥6Œ<¹¡ˆJþXÎQ Òˆ\r‡x0âÂ¤	î¨“øRZÏë\n‡ŒäÔ³¬µ6w° é‰Õ>÷ŒNtq·Â›ÏK*ŸùCœohínGx_”„|6°	ÃËJ¥¤Mß¨}|äzåÓ‰>	ç\\är=Ò¢aNŽ€5]fìùo¼loÝy ð™V{L¦\\´r‘²° uÉR&gO_¿nW®]³mù¤;g{8$I¸Öh»„\n$¾³R\Zg<I%s›iÖKzXEw•yûwóçì®1É`VDŽÉ±¸âÐ¡Ä‚Ïý%3å´TY=uvWÿðq›\0Þ£ÄGƒœ2ÀŸ¹_o¤þ±F´Iòy•ƒÅ\nR¾ž™4îµ\'…\0­†`žË¼”9N”\n’›ušk”½<b\Z$à&t°ùÏÍÀ ­<e×ëu–8Ø\'X´}éK_Ô\ZG³¬µ±a-HÈu,± RpX”]š&_°áð,k’Ð]Î]ô0K`ùÂ!ÄçØ­¯Òø\r•Ù£ƒS»sçžY.»°zµ`…,#a’Wóê…æS¶ÕÅC‘ÕÕm…‰&|,\ZQêÆ¦êÉ©2t-Ïi#hÅ³Œ$‚u¨Ò•éš¹Vk:@(-!i³V¢áqÆe““Gåú ÏaÍéSÆ¬ŽdÑ2¿ñÿžl¾¢“TtÏ(~2; æÔÝU¼ÄH>g­Ê43]B~æÛ3´xÏ5È—Ê‚ (r-ß>w¨÷«àvC,\0ÍÅ*g­­{ê™÷Š,,7ut{¡°ÇÒ{’9\r{\"y²¡Ytœ€t‚xƒà¤²“aOŸ‰€u2%(+èòÀÁ¼È@Žíþýûvpph£éÒÞ¾sßNzc›.“Iefn%¦îk–òVÂå$¦Ï«lO^»a»ömk{Ëgø84—ûÚ.ï›Q# î­¤o’¢¥ºxQš#´(ã³4a¿r;\r‹»ãŠ³ÙLÁ”%ñ›x@é`á}\"Sæ™è@š;HÆêAk¢<\'}zyÁu¨Óš¨1±1bÝPÒ‚y¦œ:™‰ œPÁá¥ÙÐ,§JôRUj™PWÐ%\'@ðü¬ø:©“ýyr°Öø’8xa*hï°Èäâ°Œ€›)dXtx&÷g>Í„ÛwîØ¿ø«V\0è¶waß._½êf† w\\…V;`q!oýÞ@Ÿ\0à‹ì¤Ìk(W]É/7öç\r\"î™p=lÉŽúöÕç_¶7Þ¼e•RÑš²5ë%kÖËVË“AŽl&(„Ã…8îA<Í–ëà^ìò6¾Fâ=#XðL#á{ Tå„n;J¸&Õêj6Tu(¼žÓYf4§þž¬~—õá@É&ú¨Nr¦|;dy2¿ñ«W´†À‹bÈU<—s\n¡¨‚ôæA\\EBÊ\nF>‹¯¥ô?u_<#ðÜ÷¬Kâ™ZX¸ëûÈÕ$-ÏÐÎ$(âwõ—nC®Rˆ’G£%Û»xÅ®\\{Òfsº~z:Á]w	VÌdaË¤”tµ°rt=s‘ i7[[&<Dæ©C?!()4²’ÉØÞÞ®6(ÙÑñ°‚V£nÝö©Úo¼e·îÞ·G‡][d‹¶ÄóOô¹•Ñv§‹TÉpÏf@Í\ZåŠÝ¼~]8LiÊ×ÌöìG|ªà·1gfŒzøA¢æI\ZHåó…î’l×@q1¦éÙàÑb^±r²©YÃ»BƒžÝšÖpæ¼CÆâ8&4î!ä:Æ&èdéZM1ËHi\"à›@›FJ¦CôÐÉÈiÊ?q•Ø Hž 0Ê3gó‡ª€ºqIAóS	Š¹ïT1èÁ¢ó™ö\"“2vLnîÚe’DX„ÊB2Âží¨1“šQ2\rGCû«—^²Ï~öÏ¬^)ÚÎÞ¶]½~Ív÷/¸^µfÖFÂÔJ–\' ­Ìz½«s\"™,à¸ß\"*Cñ@»=%Ú,j~ùÞŒÃ}wãlQ´É¢h_úê7í‹_~A–qâ§åÍ6›Ûn.­Šò“³‘óü4¸NŽMòµ<\'ÆÉ^rìùL›\'‚*…öŸ¬ÄÀ\Z]Vˆ¯0:Q™ˆ$3]ÚÖ†míìŠâA¹Î¿9IØSð9Ð¸Xn>\'OÇhð°Öd8uq Q\n’H(ÓûÍò÷Wâ—¤ÔÐ£Ñ8t½“+pZL>þâ¼}­Â8À»O¾Ý{…H\\;9Ù|»Èâ)]F×\r¤‘.ðÞoŠ‚–Nxïè­ÓBÅ¾¥M—3«5[våúVoîX¥Ú°\"ÂÿÒXrgÜa2\0E¡a…<›l2›ò…’ŽL%RJQ0‡f³%½|>c£AÇzž´ÌCRåòÅ‹â5u{=;|ôÈîß»cjÉ7Çdlwï=´{ì­Ûl™õ²+ªJ9oÕ\\Æv\Z5«AP”uNýíW!¼n‰ˆÈlœÊÂ|roÖ¾€i`W=Ý²—ÇwSÓsòq\'ÿÅ±1ð6…‚|‰Ã¹z§¥¢d†\\ƒ\\§H²$<RæÚª¼·—VnÊê‹ÒÇqfà64R×“‹ôùiÏß¹V´ÄX§dù²\'tð}VµÁÐ.8‡%â³gä`\nPl‚œ%‚{²LÜ”õÀ\Zð²——Ä\r!\'¹aÖ#óÓ/åËöçñ9kµ*véÒeÛ¿pÑö.\\Ò!³³»cåjÕÃ‰Ü–¥ó®,#\rò\'1@‚+k[aê\n,_úpð:›!\'AIÛ…²\rÇ+»uûØþðÓ¡¿k(…lr9¶ÍFÑö¶›Öª3)1·‚M­˜[Z)Ï8\rº´ÓÄŒ×P¯wÕés§_[SæNl.Ü‰žœªíñ•àA,Ùœ¸g®\\ÑXÔ>€²´<ÚhCu”Èª»i¾T‡Cš¯¥9‚Ò)Dpâ]W=“þëÿP%ap›£ð(ë» ,Ç½„ó@ò.¹,]Œ³ ¦ª×ÍÃš†KÓJÒ$ky×ññÖ©o2iiœÆ›îÐá‹‘×åµÕÈ¼%ó©wÛ¥ËOÈ)„ÌJéölb3H÷ã¡M½a0!+v5šNÄŽ–žü9\"Ý|ºHvôY;^–+EùRö–°R¡`o½öŠ<°F­â×ž/Ùƒ£¶}õk/Ûiäj•âÚ,­–ËÚ…VMÝA\0x×Î2qŽ®_»b››°¤ëÊ°¤°*ö¹7>¤\rF“ƒÓ8i\\Ås‹2ÚhÇùB)’ò6\Z(¢4ÈŒÃA]§7Ð¾wûwéà\'·Å;\r[{7”à\ZÞƒ“6H¹\0ï\'þƒ¾\0ÖÇºà¾;”àìg-tXÚ4”ÏfÑèúª[˜f;	Ü2…­y\0g“LWeÁt‘RÓÀËè¼e4dn‹‰›ß2Â\"…YñÎ:_\n\\©üÇA0xO†‘µŸÛg?ûY»}÷–=ûž§í™gÞm…RM¥b£Õ´Í\rmÔv·góÙJT®ÕG[8+V­5E¬…~PËpàND¬¯Àmu4ŸScõLÒ•MffýÑÂ>õég¯½qß¦³¬*{	\\Y.³´fÕv¶¶Õ(Z¥°TàÊÌGÂnÁe™?ðûà+¾¼[˜tÖ(‘WTÑR<aY««ÛèÎÜd˜{®ØÆÖ¶Õ!ÔVQ2¦ñE…â¢—^±Ì„1Ã¤ä&]@Z\0\0 \0IDAT*¶˜¦H“²k,Ô~û7~É…\rÖJ¢~Úûb÷Ž(†?ø`­\0õœ»æz`ùV³ÎÀÃBU€€ÝÇuÝ«×w} ÊÀ248™¡ûFæåBjð¹KlðLÆÓ¹mí^²w½û}\n&ÎQr%E\08‹Pk~Áç±Œ#T§ù(Ý››[Ê,ÛèTM&2Édœ@¾V+ÙhØµG‹.píÚ5k5[\n`ÓSëœ´u­ÓÑÀ:§‡V«V”¡MÙôùŠ}ã¥×ìå×ßR;ZšG³©ÕŠ9»¸Ñ°\Z\"t©la‘Ö«»~å²mlm$¬Ã3KJ4«Ø¸KÐ\\JÍ\nqm<ð(|¤)Ñ•ÃyX<[/½¼ñyM@xW%ðÙB²¬hlˆ›„Ú(¥C‡]¼°TºÇÀ²ÏŽ%%¹F\'\'¤´<˜xùÏé-¹›²»Ô/zN>á@“#Äï$CS­H°ÏÕ<\"SaÂ¡˜ÃÌU4ã¦An×…aI5Ó/)_¢Ü\r0”tÒSŸŠÌ\r:åBy:±;wïØŸüéŸX£Y³}ÇìÚõ›V«oHðp4»?a¥$ÏB”P‘`ÝP†lhî€³2Ôªœ¼ö ?Òæ¦DŒÃ&ÆØ‡ìÞ9\\ž26œ®ì…ß´?ÿËçí¨=Ôë+ãÌg¥è\0´XÌÚÖFÍ¶[eÛjT-Ÿ#šZvÁ0?AÄÅyRmIót¡$\Z.èÊð”Eù vU$~‡æŒ&MòEÛ¿pIg½Ù°Zµ&h\0î\Zi½N[‡˜7gJ$(ÿXG‚šäV”œ¢üä]ïÌïüæ¯Ä“ŠgZdPn]\\‘óSà%\n ¤ˆ‰ï]Æ\0eù9\'kº^6‹Ø[¤ž¹­OwuÊò“Sõ‘ÌëD®Lõ¯·¤±=UjNJK}[±í½‹ö¡~X$B9Ù,ÁÎ›“Ÿe…‰•ò¹53›ZZ\'¿TÒÉÈÑžš\Z½\"¬è›õ†5\Z;9:>œ%£Lÿr4¶[o¿¥ajº!»ÛÛ:Eï<8°ÞxnŽ:öÂKßtº„Œá²vi«eõB.‰öùp2ÙÙå‹Ô£nç:¸¯,µ»E9ð Ä50IÙñy~[€ÚFÐ«`GçW\">v\"E-Vž^\nžéé;ø	O&æÏ:®á€˜$8–C¾É	Z?IUT~y¡\"¿‡svòÒ…CÙ*¥qdƒ”€*	ÃA0•¥y²™[y7É3Â4HF]‚à®‰A.ôTÊœo$éy¦ƒ<‰-¨VzÁ9ìzýž½ðõ¯Ù×^øš=õÌ“ö®gŸ±FcCj Œp¦¾Ã…ªV›V(úAND«ŸYAM5j4\nvw^ëJ{\"À~1¥J„5 @Šr¨|\nV6çà±œÝº}hŸúÌŸÛK¯¾#,·ÑBŠ[Isšº~æ-K9«×\n¶¿Ó²ÍVÕJ®aÛ¦“ˆµœuà`(é\nsÒ4ƒ›K(›Òráÿ³F\\ZÆYŽk\"ƒ,=—·Z>$¥±O&p=ðhÐIr9uõÂé0Ð°ZÂbIä?ŒÀÆAù—ÿütÿv°ÛhH?$‹žÄy’aA8ý&Ê~¤’Ž]x):Š®ðàYXl¿a˜Ê¼ÉôBe´§ì\nT2q Ím¼tH\'Ù•ìégžµ÷}àCª½§Ó‘Æ==TÒVøU<Ñ¿¢ŽFh¯Q¯û5j¦Íc#£%>9ñr2+h\nt»8ºÖîœºlq©,—ÅÏ<ÚÉÉ‰p²œ8‹ÛMw0µ/}íE{txj‡íŽ²Ñ22Y«äWvi«i\røW‚Ðbi­†V£A°òM#KÎÉqP<2Z6ud¾qO×åZhK±áRñltz¶¦)9¸•;áò§äw9(¦~À8àÖ»¾gÏ×ÎŠçgÕ5B=Rk$Hk¥€…º@t‚)½H¸ôÞi¶QÃàå6J°ÙT\'È®¾P²rÍ9Xž%¹±¾Òä%šWl\nž•þcC&ŠF4ÈÊ\"¸«Â IÓPÍˆ•øel¸ãö‰}á‹Ÿ·Ã£C{ö½ÏÚöÞ¶å²Ð+Z\"ú:ñ¶ 2Ð;„UM2p¸dO\\7Ü4YK¼Æ´®FêÏ›ï¡Â{Æ¨W,že\'f1+vpÒ·ßÿÔŸÚç>ÿ5³,ã@Î¿ËhÈ+^Â¡BºDòÊNÓöZuÛ(r@0Àß·Åb$W½µ4ODA&Îµ¤„µêóÃŽý(Œ\nQ‚‚›êòœhèÔêk7Y•ò+êÝŽMÇC}6ÖŠ €@hBBÏò[IêZ¯À,dXÑ‘‹“)6€Œ}ÿé‹Ò,Nw¸¤íþÂ¤FöË3:ˆ	Ø…rÞúG=z²-J:èJM½||ƒ(7gl™÷Lƒ…pãæöÄÍ§TÂ±™Fr­%5ö±„vûÔO€‰‹Ë^ÇMâZBÉ^ÔÊO§3×Gš\n]Á%aD—Ê¬Fã¡uÛÛÝÙ’&Ö£‡ìèøÈæ“‰°58LíNÛÆ“©UÛöç_|ÎËš‰n‹ºd¹¬º“û­Ší4}”G©år¥€uiÏš-ºbà8ÅµÄ	e[4H¼Õî(ÚÆñâÏÀ5ý)¦±g8VV&õ€3	šï%€Ù‰ªA\nö²ñÌàó‹ÀU¸Çñž¢SH(Î+‹Àù\"ÃÒ!FéšIJ/$‘S‰®ƒLŽÂpì\"ëÀ‡=ð6÷\"t›/]q©wš‰V8x)‡	n@\ZrWkÝU;dœª	ÿü‘‰¬ï!Ê`¯9‚+˜©cïÜ½c/¾ø\rkm4í]ïy—U±«_ º‘Qð$’­S\náKÈÈ;&%Â-ÙÅ\"ŸéC‡ñòØ³ÂX£ü]\\ºtÜ²0Tlÿ‡Ó¡åK›‰ç÷ŠýoÿçÙÃÃžÕë[ê,+“[pqr0}2ØbN°ÌØîÖ¦µ*kÔKÖj”m6éØ }`™ÅØª—ëftÇòdŒdU®yî›ºìbºú‚¯CÇBuý÷+,QÆWj:HFcÊÂ¾\\ÐÃô†¦UtF¹÷|ysÍ\r`b}ë¹°¦þÛ_ýÏ5š)tœÒcéÄ$8›ôùò/Úß‘¾ÆC?{-º.>^v$JF=$zûsNü¹NVy¯i„€V>é\'FŽø¯-¬Ýs\'›¿þ}ßmí=Ï¦ÅæmlÒöL–n*’.=Âf€ÈÉMvQ>ç³)XX™€¢‘Ú*%§e08X»}bý~G,º”}\'nb}?Rú\\\'{k4tz|óµ·­7YØ­»í¸Ãb\r\rqo¿V»´Ù°íFÕÊ|^)G˜íîlÚEu™Ü#.¤rC—I¼³t€DgÍÛäàƒgæ©*ûRi\'Bir\"«Ò|aŠ(lF6¥ØÍt¢ä†ã©Ä’8—eygÈçê<ó¢|8àé0éÑù9’\nCÝ”y;¾ìm—DQ)&Œ.yÜaÓ•L4H,C¼þL¥<›BÚTÉcPA8•¡ÒøO\rœÙXÉhä0Y°à\nÇ;uŸ$@X®;;–âzûÜO²è×ßxÕ^{ýukn6%ØÁwkkÏ\nÅŠ=F­×UÙ¼±µe[»V*\"´’sdJ8d”…¬v·«ç{éâeacz&ç‘ÙWÑÈ8ÿ|Éœ”éjð?cãùÂN{CûÃûçöÙ¿|Î\ny\Z5«”!Ø\"SÃëz¶*i†ai»ƒºS-m³U³ÍfÙÊ9H§C³éÀl6²r!cù2’3+¤ÌGâ\0ìº¼QLãÂ>ßŠŽ “\næ/¨­Vm¹ò½6›Ž„õORŸRÇðh¹Ò©Ç¤€›Ìx&¿öËwE:Ì	,<&™;(õK§ ¤bSš\Z™“·ƒáß„DkL™ûÉ%Kl\ZFBŠFeMâÉˆFÁâYL%ÎÆG[b\"p­¬Q¡&K;>%8)SøÎïü€ýïû°Õ*,¨‰‹«	ãƒÎ•v.æ\'ýÔBª—QC6i|&º\\#ÎÎjwÚBh@ xJK2,ÀgÖÉá2,Xð<$1ÍÓˆ	™è‡öÆ;÷ìþaÛú#7­p×[_hŒ§^ÚhØN£jXñ2ó4Ûl5moI’’¶ë0)*jGéÂæVv¡Ù?ß„Áƒ‹ìŠÍÎ©/RiÊ’õû,vO˜uj«a‚æ¨,Ÿ(õ!‰¾¹Ñ.²6Î„Ž“Ï;€´7óát/Suæ£PI¨Í!‚ð±D[“:xG>ÃÞÖº—ÈÌ¸É8Ø‡“HôéÕtðÅÎó\0d_L‘îMÕ¤ÖJYÐ…Pä«Ez˜TNeã6\ZÙãƒGöòË/ÙƒG÷•I_¹vÕ®^¿n.\\¶íšŸ<é´”îX½Þ²Jµ)ÃSd³yÀ\r4²juëFâýñYq©áp\"€±/À.c‚kã+ÔÞxb-Üs†ä£“ûÓÏ}Ñžá›-r6_B²­©Óì¡W*d˜pþ˜ €º4I†\"tá œVŠ«ÍZÕ¼•r^BÒ3§H¦šåðƒ”(\r*ÁÕ]¤Êrì’×ÄÂ\Z&H7Ýé|(—tš0>ÆÙ”p»´Î=yr\r7ßžˆDÓ!ó_ýÂÏü¿†Ÿ`wìÄq¦b^/J\Z:mmð\0uùÓÕÎì»¼èºˆ˜è ëY‚)Îñ\0ägÔfºÌÙÌòÖ¯¬ÝÚÃÃ¶ÀëadõRÖ~îgþ¶½ëÝWeã]-¹†´¦¤Ñ4çF‹5Œø~½ÞL|–¢Nð…yS€MH&/Lbtš\'ì[	©\"#(C´ÕrI™äPÊL™Ê¬BÖz¾ºJƒÑXÖ+oÝ¶þ”ñ\n²ÚúÜ/ËË-¦¶ß¬Ú…­–2,6 ÉF½f{;Ûbv³ˆÀrtÿÉ¬\0Ú	X‘a¥€§Ðy\\1øEÊr”\"{i.ãXÊÇïÞ\Zp5WŒ%€y¸˜™ãÙ<È@\'ÒËòM¤÷•©«ó³¢³V_ÈˆŒÊ¼ÍÂ»w~nYæLþø‚¼KÙ#{xé‹\'»(2t:ªÉ\"°,\'¿rpøœMdH™C:L°B•TÖÛñG³)|û\"(h“ š×ë0G8ïÖ­·,£áoèF™Ä¤—g•-½ú\04Ý2˜ùøüFˆÎ5gÈ@;RH”{Î/\"#)Û`4RæäíÀ|ÃÇS´\rÖ”S]’oß¾kÏ}ý%{á¯ÚtQ°U\\Ò1%îx(âI£@Ö?$kJ54»øpëR!c;›Uk5\nV*˜•WËIÀÀl>²ª¬+_Ï¬+q%9øÎ	m’±òzdWÍ\rË—j6AuÅð¹Ï–ò™‚HÏ€\0÷=†äƒ~Â:ÊüÂÏþäÊëQÇÎ/tûü„wš«†Ë²‚†›—¯õã*Üw¨õ,\0ëk)g&» q³7¨À©À¦Á¬’h¼²ƒvßn?8¶“ÎÄ&ÓiÐ==µjÆ~ö?ù)ûÈw¿ÏJ:oÈçl‚9ªŒè¸‘ÕxgFÒ»¢|)ŠJ™Õ¹˜²Ü”5\Z´È´Dò,Kj†	ÿÓÓ›a´€œLÉç£xð<dÌØd‡‡GšÕ\"»úÚ‹¯X‚»rÕFªð†‘g#Ûª”íÆå}©C2ÿÅkm6›V«U„w1ÜšBÜÏ	˜tO$Ã@\"50¢´ð;‚ŠAP‚\rªŠs—\0B½ûD\'k® APãbXzþð¶ÈÆ—äJ	¬Öv_ÊàhÆ$¢© tBúZI\rc.‰[$ö»Þ@î!Kï”*ê’–Ô(Ðô?4Éõâ‚sIY\"Õ®H¯T4xLCa.¼QÃØœØÉQôf×ÒHŽ2¿ÄÁ\"ë‹Ñ®ƒgÆóbMPæ¿}ëM{ùå—íê«¶¹¹¡ÌškD…”™ATNÑ0ïá…Ýä|€›@ž@Fç—ìJ€z¹¬Ž2²5Š£ù	\0ë–ªG0ã;e^¯fN‰C=éÈÞ¹{×ŠÕ†=ÿõWìó_úšw¸ldašÉ¬Ö×NçùlÉ1<|iöðuôgË®¬\\#ÎZ½^²íJÁ¶êe+æW6vm6l›-†V*ÂÝI´\nIviiÏ¥©!ûÖ|¾áHø_swN\"«Rc)ÙÏ…ìº2q¤‹$¦IcÌùŽ\n\\ÿéßþ„ô°bÆŸ0ÒÝJÈ‰›a7uÐ“y‚½Ëí²ˆBö•9\"^C¥Å—ˆæ/æVÐÏƒM™M–üÉ¢,Ú<[±ãÎÐ†£™Ýtj§ý‰ž,«À™³^÷È–“žm–³ö“?ñãö±ø>+diÃZI™R%dNñ€aQ­ÝÄ-‚—RÂÓÍf†ã¾ºìÙÕR,\\>“JIð2V]IÿJN0CºŽ]ýÎ,ÝíÍ\r¶ÈN;=ÏVöÊ[ïØ«oÝË…yp)Q2ð„ÕÊjÅ‚Ý¸¸k­rÞ2Ó‘† a×Wju«–*†G¢øIƒó“24œä§ç™IÐ?âïçqI?Ó“ìá£U‡•?D0	\ròèw„5@ LvYNì=ãÝæžo°¬¹z2ëpàÚÙãNŽU6›µ¯;ÇÀ.5{\'±;—(¬qu§ü4Öá™ŽœÞdŠÊô’»‹0>ag,ðYR¹¤ùï% ÊÅD~^ÎÉHÃ·w79\\ÔUÍ­ßhØùõ7^·7o½©€uéòE»výºÕkuq¿NÚm•úÌ>6ëu•ÖÜ3þ-“e”áü-}vþ\rÐ\\ª(	¬ŽqñÞH\'“¬\rn4‚°t¦ÀîÔ½„kXK÷R”†wî<°ÿýÿø7öö{–+–…­‰ºSnHÞˆøÍ}ó\nE2ÐD(øÈkŠgÇ{U*Ek5kV*d­^)©»\'ãZl1íYŽ¿ç3ffH\r“T–S)USS,o™ª¨NJ–œs¢]€iœ‰5*\Z9T;Toè¨u&óó?õ#ë’0Àðà¢ÓXh2»§Ú8yùpÜxõ“c‰Dàˆ&;yÈ< NÞ´Á¨©Ñ²›YÁÆ³œ·Gv:ZØái×ŽŽOl<^Ød™µnoh•ZÅª¥¬²s³ÉÀj%³ïýÈGìoýÍÕ$:™åÁŠNº9›{GH¹í†¢w—ü$[Úd:POÉP)åt˜ôŽEV6fÊRRJy:Òâý=V.ËÌbeýÁPö…—^µGÇ9%)­%æ\'Ü¨“¼õÊþ¶í7k–Ÿ%1í‚ÓH0äS4¾±ÐÌ¸YR€ìêš¤ú{©ëÚµnöÑW™dÁ•ùªTö–4CÄš:ˆ×ÔýôA\\úë“Ð3/}/é-E%Á?Ô6¢\0½!JÇ¨”pgx©Ç Ï%0]CÛŸž‰	R2ò|pÒ„çéŒî!ŒN–ÿŒyð=$õÎ´ÛÝý9H>€«“|åå\"#\'§Çm;<<´×ÞxÝÚ½¶]¹vY™Ôþ…}Í8Â¿ª5\ZvÜîèµyvŒx1´\r†ÃZ§ô&\nj¸‰ŠBN“dU`œ/,¼ÜÁŸ1ä`ÿ$4±|ˆÙUAxŸÇ§ö¯ÿ—ÿÕnßyÆbŠV(×ä|>ž’U•$ Iæ.èdÊ>€£Æáì^Ü[…‚%5]LÓÛ¬•­U+j–²+dÑ“§;±¢ªh*ÐÕY—Ìvö>t?4¸Ÿ<45‹œ˜Ê²W+á[tw¹ÿd¶±fô»?÷~\\´€¾À øÿ`1ll¸p¾GF¥Y?á®CÅ‡ö!Z!–©¥é¦	>DÊ©\rq\rÀ;/­uäVàR\rgKmîÓÎÄõ¬=šÚX‹Ä¾À\0´±<wí=Oß°<û”ÆY®^¹dÏ¾ë™¤]\rÀë7^%E*Aéà!fá²Y‡|˜dGkVÉƒú°‡ýüP* \0‹Z¨i\nÝóÒªš«ËX»sb“ñ@í]:üÞý»†çÖ`N:öõ—^³ñbi£oiJxÐ³›Œcµ²ýÍ–]ÝiY%»´ŠÔ	ÊV­7”.×˜ÃJX 7‘€ºçñpãóØ¥Ä:H¤’‡gSçi¢¢¬q#‘ÃúÉ‡Ü)ÙœXˆÞÂ^f¼õN£ ÆYÎ2+Ï¸ð¡¾°¾¦ä\Z×¦ï§¦‡#¬ÎC‚Á(R(œ+5\0([]\'Jåmj.‚“¦Öÿ\Zsåéµ³NÅ´Q31<•Ô©3x´r*kÐP´f888²GÙí»wl¶œÙ…K”a1‚#‘€|ÞZ[Û6æp›ÎäbCÄœëÖÎ¶,ø~.¹“Uã½!¡ú¸•×ÂšáDVe<Ðúàd9ýØ(d}4êj_à¾´bTgewï?¶OýÑ§íö[ïØÞÞEe_àT;»ìàèDÍŒ™JvºîC§H bÁáˆã%-÷•Ñ6š,åRC‡;Xk¹˜·Fî ƒþ%ôe( Î‹ž<Ø¡òÉ Þ\0EÅ¥a¨”Ê¹j\Z6OXª¸–gD_„ÕY8Ñ4èºyGIÄ4L	L%µe±JZŽ,ÎjõtþL‰An+báB]pMfnr&&äÝ/¿–6[æl²,Xw¼´öpjÇÝ=>êZ8³ÑÄu£\04	P”`\r\"UfVXMí¾÷ÃöãŸø!ukåŠ0¦b	|ÊÛèkÞÓè3WàÚäi–6lÜ„-Ì)\\ö—:ÞõœúR&å3~;·?p¡½\nxÉT¢}JQSgn2žJJ†Ò©ÝØq·g/¿ú–öZ¬T´%a^Ë1\'cä›ÕŠ=AYXÊZ9GIQ–:AYÕ5ª×œ•žˆ¶”e*}Âœ2EÈZ¤åÿG	%¡~&eÃAGˆŸ§28+×Ü2=ˆ¼¤ëu“S/ÞCc‰=®€…rGÂ2\"øËŽ*äˆÿ‰%æSG”uÅ(+KÙò1	ØÎß±ŸÌ{öÌ³‡\0ë\nÇ;XrÊžqèœf:¸$ÔFD×:	æ°Ð_¡<²ÃÃc»sï®½ñæR?½|õ²]lßhª$W¬äÂ}ü|!W°F«¥’§µ¹¡ç\rnE7¼ìÏŽÁól\Z„’™uèâzS™	‚zlàY2ÿMj\ZdHšGÌµ¾ðÅ¯Ø—¾òœ<>ÔÐöå+×„©6ZÎÍ‚ßXk4í´Ý¶n\"¶5q‚Ó•žpïT\\¸½?oKH¨ÐGœK]¨V)ZI´™5p*j”­’Z½œ³´	JÅRÒÐ†xý¬îS¥P³ÌB=bW¢e\\*©¼pO¾á°‘ c’é˜CÌ?üÙŸÔð³s4üäd1P[†Ò!x5t|çÞ8wÅ5îpKn\rdœ2$D|Yÿ­r–É—m4ËXo4·ÓþÂwí¨3°þd*lÍ\\).;ÕïµÉZ×¬´ýóË©}ô;ÿ=ûÄ}¿íïn( ‘­`Î5AI2CÚJHÈR:“–ÏÅiËÂx9Ÿ«­ëœ¸d7e¦ô“À‡2\0ŸÿÏŒÓéÉ±MG8›”ˆƒt:m?í¡‚P6´»6M•¾¿øò+vûþ#ñcdŽé7dèùœê.Ö*—ìÉËû¶]Î[9ÇBp*\0³sÃ–V­#„æícÑ	Ò pdGçË,]S\Zê=gqˆD@{úó\re×’ìu7e²>6B€ãwU¾$<ÇÅÎÌZ)]ÈH¢M¦\Zå/%|ˆvÈ9‘H‚K‘×#\0AŸ˜®T%Ä\'fDòU”ˆ¡†k]²Ä³‹48-»²lr÷ñ¡w	s£T)hŒ’Ê¥ ïÏgˆL+‚˜Ó[ú‚Ê=::±·ß¹eí^×šÍº]¼|QÄÑF³aUÈ™œ%Å’íï_pìl¶P+Ÿ|3y\0à<ÐÁxŒB‚‘Ñø`0üÁ‰~@ÙiëÏ­Í-—¹eXÓJeØï¸•]Õá?&5P»-íñá©ý›ÿûìëßø+Ëkü)c»{ûÊªH¶w÷•1]¹rUDi2GJHøQ4:h\nŒ½„FÀ˜^¡¨\"ã9åbM6Æ†PÁ<…²½1¨\rÆ~šÖ(f¬˜™Z5ÿm(²*‡()\"žB+ò±=Ÿ<³>ÃCtÝmNk,(U:Lñç*Q`Î¸VÑ5’óm)x >~CÉd^:™È£ŽÜ›j:]Ù`LË¬ˆÒoe½™Ê¾No¢Ì\n._6Ÿ•z\'].U4œ¬±f‘]¹Aƒ½”uå¬ýøÇ?fïÏ3výò®NL7SI%e©7åH\Z´Ù“:Æ…‚’2Ðfî¯hq (	Xîãš?ò1K(*§\'Ñ@p¤ñ63™ÛÉi_xÁ7_{ÃnÝ¿§k!S…8•Èˆ+›a>Qð`TËgíÒÎ†]Þj¸ÍÃ½f*]B×•?}{›Zø\Z¸á¹l…ïi|&›ØŒžRŸW’%0$ÑÅDTŒÌšÊGw’ÁfšJÐgHå~d‹ÂÕËœŒD†©iª»&¾+Ž®94aRpÎŠL(UR££aÊž˜dìHÖV\n¢g&@ŽÅqp‡â„/zt¹”9‚QÎ¦\"~Â~WÀMvUçhÝ_J]2æÀ¤÷ž,ÊÈD:Ý¾½ôê+òœÜÝß±+W.ÛÞÞŽ5[M©Eô‡c‰Õ]½vÝÇ“¤‰ÿˆƒ—î^Y×Êy?M÷r0£:^žÁý[Ú`Øµ÷n³¦­VtWÒÀ±ÓƒPmÕ¡!9–Œ8Š_üòóúïÁƒG\"ÊÐh6Z:Œþ0ðe)¶Z‰aåB®–±ÓîÀØh‚lÓ¦ª&L&}î©ûò,h\ni_Î˜0ðÑ%®¥X)Zµ˜·Vµ`»Í²m7Š–_\rmØ?±Ó\"Y8ƒ`¢L\Z¸’ì7šPr}—J«ëð÷A5§ƒùWþþOk–P(ä:Ò‚‰!ƒT\0\0 \0IDATïùFðì€4Neâh_uˆ%M¯Ö-âb9Œ(}\nvÜî‰Cu4XX·)?@÷sx;9a^>œê¯ëN>”åbÑ6›%û?÷3vóê¾Õ*”\"¸peiï&^Œëykx•Q$qÓD8¤Ï(_ÿqë¤)²¾ó™õ˜´Wunµ\n”Œ¢ì¼XÈà(<ÄIÈ† ÕÊÉD©åÁêÔúƒ©=>:µ;Xw0ÔØ‚´R†ÅçÔ\\\ZÝ]5e-»œÙÅ­–=qqÏZ¥¼5˜ë3ôÉ!N:†Çõºbƒ¡zç6)jœ0AK‰¬ò|pq›û3‘¿ÈtÎgi¾a“*)KFLJ—š	\'‡H`PÚhÃÑ:;¬K¢nIqt}’´9³i×5‰˜’?¢†š%¥“OÊ˜&¸ýTÌÝq(*XSB&JÞCçi¢ÍH\r ¡°s—ÔPÊÚWÃµ(ÖE4’ØHË)&\Z#±×¿¢ã·ƒNY£®-÷rµ.gêí-ÛÞÙöBw‹rÙB2EÿôY3kÔ[âŽGø0ž5§¸îå°ßµÁ°£æéfsC\0¾ÞùTšÃ‘5D€]\ntÿÊsß°çžÿ†Ý¾{O‡-Ò8”X­Ö†¯Ö\\\r‚RNw©”SÙ‰†Æ½ÁX¦¿àf|†\\Æyy	ÈÁœŽ%M*7™a-‚Ý.ò«UÊVÀ0¤\\°ÝVÕ¶ëe+ä¦–Ï èäüèLN%áÌ\Z©b.áu›\ZRq€\ZÕŸÖü?ýå¿·6R]—ƒIað[t]é6\\IJÐñãt.Øp–±þÄ¬ÝŸÙÑIß;ÖŽm<Aô>q÷ÙPf#	h^I€¯‰¡î\nš´|YÈ€ök”sö#û^ûÐûÞm»{ÛÕ…tŸ	¹36#6F¼,tm­˜)xTð™xŸéL|në™\"A”‚ƒÔ¼×më}4\'XJAo¾Í­[·<À5\Zê\"Mç9{í·í´×ÕÃ¥t\0\Z5Q°8oó/³tO|ãÛbf{Íº=uuß6+e«¡<`¦²‡Ò0Rpá<	ŠÒˆ×Ö°m˜I¤aç5f–2¨À¯Öåb\n\Z‘¡Efq–i9‘T+t„²00îÏ>	õ†,\'«ÎÜE:m%²h-ž\rój”~Ärq’D	ãR ‰¢­(\'’*…>kâ$…nº+:–ÞíóN¶swÈ®¤„Éa+u§ÓÄgå¹è\0J»¼–£9Äz];>=µwîÞ³Þ o—®^±K—.ÐFUsÀç¡,lno	 dãßj–•ªe£Ä*Þ$äŠ|¹¯dº!Äf¤‹zøø¡ŠÜÿ•uN»V«acñ¾”;AC1‚þ;îãjËUÞ&³¥½ñæm»÷ð¡}å‹_I	Ÿ5+»8&=8Ýe_·\\ÚÑÑ‘!™zpüðÙ=]C*öF¯1¼<ËXQ\0:ÖbÎ»£¬ôhNáZ/Y)0Ÿ±F¥hÛ­Šmo0%‚ÜÍÐ2Ë¡-´Ç\nn<ý B°Ve\\‘0çõ³MUæ·~í×K%Ò\ZÏøòYi¾R¿à3¹òè¡|Ã%8gáÂ\rìx0·Î`!Ìj’†.Gƒ¶-g´˜iÜY™é¢ê\n”Ÿ–!-§¥LÀ€¦î‡5·ÅøÔž¾¾o?õü¨Ý|ò)u+¨£QL ÌÒ)@×*IÒˆeÆ18zyÀ\\?j‘-9BÃ6nŸHâxgwWà6|+´¯Žl6ˆßÅœŸº¦y/ãºý~‡ä;·ï&Ò¬õ‡s{çÞ}‘+Ù€b“Y­³+e¤J´qxh¨Ž>uå‚]ÞnIçÒ‘4$UçsDƒ$ÆJÀ\"€a/:€ˆb`=E˜•*˜žc¨«<Röy¦aMƒQiXô7î·‚f\ZËÑß“öÝ!š|E@ˆó8ôàhæ$©*€°ä™Ë+rÂC|,9m!¦\'XŽ{¹ñ*×¤{€´PÂE(ëÚ&ë¹Œ2jÖ˜—?*«Qpˆ,,Æ_èìÙPÉÙ½‡$ô¸½·+I™Ë—.Z«ÕÔ&ÅÑ™±ZoÚþÅê©)ðNö¥&	´’DUiÑË/eX‘Ù`ÉP(FÏ=­|Ñº½F§âÉH¶T²n¿Ÿ$ÁÉˆÂ¤^}ýuûÌ~F7{ˆ²éFXÖ.]ºd§íSkŸölŽ˜Àri[Û›V¯Õ¬Ý>VF»½½i.\\ÿÁÁ‘-3ya[$^_f\Zû‚Š!Ée’ƒ±Ì_²ùº•KM½¸Bmµ*Öj­Q\\ZÞÖrªŽb1´Þé2Õ0ê~Ì§ñ©ZŠM¿óÿõJé¸N5nuêÌ¦àœXê†¹%§,ƒ”3d‘6ªÙpU¶“ÞÐzÃ©žìñI_C¿¤Ž`ÎK^—(š|á4¶¡.›ÚõÖ	,’EÎr±Y[Î©k³Vy²l™åX´†û‘ï·ì­Zõád®Itæû’zaOh	©ð$4@pË˜ÚÒíÓS1‘©åE4NìôøHÂ|l\02+Õë¢aÓAëÚ=“´¥–vpt¬{ºÌÛëoÞ# È”5zÊ2<¿âó\'hp \r•š]ÜÞ²\'.íÙVµd¹%†­5iÔíÃaOc³å¥¤7rÎÆPÜ7/Ùi‹|ëü\'Wpé¤„‘œabh‹×ãš#ÈùkËoyÍŠf|„uYûý¥=6²Œ$KÌ\ZJ´î]ŒÃœ\"ÒÊ®ÜM1èT1#eFRÔŠd3§’P\r?X£ÌŠ&$%ñëÈ–æPVÆZ×Âä„!m(I6TC¦S4ïùÝ…ÁAße|ï>¸ocØíÝm¬½Ý=,‰ÖAT^™566lcs[åÖÉi[Ù&YÍS¶§`	3ƒLî>À¤36Óótu‹‰Q\\kºp¦zý¾î­ôå¥TB#¦ ž ›¤âH·o¾ö–ýþïÊÞ|ýu×=SgÕ»ÿüÓ2[iX«¹i–)ÚDô:±%Öëõõ,5†[!Å¦²¯wnß¶v»k\rÐçl0FU½6ô´¼³œÏUävŽ\\s“2VW1g­JÑšå‚3æ¥›XÈ2ú3³Ì‚¤Ò.ØÈ{ÑtÑ!…U}ªe	D»‘JÖƒ –H,\r´fX,›XÁz£•õÇK{Ü™ÙáIßŽÚÍ–š5›È}wVCV#!`Ôq>Cväó]ÚÅ¶È.òSðùÃ’Š¤U/Û“7.Ù\'>þƒöì3Oi@†˜0¨ÅHG5™>ï^¢Ù.9dÙoU¬RkzÀ!sÁbJf	.‰™O²ãµOm8èéµåCî†„{îÀ‰?MôÚGGÇvrÒÖéÅP\'„ÑöhnoÝº}–QDë>)8•@ë%du¸­jÕÞsãºíÖ‹Æè7Ä	”°”ÝAWã´ñé¸qßRi³.Ñ(	c\\\'ò^ú8Ë[ÆDÎ;Ã	|hYô< •þo‘½¹ªS5\"Èy€ð.dd[³\0âƒK™&Œ)@¦,Nšf«]e{\nÖRM×/õ†Dd\Z†„Òl %HÃÅ§.\"Lwî9A˜ÊŠea~à“‘-Šã„VÖD„epÉ‡‡Õô K·±Õ’;ÙM4Ú½ŽÈ›(3lln	ÂÊ\rB‚—H¾d‘?d€»()oï¸;, <5\rŸsâ; lº½l¶Jº_`\\²ÃF«Ò‰t(uTIæ6]˜}õ¹¿²OýÑgô !è0a–:f>]¢†àÔjmZ£ÑR‡†ÖÎî¾u{};8>•8¦ä…˜%Î™5ke»~íšâÃéiÇÞ¹wOï7§a‘A‰ÁåÏålMé/Á—¸Q“ºY³Ú°\nÝÑzÑ67˜\nÈ[)étj¹ÙÈ2L@ý1§Q©Âb‚¥äôÌ¿úÿl!òjãižKãô˜ï[Aø„ª°€Gµ²£ÓÝ{|býIFäÈ!<ê,beó³†>:1¾ë<i9ÅÃ çôD×\"Z«Ù•}ðýï±OþèÙ•‹»V”iƒï&°&2ÍI;\'Edº–(\Zö{,«\rWiL˜×l<R)ŠÙ) ŸNÔäÑfÒÒŠÏâØ;´n¯kÝnOÙM€ø`l´»>~,éØù½ÙÊŽŽO×mÙQ¢XÜ–~†L+›±÷?ý”]ÝnY£€S‰wY êÚ‚™¤nŸë»_ 2¡$+¬!ÔhÄ‚O˜WL¼G9!jGÈÑ†Uy2ü8¨{ 9rÞíƒq@Â~‚ëÅÏkœe:F¥`”¯qï\"Õ×fM¤AmÐ”Q ¥ßŽxcY\nNžYŠZ‘È´AŽ×‰NéÚÀ$ÙJq]`Ud×j-™™QBÌFÝ8ÃuÆRáèõGv|zb÷?´­ím»vó†5šu	ó‘¡øõìÊÙL¶^­ímeôd`@|e‚ÊÂ–VÄQPÀŠƒÄïÑT¥¸U§ãÚhÉ¥\\ábfÇ‡nä»³£R¸P(«\\¦äŒçþÐ™ÿòW^°?üôËèndtj=°¬œ®$¬—ÏMeÛhmÚ•k×­VÃK !JþÞ@A‹lš%ööÖ–%UÆƒÇ•3F5ÏÝrM*Œ×-ãzÃçþ\r¥jÉš\r¦9p;ÏZ9¿°JÁ6kT3[MÇ–Ï‘aR¸§¢&\"lÿÝßþÕUKÈ*5QæßR} >Yæl8ÏZ{¸°îØìà¸o\'ídSVÙ¬uz½¤?ç\0\ZÄÏ\"€¿&º]çh¾ÊªÝ«Ž¼7L’„35w(‡_”§’éP2ýÐ~Ÿ}ò?d…ÂJÁªTòRj¬\\**@i³,g:ÙX\0•ˆý\"˜ÀXplºS«Ã©R°pÂž&ê•y¹_”ïÝ±££e,ÎÑp¢‘†ñxfc²ÊéT™)#3WI¯Àk¢+%Ðš†‚²A_›üOnµ´÷íÝ7.ÛV­$•LÊ¢(}$f¥`¼~:¡ÃÜ“r)xFçÜqÎyJža[~ÒGwOeyÂ£\"8h|9LkeûÒŽ1ˆ‹%—TŽ%Í«x¿Œ—q_x.ñ»J|ÓÔ~”¾®æŠ\rÉ‚=Ÿs>?\':M6¨JË0—\")uPð3dÞdå¹Œç£’)ƒÕ„{ÁY­þNO‡AëÂåKöÔ3OKãJŽÐbn»µ(2sÈ˜©n;`Ìà³LD“U|ò¹ôq5|ýžF–Æºƒ.‡‘ÒiPT\\›ñ¿~§kÛÛ[2)õ¡¬î–j¼OO–öûðiûÂ>ï†½yü™©õQ*œ…H”â+9\n3–)I&ç{û¶½½«Œ³åÜ˜R6c[››2nå°ÝÙÞ²NçT÷°ÝîX{€¥Y+•AIdZ•v9báÐåmJy\\ÏjŠsYÉD@%pQ.Vø{Sß¾­\0ósíùr™˜³Ìïþó_Y©«\"¸HRB`”5èTíÑÂºc;êŽ­;\\Øi‡½ÒÅ GLªí`¼·ûÑ}ý`#]BŒÙ4qJ‚\rÍïA”ÄÙ¤i²Z¶ÝíÉo´êvóæûžÈ.íïHˆÎ¢†#GHÁŒm£ÙÔƒíöÚJéò\0X8dXÐÃ±º?KVçôDŠ¥ð°p,ÒqN[4Á‰×gac[røX¸‹›SçäÔ‰¢–/Ú½ìñá‘ZËÂ,Bšø\\öÙo\\º$±“\"•z1oï{ú†]ÙÙÃßÉ»¾I×ÀzR@UZ²fT™ðŠµýxò˜‹ÀéIY\ZÊ»Â\'_^2xUìL@|\0ýáñ·ÎÓŒ¥oÝ5‹–Œ(¢»(ÊÄ ”*¸œ+}üÇ7¯0:8gÉ9FA\Z:k#¹ìè{çôÖ¢\ZÐX‰JAÿ,*S~f]K–š©Çè42gkæPè½‹¶Ã}<V¦üàÑCÍÂ]½qÝn>ù„m\'û.ÆG2b%¦¬vsgÏêÍ–›g ƒm=hAS×_à¯¦EâÒ©ºvû3‚jo8°A·\'ƒÞÐëêvÛú·ZÝÅ!iÈXÀÉ~ÇÓ©é†ƒ\'jïæìÏ>÷ïìÏ>÷gÎþOd[	_de~ˆò¾3›ÌDòfÙ£H.pY²í­m»xñ²5[Û:ø‡Ð5,/ÁJhõ*M„¼D\'á1Þ»ÿXt±âÑƒÍÏ:KRÑ`“}*˜|ÑZõMáxÌ]‚ã±þ|ßlV­QZ(xåeO6—Alf5µÌoÿú/¬hó‹†¹bƒ@Ã/Ûp–µ/\'];îìQ{`\"èÔ§]¡qeƒ¡GXn€Ë÷ÂxfÂßéfã¡²\'þÓò\ZØÍ,­\\@T½%þ=k­jÓ®^¾¬ag´¤ßzûuËg—võÊ¾}üã³gž~BY+úè¼.JŸlÌLYl<XÒ\\0V¥V“`ZfRvŽ­}r(°6¯Xíã±o8½OO¡4tÅHgJ½ÇÐ³„ÄVâ“ÝzçŽÚÈ€‹oß¹k¢&¥yÖmó-²‰³ÒÐ‡¡ù\nj\rÜ ßuý²=ûä5«\"^—ð&”Nù]æõóâžy ‰LAÔ‚´yô~‰/Å{xIæ2ºÀ|?0¥ÈþÈÎ\" U\"Ö·~¦¤š‚ÿã%êÔ¾\'Eþ.JC’/:Ÿy)`&I]e¬¾Ä\0,†‹1dH¸>p½xu§3±Ü#“¡ˆµŸð;	\'¦‚‡ºZj>øõñ:dÓ&ŽONl@ö^«Z³µa›;[vãæMÛÙÛ-†\rJ0‘µh.§Y½BWŸª‚Kž‰Ù¬häÔê~ñür\'ƒKÑiÌšjþ?ëŽÏ™™òfw{KŒx	îA\'’F\Z†ŒI¹½$“\'s;9îÛó_Éž{áy¹øˆ¯µ ‚qUZI‘Ê¡\nÇ=DÅf0«ò¼+ÈÕŒéÁâòÉwÙ*W¾wxr,…¦ÜÖfÓš\r\'ÀrÑƒ‚Ã!N–Šb	:t~°²\nr*•kŠ7àÖiŒW¸¦Z›Õ‚µêUÛm¡‚J\'}eÅìÌ2¿‰D²€3§&dsMuœŽì 3ûu4[©Ù•„\nN¿3(årØ˜Lz\Zt\rÊõœZr‡\r~ŒZ—‘Ä–_ƒíKjý²]Øeò}C<hþî‰ÝzçM“~òÇ>nßó‘ïR$—ÄËd˜øMKácÌßAì÷{2‰`Q“ÎŠ5«1Šæ±øYf9Q\'£žµÑb—o!µ½\0º‡dFƒc>³££CM½ÃûÆKß´ÁhªFÃý‡í´ÝKÙU:ÅÓJd&<»P»:)G*xS†Ï¬”eºißõ¾g­Q.Z1Ñ(O)‘eîÀ@p²<ÙÉ\'#Ô$Ó¨k	/ñ¢$|6\ZÁ2JÀÈp¸>6Žˆ¢ÊdÎ0¬ «RÒ*K’ÛIÛ“ó‰ÀýTóûûzVª’,Q¸®pü&3âçxmðª\\ág¤¸Ê|`:õ3I4‚dP(Ë–¾)Ãñ{¦r_Ÿ1q±B™UëÔKD®‘ŒÜÞ‡×áÉ¡mnmÚîþ~rZ^ÊŠI¾4¾õö›\Z5Á¥—Ê54Þ5ÎXM‡.yþA2†ÀIà\06 `Qz’Õ“eµêð¤(E;:„€:¤¼¹ÄÚGåtÿ$ÍÔ†{y’¯ÃÆSóg2³Ïá9ûü—žS)«€±µW‚K*ÐÄL\r“ù²ž-9·è!ã¡†ÈÙŸO½û½váâe;8<Ö½â?ayÂõžtGww÷õ<1\\íú¶³³«×Çà…ð1\Z£½Vc0žX±‚ÇdI8r…–¢•r+	v^Ü®[£œµÌ¯þò±Â•Ògg@‡/+¶ëÁIÏ;S¹{P’\Z&#ŸÂ_ ƒ5V¹} jexà*\0ÁÔÅƒŠ?³Rþ¬„`p“™9@<‚é._Ónh¥JŠJ§æÄžyêºýôüÙµ+õ³\0ã´À5(g—‰Õ0ž\\Ì=KšŒõzµjCe¡iLµÓÂÆi:»²éhdƒnÛN»9à„„ò(ZîD{&F}”G‹vzrª2˜Ù¬Û÷ØÃÇpt­7d€Ó»P\0¢Ü:°ÖÍdÕ%ý†T®‘—sKûÐ³ï¶‹Û®DÊH™$\'\'_ÌUù¢ólŽ.”ó’ä9‚ñÎÏú@úît>Ó‰’,øYç›Þá	,&a^©)\"üJ2=>î]:XënaÊ¾â>èÚR×TÙ\'Úëéº4;©Á2/t‡ƒ…©ƒðzTk¨=27ÜŽÆÎNWF—tXèìÊ¹ZÌx\'\ZsC.u5;(\r¦©vÅéª„šhkkS›°Úhˆ\r¾»·»¾¯wïÞÖ8„ÑÝ½‹œ¡ÕÐÅ#@ÉðQAáNÙÄNg4çÌAŠLFÝóÌJÞÜË–2þžÖ8UX—k¬·ššO<×¸Œh7ÜÃœ\rXŸÞþà?#»1Áh2ön7Ù²:mZ#^-ž i#CÏÞ•¡#UNå#O\\Ô	è€à9Ûß¿d;;¬µ±)âêi·\'6A·}$*	A\"*_$0öyŽT2JÍn^{Rds~—yÛG‡\'jä \'DéöôTYYB“€€š·V½`™_ú¥´\ZÍ\nÖŸ®ì¸=–aBw0ÑÐ#3Š¼!vï¤Î‘šØ|6VàrGN\0÷ècŽ‹¨Ì‰ÐítEî”\n&yŸÃ»°·o›Ô°yûæ+/©%Žai¶PØ7žô$,¶±Q³OþèÇíÃßùA\rþÐnFve8!˜ÐIcPºgˆÞ•KJéIÓ“ µítº\"ÌUk8˜¸œ/å |ÝÓ)†rsö÷/zûY.:E#)8ÐÿF~çÖ?8\0‹ùè¨m£ÙÌî=|lïÜ}(¾r´bÅ¦2/JÁÿ¯’P\"|IÓÜg´œrsq5³\'®\\´÷>uÃZµŠÄÚh+ÑEŠY¸(å|f¥8É\"ÓPJËù¼$¼+è$Ñt$x­À«hð÷r<èLêz]&\nY¾§Ñ§Èž2Þ…:Ï·òMâ÷\'fõ½•3¥¹F\0FÞâhdxˆù0G Ö˜RÒZ‹„×#Ss%SM1hžÑî³‰ÃÉâ+´Ú¹Nà\0ÈÀ¬w†œ¡0Üxâ	qà:QÞmnï®çð‚H}r| ],¼1¥H oÇ¬¡à)YWÌ~¢@ºž%,—ux-¨2XÔà˜ô/·\'£tãšé–ìç$Rè[L#p?\0à™œõzSûÓÏþ¥ýñŸþ±J-FrœƒW^‹ð:jJH¹Ã6º¨þå‡ÞˆAcaKM\Zdm6–˜‘ZÙþÞÛÝ¿$F?¿÷øñc©ò’\rbžÊïÓDˆæ1ø_t]÷/\\T&Ölµl±ÌJK¬Ýé*3mwzVª0>´è e6þ •rÆ2?óóÿåê¸;³ö`.Ùîp&¼GLqº(20p‡^2:[\ZàþâdEÀkj^hµrI];6?<J¶Í­d\0ÙP*X*c!cB,i÷â]0¢z\'\'$ÁúÑ~Ø~àû>*û«J’1ž0“RD»0À¾	\ZóV§x\"[©[‰k¢+¢N×6²n§-Î ;ÁžŽ³hwñï´·Á:Hž8Ù¸ó¾ñÆÛÂ7î?:TÐBoÙexg$\"PF@¼²\"é_\'ÏGeàhQòMT¢ÚðÝï]ÞÛ¶R¾àc=IÔÝ]p‹Å½†Ï“éC¨!¤TO™˜/Çè\nFöÅï©Ôà¸´œÏÌÜ¸ÓËÂ8\n}¡g,c‹3ÅZ6¾~V/õg:ÿ^Ê¾¹¶$¨·=’\ZÅÙÜ ,r\0àðˆÀã@´4þ\"¸Â•Ù§q+î‘\Z\"†z¶Âý##suË©ˆ™¨tû=1Ú·v7UÂAc k	}€†œù<È¬âì¥Ë—%ºˆ’­†…\'Œ9à­Ñ*¹0;‰“.Ó|xÙ]œ–6!`Ígu©O–ðè˜²6y½ææ†Í%N¸´ûáI˜©k²EÃ½ýÎ]ûÌ¿ý´Ê6T”|tYY°†dt©d›²RÞ[ê\'pÒàa\"à	ì‚.3ÝDÊ|„ÿQ”mk{WrÞ4Ö˜\0ó¢Êñû>•â…L&X¯¥’Æ¯ÈØh~€Yö{}6Õ-öc{tx(Itš~èÓË6Œû{~ä¬h[bùÎc†é\nÎ‚SD#qœ„tx@Y[Í\'IL	WoWp¼‘¼*xúÒÙ­¥²Ú à²¥Œ=|øÈÅóç0`\nT€ïŒ“Qòlno$à|`Ç\'òsû®Èþæýˆ]»vE7@\'ºVO¥i³ÑP\0%»$íT§NîÆ´tq¤Å#²ÓËqPV´´§žz+-g¦@Ë¾===JŒjnFÎº½üÚ›²UzpxhÇ\'§ÉËÏPüÌ·g\\QŠ¥ãlÍ,•$ƒ¹wO_Ú³÷Ü¼¦:¾\nx›¨é÷%ã!^7Ê9éÂ |*8ˆ£ï¹A*2/þäÞDfÔ3Šƒƒªz‰†\neDœÐŽ‚ÿEV¥\0–hÁóŠû)×}Ý]™UbíG©ê¤Ñ„©%åSqùSóg\rúÏ1qÉnéb%Ie¦¡Ä *Ýe²äˆf6µîa³ƒ)í]Ü³Ë7®YYCð%5q|ÎÂÀ¯ºÞ~÷´#ßJÜqpÎAT°TªŠxIgŒ}±Ùjé3w*ÍZ5•¿˜›–\\Hoå%7a<èûì£ÊVÈ½»	ÔA,AEj09e>·Á¾\0\0 \0IDATS\Z,dnèÿ,VY{íÍ;ö¹¿ø¢½ùÆ›NqbQ†¾cÊ¬]ˆÚáƒ4:\'e\\‘’›³Ð7ã ë.WÔÔV6‰\05ê»t¤\\²ËÕÊê•šäÛ+ã½Õ­Ìfå„}åê\rÍH\"\'N¶uçÎ;vr|,üxscC6÷`ZÇ\'m{ðèH\"×*ŸþÈßYÁ%‚)ËM•Ò¢BVISRt«&\n>Sð¸QÙ5º\0ê‹\nj½êUèüåªRÅÞ ë”ÿ9]„\rÛÝÚV9Gý\r“—T’ßëcu´²‹—víûÿÆ_·~ô{­^++Í(^¯+(²±Že‹ò,\Z¥×SÜmK’¯±Ê\nètw4Æ#]¯…-gSáZÅ|N€>\'6Fd¼.ÎÕj½j«yÎ:Ý½úæ-{óö];<…å¼tB\'‹ï»<Vtà\"ˆ¬#2¯hQnE&VÏ¬ì}Oß´ë×®Jä>\Z ¼b«\'îÂvÂæ;ºz|þ(§x­óïÇ{ìh]v%y2€oX âó¸R«KÉPnð§w ƒëåtNi®’÷bg¾®Ü;Éå&õ	•{t;“W ¦ÔAcôŒDÖf‰ææ.ÚÐ|­\nßLe§È£š\rs*€JGiOa22•‹¼‡ÓN·­×Gùò+žÁh*« c-}ö¬Öôb2•\n)%ÍÞÅKnV*Ûéi[Øë‰ëRÙõÞ¹¯Ì¯r}Ü3\ZA˜œÒÀ`¸XØf·dYdh\\ãŸðà$b ë”ªh´S¡˜–Jx¬àÁ\ZKUë\rfö™?þœýÅçþBPø-×®Ö©\0” ñ#‘@‚%«5oNxsÆç_u“Ž<*ºâd’Üo¨72Ø¿¤*Ñô\nÃæ>¿~’hÄM‘QÎs­4*vmw÷‚]»zCÂ˜ìÿ£Ã#ëu{¶·»o{û<H®ÌNN{ÂÕá>fvÿÚO¨QN9å-h@Ë‰J¢p«ÆC•+hÝ€ë,p÷˜­Ö éš•&¢–Yo*\rfž\n€šS¡ßÃŒ´«¹.\0w\'l.¬Û=JŠÝ3nÜÓO?i?ów~Ú®^½¤E£¢nGÞjÕ²øWÔý´r:± à‰ð°ÚàáKIq€Ú3&ÞÇ3‡™äŽMÇhÀ££´˜š-gVBwªTV˜¬Pª-»*Øƒ‡‡vÿñ‘½~ëŽt»âÅè„áá&ÅÈžüÁŸÙWùæ>³Ò>Ÿ…ÍÏˆZ0Ø•ÝûŽ÷¿×65«äMF–	v£hæ49%Ý>L#F‰_¥\n0y»IÜ?q€Àhø\nÅR±÷@#Û;v‘Åõ™XtÖàÛ8Öá%§ÿ<úd<O§«DÆÇf‰ßï»™+IÀ™®»‚K\n¦!‰Q¿Ÿš:#e„ÊŸIaUžˆdÑi^254\"Ã^:Ä|¡ƒm8¢¹Ó³þ°¯ä*j¢7oX¹†.»…æJŒ“àü‚˜]ÉŠÙ¼µON-_.ÚæÎ®fòÂM¥²¹‘(È¹«µcSÐ\Zr‰Ì¹û\0ðïÅä\\ÎÞ °BàÞß»wÏvwö8)‘	Øè°Q~á-Òy\\¬`¾çìµ×oÙïýO¿gÇíÓdìAÙ\rxÝ^Æ™Ï~zyŠ8p€O‹Èa\n9á‘Ëqmžˆ?&Çí<ó(ºâ—@çŸò› ‹üMN¤köýPa `ÊÙªÈ<gÆÜ’Òûâþ¾m47t\Zƒ9Óº#³dìr‘€\rZ¦ñ®OŠé®¨ˆ‘CÖëD©©†¢IOÁ%s«WKšb§–ešœ·Aº,êqR(Ë>›ú™ßßÞÙQ]:\ZŒU‚M\'ø‘aÑ±á¨¯.ŸFLèQãÃdVi³ÿìçÎ>ôÁ8ë]ƒÎ#ó[[-ÝPaPã‘R^2\'2,N1@:vF#àùÜ ?K	Àï‚ÈO€ß?ºgÃaWžk+I¿ä¬…!›³Ã£C;8~dÄ³ñdaOìß|Í(D¨Üð ìòóë|IvÍ:Çˆ?“Å©ÆÌÞû®\'ì½O^·2šï¥¼Jm€ŠêÇ²Òàrð¶„}$r¦:>¸ÿ$æ>e³p D¾ä`ŠlïÛMR#p&¤îÄ˜÷N\\dU^\n0/”R·Ðïy9Ï††œ‚¡Ï›2FW¯õ×bÁ+ƒH\nþœœ]¯ šþ-2?>[x\0P6È”žZ(vÄ=¡Û=¨ä€CyÜjaø\ZTíêµ+¶»·c²zdš²uú=iÍƒ…–ÁŸ–+÷Ö+¬µ±eÖ†3¹¥áŸ•Rƒwú}×}’ÙkÎ:½¶F®Z\"Ê\rYxWÉúPi&˜¢Œtøìlmé\0ÂqzkIï¹–š6Ÿöà^RºNc÷ðQÛžáEûãÏü‰špµ§T¡¸;³ËH»ìÚù`ÌŽïr˜ûëIìR¥ôº£ˆ‘-NFÇ^ò±îÙ×ytà%¥îcmdW2#žÏüõT>h€y“`†Œn‡tk\'ŒÉ•¬ÕÜ°fcÓ¶¶vÄûÂ¬öðC\ZODX/™êSŸXÙp£QÏje»Ðï™Ê@9æ§>(IÓ\'ê÷öví´s\"<‰ò„¯NK»§ÓƒaHj²­ÍÍ-u»xûÍ×l8êªÄTæDôeP2_²Ñ|ìíølÎ®]»êÖå‹>ºÁ‡œzÄ&»#šÕ9ÀT¢Èto57YÝÒ^®cØë*› ë×‹9•5òšßµÑ°§ã¡˜ñˆù5m‘YØiûÈ½±$Ÿ;ƒ±}ùù¯ÛI¯ï\ZU<^N®D=°ÎcZÑ‹îÙy€>›|ÏË(—KiU\nöÝx]ßßµJû+2)Í+›Ð¡M|©0àŒ×! E§Ž…Ss+€ò¥®Á\'Ý+ã‰}Ï¿«s”¢¬ŒÎXdŠtªœÚÀ)\ZY’3©Yä|Åœa¸ý.¥Ò(¨(P\'†6ï£9ÂÞ’yˆ²0:õRË3.§Òœul9Œù]sN­B¶wbý1Ý#ëô»Ê\"66šZ×ûö,WÈ¸†š1Ž²­ì€Ò§¬BeÜÌr5‡[Öhn\Zò^­,5TL)%M°ÕÊªå²ØIûTrÉ˜S’¹€	ñL98{ýŽFqÀÉ\"ÃÒôFsCœ@tãÉ„Iøœâ˜øŠ=Ÿ/Û£Çû¿~ÿSö_vk=‰ö9‰^ {È±^±#SBàó””è’WÆîÙ+°	•4!p²*Ÿm•Õ<¡Ö²5\'1¨ŸPÖæURòºP3†“¡þ\r®Îî°;`\Zé‘ÍUiÉ(enV*–­Þ¬Ùå+WìÊ•kÚ§Ü××^}Ý2Åëß¿r«,êW|y¸Ìï¬¬èr\0V+–ms£)\0\0éðèÀZ››öàñCEMHb•rU‚òî=TôWç–<6ñå¢\r§ÖéžZ·{*ÜJ–ÖŒÎÈÐÔUB°o‹ä#±Ÿü‰¿eÍzU\\$:pz8”‰O#þŠ´Ñ]ÈN7¿XZ«PzãÄRm2DÙºef€íóùD]8W,eÏœG’Åý¶dî?¶Ñpj¹bÎFÓ¾µ{òƒúñW¯¼nŽÝËSèåÙáyÜË¦3+÷hçÛyÌK§	öñRäÛ—/ØûŸyÂv7›~p$Ó0u\r«P9ŽäÆ¸Ê\0Ó)¯×N8…Ê© 5¤€%gå”ÅD€=u.ÆFD„Î›¼——eÜo§)x[œÍ¦<µÊãú<@RšÂ³rNY|6:÷ƒ÷\rlN‹Œ-•´ºvaP5JøŒqÝâ†%	80´‘PÙŽD9PGÒP^’\'Vª”ìÊÕËvqOÙBs(x¬Á0tL†…P#©Ê«êfCë\rÖ6j¢	 ~ÌKt¹RË““£u·/2G 23¾CwprBtIAŠak:j:È8Ð™Ó+”ü`õåû‰;îÊ³EÞ>ÿ…¯Ú|êÓš‡$+Fâ…LJž@õ¤¤!\\ÊvP<1ó\"I•uü¬¦j5$í’2h•Ùqø‹:‘ÖÏX•†äÉ„Ê¾àuýÙ,m†O@LÖ™÷¼—Ä8QÍÂ{\Z1Â‘%rÌ»»{výêMÑ[2õë]áwO)ˆçýÖÆ†0,<ò.loê†iàñøXããÉÈî>x Ô°r•Í»àþl¦® RñåÊ¶76ô°NŽŽ­?èØlŽÐ–ðÎÀæaÁI¡³\"ï;¥¹qrÆŸüä\'í‡ÿýÙF³î^pTW»–R¬ðÃd%£“­;øB«,ÚÏþ5’n6TŒáÿ¡õ»m­Èf\\á˜1T=`Ð´Û“lë 7²{wîÚ|9µÉ|l³11oÇm{å·íáÑ‘”E…_)MøÿX±q\"x}{ÐÒ\Z9¯±Ž”$dfVÉfìéëWí}ïzÚJ9Ó³‘M˜|c	*BdCQªôÓzó)ÿ¼\'qžC2p ¤–Pê¹\0²Û¹3Ê<ÉÃÌo#; Ãr©c`48¢{§×8gEPx­çH°>ïØ_ÈuGfÈ÷´)Òç^•Ì/´R“!>gdxšäz£L‰rÜJŠó©JÁw¿ûif!â8]NÔ¢›G&Ym4-Ç\\)3„™•Õ5.eVªU…å³xJ‚ß&“^Ju©4 @ã ¢9EºÙlà0ŸS\nÐU–¦ƒ“­Í\rQà†SIùœg)=0—kQv‚Ì8¥0â€HÎdËöæ[wì÷þçmh}ˆ¸\n‰•çISt¿Žï»~›»eqo•Õ¼äãeF#F`ˆ2Y.—¥ÎðÕ“ôÏÒüfà–pÅòe\Zg¨¹;çk6»\0HšS¥d¦Ã¹[\n2t&‘‰*×-³}ó#«z¥hÍ†¢:ìó‡ØxØ—\"üRâœÁ>…}\\ÖMÇ½CÚ7ÇJÝ9@1ñú—VÌå4&C g!{¢u\nŸBœTÜ%¨w¦n9öms£aßñÁÙÿðÛ…ÝR·„Ïªl#3â5#ƒà}å\rÇIˆàþÆ–mmï­u±D&¤+#EJEFPÑ¾\"Ûƒ³%®4þ¡Ín÷ÿiëÜ~ã*¯(¾g<—3WÛq;‰\r½@KK¥¶ðÒRÄCÕþ}íCh%ÚÒR!õ¡\"jPD¡@pˆïñŒçj{ªßÚß>>Da…Äö\\Îù¾ýí½öZkÛŠôÙL6è¹fen\\]-Ö{_oÙí»ÿ–a¿†º¤€Åµ(‚êK÷GVñç#Px]Ñq¢C D€®Tíé\'¯ÙµËK$])AØÅqÏýÈnNÇ×.ï!6}¸b$¢&)½:vXÀ»¢ŒÏCì Pv°1Tf¨\nu?#!!`-tØ\nAOØ\Z÷>\r ˆS\Z<KèFr¾\rLÄÄÛâ{reH–Dí<W4“R/^×L†Fx“±àîâ¼=sã[vyuYk—þptèSŠÊ5Dm‚V>%\r*Ñð\\u†KV-û ^²YÌà4¢òc¿Fj¬”èdt(ò—Ï(@ð}1àË3ÛØ¸§¦KhXìT¡XdÂŽHæ5¿‘r½bÓã‰GaÙ¥ßÄ~û»ßÛ­Ûïk]ƒ	’•ÅaC³Ê­˜Èv|äI\nû‚ÌÈ5·C—/1©]F›1aHXÉ‰[t“€ÐÐ’gZj È=ø´ƒÎžŸ«z×n2–Ð\Z+S@æ}¶¬Þ¤cí†À`ixÔ•~üâ«3²Œ¬nƒ¶©g»;HÆ6œÊISÒˆ¦a-«–%=XÝmul:£]»¨T—Í“Ó¸§ìóÖ¬ÛÆˆœ¡’¡é¾Ú¨ôåwTùøhdO^[·W~þÙ³âÄI;Ÿ¨àixX\r†=\rÀØ¼f†J!_inh«-#2ÏºB~›@öt®ˆŠ•†tŠzº Œ rË\\ð/ªjî³G‡½ä“ÕWf˜U™ž{lŸ|ú¹Ýúð#Û¦ó‰—Ï’ì™#P(xd_ñ{±y‹¥b1`±pœ/ƒÕ¾÷e\r]½ñÄš­<¶¤Á«`NHYšö‘­ic\'ýžSÍ¼˜ÿl*ÃÀi„;%Ár”³Q–E‹¬0²9èÎ&LìiñzÜ 0À}•¦…©7‘aqÿ9 \"@*h%ÿ¨<(¦¬)pµàs	3d“k<ü¿„#&‰ï1(”¯²\\:Mý	¥ÿÄ&ÇS.JÁgèÆÎw´®›3Œñ¥³íNX!W²ÌÆÇX¨Õ¤‚dLÕÀú«”`ã“ÝC-[©’Æ‘AÆKŽR‡õ\\«hm=ØØÐž¸pî¼®ÓÁA_ƒƒÁ(Ñ¬¢apt§“˜·\Zž§™ÂDà L+;Ãý³šu­×Ùëø“}p÷#§±Ð€j¶s\"äiIÛ4\'À©H’•IêCg	þ@9ÒeiºÝª$<Èðgïù]YZ\'Œ¯3ïs¯ež8sQº¬q&)ƒ«2§üú†/h½CxNÄÐÇ˜ûAƒùþ/Íp%à$\'Ý¡M\r\Z’_,!k(’â\Z@Ç„›¥©ò%‡ÉÚS„È¤¤ïJ­!9kú@	Å+[»» ÓpŸÒ’` 1aÇS{áG?´—_zI\nu|µX<¤èpÀ.\0Î1I¤Ýî¨Kƒ>˜Ý/¢>à£[o8úÊMw#ïÖ°È	Vˆ 5ò»æóa\'ƒ%D×‚à‹·;0\ri¥Ò”áëí=»s÷cûrãkÙò(`Q»@ë¸Á9)QÍ•Y¨‘µD9\rj^ž‘ríäU.Ùòù3’í,ušÂÚ4a&e.ˆ\"«Š1a*‘ÒÄî°XŽŸULT‹\"&ï‘ÅX|^Çš]ÓS\n|©.baÊö|~¥u\rRƒÅ‡dº0X\r‚D±ð`èdW\'~¤I=ÚL§C#ô9Ò¤\"q†ÒðVñcs¹“ó²Ä8?Fv3¶ÁÈ%\"Rè«tüŠrðÚúš2¬fÃ»‚àMxSq\rš¦]||ÅJ•š“õÙÞþŽµ¥…W…Àì@•Ãmx™Ñœr¢èl®&ÏweLZËS÷Ñ\ZOäÊ@VG´\\±»C½¦ŒÓ@‚A—5Ä¬ì½)0þúGSÒDŽ5Wà‹¯Ø[{Û¶¶ödÐG½Ec€jDÂvöÊÜ|’NdÒ”gtü<Áð{§\Z:QRSh[#Kê6SÆJàUPRVí<Ìâz–†‘Ì‹ýWöæ{–-£¼àÕa–…‡câ“±”&¢M„A—.¬|gÆ›bñtpçl¶ÿ&“2¦è<¡«.D5F¿æ£Ýp“È¨Â7ŸÚâ¥Ž”û¢Ðš>Î	pÈQÆF ÓúÍ¯eÏ>û]9f5ï úÌªÄ¶xåòšÒoÚ½¸#½¹ð´[qbd3°x)#ù}¤>\0™£a_ÝF«{Û;Ò4Â­áspR¸ww¶õ;û»;6<<Ô¢_hkÁà[_©–ÏÙ»·Þ·ÿó©2‹°`‰kU,óøÿb)TÜ|ÞMK­Âèxý¼„Ì‰YÎµÄslv¢1`ëW.ÙÕKËr²¨*£9õw/f&`LœøîSæ4ƒÐ:øêÀvdP\ZYžÀíHÿ¹^~û{ó¢R¶¨Y’ÞÙáä–sgÒÇÅëñ÷G16ezd‘åJ’M%Ý_¡[yÚ)<Õ  ô!(ÒXHDÙ(wxý\0—¡³pÐ\"«ŽGÖÇ ñdf½sã³¼reÕžþê\"Ê_¢Á~Ë=Å ™ì\Zò\"œ=ÞþÒ™³Ö™_T ÖP’4Ë3¿n*«\rIX*4…ææ¬?ìË…‚Ãa/°Ãx0”&â4f‘ü>Ÿ¿ÕsÞ•2Süâ˜]oçÞVDÉ<Áå¶÷ûöÆŸß²÷o¨®¥»9˜ô~|&î5×žõÌðcäJ” €åt(ÉjäðI’1s‡“ÜÍWÞø	»,¥IÍé@	ÙOÞ<I¼CoÖ ‹=±“dÝ,_2`!M˜w,T0¢ï9o°ÂàACL«ÝiY7\0¥ƒ8zÖÔÑÃ@Æ‹©ž„ÚO?.Ö,uÈÕŸL@R›fæ ¡pxBòsç\rØy–¡N]ÄJÕÎ,-Ø7ìg?ý‰?¿dpTÁ¯\0*·7ïK\rŽ³(î¢óSz}u8kð&)5QšCf˜dC?aµC_Ñƒûê²@ºã¤¡LÐÚßÛµƒÞCÙÉÍQÞòyˆö³RMmÝ‡½½só=ûòþý„Ç…DÅIr¤¢„Š?¿ª?â“,Ê±|*È~ÎS#÷@ Ýmfveå¢­\\\\Nx–ã‘µ¬Fd+\nƒ¬]sv³îA!PF€‹÷ÍóOJ¤à¡•sw’›\\rlVæ&zqÈEi8Xˆ˜•YR‚êžaŸëÎ\ZAR\r©g >O‡f¤IÞ\0».%q°,J@î#ÒÚð@\ZT	ý¡ãV”¹£rmP]tìúõ§l}ýª=y®àèm|uOAqñì’DÇY»\r\rb$SÉ¿M†ã±¾¸îÌµŒõ5»\ZÚ\"ëh&±ÁèÒH7†žð¹Î,,ÚÞþ®mn>\'Lë2y™“°rMj\r<·(ïÌšYKA\rNÍfkZ¥nÞýÄÞ|ómY³(pPØJöãø\"‡/ìv²*ìË¡¨r—á+rÑ`¦AÉç’!J#:sÚ	û˜ŠÄ;Ë”ö^â).¤F\n¯w0‚7ˆàDWŸòÜÊGÞùT!ªU­\\Kž‡%‘T{-}û{/B\rSD¤gV™J €m@7¥r^«Æ7·O\0-­N\"„œ½ý©tJ6Ì¼Éœ£$ÇCïn…=|£••{õ—¯ˆ•eUkÔç<«:Ø·‡{Ûâ‰?{V©4¤Iœzýš\00a\0À)A4¬£-Ì#ð’VÂÌ(%%ðƒ„:+ùl8gÒc«{$‰œè~¼ƒ‡£#íÝ»ùÞÛÜÁèßf/å’‹h¢³©(Ó\rbhN\'3Ç_Ø–¤ðáJÂ[V——íl·)ó7ùßËì~æƒi“—•Ÿl§Ã&Š]Âoâfþ9Š¸\Z¤ÝâûS6vâ’€åÞñ>îIa\"¡p—å8É‚\"Ãã9µˆ“Î&p¬<«J€½^O”}Qûs‚)›?:žÁ³B¿È&ò® âaôsŽ[\rÆØó5•†ù¬öÕË+>Ñ¥^Ó¡)N£¥Óû&‹Ó-l10ãßÁêÆVIžðY½#?,5 ÐøMÆÂËâ¾ªƒ[Ë\\ÏGcã„ñõMÙ6!ŠfÏl=ØT•AÆOglkkÓÎ;«ÏìÁƒ J–îw{~^ÁFÓ\'ñ~1Ån,›ä>øHpÇÆTÝíÀ•©$5„=ã~ØÜÌq,°kw¦CíšGáËÂ§¼#Î^Rf„DÉGâr¥Š¡ˆ{Ê/¿i¢“[EshéRwŸýKÐBÛIQ£†¤†)Yâ”Î¬ÎàrÈ‰!Õ©,&‚•jMEG6”w<²úW¤>òÌÉm)|.?a}Š‹FT%!µ(i‘ò|ºƒ®—.^°×^{ÍÖ××”YáY†µ³u_mæ[ÕûÛ;[®%“ö‰	É]•…áÏ‚\"Ïð™iÈï*v¸+Óà$ã‰ÍìdMTã\\É„4[ÐK™‡ˆzdö°7´/îmØ»·îH¼)Ï­”qâ´”w¹TéïŽ	–\\qmãytÓÐŸ”ƒÕÜ¯¶W.œ³ùN[ÁLKÜ–$Gqÿ(!;Ú‘è@I™S`T¤’’?éÿ|Qz&Gï·ì¶6dÍ’ÜÈMÂõzAJDö€”E‰–©ºpØŸx`“ÅNrŽÈKé4X„oÈ\'ŠçŽ“W »ØHdP÷º\n7²\"¾„YiSãpdkëWlmí²ó„*%Íëë uÉš*vö¶ma~Aê‰F»kåjC˜\r×—N\"Ž$Ã©k¡ÆÄ=#È¸<È1#¤&<‚òh\"~Ö!˜ª$1Çö9yÇ[¾pQ¬u^·Ûù’ç ‰\0—•r£N“*sÐzì»JÝ±Àr%S—ðÁæŽýå¯·›7ÿ¥’Š¥;c¾\"`ù@ïä²Fªe×m°(Sî¡»ŽèÙ\Z÷îw)­[«$Ò†jpˆÏ‰ðä%4‰qÏƒº’¼s}Â´²«š Ú@{ ùn­ª²[ÞJÖöº.5ˆYƒ¤u~²Óv•®Ð±+%žpp ­¤Ý!ÛËÆ¹nÖæ†ÿ¸dMÏ=÷¬=}ýº=õäJÕ¹Y»—¾õÐûM`úvÕí«áBØÈÔ\0dG˜RM\'%¡Wð¯ºÊ±›8ƒ¿%A®ÀìßËYœx8-Ci‚<¼Ð8*øÂ‘‘ç©÷±}qï¾ýãŸï(`	KX¥BâE‰7°Øe)–0‘>G<+â_qƒ#`…-µÙ“#[ìvíâÒ‚]ü©*ûM8v½ €-,¥z¾ÈBV‘üâk\nô,È³0½Lrƒ>&Â¨sH+N\r&s9ßKü#8yiýpOrvz”\r\nÀ§òÑ*Ò…Èq¿BÀÊîÿ™ ­&®}ïlS\"Qjh¼ú„)Î}m\\²,Ö\"³-W/_²µ««VË8„Odˆõ.¯>Ö)‹Kç­šµõüì\0zZíûz=p//¯C}Áµbýq\r¼9T¶é`dÕ¬&L#‘™€[L^‚ßjÛüBWû‚r€EÀCŸàŽænŠÀXî8x ùº¹ŠÕ[]«ÔZvûÎ]{ýoØgŸýWÁ\0ÜŽ¹q8ø}àºÀT÷‰äèB0Ãé\"û$›â>ŒI4,\0\0\0BIDATS*)8©ö÷Cd0¤ûEÆ¹ƒ~øù—þ= š{špm·óøê>Ò±4\\ƒë†0œd‚@Ë:äçZþ›ø¬DðSæ\0\0\0\0IEND®B`‚','2015-07-28 04:26:33',NULL);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_address`
--

DROP TABLE IF EXISTS `staff_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_address` (
  `staff_address_id` int(8) NOT NULL AUTO_INCREMENT,
  `staff_id` int(8) NOT NULL,
  `staff_address1_primary` text NOT NULL,
  `staff_address2_primary` text DEFAULT NULL,
  `staff_city_primary` varchar(255) NOT NULL,
  `staff_state_primary` varchar(255) NOT NULL,
  `staff_zip_primary` varchar(255) NOT NULL,
  `staff_address1_mail` text NOT NULL,
  `staff_address2_mail` text DEFAULT NULL,
  `staff_city_mail` varchar(255) NOT NULL,
  `staff_state_mail` varchar(255) NOT NULL,
  `staff_zip_mail` varchar(255) NOT NULL,
  `last_update` datetime NOT NULL,
  `staff_pobox_mail` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date time staff address record modified',
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_address_id`),
  UNIQUE KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_address`
--

LOCK TABLES `staff_address` WRITE;
/*!40000 ALTER TABLE `staff_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_certification`
--

DROP TABLE IF EXISTS `staff_certification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_certification` (
  `staff_certification_id` int(8) NOT NULL AUTO_INCREMENT,
  `staff_id` int(8) NOT NULL,
  `staff_certification_date` date DEFAULT NULL,
  `staff_certification_expiry_date` date DEFAULT NULL,
  `staff_certification_code` varchar(127) DEFAULT NULL,
  `staff_certification_short_name` varchar(127) DEFAULT NULL,
  `staff_certification_name` varchar(255) DEFAULT NULL,
  `staff_primary_certification_indicator` char(1) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `staff_certification_description` text DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_certification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_certification`
--

LOCK TABLES `staff_certification` WRITE;
/*!40000 ALTER TABLE `staff_certification` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_certification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_contact`
--

DROP TABLE IF EXISTS `staff_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_contact` (
  `staff_phone_id` int(8) NOT NULL AUTO_INCREMENT,
  `staff_id` int(8) NOT NULL,
  `last_update` datetime NOT NULL,
  `staff_home_phone` varchar(62) DEFAULT NULL,
  `staff_mobile_phone` varchar(62) DEFAULT NULL,
  `staff_work_phone` varchar(62) DEFAULT NULL,
  `staff_work_email` varchar(127) DEFAULT NULL,
  `staff_personal_email` varchar(127) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_phone_id`),
  UNIQUE KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_contact`
--

LOCK TABLES `staff_contact` WRITE;
/*!40000 ALTER TABLE `staff_contact` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_emergency_contact`
--

DROP TABLE IF EXISTS `staff_emergency_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_emergency_contact` (
  `staff_emergency_contact_id` int(8) NOT NULL AUTO_INCREMENT,
  `staff_id` int(8) NOT NULL,
  `staff_emergency_first_name` varchar(255) NOT NULL,
  `staff_emergency_last_name` varchar(255) NOT NULL,
  `staff_emergency_relationship` varchar(255) NOT NULL,
  `staff_emergency_home_phone` varchar(64) DEFAULT NULL,
  `staff_emergency_mobile_phone` varchar(64) DEFAULT NULL,
  `staff_emergency_work_phone` varchar(64) DEFAULT NULL,
  `staff_emergency_email` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_emergency_contact_id`),
  UNIQUE KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_emergency_contact`
--

LOCK TABLES `staff_emergency_contact` WRITE;
/*!40000 ALTER TABLE `staff_emergency_contact` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_emergency_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_field_categories`
--

DROP TABLE IF EXISTS `staff_field_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_field_categories` (
  `id` int(8) NOT NULL DEFAULT 0,
  `title` varchar(100) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `include` varchar(100) DEFAULT NULL,
  `admin` char(1) DEFAULT NULL,
  `teacher` char(1) DEFAULT NULL,
  `parent` char(1) DEFAULT NULL,
  `none` char(1) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_field_categories`
--

LOCK TABLES `staff_field_categories` WRITE;
/*!40000 ALTER TABLE `staff_field_categories` DISABLE KEYS */;
INSERT INTO `staff_field_categories` VALUES (1,'Demographic Info',1,NULL,'Y','Y','Y','Y','2015-07-28 09:56:33',NULL),(2,'Addresses & Contacts',2,NULL,'Y','Y','Y','Y','2015-07-28 09:56:33',NULL),(3,'School Information',3,NULL,'Y','Y','Y','Y','2015-07-28 09:56:33',NULL),(4,'Certification Information',4,NULL,'Y','Y','Y','Y','2015-07-28 09:56:33',NULL),(5,'Schedule',5,NULL,'Y','Y',NULL,NULL,'2015-07-28 09:56:33',NULL);
/*!40000 ALTER TABLE `staff_field_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_fields`
--

DROP TABLE IF EXISTS `staff_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_fields` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) DEFAULT NULL,
  `search` varchar(1) DEFAULT NULL,
  `title` varchar(30) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `select_options` varchar(10000) DEFAULT NULL,
  `category_id` decimal(10,0) DEFAULT NULL,
  `system_field` char(1) DEFAULT NULL,
  `required` varchar(1) DEFAULT NULL,
  `default_selection` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `staff_desc_ind1` (`id`) USING BTREE,
  KEY `staff_desc_ind2` (`type`) USING BTREE,
  KEY `staff_fields_ind3` (`category_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_fields`
--

LOCK TABLES `staff_fields` WRITE;
/*!40000 ALTER TABLE `staff_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_school_info`
--

DROP TABLE IF EXISTS `staff_school_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_school_info` (
  `staff_school_info_id` int(8) NOT NULL AUTO_INCREMENT,
  `staff_id` int(8) NOT NULL,
  `category` varchar(255) NOT NULL,
  `job_title` varchar(255) DEFAULT NULL,
  `joining_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `home_school` int(8) NOT NULL,
  `opensis_access` char(1) NOT NULL DEFAULT 'N',
  `opensis_profile` varchar(255) DEFAULT NULL,
  `school_access` varchar(255) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date and time staff school info was modified',
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`staff_school_info_id`),
  UNIQUE KEY `staff_id` (`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_school_info`
--

LOCK TABLES `staff_school_info` WRITE;
/*!40000 ALTER TABLE `staff_school_info` DISABLE KEYS */;
INSERT INTO `staff_school_info` VALUES (1,1,'Super Administrator','Super Administrator','2019-01-01',NULL,1,'Y','0','1','2018-01-22 03:48:03',NULL);
/*!40000 ALTER TABLE `staff_school_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_school_relationship`
--

DROP TABLE IF EXISTS `staff_school_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_school_relationship` (
  `staff_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `syear` int(4) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`staff_id`,`school_id`,`syear`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_school_relationship`
--

LOCK TABLES `staff_school_relationship` WRITE;
/*!40000 ALTER TABLE `staff_school_relationship` DISABLE KEYS */;
INSERT INTO `staff_school_relationship` VALUES (1,1,2019,'2019-10-06 16:55:03',NULL,'2019-07-15','0000-00-00');
/*!40000 ALTER TABLE `staff_school_relationship` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_address`
--

DROP TABLE IF EXISTS `student_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `syear` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `street_address_1` varchar(5000) DEFAULT NULL,
  `street_address_2` varchar(5000) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zipcode` varchar(255) DEFAULT NULL,
  `bus_pickup` varchar(1) DEFAULT NULL,
  `bus_dropoff` varchar(1) DEFAULT NULL,
  `bus_no` varchar(255) DEFAULT NULL,
  `type` varchar(500) NOT NULL,
  `people_id` int(11) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_address`
--

LOCK TABLES `student_address` WRITE;
/*!40000 ALTER TABLE `student_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_eligibility_activities`
--

DROP TABLE IF EXISTS `student_eligibility_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_eligibility_activities` (
  `syear` decimal(4,0) DEFAULT NULL,
  `student_id` decimal(10,0) DEFAULT NULL,
  `activity_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  KEY `student_eligibility_activities_ind1` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_eligibility_activities`
--

LOCK TABLES `student_eligibility_activities` WRITE;
/*!40000 ALTER TABLE `student_eligibility_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_eligibility_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_enrollment`
--

DROP TABLE IF EXISTS `student_enrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_enrollment` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `student_id` decimal(10,0) DEFAULT NULL,
  `grade_id` decimal(10,0) DEFAULT NULL,
  `section_id` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `enrollment_code` decimal(10,0) DEFAULT NULL,
  `drop_code` decimal(10,0) DEFAULT NULL,
  `next_school` decimal(10,0) DEFAULT NULL,
  `calendar_id` decimal(10,0) DEFAULT NULL,
  `last_school` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_enrollment_1` (`student_id`,`enrollment_code`) USING BTREE,
  KEY `student_enrollment_2` (`grade_id`) USING BTREE,
  KEY `student_enrollment_3` (`syear`,`student_id`,`school_id`,`grade_id`) USING BTREE,
  KEY `student_enrollment_6` (`syear`,`student_id`,`start_date`,`end_date`) USING BTREE,
  KEY `student_enrollment_7` (`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_enrollment`
--

LOCK TABLES `student_enrollment` WRITE;
/*!40000 ALTER TABLE `student_enrollment` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_enrollment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_enrollment_codes`
--

DROP TABLE IF EXISTS `student_enrollment_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_enrollment_codes` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `syear` decimal(4,0) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `short_name` varchar(10) DEFAULT NULL,
  `type` varchar(4) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_enrollment_codes`
--

LOCK TABLES `student_enrollment_codes` WRITE;
/*!40000 ALTER TABLE `student_enrollment_codes` DISABLE KEYS */;
INSERT INTO `student_enrollment_codes` VALUES (1,2019,'Transferred Out','TRAN','TrnD','2015-07-28 00:26:33',NULL),(2,2019,'Transferred In','TRAN','TrnE','2015-07-28 00:26:33',NULL),(3,2019,'Rolled Over','ROLL','Roll','2015-07-28 00:26:33',NULL),(4,2019,'Dropped Out','DROP','Drop','2015-07-28 00:26:33',NULL),(5,2019,'New','NEW','Add','2015-07-28 00:26:33',NULL);
/*!40000 ALTER TABLE `student_enrollment_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_field_categories`
--

DROP TABLE IF EXISTS `student_field_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_field_categories` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `sort_order` decimal(10,0) DEFAULT NULL,
  `include` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_field_categories`
--

LOCK TABLES `student_field_categories` WRITE;
/*!40000 ALTER TABLE `student_field_categories` DISABLE KEYS */;
INSERT INTO `student_field_categories` VALUES (1,'General Info',1,NULL,'2015-07-28 09:56:33',NULL),(2,'Medical',3,NULL,'2015-07-28 09:56:33',NULL),(3,'Addresses & Contacts',2,NULL,'2015-07-28 09:56:33',NULL),(4,'Comments',4,NULL,'2015-07-28 09:56:33',NULL),(5,'Goals',5,NULL,'2015-07-28 09:56:33',NULL),(6,'Enrollment Info',6,NULL,'2015-07-28 09:56:33',NULL),(7,'Files',7,NULL,'2015-07-28 09:56:33',NULL);
/*!40000 ALTER TABLE `student_field_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_goal`
--

DROP TABLE IF EXISTS `student_goal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_goal` (
  `goal_id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) NOT NULL,
  `goal_title` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `goal_description` text DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `syear` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`goal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_goal`
--

LOCK TABLES `student_goal` WRITE;
/*!40000 ALTER TABLE `student_goal` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_goal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_goal_progress`
--

DROP TABLE IF EXISTS `student_goal_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_goal_progress` (
  `progress_id` int(8) NOT NULL AUTO_INCREMENT,
  `goal_id` decimal(10,0) NOT NULL,
  `student_id` decimal(10,0) NOT NULL,
  `start_date` date DEFAULT NULL,
  `progress_name` text NOT NULL,
  `proficiency` varchar(100) NOT NULL,
  `progress_description` text NOT NULL,
  `course_period_id` decimal(10,0) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`progress_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_goal_progress`
--

LOCK TABLES `student_goal_progress` WRITE;
/*!40000 ALTER TABLE `student_goal_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_goal_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_gpa_calculated`
--

DROP TABLE IF EXISTS `student_gpa_calculated`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_gpa_calculated` (
  `student_id` decimal(10,0) DEFAULT NULL,
  `marking_period_id` int(11) DEFAULT NULL,
  `mp` varchar(4) DEFAULT NULL,
  `gpa` decimal(10,2) DEFAULT NULL,
  `weighted_gpa` decimal(10,2) DEFAULT NULL,
  `unweighted_gpa` decimal(10,2) DEFAULT NULL,
  `class_rank` decimal(10,0) DEFAULT NULL,
  `grade_level_short` varchar(100) DEFAULT NULL,
  `cgpa` decimal(10,2) DEFAULT NULL,
  `cum_unweighted_factor` decimal(10,6) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  KEY `student_gpa_calculated_ind1` (`marking_period_id`,`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_gpa_calculated`
--

LOCK TABLES `student_gpa_calculated` WRITE;
/*!40000 ALTER TABLE `student_gpa_calculated` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_gpa_calculated` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_immunization`
--

DROP TABLE IF EXISTS `student_immunization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_immunization` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) DEFAULT NULL,
  `type` varchar(25) DEFAULT NULL,
  `medical_date` date DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_medical_ind1` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_immunization`
--

LOCK TABLES `student_immunization` WRITE;
/*!40000 ALTER TABLE `student_immunization` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_immunization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_medical_alerts`
--

DROP TABLE IF EXISTS `student_medical_alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_medical_alerts` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `alert_date` date DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_medical_alerts_ind1` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_medical_alerts`
--

LOCK TABLES `student_medical_alerts` WRITE;
/*!40000 ALTER TABLE `student_medical_alerts` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_medical_alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_medical_notes`
--

DROP TABLE IF EXISTS `student_medical_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_medical_notes` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) NOT NULL,
  `doctors_note_date` date DEFAULT NULL,
  `doctors_note_comments` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_medical_notes`
--

LOCK TABLES `student_medical_notes` WRITE;
/*!40000 ALTER TABLE `student_medical_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_medical_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_medical_visits`
--

DROP TABLE IF EXISTS `student_medical_visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_medical_visits` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) DEFAULT NULL,
  `school_date` date DEFAULT NULL,
  `time_in` varchar(20) DEFAULT NULL,
  `time_out` varchar(20) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `result` text DEFAULT NULL,
  `comments` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_medical_visits_ind1` (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_medical_visits`
--

LOCK TABLES `student_medical_visits` WRITE;
/*!40000 ALTER TABLE `student_medical_visits` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_medical_visits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_mp_comments`
--

DROP TABLE IF EXISTS `student_mp_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_mp_comments` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) NOT NULL,
  `syear` decimal(4,0) NOT NULL,
  `marking_period_id` int(11) NOT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `comment_date` date DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_mp_comments`
--

LOCK TABLES `student_mp_comments` WRITE;
/*!40000 ALTER TABLE `student_mp_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_mp_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_report_card_comments`
--

DROP TABLE IF EXISTS `student_report_card_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_report_card_comments` (
  `syear` decimal(4,0) NOT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `student_id` decimal(10,0) NOT NULL,
  `course_period_id` decimal(10,0) NOT NULL,
  `report_card_comment_id` decimal(10,0) NOT NULL,
  `comment` varchar(1) DEFAULT NULL,
  `marking_period_id` int(11) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`syear`,`student_id`,`course_period_id`,`marking_period_id`,`report_card_comment_id`),
  KEY `student_report_card_comments_ind1` (`school_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_report_card_comments`
--

LOCK TABLES `student_report_card_comments` WRITE;
/*!40000 ALTER TABLE `student_report_card_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_report_card_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_report_card_grades`
--

DROP TABLE IF EXISTS `student_report_card_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_report_card_grades` (
  `syear` decimal(4,0) DEFAULT NULL,
  `school_id` decimal(10,0) DEFAULT NULL,
  `student_id` decimal(10,0) NOT NULL,
  `course_period_id` decimal(10,0) DEFAULT NULL,
  `report_card_grade_id` decimal(10,0) DEFAULT NULL,
  `report_card_comment_id` decimal(10,0) DEFAULT NULL,
  `comment` longtext DEFAULT NULL,
  `grade_percent` decimal(5,2) DEFAULT NULL,
  `marking_period_id` varchar(10) NOT NULL,
  `grade_letter` varchar(5) DEFAULT NULL,
  `weighted_gp` decimal(10,3) DEFAULT NULL,
  `unweighted_gp` decimal(10,3) DEFAULT NULL,
  `gp_scale` decimal(10,3) DEFAULT NULL,
  `gpa_cal` varchar(2) DEFAULT NULL,
  `credit_attempted` decimal(10,3) DEFAULT NULL,
  `credit_earned` decimal(10,3) DEFAULT NULL,
  `credit_category` varchar(10) DEFAULT NULL,
  `course_code` varchar(100) DEFAULT NULL,
  `course_title` text DEFAULT NULL,
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_report_card_grades_ind1` (`school_id`) USING BTREE,
  KEY `student_report_card_grades_ind2` (`student_id`) USING BTREE,
  KEY `student_report_card_grades_ind3` (`course_period_id`) USING BTREE,
  KEY `student_report_card_grades_ind4` (`marking_period_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_report_card_grades`
--

LOCK TABLES `student_report_card_grades` WRITE;
/*!40000 ALTER TABLE `student_report_card_grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_report_card_grades` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER `ti_student_report_card_grades`
     AFTER INSERT ON student_report_card_grades
     FOR EACH ROW
 	SELECT CALC_GPA_MP(NEW.student_id, NEW.marking_period_id) INTO @return$$ */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER `tu_student_report_card_grades`
     AFTER UPDATE ON student_report_card_grades
     FOR EACH ROW
 	SELECT CALC_GPA_MP(NEW.student_id, NEW.marking_period_id) INTO @return$$ */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`opensis`@`localhost`*/ /*!50003 TRIGGER `td_student_report_card_grades`
     AFTER DELETE ON student_report_card_grades
     FOR EACH ROW
 	SELECT CALC_GPA_MP(OLD.student_id, OLD.marking_period_id) INTO @return$$ */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `student_id` int(8) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `name_suffix` varchar(3) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `ethnicity` varchar(255) DEFAULT NULL,
  `common_name` varchar(255) DEFAULT NULL,
  `social_security` varchar(255) DEFAULT NULL,
  `birthdate` varchar(255) DEFAULT NULL,
  `language_id` int(8) DEFAULT NULL,
  `estimated_grad_date` varchar(255) DEFAULT NULL,
  `alt_id` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `is_disable` varchar(10) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  KEY `name` (`last_name`,`first_name`,`middle_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students_join_people`
--

DROP TABLE IF EXISTS `students_join_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students_join_people` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `student_id` decimal(10,0) NOT NULL,
  `person_id` decimal(10,0) NOT NULL,
  `is_emergency` varchar(10) DEFAULT NULL,
  `emergency_type` varchar(100) DEFAULT NULL,
  `relationship` varchar(100) NOT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students_join_people`
--

LOCK TABLES `students_join_people` WRITE;
/*!40000 ALTER TABLE `students_join_people` DISABLE KEYS */;
/*!40000 ALTER TABLE `students_join_people` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_preference`
--

DROP TABLE IF EXISTS `system_preference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_preference` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `school_id` int(8) NOT NULL,
  `full_day_minute` int(8) DEFAULT NULL,
  `half_day_minute` int(8) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_preference`
--

LOCK TABLES `system_preference` WRITE;
/*!40000 ALTER TABLE `system_preference` DISABLE KEYS */;
INSERT INTO `system_preference` VALUES (1,1,5,2,'2015-07-28 09:56:33',NULL);
/*!40000 ALTER TABLE `system_preference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_preference_misc`
--

DROP TABLE IF EXISTS `system_preference_misc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `system_preference_misc` (
  `fail_count` decimal(5,0) NOT NULL DEFAULT 3,
  `activity_days` decimal(5,0) NOT NULL DEFAULT 30,
  `system_maintenance_switch` char(1) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_preference_misc`
--

LOCK TABLES `system_preference_misc` WRITE;
/*!40000 ALTER TABLE `system_preference_misc` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_preference_misc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher_reassignment`
--

DROP TABLE IF EXISTS `teacher_reassignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teacher_reassignment` (
  `course_period_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `assign_date` date NOT NULL,
  `modified_date` date NOT NULL,
  `pre_teacher_id` int(11) NOT NULL,
  `modified_by` int(11) NOT NULL,
  `updated` enum('Y','N') NOT NULL DEFAULT 'N',
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_reassignment`
--

LOCK TABLES `teacher_reassignment` WRITE;
/*!40000 ALTER TABLE `teacher_reassignment` DISABLE KEYS */;
/*!40000 ALTER TABLE `teacher_reassignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_message_filepath_ws`
--

DROP TABLE IF EXISTS `temp_message_filepath_ws`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_message_filepath_ws` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyval` varchar(100) NOT NULL,
  `filepath` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_message_filepath_ws`
--

LOCK TABLES `temp_message_filepath_ws` WRITE;
/*!40000 ALTER TABLE `temp_message_filepath_ws` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_message_filepath_ws` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `transcript_grades`
--

DROP TABLE IF EXISTS `transcript_grades`;
/*!50001 DROP VIEW IF EXISTS `transcript_grades`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `transcript_grades` (
  `school_id` tinyint NOT NULL,
  `school_name` tinyint NOT NULL,
  `mp_source` tinyint NOT NULL,
  `mp_id` tinyint NOT NULL,
  `mp_name` tinyint NOT NULL,
  `syear` tinyint NOT NULL,
  `posted` tinyint NOT NULL,
  `student_id` tinyint NOT NULL,
  `gradelevel` tinyint NOT NULL,
  `grade_letter` tinyint NOT NULL,
  `gp_value` tinyint NOT NULL,
  `weighting` tinyint NOT NULL,
  `gp_scale` tinyint NOT NULL,
  `credit_attempted` tinyint NOT NULL,
  `credit_earned` tinyint NOT NULL,
  `credit_category` tinyint NOT NULL,
  `course_period_id` tinyint NOT NULL,
  `course_name` tinyint NOT NULL,
  `course_short_name` tinyint NOT NULL,
  `gpa_cal` tinyint NOT NULL,
  `weighted_gpa` tinyint NOT NULL,
  `unweighted_gpa` tinyint NOT NULL,
  `gpa` tinyint NOT NULL,
  `class_rank` tinyint NOT NULL,
  `sort_order` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_file_upload`
--

DROP TABLE IF EXISTS `user_file_upload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_file_upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `profile_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `syear` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `size` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `content` longblob NOT NULL,
  `file_info` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_file_upload`
--

LOCK TABLES `user_file_upload` WRITE;
/*!40000 ALTER TABLE `user_file_upload` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_file_upload` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_profiles` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `profile` varchar(30) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_profiles`
--

LOCK TABLES `user_profiles` WRITE;
/*!40000 ALTER TABLE `user_profiles` DISABLE KEYS */;
INSERT INTO `user_profiles` VALUES (0,'admin','Super Administrator','2015-07-27 22:56:33',NULL),(1,'admin','Administrator','2015-07-27 22:56:33',NULL),(2,'teacher','Teacher','2015-07-27 22:56:33',NULL),(3,'student','Student','2015-07-27 22:56:33',NULL),(4,'parent','Parent','2015-07-27 22:56:33',NULL),(5,'admin','Admin Asst','2015-07-27 22:56:33',NULL);
/*!40000 ALTER TABLE `user_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `course_details`
--

/*!50001 DROP TABLE IF EXISTS `course_details`*/;
/*!50001 DROP VIEW IF EXISTS `course_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`opensis`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `course_details` AS select `cp`.`school_id` AS `school_id`,`cp`.`syear` AS `syear`,`cp`.`marking_period_id` AS `marking_period_id`,`c`.`subject_id` AS `subject_id`,`cp`.`course_id` AS `course_id`,`cp`.`course_period_id` AS `course_period_id`,`cp`.`teacher_id` AS `teacher_id`,`cp`.`secondary_teacher_id` AS `secondary_teacher_id`,`c`.`title` AS `course_title`,`cp`.`title` AS `cp_title`,`cp`.`grade_scale_id` AS `grade_scale_id`,`cp`.`mp` AS `mp`,`cp`.`credits` AS `credits`,`cp`.`begin_date` AS `begin_date`,`cp`.`end_date` AS `end_date` from (`course_periods` `cp` join `courses` `c`) where `cp`.`course_id` = `c`.`course_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `enroll_grade`
--

/*!50001 DROP TABLE IF EXISTS `enroll_grade`*/;
/*!50001 DROP VIEW IF EXISTS `enroll_grade`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`opensis`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `enroll_grade` AS select `e`.`id` AS `id`,`e`.`syear` AS `syear`,`e`.`school_id` AS `school_id`,`e`.`student_id` AS `student_id`,`e`.`start_date` AS `start_date`,`e`.`end_date` AS `end_date`,`sg`.`short_name` AS `short_name`,`sg`.`title` AS `title` from (`student_enrollment` `e` join `school_gradelevels` `sg`) where `e`.`grade_id` = `sg`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `marking_periods`
--

/*!50001 DROP TABLE IF EXISTS `marking_periods`*/;
/*!50001 DROP VIEW IF EXISTS `marking_periods`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`opensis`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `marking_periods` AS select `q`.`marking_period_id` AS `marking_period_id`,'openSIS' AS `mp_source`,`q`.`syear` AS `syear`,`q`.`school_id` AS `school_id`,'quarter' AS `mp_type`,`q`.`title` AS `title`,`q`.`short_name` AS `short_name`,`q`.`sort_order` AS `sort_order`,`q`.`semester_id` AS `parent_id`,`s`.`year_id` AS `grandparent_id`,`q`.`start_date` AS `start_date`,`q`.`end_date` AS `end_date`,`q`.`post_start_date` AS `post_start_date`,`q`.`post_end_date` AS `post_end_date`,`q`.`does_grades` AS `does_grades`,`q`.`does_exam` AS `does_exam`,`q`.`does_comments` AS `does_comments` from (`school_quarters` `q` join `school_semesters` `s` on(`q`.`semester_id` = `s`.`marking_period_id`)) union select `school_semesters`.`marking_period_id` AS `marking_period_id`,'openSIS' AS `mp_source`,`school_semesters`.`syear` AS `syear`,`school_semesters`.`school_id` AS `school_id`,'semester' AS `mp_type`,`school_semesters`.`title` AS `title`,`school_semesters`.`short_name` AS `short_name`,`school_semesters`.`sort_order` AS `sort_order`,`school_semesters`.`year_id` AS `parent_id`,-1 AS `grandparent_id`,`school_semesters`.`start_date` AS `start_date`,`school_semesters`.`end_date` AS `end_date`,`school_semesters`.`post_start_date` AS `post_start_date`,`school_semesters`.`post_end_date` AS `post_end_date`,`school_semesters`.`does_grades` AS `does_grades`,`school_semesters`.`does_exam` AS `does_exam`,`school_semesters`.`does_comments` AS `does_comments` from `school_semesters` union select `school_years`.`marking_period_id` AS `marking_period_id`,'openSIS' AS `mp_source`,`school_years`.`syear` AS `syear`,`school_years`.`school_id` AS `school_id`,'year' AS `mp_type`,`school_years`.`title` AS `title`,`school_years`.`short_name` AS `short_name`,`school_years`.`sort_order` AS `sort_order`,-1 AS `parent_id`,-1 AS `grandparent_id`,`school_years`.`start_date` AS `start_date`,`school_years`.`end_date` AS `end_date`,`school_years`.`post_start_date` AS `post_start_date`,`school_years`.`post_end_date` AS `post_end_date`,`school_years`.`does_grades` AS `does_grades`,`school_years`.`does_exam` AS `does_exam`,`school_years`.`does_comments` AS `does_comments` from `school_years` union select `history_marking_periods`.`marking_period_id` AS `marking_period_id`,'History' AS `mp_source`,`history_marking_periods`.`syear` AS `syear`,`history_marking_periods`.`school_id` AS `school_id`,`history_marking_periods`.`mp_type` AS `mp_type`,`history_marking_periods`.`name` AS `title`,NULL AS `short_name`,NULL AS `sort_order`,`history_marking_periods`.`parent_id` AS `parent_id`,-1 AS `grandparent_id`,NULL AS `start_date`,`history_marking_periods`.`post_end_date` AS `end_date`,NULL AS `post_start_date`,`history_marking_periods`.`post_end_date` AS `post_end_date`,'Y' AS `does_grades`,NULL AS `does_exam`,NULL AS `does_comments` from `history_marking_periods` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `transcript_grades`
--

/*!50001 DROP TABLE IF EXISTS `transcript_grades`*/;
/*!50001 DROP VIEW IF EXISTS `transcript_grades`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`opensis`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `transcript_grades` AS select `s`.`id` AS `school_id`,if(`mp`.`mp_source` = 'history',(select `history_school`.`school_name` from `history_school` where `history_school`.`student_id` = `rcg`.`student_id` and `history_school`.`marking_period_id` = `mp`.`marking_period_id`),`s`.`title`) AS `school_name`,`mp`.`mp_source` AS `mp_source`,`mp`.`marking_period_id` AS `mp_id`,`mp`.`title` AS `mp_name`,`mp`.`syear` AS `syear`,`mp`.`end_date` AS `posted`,`rcg`.`student_id` AS `student_id`,`sgc`.`grade_level_short` AS `gradelevel`,`rcg`.`grade_letter` AS `grade_letter`,`rcg`.`unweighted_gp` AS `gp_value`,`rcg`.`weighted_gp` AS `weighting`,`rcg`.`gp_scale` AS `gp_scale`,`rcg`.`credit_attempted` AS `credit_attempted`,`rcg`.`credit_earned` AS `credit_earned`,`rcg`.`credit_category` AS `credit_category`,`rcg`.`course_period_id` AS `course_period_id`,`rcg`.`course_title` AS `course_name`,(select `courses`.`short_name` from (`course_periods` join `courses`) where `course_periods`.`course_id` = `courses`.`course_id` and `course_periods`.`course_period_id` = `rcg`.`course_period_id`) AS `course_short_name`,`rcg`.`gpa_cal` AS `gpa_cal`,`sgc`.`weighted_gpa` AS `weighted_gpa`,`sgc`.`unweighted_gpa` AS `unweighted_gpa`,`sgc`.`gpa` AS `gpa`,`sgc`.`class_rank` AS `class_rank`,`mp`.`sort_order` AS `sort_order` from (((`student_report_card_grades` `rcg` join `marking_periods` `mp` on(`mp`.`marking_period_id` = `rcg`.`marking_period_id` and `mp`.`mp_type` in ('year','semester','quarter'))) join `student_gpa_calculated` `sgc` on(`sgc`.`student_id` = `rcg`.`student_id` and `sgc`.`marking_period_id` = `rcg`.`marking_period_id`)) join `schools` `s` on(`s`.`id` = `mp`.`school_id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
