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
INSERT INTO `staff` VALUES (1,1,NULL,'sudo','su','',NULL,'joe@pshs.edu','admin',NULL,0,1,'Male',1,NULL,NULL,NULL,5,NULL,'N','N',NULL,'admin.jpg','�PNG\r\n\Z\n\0\0\0\rIHDR\0\0,\0\0,\0\0\0y}�u\0\0 \0IDATx^|�g���u�y�gy{mt�E*$�4d�>J1��91!K�Q \\�k˛�f�Y���}_x���|�q{���i��o�i�Z�J��*�[�כ������l6+�^��:���z�k�}�nW׭V|��ѝv)�n�����`�{ۼ��l��j���,��r{{[�E|�i��rQZ���N��ߣM������s����}~g�g�;��O�s��^�+_�ےǔ�i�ƪ�R�2ƽ��N�]�u�w�n7׻��gֱ�m�[��\\,5Nz^�<V��t6�����7���m�KZ����xc�gyN��m����tMn[�����\\���׵�����m�X��������������h~���o�}\\�נװ�;��5���s�=�����&ݎ�����5~�א���t����c�wZ6�:�Z�����ɿgy�����!��ZO����b����$��ga͠⇔�*��Z��hYz�N������n\0��HV�ɓ�x�[���0���t1�,�I\0m\r\0���eYA�9!��������{L,\\�\'ѓ��ys0�����ܾ�^��������?>ˋ��H��5<��^l,jw;�����i�%�h���7��1t;s��<�c��7�q�K��ɿ M@��k�����^���cS� �~獛�����zkn�������x��C{i�n�v��x��m6�*�\Z���{�\r��&�pK����f��{��S@��9�s��<�\\�y��y\\[���\0�w�-�B�{��F��������`��[�Mۅ�s���m�a�_v�C��lc��#���[�\\���;��;��Ɉ߆u�c\'���w-�:��Z\n�k�V�0\Z��]��3w�3�G�;�GW���Ю�j��º�;���\ZOp^�M�F�g�~f�oӸ�jLjg��4�I��S�,���_A/�I�=_^�y׵�Y���T�4��\n_)���z]�K�,	`���;�\"\0ؿ�]�$����mf�5�	��[\r�{��-0o��x�v>Y?\\��g<3�+��`Ȧa���\r�ۿ$���`�5��hϿ��݆�.o�(3��e6�y��ά����y�����9����7k-���l�\'���y��h+�٨~<\'&�\r�āO���;;���n���p�I>�/VR	����K#&8RB�X��Xl��a�v����\0�v7�\"���w���	5���1���P����n��w[�5v�:5�\n�����_�P6����c��׌�e9F��\0j��{[U��L#o y\'���Em��U�&S4�������Yf\\�B6�Y�2d������^�ä�p\0�޸�=�g;u��|U�B��|*�獦�&=�Nc�Zp�6s�F����g\0�<&~wV�2HL���l��B������)p�����W�7l���#?�������ڍ�@��f�r7[C�$E�¦���6��p(v��B���z,W�\\__��/Su��VE=q�f���ɶ����yW���\0eV����̻*�k\n��9[.>�M���\n�zz�P���y�dp36��8a0h`0���&�aޙ�;���������@���E�5��o�;��1E\0\0.��Bh�d����1���wzsl\n�߿��K^#�7��eذ�A<��,Ky����U�<>~��)�^g��3rk 6��m0?�_�kfm��f-_fh���ƙ��^cnKf�y3�j���/Æe�k����ɠ�w�)7ȃ��\0�Aa|�����tЪ�O��F�]1��d��n�lg��_�bR}�q����o~�S�w�<��&�x�,7 ˍ�`��E��L��Άl���z^ܮ�Fx�λ��X��ڭ�;쳲�9�F� |]^��K^s\\=�nos}ep�;�U��H������|jn>�`뮙@��d�yj^���L<����W^��l\'��C-{���w�g7+�#�ϧ6�����ڼ��3�!��7���<�zn�>��-��:f���`�\Z����7�L��H��Ψ�̀[EJ�������������k����0����\n�����JO�Q��:����cuD�W��,܌�����;x`6(y\0}]�8�@����׋�B녑Y�\'�\nնJ#��2��\n���c���\'@�\n�龳0*7��{D�B����\Z�uY�p��š�&�����nԫ�\no��*U�`l�+���b|�?�o^����6h�sYk܇��c�37�%�\'�3k1y�������P�>k�|�S���\Z&��z�]�m4�0Hx��&��t��Toxl�Sf4~n�S&������Uoo�f���&#���M;��id]\0�?~��unp\rFi���Y��]��B�\Z��P�R˶\Z�e#���锽�݂J(��e��e=��{�Z\n�`X�E)0܆5l��:}^|��z��{wwW(���`֥�q(�Zj�+~:�\"T���9��;�^��jD\0��	Ҥ�B�.�$����w�=x����E��xG�;����b��\'d{��cU7 ԬV;<�|Q�Ӧ_K�5�\\-u�Ǜ1�����\0�Vk�Y��c\\*H����\'�y�����W��m�c�k��:N\0,��\Z�M��3��L��=c�������yߨR�0����M��Y��\"�Hxf���loҰ���l��}~���:���Q|��T��Ly��:�fl���Z�u���1�dSJf~Y6��f�ض�=��V�g��$��ս�N�Z�K�����R��|u�G�� S��*�^����	�������L�`�#�R6��o>�y�Ar��b2Uπ��-�a��l���!��|+X���6�X��ض`-\n�w�U�K�Lga���ݪ1(5H��a�(�~e`�Ի�a�|�^�Ӂ���es	{V�3�/T�ܢgzl��s��#�C,jYxkW@��a�y��Tf\r����<�zfe]k�\\,}�}�Bf�J9l������\Z��d&d�v�2S��Y�<G���v*�����&��_���a��zӵ�u����6&+,���o�\r�J������Y��dP�*�Y��9�7���ckf����w�Zm�����/%���ۆ�U��:[=*y�=h�VW���t�ݒ���p��R���qX�+�2r{����v�\0�2��`s_������ܕ<�ߴ^΀\n�X,�;/F�GGO@��c�i�:�\'`5[��l>@^�c��ɰPq�k�{�7jd��{=��Uġ	�ץ̗�2�/�~�D�����ȷ����-5�2�����-���|\0	��ˠ�	�M8R\"FD6��J�������<f���	���q�������v/�2(�\r$�SsN�f��4��Sk�}0Kʀ��\Z�y�\"�!�k��&�̼��M�p�R��{|��X�q�us�2������[��bQM����k>/������ٮ��%ٕ<0��\rE-�T��mi�et�;lGi��eg0��d���Q�IEl�ڰ<�sk��6�kL��p��^j�=�6m�����\ZxL2����;�\Z���4;��x:-��X��.h�Z�.���^_m����[Ȏ��j7e�����D�0`N�s�!}<\Z���(���F<��Ζ�UW-T�V����S?���U��f�d+	u,3Z��w�:�0;�Vۏٛ�5k�:��7�|�$R�FVq��\'lf�Y��ް�B��&�5���_�+.l��B\"�,2\0~T��0ix�ne!2G�\0�����-Z�z��mX��e�Ds��Y^��2�g��mXbu2�A���s�wdfe5���?�f��h��2�/�5WZڡ6ԅv�P�\"^��t]v�Xa<g�;F&/V/tXB��jKM!�t\"�g~����x\03#�;O�S;n^�Ri��#�jQm11.���L����L��\Z?�8K�=<��b^����D����+��Pv�U�Iu�=�۲Z�Uw���+ѿ�dZ&�QY�f�F���rttXvvC=���&#b^`a�n;���T�j_�a¢��PncaEZ����ZU�t�V��=�y��ż�N��M�\0�5���*�7\"/x���lG�����.`�Nۈ;�Y��l��X˨a2٫�}V�\"X\rVT3��[��Y����dq3k�����i�C�s��<l5�h���������qNTY�rӜG������XG�U�xlvĔG�x���b���6M���,j�\'*��-;��T�^\r�w�dޑ�dX6�{g\0�@��s_�����\"��l1q��Ob�\\X%���<Y�6������9����4*�ɴ���x�Xf�I$Y��bW�v����ʬP���ǐ���?�����e?�	����xR��6��k88v{�2�DΥXSG�˘������$�\n�Sն�N7<��p����`�1Nr	n�汪QyǦ������#?�Fen�\n3\0_��y���~,`�>��,�o`k2�㵛������[.�h +�5x4U�\0:b!��l�}+�q��+��~�Y�A��` � >�\\�/�������gfk����\r+�S�,�5�����6,��z�f�a�w�贃��Q7x�m�ů�\\G�;a\rfw�*����l25�꓎���l��˻�w?7��Y����s�eTa��q4��m��Gi\'��\r��|:-��g\\�/�d�Pf㑘G�ӓ\n9_��T*_����k�]!��N�9�ʸ����\Z>0��JkņTmg�H$�N\'e\np�+6Ҧ�e_�\0�*�N�m$�4:�0�w��x�;�����5]�y[�N\"�6�,�*R@�`Y�,�Q��=.^�^/�/����1�&ö�\\���������a�5##?ӂo��?�$#�\r�\\(2�٬�jO��7t�;G�{��V?w{}�;�_ֆ<�Nl�3y����P7 tFY	-l�U��+���\Z;�^T�a��%D���X�U%t\'���\'���~�5)�����U�I3r�u�̠Lo3h7�B��b%T����a\nsb��?��63�<�*3*1H�ŬLG����̧#��� ;{��l^ý���\0;�{e���ؖgi��n5+ww�e1c�r6)��;&3_Dz�޽�zŪ<><���]7��{�e�`���^�2E��*;.��fu�j�����	��˙X�b�:]��\"0?�Jx~��ɖ�CA�Va`�M,&A�h%(3\Zϧ7P��q�qf�����A$�D��oA�O�������eP4C�½�OB:>��f�73���~\";	�r�F�{�uSJUA<�M\0��\Z��)`�P�𔧴�T5%˖�$�O�&x������~�jW+94�\rۀM\n!��6j�).r��z3�` 5�t=/�~���K��J�4i�Ӓ.4���;�mX�Vx����N�@�y����J�k�S�e兀!:P��<[\"ں��%̪N/b�]��L&��C(�a�N\'���MJk�(���2?�vY��l^V�v�98*��^��_��ή�]01X�Y��ޮ�b��\\��tZ&�q�GR_O��*���@`F�#�\0���J�?(�V����3�\"���l*v<���J�0��LF��^�Wz�~!p���S�[�����A������n�]�\nJ�Y��`�/�.�-6	r>��,�G�(�U�u��l�;U�fU��Y�ިX\\\'#x-�S׼��A/�8\Z�o����,�J��z$a;OTm�Iƌ��2�b�ӫ3~>%�Ln^ۙ�fɲ4x����zg��l�g��i��e`�u�>�����0�5�|�+��@Ia5�=t��bxR<�f7����\Z3,y�l�\\�e��VKjDh�ۀ?:b��le�e�1\\�\r+�h\0X�<��Xhp� cF�\'-\0k�	�v���)a�\"�8�b�쀠�VC=��@w9+�I�2,���B������u�P����I�\rvK���h4-�n��{��pWn����͵�?ll���\'�0��?<��NF�rt�_k��˪��j�|*\0\0|�T(�ΰ*�V����)C���@�`)���Gq!��wdؼ:�������_��{2 ���.�A/�޲�^t�*E�g���-g�#�dG��$�u\n��Z�Xހ��6lj����U����P��l���k�ﲗ33�O eS��Sp�\ZeͲ�j׊Ys��ٞ����ep��*��2	Ax,��b�:wM�1pF��m0�7_��7���x��Ck�j>n�l���UBˬ�\\�^B?���#��P�4Y-\"�#.\'O8A�FX���	`Y%�x�*\rv���~�`�ZC���jnK��3�g���yP�؃!�_���\"�?\n�U�ʮV��>�v����}㪨���G0-�L����<���H��r>�J��x/�����)�G2�����l)u����`�\\^|,�7��͍��p\'J����r%����\'��w#�(�P<li6�	t�}���z��6ڌzʵR�vv���@�\"$c1����b��%�y4�Z�gBW���䬜�xY��A��j{55�R�\0���-&	��e����\0y��ȯx�F�,\0�Y��wŌ\0��`�O�dy�{�4\0xy]j����7��c��fO�����\Z����ʟ���yސ?ٴ�E��6��\\c�r{,���2�ލ|������(��D�oY#����b���ՠ�.\0�N�SݛT��n�0w»�b�(G1\'=xU=a�(v����Q�G>Q�/�����+��軚X���(�g��5w�LI?�I�V�5,T%�T7qح�ZE�*�Cٝp�q�i�}	!�e�aK��\"�?��R/�5�F�w�LFx�\n9�~ÝA���*����\\���鳲�$��Xh��vs]�.?��;@k��p|rV����LQ�=ݓG᾽�\n�/i;5�ሱ.�ciޫ�k�as;���@j ���P�2d:�	�s�=���pw��?QNϞ凎�e�Z��Fl�5�c���0l_��	�~�\nUV%�4)���-@Y]Q*P�g5و��s�u���Z^6�פm����L��5�3-Ǎ�cpp�_~NfZ\\�G�FZ���`��̠�9��f�M�4��y\rCɶJ��!3Ʀ,f�1��z�|�lX,�l��.����c7��,�;zJW�Z/��+r[;x��ސTBSjTV	]��v$�́�/���\'ͻO��y\"7;O���,^TAR��1���:^!��rs�Iq��I�f����abs1Q����H�<B� �^_�-�����d\\�vw��Օ��vwP:�Ay���x9����y������<�ݔ�B��yK�g/^���Y�6�\Zv�TDJ�,fS��\\O�=��l�z}�,�0��|�,�ݝ�g5p?k�y�`�eT֕�؅e��ӳ󲳻_fә���� ��Y�$l�D=99���������wߥ@X�F�V�<��h&�Ӷ\Z��)�8<Ǚ�g�V0�P5��dm�w��D֨������,�^��,S���@�K&g���c�i�6�諚˛٘��~�+���g\\6�^`�˲����~���y��m�\r�<S*!�e7����4ն+#�:V���nT(^*�kGPl/ݲ;�!j�` ;D.��N�z~U	-j|ͅ��6z��\"��p�-�|?#����l��]{ZT���E�\0蠚��v�z���Q�T�b��gm	C\Z	�`\"��x$4���<��ݝA��e<�����2�-���y��8h�������r��}�OFe1���b��p��\0����J�&ȳ�R�a�FUC(�����/��g��C���u�In����=\0�}��]��i�P�b_���.��G	�ă�}y$���,�{�e��)��P���h��-F|\'�A�O��B4j�XdqGp�I\0�9����0Mu��X�f�@�dm��Xv��3�Ȳ��m~��h�;����:��\rX�\0�̨��ܲfa�p\0s\\�ˌG!eNT���v�LL|����菍C�^�%*N/������Bu�>��fc�Ѓ��0\n瘓LM7�/n�A:l��5RZUJ�����n�Ů�)���Ob6�D:���f�$���*q�}eF�\r�K�x��ݓ��WA���U�Wk�L���oe��^D\n���qw��O�̥&M�p|*��Bq?9}JV�$�[e8�}�I99VP�K�WCEH��I]�L�e>���u����\\~�|���8�pt�bD�{wg7RMTFE�\0P	��1�+�]��9���h��\0\0 \0IDAT���z�%�����������%jCh ��O�v��������F	c=;;��xY�62��{���k�uz���Ջ������;!{��ăE���2�^��b�ǿ��d��هכ7���u�\'�̢�Le ����%m�qX��p���]e6��R@~W�\\���vdа��ݵ�FĨ��2D>0�w��\\&ZE��?u6��\n��ƕ	��&��)��8,>0Ӱ��CY���ΪXM%�$�nv�n�P#p(ᖆa�B�EO9�R�\r�N��h �+1\0�f��V�{s�1�}��LC���n���4��Ӥ�ڊ#�96,���9>�wo,��X�>��x�vv��n���K1\Z�pRi�������2����-��3��܍F����\0a2[�n5��;<:��\\����^_����2��-\0ڰ�vV���?,}>[š^���Q�1Ug�De��,f�qqqQ泹l`�<~�-�, ��M\ZϠ_:�k���쑾Y}B�q�0��t�á�T��F�xC(�ky~~Z^�zU��\"2�Ϝ|c���%�J�5׍P�yd�5�6k�q��(�,�G�ˌ.3�0MУ�\\��\n�߭���$�`P���-�O�����̸�r��b��l*s��xH��7��iY>;!� ��ץ����dTBB�%�~�p?\\�^K]��ց��D��E(�>�I2�F=,�ƕ�=���:Ϫ���<����sy�\r|^���ݧ&;3�ov�*`��ZYU�bC@����-߿��\"l:��b������ʀ5-�~���8�z4z��\Z����|uuU^�x.a���)G���`�[.�n5F�u��~бcp:y|(��H�5��2\0<k�/@�y��\n��d��ÛN���9~��T��V���~(�\n����i�=�;:�U�ll�\nM���=Z�9��Ym�@��6R��Ӓ����T`�7��999V>���a��\ri�;����?�0L�\0e�e���,�ڪ�I���M��\\�&`�o���0>J/3	˒?�2�UG~��ܷ�T	I�XV-+\"+�M��e旉��͠���P5�����.�9�Y��\'~�|��V3!�\Z����4!_�l>��A:��,�ʽ5�*谔��P��hdfw�!`X�J���y�������|�)���qePV|v�8�y5�%��Rȥ.��ޔ��e>#�s������wp\\vv$�w�:tc1+֪�iɻ(��7�{����~>��ӓc�ŎO�	G�r}s#{��{ooG���Ѩ����ݽ\0rtwU��2y���RxT&�\r���3�D�����x�..9���U���.��c�RU%�]�{�ON�9`&\0��Ql��>ƻ��1Ođц��ӈ����UZ\0�WUXK�Lfq�\0�q8??+��	n�	N�	���5�O�6U���d[q�0�ق�ز@m�\'��F����f[7o����k̀�x=k$~������̰�ݵ�}O��l��i�ԼjM���xc�D�cͳ�m+˴�]@�)�c\'���Ȟۘ[���W�8j�t�{T��nH�)dt�u�<�zI-4�<T�(�g��Q��nx`��M�g�����8,�?�9V�xw�m�@��ŋN@XU?	^�U���`��\0�ه��\nX�2��e�>8>-�����)c�fԣ��Ȃ�;��q?@s99=-���A��x�.>��W���B�N�4h�7�{x�+�����>S�46��������r��ǲߕ��T���$��\0X�t[}����\0����j��g4�ND����A*b���+�[���i`�5�0�/�؃y^�v �T�E��|.�\rF�B�H2���)*u���5,�8N�O����҉\0$�].-�9�?����^�t DB��Ȗ`��ׂ�MSx�b]Y�\rB���6�8%�������뼦�����@��)�$\0�L(^�o�LJqr�\'�6�����>4�½1��٘E�~��5\Zkh�\036,�D��yw�;�q�;h&���\'ZI�\\C+�v��t\r*~���ۡg�8��7��a�]//2���xUE���E��3�<v���i�~�`X jF�0��(���x؈�\",a>���o�\\�RG\'�b[\n%h���-��j>�(��q� [���i�Ș\r��}x�}?ܔ��rz���=Yz�}��d<���\\����2��+��_���#��no���Ln�b�X���* ^>��ÓLP��AQ�y��ߩR1�ܳ};�jK��9/�Ǩ��z+�^���ґ� p�b�d5�nՊ8\r���{�vK��y�1,ꟂI��2\0K0�R���{0�R����CE�0�lr.��c��S*\'��������yT_��ar�9mBT#[\\�����\0�e��aZ08x-{}�z��&C�mn_�ۍ�8�\'y-�f+�˞߻y��}��q\"�g{�֫�&\"��6]������oƹ�l~ΕU�3E#Ӧ���\r+����%�gT�av�VQ�)vm�*�W��b��Si�\'+�\'[E��c	��(WmX\\�I�l���_mW��\"�!F�\\e!J�`�����I5����Ԯ\Z����IYL�L���y��F��8˒J�X�������B���a��˯��΁��?����>����a2*\'����ً��W?����W�i�x�}���@�N�}��l\\��_��b\";��-o\'�[,,��G��j�SY��\"�1����Ƚ��R���Raـ�ϻw�$������9�=;���N+�j�u4��ac�#�;l�*M��(5�\Z��1�Ԗ��b�Q�µṞ�3�NQ���F�z@ywoXv�$�ǹ��X�ъZ8�\\.�Z�5�%1<��Ϝ��0��\r=�R�uXF��!3��&�r?�,�k��l�^l2n6�Ɓ\'Oh����i�����|�a�=>� 31���mS��r�>a6�@�/��{�E�b��J��<���$�Pv���MP#*a�$/w�T2�w$_��I�T��م�:	&�=�9���cGt�m����c�����/�������+��Igg��E�\n�\\J���ߔۻ�rz���x�E9{�J�g<~,��}y��(o޿�����g�/�����E͔���lt[��o�x�,���R���o����u���(&�ʱ�\04;�)9�ے=��QT2��jUZK�wԆ{�����::8�j^O��5�VЩ��#�\r\n��j�;�g;�Ʈ��\rd�����x�1Y����q�ZuB��A��Y���:�9���\\��bb�:��ۜB1G>�7R�F&`I�Eƅ���\Z���z\n��D��{�K^j0kfK�᱖������Rh:%Ǜ��}�.��.�-��e��Wm�V�r�6��j�ʶ;�3�0��nc�_��6��d��\'5��.�gn\"`�/�czy=����b��A���`�a���{ ��d�V<cs�s��ය�\'�0ޝ�H��y}؎���C%Q���\0԰�$k/dP�kF��l�Pno�zD�_NNNK���ɸF\0�˘�T�VY�&���?�^oXڃ�������~�+������e��)�gu{���e9�y99{�L��G����t�*��T�R�����||W�s��g��(z�����Q٣�R�Tq\"ذs̔��*e1�*��S�M��t\rお�x�<���wvKg�X��M�z@\0�N�����q㻈+�S�\Z�\0��U���2�O#��0]\"�0�2Ƶ����=6`q�J���,��؅��Q������$	��H����63����d��U�^Ě��cv��|�L;�Ff=���s�T�bvT�,�O���=����s���&��d��Wa^�� �;�Q�7�C�t5������c`���$7,Sa�q.!����W��*y����w����0�k)�\Z��=bXخ�0���6F�E���.+�Y�dt�T�ܻ{;���3�x$\"�g�2��/�߾+e�)��n�����+��������S�������\'���E9{���������B�zM���ai�����ߖ�l�t����Үv:1������,�x#a6q20��t�����k\r@F�G�cI�Nk�hW&\n�GeT�)UǊ�[���\\�Hx�?�C%�N���/@��Bg R�5�ds�d�����!���\"�@�{\0I��f :����9l,��3��3B,�tB]��o�����ѹ:0;��A�kQ,�����6���J������4��L�fdYh~���v.�A������h*�f�q$�n&!/��&D㗿��uD# ��f\nۜ�H����n�a��G�2�1���n�wޕ2����,N�pd�D�{sg�Q���\\�lX���\":[�js�@�9��8b̓똌KK;��,f�2���x�q�?د�3�%�������w��XU���7Kgo�|���\Zb ~��we<�-�^KϽ��-��~9}������eR\r�\'��<>�%���y���?���w?�P���ͣ]�j��3�Ӿ&���]��5�M{Jz������J��V\0\r�d���+���p��\'��8��2�+J1�Ԡw�&�����v�qh��$ X��F\"��FzҢg�������X���\n��K�w���^���+��G���0���ܞ߈�^�mғpy�f$����-^��t(,��$�63���&����k�@��І̪�e�ȼe�3�ݾP�93��ٱ״[�]�+�fʗ�O!�F�s�h��`-� ��\0�T��[�4����*!�_�\0l���J˽`|�u߬�7w-�kF&l+��DPj��E�̪@mbe���H�4���������?�w�j�E�M��9l��p�z�\r.�etwW&�y�����;���.���L�����\\_��������ʋׯ���ξB	Fc�6��./?��ذ�/?�c��\r�(�FNrk���=�~mYT\"�8\nj�B(%sB�ñps�&�L�Q{K��������@e�*Xw�^�g����V�0y����	���i�ca?$Z����\n]/�Z�$)>Q5T)ox\04!\04j�rְ]�zr*�������!y��5�1*��<�Z�a���gz���r�4�d!�`�Z7��g�\rޠ`���Z~<qNC�7_f?�\r��d�-3�L�6��7�yS޳֓�}���}�}an�_�2=3����Y�O�b�b��]��q�w?��A�H�A��Vղ�G�\Zov�\nf#^N�O�XO\r��\\^����!�)�2���x+�;+��e����u����G�do�i��Y�#�c�tB�C)]T ��oe`~��<�G�����ݎ����7?~W�ewK�;,��We�\"�n_���/_����2�$�*�ĬFw7��۫ү�Bdߩ�Jp��t��V�#)����$$�7��c��+����b\n��הMŕg���glo�[�Uv��Ծ��φ{��\0����P{#���	}&�U�\\;m�O�ix.y>�qA�����cQ(�L�%����ZK�\0��P��g����y�je^mv��\Z�\\��׮�ɦ20X����fpx�=��)%�:�4��M���9�ƒ�����#<̖����ƚ*0�m��,�G>3\Z�E��a��y^ط=U�	X4tE�����hqM.	��ҳXl&�ç\0K԰�3!�����lZ�w�����W:l`�\r-��%!T�ˊS���}.Pb�\rv�3��LB��˅�G�����y	gZ.�e!��X@�5�B	�|qvZ��.$4�9?���t˪����¾h��\r�\'Ԟ	%jZ��������k��\"��������N�����C\0��)10�e���(y�I�8=Ie�u\0+BNPhK`�{8_�PMd�w��c�ˡ�\"!�ԯa��)%�u���Hv\"�������\'��a���kooo�i�f�����uıiM����O�J�{�Xu�}�f� �\"��G\n�T\0M��UԦ���ĕ��������ꠘ<@]p���k�B���Yf>D��r^�ل����iٱ*�dqnGSi��s�ٖٮ��!���dX���2��;��gRdBd V6I��`X�n��{0�W�W\'jX�\'d㶬nb��bZB������d:�N隤nv�����^�v�����]|[s]�����v��X\n�?Tv��<yN��\n�1#��*蓔�y��w��G���m���[	6��������pW��|��sm	A���w���rS�\n/)㰷s�+�_\\|��|�\rv��ё�LIÉ�J�û�eo�+�$\n���7�7�~oo�;��1�D�3�pNe�n�G�g�Ѓ���\r�����D�R\\� ،!\n��Q�P;/�\r��	�\\/������Hձ�wi.�E��\r�(Mg�>Ed�@9������e��)A\0��^��YE��w:�K��j�v0�u�?:(G�G��W�Y$�,v��<�a�����鵗չ���z����ɠ�-����\Z�2pZF�&�g\nlN@3��s�m֦T�<�=��u�X�{��l��3M �.>����0��e�8��ԄFf���2�iu�T$?�{�(�1�gɓ�w#���������0\\���u�l@4�|�n~2���1��b���9��5�1L�h��*�R��΍A����v��?�S~��wb�xۄ	�8��N���ߓMf2�a\Z�G�؀Q��Z��]�o���b\0@T�`�@5���������6���������.ƴ^���k�	yuu]f؆C����l\n:|\0�/B��� �Q��!;��nU�.85g�	8Qݒ�9�\0��u�j�1�1);�lݞeh�W���50jc	O)����3�C�`,	��F����ɩN#����$|�֡��G���PXo�Y���?�\"�Q�XqP��^�ȉFQu@}��lo�ˌ�bܛ�w�L��gm(k~��5�00e�c��D �e���|/m��=tf�MY��fjM7��4�{r	sC��{!e��\"2���:�Q�t��E<��w���1[S����{��L���ܑL}����g���{��t�w���fْPO&�z5�8\\�3���qPD�W�.ߗ��]Y�;���@��D,��?8P��l<ֳ�~��VB�W�*�����/��}U.Z��K��(uFΈ�g�k�����G}>�L�(NN���7o��r�h�=����\r՞C��x����2�E\0��nԸ�\r�fS.��&\rG�]�%F�N��\0c/sĺc�V��D_���8/���1Կ��a3��9��Y�P���}1�?~��t4$P��!��\Z�2:�1�ӳS=/�;k�j�W\ZT��Q�i���A<��\ZM�5�d ˌ%C�6�Ԧ��h��-�#�k[���\Z@l��l���8��V�*��w��?9H5�_�s�Y��C���?�=1����$�� cT�K��b]#�2�֝X�~�֖ەmU\\�6w\r/P�4ʱ���\0�x� �{\"�c9�#\\ؕ�����GR�G�����(-��e�i�ل\\�K��\r���!�݇�:܀\Z�����=<܋]Q}�Stj�BHt��P�\"h�[0`�܆�b������\0��L`��\0D�^�ۛ�<Mz\r�<?=+w�w�m��w{�Z;+GG������6������0�e��;.��\0qWS�5��Z$�A?r\n�D�\"`Z3$�7�J�+kٰNON�bx����Ҙ\'@���n�T@P�%�l���֬�=j��\0[@*J��1ų�;�qϜ���/_�ן����b�l�W�B��D�P��5��n���4�<e.��ˀ�YS�,�YM58e�2�P�f�6<�i��?Ől�L*Lv2C�l�>�2kq�m��95\'w4��;�<��&R�dU�\0�`�Rro�-��\Z�8����l+U�1X��������s4qJ^-Jvv^�l&8;<.z�n��]�#�Q��N�dOUea9���K�XD�wZ�r}}��\\�E�I�%�{Y�05��\n��L��Xm&����2r)u,}�	a�o�RR69�ࠚ�\0V\0��@\r�	9�����˫�?|P�+ԤW�^�\0��Z�;d��Eޠ�W�#3Rx7스eB�><8�c��)�ʀǑqz L� ��z`��qQ�Ƒ芭�G������\n��*��p����K�#�8��$\"�]�P���3(��V�I���{j�f��s�����qY��N\nHS-����Y˥\0\0 \0IDAT�%&�%���MOi?�/1�J\"����eg���<��|},����Y�-�oV���6�\\d��AU�����к*�K=���w�lh����\0��k�rv4k���63��U5��\\䭱`6�K5����ћ�3�3+���A�z\0, E�����k�\'\nj�/8��ZNA&�:*�Fa�I9;9�ym���p_Ə�J����\r��ew�SU$���`p!�2v�D���Jjv)��R*�r��|$Y��\0«���	<Z�E؏�W�F�W�R9b5�D�_P5�>%�7)*�b���b7[�}.�Z`�\0��F2��0���[1H@	\0����Gu�kU�c_�j^�aN�q�gUp�P�)2ޘ\0^j�o�N�=�8���V�\n�y�d�۩�y��|^^�|��\\����p��(��q�Dm�~>AF�R4��0	p�b��\00<��%��_~!;�h�X�a���Ү��m1�l�Y~XY8�|���3�J�e����k�2�YP^�Y���2V��h��}��0>оLbh�e�Ă�6�*��6q�&H�V��\\�\\B����<x��SL��l<�O\0+FA� ����\0�X,��X��]l�2��:O�S���U%�t�v�\Z�v3�i�e�%���(\"�9A0Ǌ��e��hrԉ�]y��QU�>�������t�D@���Rw�����!i7�bG���w��#G��d���(-T�����Xl]2�`�A��x�l�&4�\'���dS{ux�mK��q�K)����g��\\_ߖ�cqb7�XaM���<�#�Cj��/^���mP� �C�_=s}T��ڿRXj^��,����r�Խ�\\^^*ԃ�xǋ�/ST�]1P6�v���(���[ˈ�b\r�F�O6�b^(�_��e]>��Bhm��m��Xj/��R�f�]o�do�O1,��&Ѵ{�)+��Om���d�i,�jdV�2a|>�X���\Z�|��;��ے���?;�t̗�I�K\Z�\0Oy3����g;^B��75��ø�nЭzy|\0ֆ}5�\\��jS/?3�N�E�R�֡�}�N6;31X�0��c�8h=���Q����;����-{�����9���]���[��g�2P)�8��|x�\nN���;�eF`*�n��&F��������C��d������dH��\\><�Ds�+��zb<0\Z?����dۡ�I���监3?d����	������C��B�²=�NyH���17N�98���\rM�C��^x(��e�Q)�vG��m[<��l�#�;8<(]���<����P��;R�g�uy��\0�89�6b�o�vQ��D �BڍP��fgV齖=_�_g�R~>�Q��\ZYl��HnCR˚���m\"ϝՒN��N.3�L,�.˪��UZ��֌G�F�<\0�-�O��Q�i`�=�aَei\"f>1`8j7�ԕ�<��&�N�\\S�<x�G�Ie̥Φ���R�+���������~��?�����ٕa��=�Z�ŋ��-���\\_}�Q]�,�N�-\':���(�n�<><���}�^[Ύ�\"0(�S<�\0��J�V�11yU[�\\*S����U{�[ |c�Z�\n�X�1����]��!Ɲ1���T�l��[J�D�ͺY�avr0W.��6�Ä��IXQ����5Ƴ��<\'��v9������yؿ�D���,*z�N��vv��:b0>6M���onn����1�NOU�3�����}T\"��\\?��������V�ٺ�-�岼��31E4~R��a�]eD4e&�o�\n6�qԗ��?��a�=%[&�P��|���U���RU�ZY#�j�S@lB�=fXV�,�f�&E^�u������ƻ��x��+i2+�Zn\\FB��ߋ��X,�7����o\'�Ԡ�0\0yk�>OZ��>Rc��3�{��# ��^)�I�J�;jMUv��r�$����rpx$�P[\'�L����[��C\\-��Í���;�B��a���� trx����qc9���L�&ޥ�9B��=�n����\r^>�,�������C� p���>���	h����BW��ډU�v���g�`!� ���)ѱǚ���nlP\\zαP�T:�`SV�U���6���4�/p�}�x�X�T֐�j��\n�x�\"��#��\0���P��L�Oj�� �z����oߨ/�Ο���/�����h�B�Vݭժ��{�b���I}��@`��;C9YN�J;����\\��<o�;?��}}V���d5�����,�ެ\Z��L��z��0�*{ncS�̟?E8xN���u�M:dt��=\0�8�H��y\06����	y\0`XJ~��L#���-��H�\n\'?ot�zH��k*�����dcb8���a\n�@Le@�:Oa��;�:�n������\\����`���\\���K������3<�	���ѡ�����2ŉ���q\"A�i�h���D�UH��k؇��97��T�w$��!�PLhg(#6j#lQ���7�;�X,��v�P��!����&�#�\0I�<�z�E��`��S��F!^B�*�ζ�+��8(�C��<�����f�s����\']o_ĪDU2w\rj�8�/(����s\n�||��\\]^���ś��X\'��ʩ��-���p��3\n��9��1YĥQ������C�|E�ZM6�E௓�>-�g��xF�Ŷz�,�L͍=ˬ������{m��DĀbFl��f���oe�Tfef�Ԍ3�>~�����ED7�/�70�4�^n�)��1_k��dWPY�m��y���*��\\��ّ�y�2�ڦ��XQ��}Y�	-��P���;��/��txtR�\r�$����͏:S���\nb��c<d���\n��7OqP�=�`���3�@ٖ�:�p0��=>�\"�S�8Fq�]F#ٸ0���\"���?�)A���@:K�GB���(H\0�\rPL��\\=���j�R�ή@0�q���ӱ��Rk�{\0��5��I\nPx��-@�4��G�vF<�$q]Q��0�`�r�iN#�WE��(X�?�՘o��NO�	[@M;<>�Q�q<-T)E�ShH=+\0���cL\r�E���*�7�bg�y_����\Z���;�,2�̤溆!\'�����ʐ�\Z�����8u3�\r�~�9��·G]e��k=��׹�\Z����m��YZ֒23[6���\\S+�\ZZ��&��o����D�\0����\0�|�)3�LI3R��y�@�IjzΆ���x�<��$�����Q�	-U����T�:��<qQI�������B��`��r�}G�/�nW�m�I^g\0>����<����r��Ym-�O$7^����3艝�{�t���v�����M[�t�@�)}�Qa���Q�}%���`#0�\n�+�C��m�q@�l�򅞡ϩ�?��s����{���f���=�l\0��9�\\�}�ǵǐ\rF��C\'�U��b�^RB/x�3�|O����ND�s?l���������W����8A=�s$��8d\Z�.L�9�mO*)y�������)�a�zg��1�F�YS�ϟ�ׯ^�]<�*\0�=A9Ԧ���\Z�:m��.YF,\'�c�&�y�0��,L���ɒ����L,�W�s��\0�Aʄ#6�XZ��gV�ݗ�z/6,3�e�ˠd`0���3�N�N\Z�����ٔ�ʓ�g�w�\nj\Z���ڤ��q��n���$�F�m�6�RIW��;M)�ruu#���^<�\'��Gٮ�����|Zn�.����B؜fsҷu�;�|���Sf�_S�H�&�T�~\'��,?i�v�E�o<�$C�g�2�����q�#�f\'���x1��$\Z�`C�1$!8?sL۱��^�(��<K��u�F���S�w�O�CH��: ��A?�/�&���Lz=�S���\0�t?�u|xR�O�6�E��~c;���)@�r�Q��A^_^	PP�;!���3fϞ�T1A�Z�ge8�v�m@�5>�g���rt|�~>v^^�z�\\S���9j��̄2���{Mg�$ˠ�M�kˇM<��dP��$u��m�}V��|�Ue��$I�̚61\r����dN4L�\reVc�U<_kT�F�λaV	��deD���m7v./ۣ������m3�iB�������p��d$�\"�o�m)����^/�� �dر?�}S��u.\'/s|=!�;�ogR��D�-m��5�#_\r;Qx�+�л\"`@i-�!0��Pq��8� @�#\0�W���\nw�kU���Ę��T�ӆU��W/��7�������G\0� ��T.>J�\0�����A]�M��\n��{��~P���ã���G�Ϩ�_�uy��u��T��x`M�|�B �?�@�����ý�2��N��{~~��!=����l�/_>�X�Gr5�`�?�����^Q�u�l81,�׷���,������rv~Z��fEk��E��,�s�5mj�/�J�meۓ���/��,&\"�LX�|���z�AϠ�����s_k�r{�R\r���Ec�л��i>$�>�5��D�n��\Z���������|_���.�au3ک)��o~�} ��/~��Qm�$n�ST�N��1��G���u��|A�h��/��]�߉�r�����J5\\�ge:z�Zc#�1M�;�<�s��̶e�i�`�:Q��|:٩V\nՆ�8Td�d\0J^N\\�*˲P	��@�p�fHZ��I�\'@�^B�g�V��@��\\c\Zs�w1���Z N�\"k�w��JУ�Z_��*7��xq�A��Z�~������Q������䫯�Ň��V����^CL��\\����\r�J�� g���\n4⋄ui�+\n}Q���+�;��/�K�����hQ�F?�{���x\0�~�\"��y����y�z`����0aBȭ�iqttP�=;�2�ح8\\k����oZ�{Ɩ�OO�g�څe� �ύ�W��u��,���e9��2c�\Z�*0�ƌ��y���n���2��ө9Y��P@�T|��_��tx9��A��.�n����Fv2v���S̬N򝣩�\n�;l��A���6wԱL��j��!��j��c�uh�\\��ʝ�HY@@`�%E��`�}�xL:��t����7*�����c;UvO\0�����G���˚V{V��Y\0�1��۶������x�f�����\Z\0�A��`�v�O^��<˦&�+*N)�j{��ϻ�,�Й�5�T�`=]�w�\Z���rq����2��6�;����&\Z�)qW�jv���G��;�O~����[\0��_�dR�M��p��x���|����C�ont���3��)�ֵ�$�G`^�x�0�����6����I!�����\\\\\\jC;{�L�\n�m�&,sB���y0-�q�?!O�X�;�C15�ɒ�@|�\'p�fٞ�weˏA�L$�ID�F��Y�2\0e5�l��\Z���:f�����hM50�cH��j�$����� �]��+#�$���FKy|48hnD�G�٨\rޤ�yBx��qX��k�)q�9\\R��-�Z�Fl~�m,^�(B\n80��ðP�0���ݔ����F#�Q���o�$e����]�~S��w?�C�\"_���t���p\n\\X�\nqi�� θD�Y��ʛ檴 �C]�wxt��7�F����M��ekc�0�����|��Z�]�ِԻ3LI���^1\'%\\���KPV\"4,Q���$����O\"h!�v%����ǉ���t��>ez�Z蹤�p�5a�Ӿ���w�J8��\0b�BM�&�ɹ��0l���zU�����$��ūW�AT`����E��#Y#\05\0(�\\��?��?�I��g_��a������^9;����m�>�Le��Q햵N?�ga?�g���i�W/^\n��3�0{]f��lEn%\n�!Y��S���VU&|VE3(mXMM`�lΪ[f]Y��f��Ʒ)-��f��Z˳���n���|��nԦj(�:*7eu̪�՘̚<pV�\0,v\"{glK�v2�&��L���.O��X�����*nN`����B����9�0���\"R�����0��D��\\�ܖ/���lF�CՂ\r�q3�k8��+���7.*7 \0��T����F��\nu�c�y�*~�V��˨��ӴV\'œG�OT;�{�B$�qd�|�=��1Zl�0������3���RŞG�\Z5Fϝ��t�Q�)��?X��xR���Ǉk��K%�����2YƩ�l+��ZK� e�a{�Z����k<��5Fx���0��X�g\'\'�_���,\n��5wbF�������}99�X��-�^�,���lm����e:\Z�����a<*W�W�=諪�o�C��+���TC����3����è����-��*�^�T*P�z}�a@�9��^^����`ٰ�� �����L(�NVM�����ta��e��2��^K�Tó�?�X�w.?�)��;�F�M��l�s�Y��f|����\0����yP2�t��\r{��Ob���ʇ(l����AkH\r%4�E5Nk���pW>~|��z�(�3t{�(;9�lE�G���_���������ߕ�ݭ��Ў������+^�\0CT�`S?����?<����qJ5��-v�@�\rAj*<�v�nO����kA���Hd����\0ӂ�s��e�a�`v�CN��3��9�s+�S�p8(�S8�&���2;]LK���(�H���B\0urr�)�C5�n/l.6F��m@W�b��2γ�氋z�\\�7�!5���_)Ɗh�w?(���-�j���v��.�����	�Ϟ=+{�R/:���s��eEȉ����bQ�u��WL�(\0�Ӗ����K�e�$��N%���:�VŞk<�#�A-����:��7z_�,�q��Y������d �����������1�o7�o��f�DW�(?�A��/{�٬�J��p�\\���Ò/F��to�P���\'\'?�64fl��i�`4~����M�q�}�XJ�u�BRp��9M9�h&��E�B=P��8*���?���\\~|��~�H�H����?i�*n�� \n��P�w�X�N��~�J�w1~E�04=�=���M�(`Ed}�P]�j}�#GώZ�qt�RyT?�8�]�5I��B3�S=��s�����&��)�sݖ=�vK�#��\"�8$��b���T3�q\0<���]�k9��%LwE_�z%�G%Ǝ��I��w���>���+�6���������>��\\^^ɳ���o��ѱT嫛kU� ��g?��}�Q�c4���!c����`/5]��B%\');lWa��ׄwjk�F�Q#)S�Dd��/���%��I�$�S�UkZ�+FĻ��ġi���%O��Z�����ߗ7{c��-φ �������\rx~_l�qX�\'�����/4��[��p��Trx\0\'ah�N���������a���� Dg�àٮ�:�-�Ƀ�PVd2	�n�-��(������!�}k���:�ZV�}QW=R^H�!|�`oX~��w��?�V̊�jT���VFWv�ׯ_V�R�u��A�V�69��I���mĐ�x�<�?H]���\r �dB��\0��yZJ�9�R9�cAΠ�+\0�����r4P4��*�pwWn	��M��e4��Z��\Z��h-��<Wa@]��|�J���ilԏ����{��+��0��{��Ez���R,���Z B����V�v{ww[�)�3앿���.�|��o��U*�o~�[���w�w��m���Ï?������g�$*+@����x�P~���	�P!�ɂ�RLU3�*�QBiOE\0��1N\\@={�B*�ǋ�z(FWk���i��)�m��@[� �֤Jf�`1K�\ni{o�D4e�L�k�)0�i2i�*�!ۺ|�e-��՟�MN�2r��\'3D �e��)�Q-#�Q5S��i�P9��+\r<�m��;�ez�w\03,�����Y�v�2�g�s_q�˝N<�<�#ax�0�����r�����(��ru���L���m$�������r�C��T����ݻ2�({�5��1,�n�ق�0FJ!\n�\Z��Cz�P��N��n������&[k���	\'+G���[K���~��jaA~G	T�!���;%�S����R&��Q�G�1�W�!�lM	�$ Or�X���jF�8�.A�T\0\0 \0IDAT���j���C	/�������._�U���j�`�PͩME�}��f*���w�p[��������[٦������Yj�O��������\0��_��W�_��_����X��A��3��P�^�\Z*!�	�FE�-�uP�%��3<�:��P��!X8)h���q���cN��g^�����>Gx&�jR�cm捷I\"2pm�N%˃�e��M��66YZ���l�i~��m��5+���+����WQqԍ��ƍh\"���\'#�\0�o��(-\0�Kh��(kC[����\Z���#;�rHnS=�ֻ� z�N��:�ʅڲ��Z����||����^Ɏ%P@�Q�����HmP�\Z旗��C������ۢ��\0E�ρ��&�\ZǱ�Z/Rm&���huƀw\0d؆�{`sO}��#*FP	a,PEM�/f�M\\�M`������c�D*#����qC�#�����:�T]��iCQ���g�u�P+)n����:�-b��a&�G�)7��zP�T;~,_��ƏE� j�M�����BFpjP���3BNd��ꫯ�������?r���/j �-����}��͛����Gl��\Z&��㣂W���{��o��g\n��bi[̍r?��:�\r�N*@���g�5�?^(>������t�.u���E�U�QkW-prtx�����UNt�={\r��`�6�7�{M����]nO&9F3.����d%3�l��5�{`XM#X~��`�:3��ΝF%�����\rPc�l���Fc��G�N�[v�f];�6�̾6�y�\\��Ĵ\"y��2$��ڤht�].?�/�x��n���~`� r�\nV�\03~\'��ҙ���;���wӑj�?>��)f�������\Z�{I�*�5b��GA\n{�ׯ��U�����c99?-*9����8��o�/؄�N���:�|��~��3�)�2B�B��eU���a\'��I{��ܣ�^�S����w-T\'�wȰ?�G���_��>x6B˜)�a]�ۨL��D�[�p	<�D��G�!&\ZN�Y-���Bgb0������������j=������_��_	������_K\r���w��T��͛7\ny���/���6a�{uy]m���f�ϸ�+�g*2v��sO�����b�H�}G\'ge��	8:�=i��6h�S�6N�JX�3�o6�gP3��Mq�����Y\r����̑�$����1�`k��̬I%̍�C܁&�����kP�lk[�\"�It���YO��M��`CJWCqSut[�����e�e��:8X�D��,�2�)G�ל6~�\\_��ˏe>&�(\"�Q�_|�nJ�Q�@\"�����?�w�������}鶉[�� Vb��S�T���GUk����?E�0���§���\\e#\n�E-+�����^���ʝԞH`�*���1��IJ��l�rg\\��+��S�P�is�d�_�RU8��CK;�^�\\����0ĸx^�ݗ����u;\r�Zش.�.��R*\Z!�\\�\"��݃\n����Xp���I�!T�`�3�o�-?��O��@HL�����˿�w�N�(�qB5@�wJ/j�����DT���?�o������~V>���8����Q�Z�Ƙ?��XX]ðe�I�\"�\"cL��\'_��f:v8��B�B� �V��l2�j���!˜�Gfo�av���\"�>���~�A�Oɹ�bM��K�\rXa���T�2 d�w�:�Xj�u��2�VM���3Hf$f!²���ȝ1w0��殐��� D�V�2jѪL����jo&�͔r1��i�.��T	�r��oߔ�s�-0Yq����b>�1몸�*偄��U�Q�X�{�j��޾<�aY�S�a�1veT� #�:��*<�q�k�aۚ�e�`�wִK9B���w]v�f�����CVU\\/���lN����	D�p�.Y�eo\'���Б���/%)ˁ\0p��}��?Du=		a�>lYذ�1\\�mqooG6�^�C(����x��B\rh�5��0����|��u���Ϥ2$#�1m=�b���DNz�����w?�gϟ�Ea+#=���b�����yN������qt(�	���s�^�(�n��&q��I~#	����4ϟ�T\nn��M�!�	D�J���f�R岖bfӔ���e��wd��)�1QɄ�i_�&�,�M٣���D3�Q���d`ʶ-�rn�ً��_��R�:Qc�	U��c�ʅFd���{}jNV!M�=�ن�~�i�F\'�T�1�����xSE@��j;�ؕ����*u�]�X)���/n��ɩ����<;\r������r:VEr�nodtWZu��\n��%����٨�1���V��������bP᳔���EY�#NF�](�*@�v*%��\"85��Cw+@�]r�e�yoW�#v#���H��71T�1@��Ga����U����<?{Vf�Y��o~#FF�9��cA�܇w\Z�`u���x�r~���a?�S/��;�^BT�aP���s@���o��Y�����{�m��_�x3�������	�$�vtM,ݚp���������N������z�Jy��*Z�a�0�\0Z����$~�@k�:a8+�Ot�c�m���z}���J������������[��3�d˚���\0im���5G\Zd5Ϡ��!�����L0���MK���/�G��Yn�;�1����ya\ZNUpҭ�w�Mu33��V	Ͱ<Q��	LMJ��\r�[\n���T\"��Qd9L���`#$Sya5�ˏ�T��w�����g����/�ǋk-xԑn��z�F{Ԛ8̓c����0�P�r�(/$M��(¯�J�p�ö��z���&X�)q?%`þ�ia��\Z)�&���\\\\^�s�0����W�4	��X \0&�/���\"�@0���\n�őv?\0ݙ\n�ࠌ�\\�o�)G\0u\'*�F��X��rzt\\�������\\��\0�������G���;Pt���:l^�My�,\'�\'N��Ie©\0���u{m�o�E&IΤ�\06�޾U?� &t��u�_�S��h�_��_��A�(�~0P�!^��>�B�0%�4qe�W��O5�lO�B{q�k=���,�ve�S��x�ߙ\'j�o���e���`Y�ߙ-=�{&Y���<,��m[rH��q!PHs�B&\'Y6�3��-{	�p��B_��Ԕѝ1���c��!���;��6�_S%��VK�\'{2E\roK�Ԭ�� )`��/J�v��*�6������sm�%R2������o�G\n��y[��n���/��ٳ�����[�_Q���]��BS��aOA�V����ͩ+����x�P��D��vG�-R��T��$��\n�q�1�RD���5ϯ�d�ݐ��@cl�N��D5�2T�P	e��֓T��\\�1ڂ�\\_����q�����)R�8+䪚E�2u�<��R�rx`̽,~�=ǫ�X(��/~���g_}]����nF)�e8��݇����G�+���\Z.\0���N(^��\n3!�j8���{�XN�O�����-��;�H����wȪ̮2\\Y�f��v�O�\r�f��K݉zh��@wUe޺�qc�,J\"E��o��_E��B!�p�s�Y{Z[��	��!�Y�?�dNH:������~�*��q�9y��2�כ	�0���_�G!��~�_^���%F��m���������(�+�n(�\"6%����6K\"�*-2�Ss\\\n�ԫu��d\0\nF��aJ��yn��k��{�WWχ>g\0�ľ���M���\n�]S����0�\"x���5؇�u�u/�ˢ*�}kf`����E1���֢�i�ؤ����S�$�aUD��� �z*�q�o���n��r�{����^H[X]co��pq��M�F퇯�R��Ǐ���i[�o):H��*��	�E�2�0��	@�\":q@|P�w�y\'��^��0�mE}_,�Ž�a���C1�p2[��Z������bji��dv����`e��������\Z�G!U��~$Q,-�wc�c.��o&#\"wH׊\\�ʜB 0t��V{������ �)Y�������6~�(:����E� *\nF�H�Ą&\'N\n	��pvERΫ{RԔ^�;�A4n0l}������A2?�Q}������[����3m�\0=�,�LD�k�9�S\n��՟�, �|8P+�蓏�PA�;M-��D%��>.6\nD�B�\'���O���Cl<0>2��v��(­�����yS7#b�Q^�C4n}��d���x^K!��μ6�V|�r�yf^)%��]��Xc��ed|�q�F����Ih��YY������9TR�K	���Y��l�dSJ>c����6	yؾ&�:v�곪�bW��w_��<�p����O+|�0�X`Y�W��������ϭ�d�?n;��m_)\0�m����3�\"�4�4�(��c���	S�.��(���R��5O���Gh��bfJvńQ�Z�G˫�`4�3���O��w̴~,39H�P����1��STNc��W\n�f�Bl������:r�lx�:�ፈE�H+p�����O���`�={�$j���w߶�r1g*f�Y)E\"�=�T���Y53.�Ng2�~�Y�\'��w��K���K����~���cMfJs�Fyv~ў<y�`�	�s\Zs��o�m�|��2�{rΎ?j?��S�=�`���AW!RHw �46��V�7ێ�Hw��ť�t0	qGP\0����@a�)��3c|D��ԇ���$D�:J��T��]�:��`@�$%�����w�C]�^{]���1����OR�/����`���oq���9`aU�\0���(�v��ny�:�fn�%y7P�,ԕ	�Wm�Y$��<L&�磈*�ȥY���u���n���÷_���z_��\'ϟɌ�)���~���&2�0	�O�������������\\3�;�g������\n`S\0���t�0��i�R^�r�sE�/ \'�n���.�_$�F!�o����8�����i,�K�`j��I�I��լ�3��>���Z�J�%_���n���OĹN����ɻ_\0��H�y�\\?�yX�U\\�*�¶ȧ �=�s�嗿�w0�����s��ǟ��p�?8P�N ��1+�r����a��_�S�c77҆�8n\r�`+�����a:D?��VV���cj��`nTL��AJ���������Z�0��h�UR�{�&	]�\nf�*bz\rUW�_�IZ��ǭk�k��*,�`�Ւc^)`���:.��V\'WEڥ��~[��LLi�t�L@1�,�.`�3fU��}ʭ�=hfYfLu7�Q�(]�[��؍���+�\n�G��s�6\Z���4LZL�w�Zov�F�mth}�����A��[���q~7§��\"Z\Zo���q�߄2)��4���&��t���uG��+�5[N0�+��8����E-�\\�)-�\'�GcS�:кk����`6��v}��, 4�����SJN�(����i�R����O�ݵ�A���kΥC�7��F6�e|�,{Op͗ު��)Oq2I��a���A�\'�xv=jgg��8�\n|z+��.���u���Z F�FC��}�k}��O���}����\'D��h�u\'��G�҆\'�=���\'���Bj�\"��hL1�^2@Iw�zvv������QT\0�������Q� ��U�����Y��l�$͜�O�,)��җepz��������~�V��;�Jz�u�kL��%p.S���f暀9Ӥ%��0�2�ÀRM��������s������5i�!R/�ꐫ`ō�?�f���f`e^�JV\'�M@ߟ���s2XV$kUF[x8�HgtѹQ���+\Z�����JL�����������a;9?���ta��6�a�Ag!1���%i�����L1?g��x#C��xT��}��4$��H��D�2P!�.�\Z²�	$c����:�Tv���&�\0���n>Ҁ40��J	��������zB\"}�㤇Er�4ѐ�W�yΥ��q�����}�_��ڧ��2{���Pf�}�ar$e2D(A���E�d�R��DX E\"����D`:$���Q&���ã��7_G��`(@����dBb>^^_�I��o> ��H��ݿ���<��\r.��_z�F�iy�>�10,�=Y�0h�X�شQ����Ɠ��oD�\\���Ƈ, ��XG\0�7g�R� ر�m�37�V�X����N�FMj���w�^%1�[�%J�퐮���ѽ�VO�>�o\0��.t�+aFv�\Z���2s�8`��+5�٤���f�d�]�Lr�sܸ�`�R3�Ù)R����3<|j	N�I��j{eŰ�������RN^��޾{��%��\"��8�WVڵ��DA]��%B�Zdc\"��4X�ڔ��2�}�0L\r��X\rɤD��1!��\0�IJ\'��k���2���6�b�|�h;�6��~\0aj�1���]LĶ�)�F�½�!S]@�\ZA�\'>	L1�xU\r0޹<:8PL���4���y��N�1�	H�2Т�\'��3��8��k0��=<��\"�iwH�zZ�=�Dc���۶����t�>��S�-P��_|�(W\"hR~s|t����\"ڬ��L�\0,����z� sx{wW�1�>���͹��ua�ZAg�d�0�yVk��A�L�*czߜ\\��%W�c�$9����f��G�4t�K�k�u��\0��C�Y�Q�_�7j��e9��b-KZ�nHЕ�Ď�2�Rmn*Z�xծů��P][�ޠ�uL��5�t\\{�� ,~,T-��pX�t0��:A�5o�[�?Q:��gv���������^	��㣣�r��,̆{픧��F��������P�5Q�#Ƶ\Zİ1L���)\r����lH����c����-�#�s��)2�I�����w�T�&���(���	�2p�\\���?ȁ.>��\n|a����e�k!G�@C����A\0RH���υ2��XxcS*��8��Y�\\1L�\0��\\ ��as] �\Zɛ��G)�>�G���TH��	��\\�$b�\ZP��q����km\"(D0���@E�<;XlǽRh`1ʦ�lTd\rLPZ�!3�M�<l:[�9��EX�o���.��\nX&\Z^K����7۱i���J/ú�k`�CXR��n�����3&����h���/����Y�D��ɴ&���p^۳:��e���*V��X�>d�Vfe�ł����l4��D����Oj�.&zP+�f��y\r�H���\ZL�lo����jO��m;y�6���H\'�	9H4!��3���T����1JIjS7a�d�A�\"l��衮i��[\n��[��Eֹ�q�	΍0�0+�x��FM�i8��R�L���E\\�~�#�|�t�%hŦm���u�jE_>ؖXN�7���K�RDHI�$��׍�\Z��!}��b�$܆oNsw�bD�Wd�T���^��6cm]�^���%[���8̪����)���ŋ��ʴ�����۶����\n�)_|p����aڞ}�Q��������%��]ʧ�$VB���9u��RXO5���#��&�[�#�ۃ���C-}��W��`;^��L*�1X������\r�V�s�*!����%�K�B��ʢ�9^�D��>������?G������\nPfa����\r��J+)V\Z�{ٗ�6�0X��\Z�*���h�k�\r{�QN�b+xU��9�6�����ɣ�Ӣ�3|/8��C� ��f�~��]^����ml��t<jo}��޼kw�7+v��9�Y-F�H%Ţ z�B$���pO스UK\"��Ab��m��m%�B\\�\"m��`�ə�*S	�1	3 @s�<��x\Z��ƴҗ����$ß��K��g{�/k%�,	�*�`����I\0 ��e?E�r�؝���ݭ,�hȓ���M�֛G�cG�F�ck�s��j����I�\"A�Y�;�s����3�F��#�e�Ã����:�W�{���_\0ۼ7k���v|t�^��JLG;co�R@c����o� G=M,�e>:���Y��I.�S��x6@�ꀍM�����)���\nyZ��%�X1�����{���Tמ���z�|� e��k%����oa�%.;oU3�k������|��:м؝`��4�&!��{�I�n\'��/��v��Fx����K�P�e�H��ap4�{�\\�0��ϭ�#�75��`��(��B��$K��\\��QM\'Se ��N�;lkeR�eU\0\0 \0IDAT�}H!��{+�\'�\0Ϋ���ʀW��qd�c~���7�$�nf7��q8���z��G�ϊ�6��S��D�u{�2:��E�\r�<��פ���Cj�,|�J��k�)\"��C~���W��̒^ggW���\Z�p�?L�A@�DQ9���)����\"�U�\n��J|p��#�\nOf]��m&������wx�6c������Pc���hh����\\Y��V膽�Ze�sFk7�C�߾�}�\'�L��EF)B�g�i�,?y\"�ӫ��G~|��|���m����L�����6���03�a��3�5�X�oE9���*�2뚨L�k<�q��\rRX*�-IKH���#u��c��u]k�R�*?c��\Zj����?�j˞2	+��&V��#���F��y������ ��;,T�����㹖�ݪ��*`��ʲ��&�95@�}\\=h�:d.u^S�U8wٙIG��l��ߪ�����2������;���r�ڽ�}>�\\��]u�\0@LWE�6�04v*�	,�XQFM��@�\'�	��WMU�\"Q���]_EzC�\0�$�H诳X�_MZ�M�<�L��ܷL��Lዒ9ByG��T8>\r�C��N�%���~(�F�e�Y$Ϧ/K� �UI\'��\0�YSr�`#|�d��J��6�(��J�Rp��+\Z��5�rA�w�\0����*�\nӔ�C}��\"πBs����Cԯ��W��������%v��H0�\Z�A�oۢQ+MG�ȵ�FH�fEC�x&�c�\\�a��4�2X\r��/�j�TB`pꂊ?o�Z[^Kv��5l૘R�Mu�<|�\Z�M�Q-��I�/�\n3\'߸�6#k�����Zl6�\0���d���x��W���͂4êk0��\"u�*e�@۶��%T\ZX���hv�թr���S�B�#�\rBo��\09��ݕ���j�J�r�\08���U�����\rIO*KkرE��:��e%��,JhH�L����ډ4�Q���+�Lw-\"�\\���Nm���&N�I�4��d!R�	�m�8�J�~� �e�-�s¢��p�@�̖�TB/+Ҽ6U�`�Ic>�\0�(�<H|Uf�����#�F\nDl\0\"����\0,���Z��ҵ\"�\'�?�4�V�W�YY\n\ZjKf9�QVt7�2�KsZ=c���3v$��0�qeH~:�����ޜ��gϟG���AH��#)n0�ڨV���`v�}<:j[�����X�B�7����U�H�Weұ���b�1���g���U[T|�Cǯ�6x;��^ŗ�a��Յ^)�}ꉌ���#-\'\'yrc=\\m�e��졂���px�^�f��F�;�����w;Fo]Ng����H)�O�(yOZ���be���$g(�����������_�,H{�e�9�\"�u�V�&�sޭ���~3�UjC����\r�o��Z���y�e����H�j݅���d\Z��#&\r��\'�1f�L@����z���\\/��Ɋd�K����g��D�L��@�s�QS���iƤ+��ԓX�t�cR�?���H,�7r����F���E��n��y�\\�4�\Z�_���*2�*J��d�d��	 �����!I�[�;���e�e��\ZD���\'\0��\\/����\'��C��dOdx=���ҠF&4��H\Z`�:_;;�[m��\0�͍Umra��\Z�yR� �\'��Vׇ�D% �����Ϗ����Yj���R-,�uL�b�\\�<,#���m@����zs����	�2m�����耿�ݠ�hs���_�+�neiu�+�|g�?�cp%�ʹ��>q�����h�@r��9�Tx3�V��[�yݎ�e\Zd|�,T\Z�t\'�\r�����)M9rJ;h�d����ɟF�Ir1پ�S~½��*�SN#�,��* ��A���	�4=�.\0N?�U\0V���\0;�NL+�䯔C	&����f��``�w���r�6��r)\0&�{���	��A�a.G2��	\Z�C��|Θ]R�4\"+��\\�H\r1�0Y�F7�IsI�S��Y�@���\\?����66����V FԜ�@��?T:��>�qL����9#�}�,-��0[PF0��rZC8����Z7�,4�9���=��I��U�Udk�f�׸��1�n�[>��E���w�V���]\r�9�c]8�5P)��C�a��m�V��w}>>�������P�Y�4F��x���*ܓiI]�]1��W�g?@s��C�A\0S�#D)̭�7*ff���K�:� vP�ӑ��Y(���+��v�\\,h�P�P`��q�Ca����\ZH�6A�Y���t�dVaF�\"k��4�O�LR(]��3{޶�����jTf�����q����d����5sl�˔;���3J�����8��,W�ر�B�,Ș��a��M�e-�T	q�(�8��ϖ�Q�#|��)��1zit���O��{n[�9f\n惀�Թ��é�NG:��,�ݝ��Ud`�Y×hEg!@�ѣgm0jL�\rn\r4�|F��Hi�.|�v0�S�\0mD�ˠ�E�S�]?���\\�D�=y}s<[�+��u�~\0���fUu�WzX#	FM��hh���X�L�gb��}����K[\rXvL����cU�Xw߇#>�d7K�D�J9^�]2�Yp���3���F��\0X3�Y&�!Χ�nd��=��$ �Ż�Q)��ݛ�`a���G^�/e������*]s./��ꞓ�Y�p�c�Ai�8�2�?�{-��=��А��uĄ#E`Ҷ��R��#7\r�#ؐz���g&�	��в���t\r~���;����\'��$���rw]�u��i��ɹ�f�j���,	��(7��Q\'q5o\"_|�����e�+\rB\'-Au�2�(��d�cS�������_�gg��3����ƃTy�(�b}l����P\Zﴜ�ᔏ��l��\\�>nG��iE(�*\0,�)���={]��ri2\Z�����K�U�������VK��5oH~��Rw�VkH37�����CO\"��\nXFS�\"�@����;�\'����Ov�aW1����up|^.���0/�l�@����u�Ceo�9���X�Ґ\n���L+M��kM:�֮�����:����0q�g���FGů��A\n�U�GV���9W8\\�0�#q2L��4������������H@�_`Nx�J�B�1`V<�P&��LJf0����b�r2�B���HU��9�&��%Z�K�9�#����d�d�G��[����i���Q}�Q�*���;$�f�O��i��ȇ��֔��o���o�$�I8�k��i$�ȡ�\Z2LZ9�%BygbcyJ�u]���؈�/��$��s�������Zр�X���ZHڅ��VR�L��J�{?�^��߆�}cs؞<�x�nm(e�h+c���%��Ɠ�˛M%\'u�,�V�����\nvN5�\0VMD�׼�.37__5;����U�i�FG��^�\'*`VdJ����Tt{��+/#����8Z)f�*X�o�{ʟjz���ر�a�Vv�K��˔�G�)��a���^@C<:	�������8w����ȥ\"�.�c�f���F]��`g3h$t�Uw�u�8ea����;צ��к��!�<&H��J�h������l��3�	yۤEtooG��DI:t�@�h|����R\"��X�R)���Z��Da?�<k�E������U��<\0��gyf�baEw�0;5a��������$Z�\ZO�;�>ѷ���oXI�pS�y�bjO@�<�a|)�*V;L�k�dK�J/�$t�]\\�Y4����nn=�9_�}�ߗ�*�֔P�v<���L���I�3\0�zC��;G1�hO��u���=�u��*)M�z���������f�d�d�2�T@��߷�S]9~�sx���s6�\r�\0�ګ^�9ͪf޽��P��!=A��vAWHh���e�tE�����[E��e������������W櫄įd/�xL�(�r��NONBwuH���/�4�k��pâp.���yF�P�ҡ�ʱ�\'�.v^����L��,z�;t�f���md��fTFǷmLH�a�1uY���M�̀��;m{\'X-�!�ͩF���җ	��\\���\nٝ\0�/� ӹl�^\'���jaڹ�ar��;���p �2o+菡�\n�Ì��~$ʛ�@!�/�N�cD$U���\"�F7!���|�\0��\nGB(@�\'V\r�1>�gR0�!%K6��-��iJ�^�-�E<6��.�A��dϣ�E:�\Z��fRd�����\Z0��)�P�����_������(�y��]�\r���J�\0����8\\�ӈ*{2�;|}�.LD��M�ꧮ�e�l�ZI6g1�TF���wMn|�J:�<}���{eV�]�3\Z��|h��N*�ti7��Q#~A��ն�d��7ݬ�o���⟙�.��N���L��|Dj���<�8�FW��,\\�����з���<,|_Ԑٜ�wc���J�3�.&�<�D�`^���W�.��擉��f���4\Zou�Q����e&\n�p9���4�+qT&�S\r�b�#-|�2/�Y����D�T�_��(�k\0�pl\Z��.|��{-flOD����X03���s\0���Qrߡw�e,����|7h,\\o���G�!�Ӌ�c�_a��^���3�E�:��& @��%W�������`��Ɔ�(�Y��P<QZ����R&������΃�<f~�d��kX�!n@Y�K>�jry�W2��y���¿إv�c^_�x�q�lLS,��ޠ�k1�z]������\"+��&�U� aL�R�N+�Z�6����F_c=�:Ⱦ��m�{1e���`�\0�@}���^�EP���]i���b������6���G;��F;�1�IG���7�\0C1��U�i� 6ĿwT\ZB���\0N\ZZsr��C�e�ak�����%����j$�����L�JI�QI�N�H��Gfg��R`kS�g��Oc���FsguDP��t֚�/�Y)Z�1���GC=��&	�\\u.�4�R�!z�y4�l��%��`^�+x��{���m�z��8����Z����~2E�eP���`ZQ����g�	M�����x�efH$c\"�����,������� w������	�0���l� \Z9e)�u���X�M�cR7޳�\r�s�b��?�czM��}\rb`����2-���O��􁌮:N�FJQu+&��Lu���z�\rXL�\'��Y�F�q�����<�Zxivj�;�Q5p�/8_WV�r�z�7��bƙ���+5EEy�7�/K\n8zqВ\rO>��^��L����c��K�����3B߰:�(���$�C�W~\"��=H�����S��s�`���^�y�`@�C��\"��ř��6�l��x�G`�����d���]Wɝ9�f�|�>w>ϸ�^�h�	�XE�\'��ar�Ĕ�5�K^��	m����󫎍:FuX�;>5��Tf쯮�i\r�^�N5yp���`<l��\\R�j\ZS�S���߲jkl$+��@��ҽ]Zn��ְ�1�<0\0zk��v�,=��};��m뤔��-�F\r.u3�̩Z5^�u���*�2�+aYli�w�\"?\'���$]E�c�V�pE�V�dEV!�<���EfJ�I^| w��\0֝�&a�j;�Z<�MY+Vԯ ,�R�@l}eAo\n~��D�[ߕ��C�8;U]���݌���$��)��;P|���ȿ��op��S֢x�ࣙ���J��9\r�Ȕ�G(�Rdz�֌v`��0GQФ@\0b!mK^U��3�^�#Z�c]�O�C̝H���Y�g(i6�%{]I��+E\"��3-��z?Oo<�8S}#\ZCx~����̙S�v\\�I�n>�s���z��R�M*g�w�gՄ�{�����l�0F�2�\"*2(�����E��D� ʇ2���\n��|�H2� L\\��H�\0��<��Ѻ	sT�f!���ဤ�A���׹�;ö��/���;{�L����m��Ikl!��X�f�f7�h�j�y�w��-�����U���׵�*n�������e��}p�R�F�ǜ��\r�ܪ�d��ט�Q��w����h��P���ZB���\"�o�;Çؠo�2I��m.�\n���d`�K�D&c�M2�f�	�Ԛ��m]����s�(���0uw����i����d6dďqa�1�����\"YQh.��H��ގ\"|\0ŵ���]�<��@��A �{�q=�R�N�ĭ���(x;��ŕ�6\"r���i�Ƨ*+2\0tɬ�h��|���/&jCt��m������Y]�����u�_�wW~+��f��	LIh�d¯�b\02�D��?;��p��in���\'�7G�|05+�^e�r���Õyz�ޑ��*1�����}�G�����-d���(˭�@�/H�dv8�eL���j�(3��)B8���f(_I\\W����TM�ݸ��%`k6���Ck�k��̴�ϱ�k̬��;�};���Y/����@(�+���+�9�z�+�68���Xid5��Չǃ���B��\"v��W΃U�T�\n��|��ϧ����*V}��� �\0ɖ�H+��lо��F��Qj`��o/��兲�e��.BE��s&+�ePw��`<c�2�Uy��F��N�l�Sz�\Z\Z��	�2��N�Lc�u��f�{!T/?�D�sL�p��O�\n�\Zo��G���=F�&��o5F��̙Pn��d:����>�c����{\"��ɱ/٥�#6��(#>�I��c\\C~�e�-�����g:�C�0K�hZ���?����J�|Z�i�RKr�<�U���%/���U<o��9h���B���َ�<U\"�F &�����v?o��`X������Ԡ#��<�>�����LNn<���W�����:�w5?+��{���>M����ՂZ\\&�/�i	����W�E����[0��p\"�e|�����Êd���=y}s�y�VM��}0����h��X%��E��r�<�.\0�q;??k7��r\'���ֺ�EiF�I�9�ӝs_q��@��z�	�$g<\"�f.�����\r&)�.��B��R�겒iz��cJ��Y���k�����KU�Gl\"2���:��B���f�LFt�]����\n�Lo�f��4�=�07���u�h~��B�a�z�>i?Qh�\Z��I�xn�|�(\"�V�x�e��TQ���`td�{kH9f���Ӧ���M�e{*/�H��u����>�[ϖyqE�B��u���*t�\0\'4ᇃ�5ؖ:�ģ�vrq)���`[���^��sQ���<���\nu37��w����	��\0C��7��9ߤ�b���?k�Ze~Z������d5�.g����`r6���y3\\l���*�����Da��*`y�zp=`��e�n^ŀf�W��\\wG��-��h�jo���*gb������>��h�y��g�ú�����\r=�a���F����ɬl�y�;qp��b+r�����wd�3I�q������[K�4=�T,$�H:X!���#	�$��Ի�y������۲AD�ǋl�`t��,r�.XjY@�Y#�b�\r6^XZi&��w6oS��R��a�J`8�*��S�&�]`��\0�5\Z�3��d�{/Uf�\nyb������X�[$���\\n��?��3u�9s�@*���v�o�o�����b#*�����\r�we\Z��8���Y�_���֎���>}\ZY��ynn�-��<kY��e����5YYTlK%Ϭ�$]�Q�.�q\r�7-on�5�����J0X�|3B\Zٺ�Ѩ�����Ty��n0�f�Jn�yX����|��|�5�ۃZ�����-֛�C�h�IG�\\��|X�°H�{��D�Q	�S%�(8��i�\rv���=þ�_%��=���2��R�O���l���.&&cAZ�Ea+�BFYI�)Q��=P�\rﱠ}�P���g���M�s��yQ�W� *\"�L�>C�=S�D\"�1y���E�����u� ����F�g�Q�`udm�3����\'��*���A��X,���B��92�������}\\�㬦#}QN�0=�D�ݖ���m0�ϑ�R�^�#,�uӴ��Fך\0i���m�;V����BJ��f��O�mm]9X4���7�U�|����=�����|Y�Ө��vf�jm�)$ǹ\0\0 \0IDAT����r�<*��z5���I��\'�UysY��\r��^�Ц�����s�b�Au^�ê&SE�J��j:���c�ux� I�F�/n��5�F+J�V��*�u2X��dA�ww�wzX��\Z���%lJK[k`5��ܷ����џ������mk�_\r���4�ю����߷ԏ��IE�ۘ�z������9�cq-��6��d���6�/�9S)\r\rj�\Z���1�H�P4+���A}�A�LH�;\0,6�`]ֺ�G�+3ŝ���H���o�/P��lP[�)l)d�{j�\"x��yA��s�2��l���6�LZ�a��KR�$�h�!�V�`�]ł�����m%Zo�v4�P\0��E�hO����FV1��86K\'ц��z0sJ���!iW��Q�s�ޓ{�@k5>x��yZ�!��jú�ƾ�ͱ�@�?{�����O�[}RZ$����N��n��\ru-�ͿZZ�L`�9�tt�nZI��7�\n����k=]���|����[Qٌ�7^O��_��������Ų=�o��c���}e���sM����F~��z\\P6�k{\\4�N9�^Ӈ���O���[���$���M���Qp,�\\N�#����\0�-�®��C�[g�Ikbdw�1�c�?6�7@��<����P�I*nf�+�#zh�O)ğ;~8�#��\"�7��q�� ��(;����X`�p-Ĉ��9<o0���ݔ1�|J\n*�DÔ>�,i��FMi21~^�9�9��geMs%$��o#�u�__,\"��+p]��(G}:��\'���H	���_��Z#��u��y\Z��~ؙ}[Qs�����)��ycC:<:n����Ք\'�j��2o�;���>k�}է�\\h2˱�PrU�0�(�>�o��\r�Z#���uu����?���U�d�ѵ�t^g�W��U�����\\Fјa\Z��~#�.-�\"|��FK�z~M�R�^��7]m�.(�tI�߫���4�����j�8=m\'o_�d�GW�����|�D#�o�?Ҹ�z�Ꜣ�M\Z:	4,&~�kJ�s�Q�3Q﹞����E�������p\'�G�pX*���<kF�(��b�)?聨$up`ڬ=�1�\"�=��B����+������0�����3�T�棘y6g���q��:��	��El�����d�x�\\��ٍ~���<����!t��b�=D�E�P��Z�t�:a�����	�,���Q=�`P�g˱\"�0������A��rc#@��v��Z������������ٿ�՗����v��ɢK��ᡘ7\Zl�3��U7�ћ�,vD5���y]���cd�]��8u���ص���� ����\'���oР��d�`�\"��Bv-3&`����t_L�̒��Hf@�8��Z�`�4`uSL \'L���,�g�w�=�5m��>��ٻw�[M�|ru��ߌ�*�U����ʥR	�X�{f�^���<z�(��#K`�ڈ2b2���ʲ��>�\n��4������Myd9�<0ߢa���f�&���)�D5�w(�u�\\�#o$uC�.-�u2�uJ�t��������<�ێy���������X�z�3W�Qu�-v\"�����J-$�\'~�0�ܩ�F�^�Q�,��5V�K!ҷ��9\\\Z8�c��T��Y�lE��>Mk\n�W7�j��ن{���G����cU/p<X���í-�?{ ��l�WA����S�ס_3�֐םA��m02��}�����=�����u��ꫯޓ��Mԅns�T/�|fX���ฑ�Ͷ\nxՔ�`p�\Z]1�T�y=�u��8���Z��5�>`������0�./Nۛ7��p�/YZr�H]^e�-T8�\Z�&�r�zk��ͬ��9a.�3�����	C©�Y�n1�$��2�k�FDY�J�DP0��`q��$v� �<j��-\n��݌$�\0\'V��a�]�;�4\'H3 aXѵ0���T��L\"T�Z�\'?��uw�X�����\rZ�{�a�Q7��ġbA�\rƕ���������Pr�6��֐���$jD�\\AL�\0)X*l�\rY~Gj4��\n��g$E�26Z�R�\rM46E\r�2��ljހaaz�	�TY���s�4	��{��7��{�Ύ�$*�>��o�-\n�%o@�5XA�|���%�X\0��e�}�5f�[�oL螿�Oo:�w����ǩkRk�믿^H$W�QoԶ�/λ��v��\"��R9�J=\0[<�9��\'��442�C>\"J���MO\\C֭����\n��-�!��`�|H����m;9y5�cTT#��yM�RL��¤������m�o�o��\r���̡�%r~�ܫ:�d2��/(�(�9E�,2t�]�\"\rue����>�y�ת��I��fAZ?NQa1���P�8��8<�<Å��%E��6�-?�E�$��fi8��1]$�r\'G5I���=��>�Tt�\'+u��r�s�q�3�\0���lm���g*:hc\ZR-��FM\0�Z@�TҬ\r в\n�yw�_���P� EeZξ���4�����8z��{&?�(�g��\Z�#���~�8=kGG�mog\'�RH�0̵�5�9��稣�ה��f�����u����P\rP�}�&ϋ��J&`�{̚m�*�\Z�8^�������5�L�����eB�1����；�!T��,3�z�\n�������7�{t;ng�gj�E�9�x�l�g\'2�\\�܅_g�޾z�����u�Ƹ���٢ժ�\r�m�8��bz��#<�P��]l�,M4	E�A�\ZMP69K�U*�GҺ��W��0��]�f<��0���X6��;o��7/��B�$6=�Ź�\\7�ȕǲwz���5�4�����0bw���^��\"��t-�U��5`���FiR;��ٷ&\r-���ZL�b�\'���$�������LOG���DQ�<b\"�����h�Lm�wZ7���6��m;;�mgoOE�JD����p؎�����~��&\\�g]�Y���C��kN7����+��3��������X�`�%9�Ks�ZB�/T�SQ� a����(&�2���83�*/�4�T3�;y����;��S�KK��h��������D��G��͛w���举��@J�����8>�{�0U���ɉ^�o!�Z�f��~~�\n�g\'r\r�G���?Ga��́��oq�F8��ĔQb(~�(���\0�\"	��°b��3��C�\rVep��np�����<�s�vvz�k�X*�$�z��󬓳n��r*�$Jr�oct��:)b3�R@�HD��6���G��I�ʅ�T�*8�\ZPZ�G�Ch�/�	��\\21��1���u�?��:��)��>K>7y �,Tn�NA�\n��TE���G����5�=M16��p�}6�I(vdR�7n�Vu����k�����|�U�uf���zM��ǫ����yT���@T�e��@,��9\"Iː�نO��ԓ��w���/����p�W�n��Q[M;��gggV�D�z�]p�N�����*�2�yׯ�L�9��C���Q�qvd�6�!��e����i4J%��ҝ�a��U_��(����$9W\0������gr/J����<s8��`G3��`X8f����9)���k2Ëh�f�R+��ɤ�QX�Y�#\0��,�� �;��(\0N?Ԣ���ByN�ԳM�����]���ް�?�V�y�����?\'��\0�`S���_��`�9Ʀ�\\�T4���)��B�ӏ�1R��Z�\Z��rZ4��6\"	��Vgj��%8ܿ�<j$�y1��<�LIc�\n��Y��Co��,�a��I�b��	��v��>k���a�������\Z �u�(�B+	�<5���:�����zŔJ8�������s�ay72\0��^�/��Ɗ�^�q.y���ÒJV�2fY]P�y߻�,��|0��R+�K7��]wu\0�ﺓw�SA��Ň3���ͭ��������Ju[�^!�̽´H�c�_������j%���=�{{M���&�c0���X%� ��&G�i�-�5(gHME�d*ha��ʤ���!@	�J�$@@�B8���s�f���=���8r�i��̝��aa�}����(��B�`<)A���f�}Z�az���	SA�%\n)��r&�HD���\"��8*)\n3��X�c~i>)\'X�����jcΤTR#�K�\r�HTU��̌�i\'�4�6hS�Q>]�by]yz7��@���#�A5�Tn&��ޮ6���j�0ܤ��@MSif�r�l\n�\n�\r��2���A�����0��<�l�y3��q�^;��.fie]~��-��+�T�LJ�2�����T\Z^)_6�7�1�x@$�9J��&�s���ъ��5�C��P>O�Jg���Q�^*��`��.��&G-�2t�V{t������t�\'��v���~��5��I�dѸ;��FB��;�����0��ɾ��B��wB\"�\\ǡl�Ÿ�������c�ͮ��\Z1l$�G;\'ɯ�	!x���TM�\rj5ީ�l)�����U�sk�!�U�,%�!A��/orv��P��^(+��Otۡ/$���͕�,�$~HI���.�a�f\nC��F�?j5�%7�,�VP5�#=s2dm��\0�0	��W[q�������X�H\rC21V��AFqbu3��1��9�c��o�H̠Lq��i�7�URe�k�s�s�k��q^k��0�x}{�x�������]��m%\0G|[k�mjiJ��o������貏.����\nj�qq3�σ���^|��o�`5՜��k]좝<.������}�.L���N�����Q!�M�T��x�F�FG��m6�m/^�(\'(\ZX��B���������(�2�TI*\Z-�~�0�Y�j�r�j���8�^�w�1�A�Q|��L�N������3*��`�b0��,��\Z\"�4r����gl\"�L���H�ȉ����^���7\0k�P��\0?-��x�*�^����9Ru�h1���ќa�B���,Λ���J����21I��P�0�j�6�(�IߤR.���i�=G=}_5����Sg�Uu�Aß(�������[����֞>~�v�5�p���P�9��m�S�IeYu���VP3˩��/;�,|vu���]���������u��:�X>Iw�Vʦ�)S�h[��H[��#I��IuM#wel�*������?d�u��~`����u��q����2���;\nV1C\"���߼SO���^��s�?䒙��<���;��^ZO�;��}wr��AN^�K3�[[��&��P�\\��w�1��(���uzN�h�%D\0�K���ˋx=���� ��a� ���nM�g�T����OFS�Z�%�R�E�\"�\\���M%غ����a)�l��${P��JgTwHǘH�����ڭ~<R\'�f@�QttY5!F���=��JH�S���R�!�sJ������=z�d��o�}�ZL�4�5\0-���H%?~c0�o�A_���,�1]�U7l�w0�5��[5��\0��ymx7�xө����R�P�8���P�T�٠����zf;ݛ�/�7i�03���N5�B��՛�u3;�9����(�Y��|]�����ޥ�\ZH�\Z��O驇�Z?�V��~�޽��������L�\n8܇�[b`0%�0����F;�vuzz*��2�Sc^�lIа��\nc�ehG\':\ZI)OH�Avs��_�jI(��F�*�F�jt��	�1p0i�+Ń� �������v�N�Bv	6�k��\n����3��*&u�$��h��|W\0.Lj��-L���B|�(�`�)G>���y�*�3ʛ�#�mlpdJΒI���c)���o��p*�W-[S����4�A40���P|uE�\r�n\r������+7������$\Z<���}c����E��\\8u��Ij6S��jw׵Q�Vu��E�����cP��?�5\\}e]���ӱ�t��`5�*��d�|��)�Ak�Ԡb U�bg�>,��l�~Ϡ�k�8�T��ݠ��~�z_6��h��5����A��&\n˫Ć_=�4&�i��7_�7/~mk�;y#p�����^(_��$&���a�ߏf�ZPwcu&��L�J��*M��^���%���ᜎ��|Y,��HW��|O�ˆ��)ڱ߅�ga��zޓ�cEt�����?�1��fӀ���]���H�)���r{�����d6BJ\\��.��l��!�a�_%���Y�0�0�4��̜���b�Dَύ���\Z�h�J�7�qE.W��ЌХG�ai�ع�2��MD���0�qf����=̋~���죏)��n����>J���q�l�\'��`\0�(��TӮn�^��2>�A�&��?v�Ć��Z������۪3�Xt~����_2S�-Ym�:e+��������M��xw���]�*�vme���7WMZ�J��\0b4�O�,,�l���hє�E�T�/���߾m�\'o����B4��H r3gg�RS�=\0K�Gw���X��s�d2h�����������댆�V��e0�QD���3d��+���Tż�����_��H��_����Y��7�XQ�����Uwl�5�Fb�\'��e,��M��D�zQ��m|t:Xf�T=����{	��2QT\rI����t[0%�*)M�H��?Of/\\/�O�\r�Ϣj��m��x��Yݒd�&��S�ӣ�;����O?�\\��W�����q;:�]4x�]7_�/�g��\rޯ@�\0��9۵bX~�՚�$ϛJ*�g|Ί�_��	��?��?-Js>�.DɗY��|��]p0�dIF�uN���l�~���q\\�Ro��dV�Q��d���\\�は�!�R���$�2oRk��o�Ż�����mcc�,�0+굺�nTB�S\r��Pt\0�][	�Q@�I`��T�&v]~�	�l���5�MU:=���]J��x��f���T#u̔��B��]�=��&��!J{b^�	U\'�\'���-��x�r�ٗ�E�g`V�����(����3ӛe�=�H��y��s<�r�g�b	�����K��ݐ1�\n�2C�i��`��X�ye�0@3��Ll5DN�#��W��(\'8�,���{8m�w����F?D$?z��=>:P�Uw^{�����?[3 ��IwmU,0�T�V�[����u������q=־F����/t��N�DEb_X�q�#B��	���Drw0+���y\\�΃����w��RM�ǔ����p�gB!z�=p.%Z�G����\'o޶�������������vr��aF{�����������N��ɷeS����M�_3�� ހ��Z��b��{J�0�{~̲K�S-;�(N�j-&C�������1rΛ���m)h�zO8��~n��.V��>)K�`_*\'�ߛ��w#*�4�a4ꢣ0�2��x�����1~�xIJ��Y[4�lY��{�O�2������`8�c�u=ɞ�}	�����L$G���؄���@C���6��/���^\0*�a���N\'���V����3̦�K]uQ�y���C�����k�����}���su���������瀿�u^�A��6_�E���*P՛ӄ�D�J�|c6Oj��z�fD>�MF߼���I0^\0��\r���y��2^P���ޖ�>���G����7���vuzҮ/�ۻ7��A��<\Z&Ȇ�0ǊR_�u`N�>������)�@~�՞�`a���� ��J�Vvav[ߗwp��+�\"�(���}�|e�g���\\j�f4������UO(/��������\n��!/�\r��oe�l�Yw����N�v�!����\r��0`RHd�����C��\0,-\Z%��ש��05g���c\n`IW�T�����o��DG,�\09@6���Tܕm�T��bQ�:h�~��1��5��\'_	��ms��v���~���S5�H���J�K��[��7}�[��$���ee��\\v2���5Tٖٯ�����]������]j�P$v�_�}aݛ1U�����1�����w*�MTF���\0h3�y@̨�~���A=t\"oYk�\"�t��//��/�����mc�׾������/�����~��D�n�GmggO@F�εh����Eyj��=��d��+M���DA�4�TZȚ���7�AD�j�BN���AP�?VL,�-�.1�#?,di�̣�+�\r�T�KR	�\\z��D���z\"sRLG�sWu&�vY0�RD�> ��3w��b熡�l1�S�z:�TH;�L���\0\0 \0IDATBmF��\n�k5_�6�\\>\"��X\r��H���$j�l����$Q6�lǥ��J�)0\0뒖�$�̺[�c�u���g��k��E$���M\"ͅgL�����$�&�[����v�����+Ý?r�8��Y*Æ��ҝ�\r�M�\n,u��u���͔*�T�3��y��zM]�槭�z�Z��K�E�����>�����~�@�	�(E�V�8����.+qv�`��8����e���7����?t��,��B���6ڍ������Ջ�_]i��?�\'�_|�����OK�a:N�nrnm���!\n�����¬1��E9z�)�����(2�+p��Ȥ=��\"��ԝb1k�&o��ɀ,���æ$�lv�Rɥ�`)\"�DӄΚ>?k��1�#�C��L3��\0��~!�\0,�Rϵ1�i���.���s0[}�}�����o�B���4?\\t.=1��(`&-��3��Q\Zm�0[Ic��n�=�TdC!N�\\���@bS�-v�{�9���(���&����vq5j��ג�����O�v�w��Ŧ�^�q~�-*�,K=��D]���&!��r���촺g�nM�xQqb��J�M5��^�ƥ�G���˾�z��|]}3����̰T̛\n_`�1��;J���w���\n�u\'�;�ٖwT�(݇���\\�����v;���o޴����f�vwy�������h����߷��?�N�=�8U�=̯����_C��;.=�u>`��wnM�ddZg�@i1��p8���l8:�d�)I�d�� p��L5\"v�)/kY�c �q�5{�y���s��`���v�����2	�&��;X���^�:RI������ݓ�y��b�\\\n�m2U�������+jq�S0�d$�́��Q��#]B:���A�!�v�.���7F1�4a�J�H?#׊[S���=�D<�m�J�[*�\0�k��������7��+L��D�Z���k�{�;���WR�5�ͭh�U�뒌ʢ����=*0z=�X���~ �Se<��u�죂V@*��s=� 3,�w�z3u����X���b*�(5��ȌƻJI/\"����1ܻ�fjú��/^�������ꗟۏ?�����o�\'�����Ե�\n��nހ�գGGZ8��뫫6�}9���[0`�=�������8v��:$���hva��k��g[�GY��O�ؖ	��5�\r63��W�x�1�;SW�j.�:ѝ}�I�P(sJ�!�3��)%�a��L��8�`�j����BQ6|h���H3�G�������rb��d6�uD���|�anMRab���=`Z2�0�`Q��x-�[��yn�3{!zkВ�r*[؏��u{w#���`K\n!����\0�_|��\r>Md~��~���p��6+�3���:�����ƺ|,��VӮbI(�x��T�\'�;**�9�R׉I�Io��\'견Ō�x��f�©f0�b������]����bZw�\nZ�=�}]O�:P��>G6� �t�	��zq)m���e;}��}�O_��t������֠���ςY�@\'}������R5�����@����&�\'O����[����cR��d��Z�~�)2D��<�!ݞә{sK�l�R���vl1�l��}��R�d���i�d��w�X$�f�d �&����� �S�����LL@��sΜ�1q�D`K�*\n�c�B�G�*��)��B=B�*�/�H;�ѶR���m��r�ǵ�ߐ���\0o�������W���-�1<N\n�HVy����:/���䋏�6_g�2Oq������ޞz��ܐ#��>�E��k���,��������<0�U�f��5�{�D�~ƠصdA�g��+��6_s�hAW��(��;f`�@]p0�Դu�ɝ�R�. \ZȜ���u�er��J3�`�`��� �\"�|��\nP�`���d�ޝ��˫��0�k/����ݷm������������w����I�S]q$>���@�]�ӓ��|�`�.7�)=>`s�\\\"�bЁ�zC��u��.��c�{	S7���a��\\�嬆���\"\"����(KMT��$vY�a2.�����Œ�5�̲tL�y��&?*j��c�\Z�47R�/�)���ݕ:�d�G1�u�55��MYΫ`A�/R1��H<�|)��Wt��78�c,UjA��Y���T���\"öTz��K�,K�P�E���8(GoF�	���Hzk����R��{�[=~\"m�\'O�ǏK�a\r�\Z�a�;27Tk��e!��0�Z��JLB�]7�J�V\r$����k�k҄�F�����Q�W׳�I-ae7�&L�?(����f]��|�1���Vzr���B=.��]>0W�/3������B:b=�#�����X\"�n|�ޞ����D\r)N߼lW4�������/��������߷9�93Ƿ�S3R�{�����F��`:���^�z��n;8�o;��!��BjLD\0x\0+��Kߍ\"��U�*~�4	i\'�kD�Ԟ^��*q��W�?3��PC:M����JG��\'4�t�E��h��=��D�H�$@�g&_R��̕L��Zp���ɷ4�*3��<�,,��k�\Z6���(�\\v�\"}��߶��a�N�_0$�WW#G�$Q`\"�4MńD	4��I Є���)��r��O�o,ia���FV~���#����ܴW�^I��qָa��Z�n����}����o��qX�jbL��Z\\���k֠UɁ7��]r�g�`���پ�t�=�tN?��[YU=�����`�u�X�nU_A�_��\\���m��{v`{R���3�[&�&����6�̼��lE���>V{��X���W_� m@��S#��	?_��41����m<\Z��g�����M{��u�����Ugh��i\rF(�ovכ�Ѣ�F@=��ˋK�� N���=i]�X�J$��OB8�z�S��j\roV�|ϭ��m�TM��\0Z�eM)N8�ç��XL	.�\n�	�Qμ���N5�j��F.*�EĐ�󙐿�N�212��E��B�����렬�^7D�\r����\\c����E\0`����vpp���?�N�gv{�6�H�E8oSp��+���(u�II`<Qn�\0�<�+s�	��lȿ�]Y��v�H�~�V��09�*�&��#QC��h`)!eu�=z��}���2�\nXK�\n��.U�ZMPM}�\'����׆���{1Ts�Z=�	3)߻��Ǯ Y���/7��f������w]�>��K.��ד��u��\r\ZL�%6��g޷�����W0�(�A����E��H��-�+���|�4��䗠?��ɫ6�E�l����7���?�������_oW�����m�IUvT�F�z���p�b�1^�}@k��#��Ƽ�ϥ�69�R�A�H��(�:�@�ST�	,���<G#eM�`X\rBm���c���A0N�Y��b;�l��/��f\05�h�v��/���o����`����R��+ϡ����L��ia��g\\c\\s�B��#4�^�	>{�L̏�j0��{L���;;m�����E:����qr_�����\r�T���˳��h3�s�B���bM*:����*M�\0�1�uN���e��Ʀ\\�a{��y����ԃ�(!��ޓ�63}}�v��j�y�\Zh<�+i���K�b����<M6��l�T�g�����=�Ń�����o&�o�ڍݛ���6�M�+��״�҆f;?����@��fd7{�ߦ��S���lrvA��7z��.t��#��B�\rE���/.��|z�.NO���C������՟��^�x�zӉ:��������̦�=]�����G���]=y��\r�\r1fɮ����\0V,&���(�ץ���im5�\Z����]�����s�,h.	�����i�o?KF��\'&�B\\��Ӫ�gg�HG�XL|6���y�ݞ?���R\ra�\r�:���f��K�,�4�N�4�f����B�;M��������܄}�{�N�����u%�����M&h��~:ʞң�8_̋�V_�G�?�&,��47]�UX_���f�Έ\n��wv������b]l0���(\'�V���o���Y{��ذ�K\0k|�6���������>SWp���a�3��&��l.�����6�ѵN̘�z�k�2-���\\쩬���k�x�y��j:~h���h����`R�G�j�@��oW��\0+�t���s�7�x�ŷT�m��T���S��V�e�g�b�:�f�z�2�\"Z�rxP?�N���}�����[�PW����}��7�a|+����Z���k���R�`r��dtۙ�D���� �[��?i�Ǐ[/A���u��a(%`�m����\nf��O���>л�h/_�l�^�l��\'�\"?*��ۣ�k��gt\rs��M�D�̓\Z�@[\\�0�A�S���K��8SB%��</L½����o�lG��r���Q��Fj���9�˛H0L�>}2r�㼺���\"l�0]��A���?h���(f�q͘�b�����V\"+��s���\r�R�D2�[��B��?��\0�}I��my��0W*����5�Po����2f`/���3y�(j|��:ԑ�o�ү����������\ZH���/0O����M*K�K�/�b��ۭ�z�x��|����W��Z9�n����}�ۿ+��e��]����ĩ�ο��^�\\������*�V�NT��¾p#}���^�o����B�5���S}��sH\\r(��i�?$ú�P(���_�&�O?��]_��?��?��ݵz���F*�f���FQ���n���2TJWV��E+������*$�r�H�#�%�9�1_�n\'�܀̂��\0\'�مo2-9A�`bkbwD��׃ip_w4�@^Y��g�4�x�G�0��i̛LI@� �S\r7ZOb�Լ}��G���~#?̋��o]�%�?Q�ht�v��1\0To\'�|{uy�.�.��7�����|N(����<8��_��}n�Zi�^kgWW.\0�e#��jnB\0ek���mc=���/E�}�Cb&��P^8~t���4�s�G��[��\"�,��w���7z�<\0x�촣GO��&��[�۞�}/�5��M��z}ֵbK��f��Yχ���9�A�`��_�`UM>ZxߛT�����h�¾���ye7����1���o�;�/�`��!;�Ti��7�4c2���Q��>v}@�&�y��`�Fw�iEu�>+���xZ(,�ك�?P\"}�ˋv=�����]]^����C�\rm�N޽ѢPd:)d7oۃ-9YG�<\n�?��=~��mw��I\"*J3gg��R���\ZE�w\0B�\'oߵ�~�A\r\\z��8i��O��y���:=��pOS� �ъj��Ɠ�b��>���e�t�o,�?�X�<��cqxp\0����|\"=r��ײ}X�KaȑƠ�$BR����\Z�\r�3YQ�5r��빾��o߶��\"x\\�ѣG���=>~ԮoG��b���Ξ����U;��J���6%����2B����I6<�0�|���d����l)p��tO�;��m��a+��g���ޞrŢ[у�2�냍vqy�޼z�M)��]e�o�m�����/��6�����ɧƾ\\�~�k�s���ʊ>.�	y�U�����Z\nX69w�%��KM��>�6�\r.~��#�\'7W���ZE�\n^�\0���گ����Q�)\r5[�N��ffW�9�>\'��A4h��׈\'��\0,L/ky#�<o��%�^���W\'o������������/힮9S���&�t�?VW��p�����7�N���֦������\Z�Ս��Eg$}�f�,ɡ>Ǭa|\0t��ח/��ׯ��8�ꫨ���]]ߨ���e)��]�����6I�tޕ K?�i��\r�\'gt�v\0���$Y^�\0Q�G\"&&fv�QQ��C���i㻶;���=X�T���U#>3Ý�ZH�rئ~�gS\'�^��������\'�����h`���Fw�v|�HI|}����!����\"�/_�n9��>�4�zџѬ���Ř���j<��V7ŝ���L�o*���9P���ѱ\Z�nm\r�i!!��!��L/^�uC�P��%������~��/��֖�w�������3N\05`��T������^��L\n*�x�TP[D=�B3N��f����Zm�z�v�����k	� \\��T�UO��ת�ȠU��\\4VH���W������N����|�]_�o�׽�pM5��;�u�ߧ�8�{Z,3<�Y<;����覍o���^]�ã��_��?���3�&���găB6���5I�r6OÑM$���m�D����1�4H\Z�s���j\"Lg�BM�֋�S��,�\'�W6�ɇ,\n9F*m�O3}�oM�Z��j�7e��=�#�4���>ƚ��sE�>͘�J��a�\r77ۓ�G����<$[�&3Nv��E��&w���[m�#$Yn�]��7_���Q���U�	���i�D�u6��Ȳa�\rw��Z_2��)ҙ6 �6�U��Fhǣ������� S=H�\r�\Z�w�G\r�>��N����7c�s�j�b[�1z�\0Nt��xV�����FV�W�\r���N{���m��־���3�R��:<�p�\r_yv����k�.����Ɵ1����l��5��Y������kp�k��[e�=���a�!3�^����a��>�?��M���YE���j��5�Ÿh�P¨���z7����9=��=8vuH�uV�˺�����\0�؉UK\rY�Q�E�ɼ�kף+�L�~�U�:?i+���Hl���$䓇CՀ��n(�H����}��Ik�m�Lr���㊞z�d	|V!�w�⽾j7��m|;`с\ZuD�̪�<��吆=1�#BvO��^�`n(e��\r��8�pD� ���7�����!h��\0,\"�8�WW��p؎Z���=}�D<@�>op���&|���I~�k���헷oĔn���`�L0~.��#]a>k��~�j�v{?��6��4���	v��9@��T�ֶ��G*��B�͍vp�H�X��f?��m�l��\'O�2c�)�\0�ͣz���_���I����S����V{��#�5l�����X��%s:5��کD��Xu�xc�1��g��n���\Z��VS%C?jaKme��ʩ�U��q2�����Eh�Z�x�|��E>�/�P\'�|��N/>��C�^�x���9���u�*�\\���Ȧ�|�&��k��Fh)M�mhE�t�z#[��f�v�0����`}��?�E�S�\Zz��XQ2nuhLBםk��?h���_����6��5��7�d�q��`��p��!fsV�UWWr�_��\n���2�Wp�G�\Z����+����n=���\Z��`�5��XH�!a~(jK�F���C�ˤS;\'fv���z�y����v���V�Y�ERm�^-?	�!��� �v?�zG� ׄ���켽:;kW�bX 	�\n�� @�-RG��f֔r������:�f&�34�V�fmU��6�~8��6�{�<�?�e�P��w��Ck��x\ZFP��j;{��|��N���ć�&���k��y�=���O?��}���2��-��X@��-�sٖȇ��j�Us��[;u\rW?�_��g�ɯܪET�C%+���_�y��a����M�*��0�U�2�\ZԘ@� ���Fڈ��Ĳ`�]�C�!�30�k���k��R&��6�_�> ����݌\'ڡo�����p���Oe�]������v{}�^��>��6њINr�L��q䮭�9��o�h���YD��,�+q�4I��D$�oG�*�Au���4���QY�K?�1I�w�5Y��P�2�i��B3jss��Ct�a�\n�1ޣ�Q���ga�M>�IFTSH�G\0 �h�uA������|Hk=�퐀\n`1��pP1rV�bbJ|��D����^�~�^XW*BG���+��_O\n\0�H��^�ޤ�j��r*Ղ����b��a�gE��!��f�d�!������)U�8�I�Q@���q���0�糐|�T��C��<o/~�%�<y>��7���~;8~�>��6˃�GzB�@K5�LU0`t��J@\0�j	y}ڧ�5Xץ��֍����\0���:�%d�S�N��,�88�����g��n\Z��ݨ4�2;�+U�6��P)���n�68�)ٔ�@���^UM��[Et�Q��\"w}H��2�z,�����np����A�CKf�޽y�޽9���\0\0 \0IDATz���s4��y���e.�y4�$atw���	`m��@	�S�6�9l��<S�L����\"-��P�@�,��n�H\nK	6��2��s�������\"�F9\r���_�ӭ|0�\\\'E#�]�G���]$�B�0[����є�u>&*�&LL�)4績��еU�7/�V?�����mk3$s��+�v�z�I(@\"杬�\\3�I0~�	Q�9�rrz�^�;U�~-�\Z�\'DՊ:��1M7Pm�����ӈ�����T��TFW�9��+c=��U����g���\r�u\r�X�3p��+Q����nk[�mesS���\Z��I!�*]�u�����ɻwb~{��be��<U�(Ӕk�Z+M2C���{%u#�։ו�F]���\rL5V-�JtL\0��5T�2@ֳמA������p��|�sF;��t�W��Nzۛ��7��:rQ��]6�����Fh�c��{7���o�D��\0G��U�Ä��66/�Y*�g�)^4�.V�g7狢Uڊ_\\\\�_�������6�8o�ɭ�U�AD��.���͕&&�rDj$1<i=��\rw�,Aɀ�N�vp�XL�����޵Y6��{�!�\"������l��jw�Y\0@ww2%�[����mT�p�������hS�<$�3\"rrԳ8\0��\'$q�끝���_�vB�;F�<L)�ؑ�h={t�ֱ[Pq~���~c�@<�!�.��97��h�]^ݨ3ϻ��0_I�H�Ә����簎D��I���&~�P#�aҀ�@���\r��=�_�|�3$�������=�d��+�,���� �XJ�՘؈��&�o�)����ԈF\"E\'z�ϵw庪�6~\'3��kq��g����7�ɓ\'OB;x��*���ߠB���_� Va�X�=������3;9>�����?ӽn��lc{[)�K��j�;;�k�UU�p�{���V�܏e*�+QU�M%x�3�����P�A/��2(�V�L�\r�f���+�t�qf΅���r�S�ŋ\'���$?D^L~���et,K��\\�F�Di��73�v���Ŀ\'�כa�����t%qRyY]c�e�뎜\Z,!��^�;�����}\0Y$��GMڙ\09���`�y:��S;~`�\'�����\'�9�������nk$S�rm�V�&�S��>X�-\ZB�Wj��Ύmll\r��)�$�\\�����C����2\"�@��$���1�ȩ4�H4\\����IL��[�p?AL�g:��g��\\�H�SC�\n������b�H���iIl�5�5����%�S�;�Y�myY��i�q%�|\0�\00q_��*����h��!2?�W��%U��{żG�ėZ.��s�.�\"�4:��Le�r���\n��~\Z�VZ��#��8�-�����YZ�J�B�Zݶ�\n��k��$ή�v|t`}�}���|���kk����c_��m���Q�����Z�I��������=us/\'ER\"�L�Hd�4�19�L7s����&��َR�E��$�^	�nR5���5\'˓y!�b����$�ʋ�˛��.!g���5�0s����A��R<5b�(p��7_\'G����ͧ_1q��r�T�<���?ǯG@�Ѿ�%����j��.����3��5����s;Bu~a������u���{�nY���F�.���F��5m��mqX�T�,εG�Α��e�d��Q��I��,/�m<�ǔ(����S���\Z1iBCHL���)d�[��w��/\\�tx�\n�� MTJ����9���*x���[)O��#��t���R�{��*�#	�q�c]����X.��\n���y����Z�[�\Z4�������ԉ�A93��?D�\"�y61B,{s�p=^���;|���:-qX<�)H�/����Ў�����ڽ�lk�]Ϫ�s���0���V�ƚB�<w���|�EB��*�\Z��W����7�I��z�ʽ��?QX��Y��J\"ה����o\n23�u\'�ʠ�pPG-lw��S�`���yo,*�M����Yx�\Z��d\0��e����7#6\' �)ѡJ��Գ�p��%i/���\n�kެ���Ó`�%0c�Pq�����sk1Fk4��ř\r�O�h���2M���y����;�zmk��� ��(�@^Slu�ν����#^\"��2VJFvp~����ࣁ$�N��\"�-����H}@zf2��8��;�8S!A���LA��d�����HﴺB�ɧP��ޑ��K<�D�L\n�U_��:�y���@�ڐ[��ιU5\n��J	~ڔ��T�*�x�2Z�6��q֨�*Ҟ��e���\">�bM�D\"��K�����ٴV̎��\\O�2���o1`�*�9-C <ZnH{K+�\n\rMg�YI��ӧ��\'�<��_���;�^���ϐ��;�bQ�2�ܯy���X���.W��4.���Q��f`��TfF��$��z��\n���<�3�f��|�W��8]# �e�͠��h΀U�a�c�MI�=��n�Ue�*!-;77��N8��4����dׄ_����q2KV%͐�������ҷx0|�sà\\;wD:a������޷�lf���e:8:��O�ٓ\'����g��߿g�޲}泯كwT�ƅ�����\Z-	wvo{1�y�5%`>T�S�):�A(��M�p�{������F��6���[�ppi���vz2P#1��Y=��=׹>)�\r��R�C�x}�S��j�!�;��\'G~i�Ҍ���tU��N�[�d�!��<��(�v�p�aΤ��6��`���f��$��d:��7G�T�U!ٙ[8�H~���ZA^�m\Zn�v����.�,;�Y]	Y�iĕ8Oyl��DU��ju��jY���V[��z�ig�\'v��g�sz#ϤO�7�*.@�	��붵�i�;�V�{��0��Z�\'���P���̜��G��M��TO�GE%��@&ߣ7ejW>e��`�._�|O�<����R�/ʊ�(u��U�a~HP\n\'q�a%\n�5�x��,��͛q���ӟ)��nDe�N��Dr�KՇb\"\n�q�E�\r^�\nZ�H�J�,���{`_u�	i�̮�&C{��?��~�#;��#\\��+�������6���?����������[����T�)A$�&��X[ۻ��C6���\Z+]�kHYஆ}{����s1OeW���������Ź�����5��������c6���&�vrv��e�)�S!�.�&�$�)�c�xvey�zJ�\Z\"�y�G�\'�z�Kr\r�\n�y^S*q�P>�o\"U� ��0pP�\"����gX]+\0QQ_�����w��C|����5U4���8�/Ox�\r;w��Hö�7t�mD�H&fSi���X�T|�?�/��=^�p��G�#[��F�3X�*�&���늝���ё\r�2|}�B�liiUi�ŭ{�}����Vz:�Y m�xfavZ�ܧ�*��S��X�*AG��DE�s�{$�)d��2�p�2^d�2_7`^k�׿��,���jy�|x]����C\\J�A�y�/�U�Qo`̀�O��C�i}��LCQ܄�J7�:�\\-�[�+�GE7L̼6�/s�\'��|Z��x֦��l+X��m6��1�̦6\r�~�}�v��C;�8���m�O������N�HY�>y��r{�ײ�rǺK{x�^p.�B4#�F��o��X[۔`T6&ըUƃ�����_(%Ԍ��M�c;��ѮS�j�D�i���z�I�G\'��i����c{��;8<��aN8T:��p��J��(\'�%���l&�4JLp�I\r����(��j��S���\0���I�Voz[K���\r�bw��QZ�6�O\Z���P�f8-~^X��N�N��	n��k]���]0��Ԕ�7���B\r?��C��L`�����b����fwnݶ;�o�y{euYr:���~.�w��{�ͷġ���K��z��\r\n_Fl��i�d��U�&S_�R�c�=ڶH?}��t\0�*���\".�r��-[�X�g�^��GLh�����r�d�a�e��{!�7�@ƅD�l��2�*��CH��3@������q��>\\��o~����/ݖB��p�)\\!o��*�ӛ7%o�~�9��	��(1oR�A�߸X�;1K��M�a�����t/u��믅�8*���y��.�%�M���|���iӨW���6���ܞ��G���?���\'v:8���}��b���=9=�\'�����]�4U��V�i;[�r*�JF��\n���֎�޾k�����ǆ���7��кmF@��Ņ��C�����F�?�u��>{f�<yl�|�v��C��~��?�G�<�\'O�i��Rh�6�\r�69�p9	�Z�\\�-EK��A�Z��1�J>�pb�㧶��Bf�p��A4:�h���*`�\ZX�\')BpX:�������ӵ*��2£zܷ3�#����j��I�>^ޝo�NNEJk,W�e��ZyI����B�g.��t��!��^�#��۟����;w�.�?��O��޳/|�R��8�!�s��3��b������;�V@X�b�Mώ�E����{��4��Nho��Eۼ{ۮ�Ϭj��k)�iu�\\�ca�oJ��^X�b��Z�<%_u�b��ͪ`^�M)�����&AW��t$��n���������ϟ�>�I�q\ry��:�ҍ ���T`�d�M�i�4����߃P\rm�� �4��\'G�@\Z6\' �.���n2�`C�1����������_m��c\\]����f����_��U������N��vr>T�l/�lrMڴ�24����oefkkv��C������~�͜�+�#�R�8���x�Ԁ��`�w�>}����K��jo|�s��wd?��/�������:)�S�^_��ŅR/���؝0��{�FJw9B�аϼ�P����O���F]���4����2	O�@S��Ф�p;&�&���M\'V8��p�	X�v�\Z�%=_����PAw��ޞ&��u@�B͟Ŋ�dj�g��EA�/\'v���Y�.?,tp�r��HF4y�������׉nO���˩�/�h��g�x�^y��mmmh���7��_��W���(�>,pTA0>>=uZ����b���@z>�_/�5�2�K�./�3�����k��k�-���w��v�Wm*>�n�j�*�S���l�\0�&QQ�����dqm��<�)�^�դ�J�,�X�}el�I�������o���oi����fe!���C	+��Ѓ\nSO<\r�u�ly�����Xޓ��h*S5N$*չ�w\"p�UL?�\"@�@�*�#eyus���pε�hv�;5PV�U��O7mUlp��>�ַ��g?���m0��t8��u�Zwv��������wԷ��+~���]sMUɒ�0�=\raqmnn۝{�q�� A>;�!ѥz	pRr�씾A�#�\r0\Z+}\'_���w�o�����;�������_�����m8�ȣick�vv�������~����l��!3��Li�����ms}�>���A�tO��U����������tN����2���ǿ��ޢb�|��C2h	y�{\\\'E:Ie��fw�*��3�vp!�����c�^�ht)Y��-���;��I��T-�O�j�f�NN�<_�ؒ������$d���z*t9LmsuM}�^�б�[��^~(��;�|��ݻ+��~�;>8�X���C��G�b0P�Mwi�:+�rM��SYaў�M�������E�A\n��k����.�OD�|����{o�nS��ZsV�\Z)a˻��N��DJe�s3�)���gn�D�^͠��%V����y��\0_�?�ٿ	pd�\0(��-}�$%�F� �NVʨn��߫��y4fc��kh�U���o�޽\0~	�&.Z�\"E����+J���Ū�#����*�q]�넃\'\'c\"���ojc��A����uU�f���>����v���峏m6Y�|l�j�N�5����V[]�Ë�=���	4���3�@�)�����r�9B*O-��H�hc\0\'\\�O��˓����\0s9J��S32��\\�*p��_f�\'g��]�ƮW�v�޴��������?���4i���&�\"U^����\rOO������j�&%��\Z�C�Xj7�M���GaU��sAk������ԓ��Q`Z^r�a�2���0�r�����j���#�ϋ�3�_ҍ0�}���pl��=���u�7ww�����EدonIr�� 1�fH\"�e�\n��pd�k����/�����˩R���]��/���a<��y���lzmK+=k՛�����+�CK�k2�k�yH�*��E{���3�{�g[��2td��Ul2<���R���w�dkwnY���v�t\'DJ��;G��n~��2xd*��e���YL���B�\n�C�p2����++��~��(xs~��_�J�(���\'\'�����\'y$ů���G�H�����fo���\nX6@���JH	�UB�I�+a HD)�f<����7�\"xT���.����*�{����A\ZE ��~g��!���k�]�>�hn��\'����cg����`�+�f�J�Nk-{��_���\\\'橝���SČ<�\r6��?�#x��������m6�I%ԃ>�Y�;���8�^���M��1��)�j0TZ���~��φ��_�Z��N.�[�>A�_3�H:={��}����:M�d)xK��wv�J�n�<x��CM�q#:\\2�y�o;U�n��Q*ɍK�i�f\"�Q�s��x|����z��	`n��zl�L<�)`]\\����ĺ�d���x��]]��������j�qⲭ����K��ʪ=�۳?y�q���eyڃ���P�ceC����[��a��7����=}��|�n�wn�K/�l_��W4;�CZ��#!̍�m ��|��������;<�SWVD٥#���JG&�LȔv-�5{����5�HA�@e�ڛ��f��s�z�]�i 2��r�\na~O)}������Md\"^�L-����2��$�9���G?��DW��y*��IR�Z������/���z#D�Ri����)���>�[m��(����OL�\Z��(z�w���o(�˔6K�>���$b9\Z#^\'�]���Q^�*Q��Bhh��:\r��������l��kϰd�؅��j}�>�f_�R\0Y���u���T�l`*K \r<U���M5>���\n�*Y�Cȩ����h�_�??Q�3��x�֐\no��LO/�~Xө���/�<��=��P��x\Z�jUY͌�cM�6�bc��M�����(��JQє�+;??S\0����[�o�+�����/\'P}s��	Xl,�<J��@ך�����5�]��tI1D��@jxqz&�$\n��ۋk�2��?�QE��f�ik��5��G�`�&\Z�ve��H����\0�uqea�<\Z�Oz��Cu+��vy9�DB����<���%���ogGPJG����R��\n��J����sqS���W�[��-u|N�l2�.���ckڻ��Ygc]���)���zC�(*��MިDGe+�2�$J�z�l���3G4A7�h.ߓK�߽_dp/9bҿ��S���@yy��<�qF�^9g�q��\"���G�B1����_�ʵ�\Z�\"d��ō����@X�6�u�·�d 8��F^{y�d#�zhͤ�v#��x�#$���YE����b����v�ɇV�#�٤�l��w��?�3����8����K wiѐ�|�i�ir8�����Yplh��gyn!蜺���Sϲ]�����0� ���M���nk+��g��S럝���ci��(�Z�F����=�tZ���é*m��T���Q��N���BQ�n�~N8{����������4E|�QG�I�7���C�ᴚmkw�<��ꇤ&�;Q�ҋ\Z�	��ԘI����zK�h��-Y��4lt����n�+�����/ʄ (W*4�G� %դa�V��\n�1��^�l\\_�~����������)B�Q�?�.\"_m9gM�fy�H�G�v�m�VG��z5��]��v��]����XU>�{�CY�|%�[�ܯ�Òk*V�ue�/S8~&ۼ��<�*ҿ�d��c�D}��h/��*���_�rÖķҿ�08��avmQ)Є��)r�м% �\0���z@V針2��A��l��%S�ظ	u��n~ST��`�t1�j4k<\0\0 \0IDAT�y�(-�{�Q�{����q�����ڽ�Ua~������������MjW6����o����mP��C�������5~O/YT�Xfmq�d?Ҧ��#�X\Z���Wz�S�k�&Á�Z�RDP�r:*kNv|��0�cÝ��5{\\i���Uaz����8�r~s����ǲ7�2ԓ#(m?-kEՏG�Z08L�|/����r�W~S�t/,O�	��B��j[��bU���\"�|�\n�h�\r7Wq_=:9�>Ŧ�U�j��5Ijj��\n��j4� [�ϘM\0n7Z���nCm�!_Q�Ge��7ް���w��Gi�h�J!�E/!��{X�W2����A��@\r���Vi!i�\Z�����=����?9P�z�ͷ��/�k3d/\Z�Z�\n����U_���W\"������D��A���9^���DW��� Ʃ���E��h�v��~�3��(�\\[y�iҔ��\'f��%\\,�7������I9[����BD��o�x\r)|���6)�#S��卝�[����|(e�����E�K>L�zF��N c���ǱkXDǪW�6=޳_}��l��_����m֩Z}����������hb����5S�!-3r�$nwD0�����G[�_a�W��B�E���}��kU�wz�a�����E��$���uJ���p<�pR�c:H\0b��V��vvF��z�_�D�\r\n�Pϱ�$U\"h��\"@< �ᕥowR���=b��<�����C�yP?�~����(�vçI8�$�M2����ɱ8+:f`�G��*�̙%r�G�D���/�x�ـl��]�ʙ��=�\'�5׷�\0\"I�tj3�����m���`��KzT��}�\'tȞ!����i��uv��e\\��z�4o�*5k7*\Z7���/��e���+V�.(zSr�\'r�`Q�D]XJ���#9����+<�3��^�=��gٛ��Sf^�G�\r��bY�At�.���gNY}�_~Ⲥ`��4���l�P+��5W�\n���>:`���SyY��!��ip�ְ���b�HW�j�>[\rU��\n��65�!:1\\��1#{��&υ������8�4�8��Bu����{mW���Í�>OeԷG?��=�������Y�b��[����ֻ���/U��^̮&\nX��e��-�K08�f��@�D�\"\rBZ��u�*��K��7����z�5�J�)���^x[q� ���b��:;>���g����T�8�m,���|tP��n+�~��X��hqB��^�x�k u���vO�D ���q�4�w=�Eq*��%(`���:��$�I�TIO�E����0A�<\ZJ���g��\0��h*\0]1����.�m���e��^R)�%�@�}@�A\0E�;���#�\r�I�	3�Ȋ�\Z�Y3\ZF�3��.�\n6��N�O���2I����k`�lr��K36�f�z���/~���`�;��$x����⹑ezW��*@�&��+Vd�2��L�2P�{	�R]��Z�GY��Y0������9V�=�=��)��\Z�{A�A$�F��^��2j�)f\".��.\r�D(߳�l8y �3P)P\\;�@��\n_����}#-rﰌ�����U�5���CY_,�vjB�ګx��6�*���K;�}��o��oa����w��?���dV�����Zh�t����f�)>76��>�,�7��5�5��&�phEx?�1\0¢���V�k�Ǽg��GRCm~D��N�Lwf\Z=�L{F6r�D���<5�%66�R�3\n	 ��hQ����@��*i!��N���=y��d����)��I�d���|�b�k��\"`��]s-M���k�C_A�\\?�y��}n\'�\Z� �z�i��6��U����	�g��7q/if$�1+\n\\�nOX���R\\�j�!8�U�ರ�u��Z�.N/�O��]��۳utZW3�+hq��x��؝W^�Lv]�^)���vՅ_y0��Y�W�ߓ((=��C<�B�o����2�L�+X�7V\")9�Ơ�l����?|���|ô��C��.��Ґ�k��i\0��A!#i�;��VITQ�[�q�����ڐv$��yEY��n�%~��B9\\�T�R3��Ծ�n������8��/Е�R�c��N�7��j\rmL�f�c�ͷ�a�?�W�;>���_����}z|&=�htn��D�/�,�!�$3��2��Ò6�۳��h[!-��͹+q_\ZV���n��.U>g�f\Z��\'v�[<ΧL�q\rއC��b��eGN�MT룛��%���<�49G	��ܑA�A�����%��Z}o�\rx�m\\z=wt�Aߕ�NY(X�|ZM�n�M����;�?PP%p)`�z�\Zr��{ʵ{��\n(i\'(�UP-���(��I��.�H�&+}:x����8�����gbKC���ޛ�C���W0��RP`BN�ٰ�\'O���HC�|��֤s����_�#Y\01��N��)_R$�U��2�K���%���)�P�����L�r��ݬJ����8�B�N��\Z�����|.��Sr(������+�]�;�ke~��������Z�ͬ��\'�\"�P.�+�W�� <}���� �j��f���\n�k��sREays�s �Bk�Q�ٚS�qU��U�M_��W�ؓ���>���Y�a�|�?Z�ݳG���I�\'V�/�<�᧵����<`5[�BPXp��nk++\n\\l�L	sB0���lN6���W^��L/&\n�@��0�bIV_�)¢��҇Uh��Omaӫ/q<�#��g��-g���! �=8,����8���BW�,Uݮ �9��JoHY�@ܤ�i͜��&���iƥ��Gоt�BxR*��t}�`�g9><VET�#�R%�AV��Dpg\0}?�*Ҟi�k��g��b}E��^ ��B#Q��4\Z�=�{3�d8�-�r�������Ɩ��x=\n\n��t\Zu{���*�tz���o�����R[OS�w��d>7;d�����\'AF\"%�/�1�,@����/A@I�����.�R��L|D0��BV��ߒ������L~�J�B�%3<?-o�1-]��~�;�P���Y�3�����Cȡ�~c�YoȆMnD�0F�3J]X���I�qb����iޠd7��Dm��X0!��8�+kj<����x����F������2��ྜྷ����B� ��N�������^�խ]cư;0�j� �X�V�;̠S�! �1ժ���K�d���*�g����{���)hMD��J�NSP\n�P���7���͡?\\�d�G�Z����$,d3�\Z?)Pi�뽼���*��Zq�Ҏ���F$E#�F�v�k]|��\"���j�&c��s�x|�;)��G��^~08\Z���!��\"�OU�<������}��N����,��2?�&@t����\n���Z\Z螆xߪٻ�Գ&؃�?��C]�m��{��mmc}Lrm�B<J�=ADI�g5?i�|�x�:%���-�TI��DV�z��3�\';f5�ءQl�+��H_�~�ߤ�ln�[	_�/M���{G_����4J�#�]Si�����*m�Ex�3^ޚ���u��J��/�X~@\'�Β���P</9k�|L��qb<9m��Q�����	˳s���sӻF*\0�f0*I}��\"G`����~�����-k����G���]A�Ә|y�S�뮵ڶ���m�}`�YU�s\n���+Rd�7���#��b@�(f���J�j��<��5�y����&�u�tqlèDzR���N�CHN��ҕ�i>��8����\'/�����x�6$��v�+ݓ�Ƴ��\"�y�����!m�\"����.��%c�p�&S$\0i�m��v������N`����?�_a����$�}uM.�\rHs��쒐\'}8�Hd+��}r�P�,i>+����CI2�s�5Vi�:9SZ���?o?���k��o���e	4�y$\"J4�_�<�}�7\n�7��	@Jr��^�ze�+���3�EPs3����|Nф���k3q����pU,LE{�m�Q圀�J��J��+m���3���\0W�A	��AX�:�W���%1՘E\"Q���>)pI4���\Z�!�=`ye��\\�Oh] ����\\q;�k�K�<5D����?r\0�@�0 7�l���K{����J�i������]�*���?�f����u[���v�=���X�����P��N׺���~�JW�I�j�s���\r@;��i.�2-&���o���zj���A�$�\nA�8�KPTIݘ�C#���8G)�9�i^��\nqx%L*y����\"���������H�:��Hl�Yx,f\0҇�]ri�!�O{�c3��^Śv<�s/��K�\r�j���M��\'91dQ�t�D�%l�G�r��d=�*kʃ8�m�y]��j]����#�ݑ*M܇�������td�=\\.�W�λ���ݻ/�&�T$�p��&JJd�\Z/]Qr����-�@T�=e�*Ӻ>e��?�]-���Y�^�\0�(=׵_�ߣ�_��3_ �b᧦��ދWT�B��H�BDN��f㘟�O~B4MLq=�#��.<��H-��\'r~͠#�I���\n�V4���W�K�A>�+K�YTU0,c<`���s~,�s���\r�X��*j:��ۻB�ӨYcri�{ϭ=�ڣ�`����N=h�K]�n�<��o�mW��W�����M�[�+G��k\'���\r6��H��o�k�1��Xee\n\'$FI<�3�>?�Fc4H�x�|�眘��_�,�N� �.�S3xO��\r1�`dlT֖:r��K�p�d�̸f/08�`����Q;�($⍼#���ȋ8��3^*���	츌��.����\0J�����9�\n4�0:mq�R�#�U����\\��j����>�3/R�(H�E@S�Q�=Â/��G�th�_X[�?���@�����2�f ��<����:�q�JdTf!e�*��a�Y%J+߷P�9Q��c�2�e�Rk^|A�-`�ԫ���3ധvUi���7�Psznxv����ޭ��?eN��Z�����c����lh\Z0�(jlm0^��\'y^�C�u�S�@7���kq�T�_U�8uQdZ��\0��ЌE�$�m�\\=���?h��!����|�_|���*�\'�����ӏ?����Ӊ�1\\\0h�y���v��7m0����:��D(����3�\"��щ�6%��\n���x���8Ib�D\n��i=)w-o��1����i������B�i�_�6D����BS�T\0aS�y��C�5a���H��#oHs�2~N:��J�(���v}b2b\r-��Ն5T��Z��Ł�{7�%���G�� ��%����\ZĨ-��!-TSqX�)spB�{�#�[K�/Xg4q�kpkS�Q�zF)0�\"ލ\n]�c6���gO���H�\n!��ɿԳ�����$�f~���\\�2@x��D:�^�B\0�M��r�K�9KĔ�����|���|>��@�dL7���wzǯ�2�B\"�L�+_��Wg��9���ʗ�Frǉ�7(_��/N3�,Ge^9PEO�C�\n�a�TL���Bd�G�B�\Z(͉EC�ޫZ�P����l�横��Z+�CQ%4�.Dހ�7k�����BV�R�Suc֝{p��-\'G�szut6s�������{��_��ǟ���Ԯ�}�vaF7�U�����W_�۟����G���kW���zN�r�� �k�q@g��N�0�{l8!HD�4C{J8Gq���\'9i��^S��>��K\Z��T�GQ-���r���Y�Ǥ�]���4e���re7^�~J����pr�Yo��y��r��|�q�iU��[�fh�t����\"���q\r�rj`H��Ⱞ����g�/O�E#���_�\Z@�\0���=x��ق�\Z-U\nU������`5�	�#�Qku����=�Q1�8;�Ӌ\rQ����5��67�l	/��\r����8�X�or_��g�w��%���e���c���H�D[e0*T��w�b��c��43�y��k8f����տ��\'G�\n�d�@�n���/H~��u\np%a)�\'�� 캠��}]/�va���CWY;�б�XC��&�Äܴ\"\\�%w���]�d������B�Nx$��2`i�\0K\"��:\"�Pe��8Q�n��T_��P�٬�j�k������Ύ�=���3����\Z����X��dwn���/��hj�;��dKY�q�s�		�ʱM��e����?�)�@0;o���Ϝ�N�h�p��)S%m�@)��_��s���G(��\'�U���\Z>�Q�b*�&� SU1yy�=����/�7\Zz�t\n�B�B|�j[gi�@[nu�*����|C=c�j��X�\n~�Ҩh=r�T\\����ҏ�0�G\"װ��M��)�,S���Y�́�C��#%�ދ Z����Y�L.�X �|��rp��l�٭���Ʀ�R\'}S�s^��������Y�d��@q3�d��\'QO�!�!�\'V�=�WqE4΢0f����H�?kN��Ϳ���W\Z/�	�ۡ�_��B�~j��͐&����\Z��eA�2o��Bg���U>N\'Nc����?)� ��~J�I?M-�4dSr�\n:1V]�P1_ё`�QE���.b6e�g(�_n�R�լN�i����%�|�}��(`]�.�J\Z7��RA�bk�n���|�-��BE�P���(`�G�}�2;����Ħ�U�g��r�ɲg�g�#�����n\ZO�H���6�D#��\'�s��JHOJ�2n��P�&��\'��뎔CH��X��vڅ4���-;N;��8��hA���Fw�ڈ5���4�\0�T�*�Le�:��H!�I����k@�?n�^�Z�	)�Ю���X{�+�	Y��hԵ��e�k�\"	k	zd(�A�\\{rt�����Aߖ�M��>���-��ګ�YZ�|�2��t�2����L8��x$�������g��C?3����f�V�{��|bb�v��\\3�_�Ȣ<\0Nr�V���i6�^]�߰XX���󞱀ؙ.h�����(�\Z7��@�����J��j�~<��/����������	�}}ڎׅ��Td�|���(�HX6�Nx���p&QC���z$��Y��n�%溜���m7���=Z;hѡ;���ұ���}��_�������/NJeN��u��l}���6׭��Zgy�N/�Z#$q��GzѦ������o��M�SI,��%A��du��zLQ&Jj��GWY����jA)��]����w�ܞ���/�%iCGqi�e�W���>ށjc�h���R��P��ʬ�0h�NÚ=��W�J!��������E��N*�K�!� 䩪�g��u�P��E��^d|FU��I�I�C�8.S��U�Hق�\'9��Ȕ/��{\nG�,�C\'���\rl4<��˱���=\Z�����+v��ץ��A#�M��K��g�c��7��2�e�+QY��r]����|��-�-ׄ\".$78,�m�cˀ�)!�G(4\Z�+���:%���D�h��u�N\nJ�R\n��ǫ3rG�iD\r���l��DJ�iI�!����9]�T��WU\0Af.\0�\rY�B+O}?5�j�\'ˢ%\'N�	�iQ�E%1����q��G~����_jv�C>F�X����o�6��^�c���>��o�����`��4 ��U�m�Xg}�Vww���͎�DP�ka��^���F:Q��}Uq2��<U5�A�:ʹ��K[[-ΐ1�<Rב)��9��c�� ���Da�k��T6�	�\Zȶ��l��P^�+��&����yIn��F�ӂD�����J\0��[]�J]�ov������O��X�p�̓�كw.��!�B�S�3�����i���2�BK��Sk�� ��#�9���\0�_B#��g}ް���������n���\Zd.ñ,���ݵ����5��I7�P~�|�	6Q��)��7SĒk*�L\"���2ؕ��PepKĞ�OV�n�:����=R�D^��X�{?���K�虢�\'9΃E���)ᨪCn�A�9yY�_i�GXK	X�CxY{](��\r�SU(�Q.����#�+s�8��{~‭���؛���t���\0�֡����ƦuއT����+�_шM��V�l�Z�O�{�uZ��\0\0 \0IDAT�<��Ѿ]��Z�����w�\Z���~�Nr�7�Se�_	M�M�W1�V	R�O�Yr�U!\n��}�i�of���!㙁�yJl������2����N�����Ь\"��x��}�$��s�Nwպ\Z�1�Cs�XI\0��ꄁ�<-EW�^_]2xP�S���8ɱaY��i��!�)\n\r��Ի0V�4֌�k���1����\"�D�(7��o��O��I\Z�T�i^����/��I�&����[#�C�\'d�at���CO�	Z��Sy�k��ř\r��6����\rv�|�J��oS��2��g���\\�5���(f���R��o��e����c��\\+��VLz	�\n ��������\"k��|�G��-|mrL:��sZٶCT�vU��W�AX *�s��NQ��\n��-���������0��ܸ/o\\��zJc��)�nE�Ͳ�50����|V\'[=�b{k�/���d ��ҙ�P��?���F�t{y�?���o���68:��ɩM����y��-m��ڽ�y/\Z��&il��F}�z%�l��kq��$���^�g�ڨ\\$�M��?�9���*�,�����+6Y.l>�KZn�5�T��R�Q���G%�kYYݐ]q�JpI�k��!�<D�5�0�#�QI�H�@Y��T�F�ѶZ�c-ƶ7Z�e�V1�<T��<���6P��|:��:9�g�W�c]�|AW�\"��~��\Z���)�B��W%�0Qg��yC���\n�*4�ڠ��\"NK��ٙ-��68>���u�[�ܰ�;w���?�J3��w*�ռ���^��}e�(�P���\0�{�$�K�� �ʾ,/�,ƌ%�/I����6�P�,�\'h��|���~���|0/��}3������/���U8�9�I�����\"�U�&2��5M��q�k��5G��d���͑��ƸK�x4��CMM�����IZ��d��k��5\\	�=�$�\n���:I��U����M�/l����ӏ��`�.Xx���Zk;;v��Wm�3��	�\"����>ߴ!����=�4��������S��O08E��\n�<�c�ZD��s�,8�N�8O�D�<ҕ$pA�t��?�u�B\n�5��=�ɴ6�\r��%\'�u#����Q����<�خi��4���[�e\r�`���\'�:\"�)��Z|[�T��#Q!8	_��D30a(���iUT�*��L m�@�!����6��PX�॥�䓌���S��3����������/άM�ƺuvw��[oY�דr�\\�Z����r\r�Ҳ��ם��&�(����E���JT$t����]����)�����`��e�T��&����c�Q������o����󡮮Ļ6L��&\"�\"�H�����\nGA��es�)Q���*dŢ);Y���f	Z(\"+��~g���+��x\'YE����|�j�]A�J���7ˑ��Q����Ք�ǵe5q{}��-?ط�G��x艹��ё�64��z�����/k>ͭ��g����{�-��X��O��lD�|\n�pW`d�H6#A�K�s�h^�U�-����j������ܤQ����97Eetx\"�%�L�7��)^��D8-W-��#��y=�{4+�a�Ĭ0�	����z*�p����е�ʚ�1Z��|��]���|�M$�Ԯ���Mx�lw�p��R�� ����.7����g��0�>�%�F4g��YIr⮦�9jC�}��p|����������-Ñ1|���z���66���a�~�\Z�x��`�w����fP���r?��e���DrI��A&�H�e�,_;��f#�!�A�Dt��|_�T�����%�q�۾�?��b��H�b:(H�Tmr��A��<��\ndFu�:�?�� �Y�^��}��-�o-�`gS��,\"tB��]dk]�6��\'Q�u��	D�nH�=>��-P<h�0�|�y���p��n��|hu<����S��G�Lp\"8P�y�?��0\"c�O�H�ni�\'\\�Y�k�\nXs����=�<r������B$��[F���nө���ku}<a��z#=ǀ����.V	�U 	q.�+�m��w�jL�A�@��oh����Y�F��,��pWp�:G�H�BV46��P��:���.�iN���v #ЅX9\n���]G�8wbL�^_���H�I)�O����uK��Cv!0���}���UG��B�d��d��g -����T���Ğ=��g������8��ֺ�lnY�֎���k\n�p���3`d@(��<���ޜB�R�DT��Y#��ʠX��N�{������DxN��3]������N/(x Q�a���_�O�$��oԬ�eO��c��b�HK�@[(ŧ3�nݧG����R�\r0�O��1I��@%hlV\\�ɦs��i(1-Aį�\rp���Y�\0�fiRӖVnil���\r��:B����9�l�����X_�aZŶ�o�l4���)\"2럞�Q�_��\Z\r��k����1_��H\nnL��Skw����fm�iyX���y\r�R��y%x\Z\n\Z~��m�ꡓ��sS�\'k@-U���-�C���\\\"*��\\�,�Ӆ��s��\\L,�Rg����H���C6l��������0�6y�Z���(܄.L(V6�>���F�[��1�&>���Ƶa��R�9\"�<`a���Bg�k��Ϣ��c��x���!	�Fg��J�Xq�J��{Eη:\nb�^=�hv���ܞ>�ئ��5�+8Y�V�Ս[��k+���u��?~X/��gPJĒך���{��� ��#�Q|Լ����g=0y�ҳ���27�d����w*n���B\n����7��͙PNp�R\Z�M�.	(��UT�S��~a�O��O�_)�f���&`a{Ţ 5�>2\' ��g\0�J�\"���\\V�n�B��r����<}i9%:��g��HeHo�=��ƇH��y��\\�S5=<�Xg���m�JÎ�<���\\=�ݖ��ڵ�y���\'�J��u4L�*���6!�;�r���	�T\n%�˶m4kS��:��N,L�QJe3Y\0)`)������s�!�}wd�mYZl���#*5������nZ�y[�UZ&W�s{�|>�u�z3o,�\'_i-��P�ˀ�p�OZ������\ZG_�O����H�_pY.�P:\'i�j���|��(]Uq��i�\n�:&��Bܘ��(�G�����y���[Հ�:�T��!L��R��V!H{�B�\0�x�����<���l�ّ`��[�����޽oK�[\n��O���ȪD���38e��ϒ�lE���)�����x�q��S�ny�J��kI�\'��ԯ{�3��=sns�����e�5��7�JU���.-��{j��\\3�b:&l�+���IzW�h� G�m2lB�_�����5��-e�4���[�YE��x婑?7\'��׵���:E�:� >���4J�\\�b��tI�jd}���v5j�h�m��l��������Z�K���#S����u��N��ܱ��\r{����i\no��?���-���T�m\Z����si7�v��&�%n���8lhp5���a����^�rX�yx��f�yx݄� �<��^9��w�Q�iJK���G�~�1�����t��*�1{���J�\\\ZF����	>�M�_�4��DT,$����`��z.x�g�d\'}�_���\n���/b8mL�n���E�k��8�D����\n����)I�<����e��ˊ�5�0\n�J�>0�vb}��]�h��&��H�i�������g�xӖW6\\>VY����G+�MD�os��\'ӵ�DyƀR��� �3����X�����KF�=�������)�D��j���v>��p爫~i�,.�����\r��\r!{����&�Ҳ���1�W�Z����ኲrzP�(��7�6�ZJ\"m��G6r�K��թ��BP�FĀ��LY��n�3�����U|4�\Z[�Tz��K�|_�ӱ�vϪ��v�,$�鸴�j��vvxl����<�gf�9�|4���]���sﾸ,�F�,Ș��P�����`pKa�����4U:�@��^%�NO�-�Fb�Ck�-�I�(�hc��3fL�c�j�(ٱ0��)G)x����[	�j��e4��,��U�lPa���������4��~���k�bAZ7%o 2�ۼY�������ҍ$�����Sj<�HIA��*Ħ�\n_�.�R�7ڋ�p/\Z5�O�KH V:=P\0r�\ZQ�<��|&��/�ovqr`�nݱ��u�#�]�j���붾�)[�&�U����w^kV�2=�g�`句��\Zs�X��Jdw3�K���_[�7wU\'��A�o��(��=�, 3���o)`�gʯ]1QG��ؐ�g\0�ro4n����-���c��I�~9���p*�E:�������	��Q��S�����%a������J�E���X<`\nΫ��M�4�4,-���O���^Iڥ෸hm��c�����z�Fx��d��£�����ɑ�싟�}gW��bti[����y_)���VL�.z8EP5�fe65���9)���-5U���y������S�t+�����A�<U.&?���7�ΟM�cu0Ԥ?c�:�S�ӟ���,�k���&?v���\'�94xo-l^G\'�W�20����SjMAù)�m]���$ �D�bBed�تt�4��n*9�[!��E��\"�L�|j��PȘ���Pi=�V]���8����,�_��vqzd�?TQ�!��%;\'�o������ -�M�vk�H��f� �P	Ŋ�&5�3ndW����x3 &bS���3�tN#�[\"b�U�8���:�a�wq(�\'�2ߓ�An#����Ul��ql�������/�]�U���P��\rKpY��M�+މ�i贈pc����W���С�W�O��3\Z��ϼq��S06���Qz[�R�**/���8\\�!c@\Z��]?Ƨ�.����9w��-����666mue�&c6ÕR8��s�r<P:x���.�[Z�������v�ߗǻ��� ^��SЪ;�⌹��b�t��\\<�����{�ߣټ\\�x+:鋜��n+m��{��X��iւ)�l�r����)8Z����ik0*]����)\'rյ�r\Z>]�{��B8Y�\ZSt�g��KVk3�}j����Ĳ�>*���EAEC<���IH�,q/cF�S�����\0���Nϼ��&=���3�)<>|��c\rݠ��`�FK��\0F�����M�C��ؒ�RoyEf�R�v�ܿ��x��«jN���y�֐)ϳp�wt���M��&OU\"+�,x)Ɣ.�d~�on◴�_�b6@\"?9�F�^�O�*��G�Ut��jp�>A�U4rx_�\0��7\'\ZbGyţ;���@����_�epA���}�e��AH_�n�@̈́��j9K�k\n҉4�9_x~s��G֤�T]��f�4���RȦ6%ٚ�I!�\Z����[���\r�]�R1���zd6����D��^��e�k��{��\"����jS�NP�9�D�/�[wp��\'?��Oʖ�0?��|����vq���t)G.&�ܹ84�3ud�`}��O�4�����ne\\o�ToЎ\"�I7�#��\na�*�+s��W;Gj�����#���)r\\^XU�%7�=i��\0ov�&05�*<L\'�8�&y�a��CT\\A��)��^4�̚u8����=d8�?Xf�*䗦���C�N�]*`������_��p�U������:ͺ�-w4�-iv�u�&�۷oK������M��ϸ|��J*˂��㋁d����d��9���\r�E�#ﳂ�� ?t����^\nbA{$x�w���3�xP��w���c�=p?L��������n���y-��<\\(�\r�������&�(��iM�ƻ\'wL3�j?��iA�}j��`�Z�qV���(>�9hX�,�C!/�5�:i��!7�����.�8=��*���uZq<��q+Fh���f6D,/w;6U*`=�:)a��&�m�����ɀ2Ѵ��P������\'��qs1q��hsc��*ڗ����y.+	K�T7g����-RzP�&h�56j����\"���4�s01���T)!���g�rdl���2�C���Y�Q�M�/$p�v\r�vqN�\Z��tRV���Ty�A�F\0@~��b\Z<[d��� ��sq+ߪU��g��s\0و|�WR\\�\\*�>�������=���U������u�ݶ��u���ҽա{��2p,�,�I�$��|#���L���\'@It��PӢ���rH��a����ȅ�s���H.����r�dMy����|[{�f�-/6ky�<��WSw>��S����yT����q�j����P��=��xC��s�\r�<���y	L>�4��<�E��i�f4.�^Ds���`F~1��k�� �`3x%ѻ�<���e>h7r�FO/-i�u�]�L�Z\'�<�?ueg��v5Z�մ�pD�������V���F\"뚸~-��o��8m2���(�D�s `i{��;��8J�A������r1��d��^�م��g��m�[�S�hIZZ]�n�BBG��`�+��6 ��L3����g��i\nUxaX׍�&�ԛjS��U�-iغK�r�`�N�����/]������x:�<�GI0� �	�j\'��=���z�G�N���x�k�A4�sp#�5���o\Z$58Xt;\nZ���Ԓ����!��ͦuWWmcg���ּ\"���B��ʠ��#[\0?��8� \"0�﹦3&ו��ʔ\0��?x���haO��(��\\�*��\"����Y��\Z}�E��O��|��J��H�$�J��t��q�F�D?����+7�T˒C�[��]]�*�8:��m)0���I?u�0�9cTpi��\"m�\'��y�k��_�G�)!�}�п%���.]Q\\+��ȀH�ϙ�d�P��;v�@R��h�]N�]ب�`FXm/��ƭ���sKZ6;r�) w�S�\'e�g2Qj	���q����ye+U�\Z���4�<�_�����uX�{�Z�<��:�$O�\'�SM묬ح;�T)�#�$-�\"�!ٙ�=ِ!� L�f�D8��7\n\Z\0�x��4���]��x�^��U�A�s�~gh��v���j�Ky>���rg�,��M�T2��������>��lu�cS(�^A�+�\Z�\"�_�׍��׉���]�Z���6�W�z��b\"1)R��ʊ�ܹ�����@�A�ܿ/,���N�T�e�*3�8�Z�Rr���`7����6�DV	$�pS�֥��?ע蔲������I8�0#4�ǧ�x�TF���y����	�A��s$������Ѳ.���6��օ�\r�x|�/�m@\r2�������F�4od�pה,�`^�{�H��jp����aJϟϧ�@�|>\r�8���n\Z��L���.�C��W\'��TL�\n��X�ڶ����u�w��*�l	Ef�V�N�X��7*�c�\'%��5�,�Z��:�pQ� ��Ϝ���z27�+�W41\'ז����J�wo��/��4R9��ͽh���鱞5��e�6X/����(�>g�pߗ��4\r�ʝzVo�0&�p�A��#{����Z��p;$(=s�MN�F����Gu�+N#D5��t����0\\��#��Q�t^T#�	\\n�k@� ���C�˕����\"���ڱ�������2#�{ ډ20$�-��L�v2�e�ɬ$?g��KĖ1!*){� 7�{�6+ˊ\0� \"A_���B�)i��`f�o���%�VB@�{�k�#-Ո]��֛h�.�$𴐣S��7�*c��8A=���p�r6T�a���X�v�7X���b6l�dX����A���Jٜ�\Z��*���>\Z���\n����X� R_�S���:�_�>^��&פ����?�t�=�kCSVo[ku�6��W�Δq��!�<қX��W��D������EW��Y�*.�	R�<s���5y��\r�>��&�1o�f��lf^}�n߻o��Tk�i��4���mz1t~��Z�\Z\\�G�#���V�g��E�\r����W���x�t���L5:x�Ğ>��z|��H/O�,� ��;?h�M�=�n�Fu+��1�XOO�����LW��D��� 2�i�L�9z�\'�l�N��E� R��z�����`�� �q>��^��`��aJ<��\"[)�Y�����\0\0 \0IDAT�2s����l�k���o\n]��UdC��.z���潼^К���~C:�����cg2�-?�>�\ZK}<U�Ŵ�\"cK�҄�P�q��i��j\Zb@���u{�Dr�N�ٌ��T���DlPOc}xk�\0܆�����~�0JL$��jJ�_���#�j�<:�P��\0�c�$��I}���	W�~�S��/]�ȴ�!��P�&�Ҵ\ne�n�6�ܳ.#���WA4��z�ט��5���s�P�Ux�r�{�]�����*+97ʋᴁ��)4�F�\n���Xt�I��$S����m߾c���?�P����A�#p5����9���ѱ�+�5��IӦ�\"�-�W%iw��]66��ef�`�Y��٩}����q��+��l~R�A�Z��j��.z/�\'E�N���SⅫ��`M��Jy��H�X��Uoz�L����삮g�����޲�BguU�5��޻��%͑״�E�i\'7u3����\0P\nW����jf@,�|�����>t�3qm\Z�X�2*ϙ�{t����V������̒��\r�q}�Ŀ�F\"��495C}�ޒ���xi����<�\Z�ջww豀䐳J�b�J��rC:o��5�z�f�ů�����3W�;��\"R��ዥJ��ѭ�]��\0��W��VR���F�K�(oNV��Z=��VՑ���\n�܋rp��2�g�C��r�� �Ttm����n�0����9�.N!���F��(�Cw	\nr���Ɂ�rx�a���JK_w�j�h-��@ b:�]pc�\nUX}C$:*�Ǽr_���Ҷ��lkkێ��U|���}�чvxt$�{uy�^y�e��ڰ���P�_�.\np깣��V�I�6�;�rl�Mj����[�:���s���>���@Ps8�S��Ơ�J�l8DBW�{1�17�fi*��j�wZ=���]*e��l)�֘\0��\"iŨ�?������鮮j����]��(�,d\r���dA�g��k-��:R�D0�_�XT��쟉5�7���|�^����r���ʀ�)!��(p�%3��ɬ8��ͯ��3wTj%\\*\\%�.�a*U	�tD�O�ֻ(�]{�i���x�i�$�����l��݄<�c����gyi��A ���#1:����;���E!�$�%�}|�<���)m���9�Aտ�����-�V��D�LNV��.�\Z�[� ��*WNpY�1l<�FT����뙭ݺc+��4�B�^aQ�À%G2r3��L���;�r�0-�0y\"\r��k��2�sۖŐ�qO�(\ZA1W��w5c�m��#��p0���{\'Q��uL������>y��>���=�۷s�*���D���/}��|�\r�Ǉ�vz|�db o����b(C�6��M:��n�	�A��}�T�P�s��A0�]����k�\"����=�!G�l��sr7<��rπ�rC��e� �A�ѣ���4�B���\Z،3w���P&�#u�\r̷�m�֮�V���\'JvZc�\'L�S��|��c^��f\",�RR@%� ��/�7O�xBߚ���I\"�c�c����F�1�_yMG�x\rU:�V��׿6c&qV�k�A�;��s\r\"��M�]H����)�\"����َ��6[A��#>��E~�z:`��n\n�S���Ǌ�5R�+��TI�5^����p��*Ѣ\r����\'F���Կ�k$UD�7��H���kr�6[uy�װ�@�=�s��F@s��,*��~���m��<�cd���`N�Je�oPV��/!��X�o�����b��+��j�[��I\Zq)�	���>�FqWa*��ȶ��,H�{��A�pQ\r,[�-��߷O�<���c ��\Z�!�	X��߳W_}Eϐͼ������l@��*�����Z��yMZ}vrf�?��#U��޻c�^zhk[��I�Y\n7>e��?�j��W�*1�$F|ip���ܻ���E\n�us>�I��^�ύ�UMw�{ڊJ?4V�GMI�1A$P��Upeժ���؝�wD�{gB�nH<� ��7�V����*�D�]�����N�J�X6͉�$L��伔_g��{@ZT����@��։���9h�Y�/����qQ�+��eJ�p�U��bN4�B=$T̲��fn]Frnv\n�Wio\\E�h�4����W	�I3o\\ٿh����9�#	��P��yS�AI�%W���ue�Z#��������	)��G��S�yҭ-&��C��6M�p\ZW�%V���\'\'\n^4��Rᙦ�V���7���X�8ҡ�i,���(T���x�����ŀ�D��x*�<;������=�ϔL�I�w\0�6�\ZT�����eM����s�)��T �%\ro�Q��hoO�{޿���;�meu�^z�Ux��k�kB��URE��=��YA�^F��ڶ��k[�z���{��G��5��ve��=�w﮽���mmcG(�ؠ}�V\n:�)$�g����+]���(?�vVnt����empJBT�c�u�VG� �~�n�\'#>�cxq���}O����+�v��mu}]���hEF��b_�H)�R�E���C����q���� �|��%��@M9R�t*?E��1C�V�������x��&�Q�˿��3y�_;g�A$O�JƼB57K_�$��X�d�L\'\\��X�j�}�3������L�i��:[O2�y�Ɓ�N�\nAJ�	�aY��6Y�Ճ���C���,lD�e�����,�����B��51��׳�X��R��S���#x\rONd�7<?w���d�n�������\Zpg\0X�M�S8	y�U���a8�%����@gr,��\n���޸�l5�ի�\"��&|���x���uR�3�&%}0B\093iц�gvvrj���V�W$^�mww�����e��~RS���u��(�F~����?c�X�pcw۶�ܵ��U�^���{�}�U&#[_]�͍u۾�kw�l�ުИ��4�lB�3%	���TNŊ�!h���4K��z�0�#Sߐ��e7..���)@4���[��Y��\rv�N�����4��z��w�i;w���{��y�h�(o�%,���:��)O�9S�X\\����b��������0�P��#5)�g��1�1���A	rY�u*ܐF9�0��_��_)`-����;9rkv姪����obFR�Q�ִ�0m�W���Ǹ�-�\"h�!+�i�H���f\\�S6��<�W�G�Hx}|nW�y=��K79��SE�4�x2�qȟJ�h9?oq��M�H��\n^�7�y+�\0̌%��X\'FK�X���Ѳ�^}��6��b7`2H�y�^W�0NK��>Vͽ�B�!~)O�����G>Y��\"2�.�v����I����,��¤\n�}$�VHy	V�(CJ�c�4I+���h��N�6��ƫ������W?��G�̄��Uu�����v���g���e��П�\0�n�k������~`���n���Y^_���[v]G���E>R�K���x�1�g>l��5\n4�C�����6k�N���,׿�|��w�<V�9��:\ZY��ٓ\'Zm�23l��Ύ�޹+T�Q`J��l�^	�Bn�z��R�9�>�{���D�M�=3����]j�˥��/�C�Kf���ms`_X�q\rz�@b�ki���\Z\\7�G�6�6�C�f��a{�r7K�����Ҝ�nx�����4i��[�H�讉��ҽz\\ �[���&�T�u�HH=\'���|@]Ъ�V�4q�����¿|� �k��1@U�����\Zvi�Yx&e��43��#�q�ZhCo�)X��P�\ZN�Fp�x4����V�lii�S�@�l*/*�y�~R->�GU�4��7�����L�g��yUa)��sE�%�\\��E�z��}���HѺ���ѯ��ģ��U�NuS}]][���Z�vrz����b�m��^\n�^�kk�Ƭ�Z]���*u{����X�j�򺽕\r�����6\'��\"_�p���q��2g����ٱQq[U�U��BE\"/��#�t�u%w��kf�W��e�AgI2M&��}��B���2 ��ݻ��{K�K��R�?���s�M3eP�ƿ������\"QP�y����@�_�\0R���32B�f�5�ޓR���|gGʂ�H�M3#\n�[�c\0����w3o�Yx�\'D$M�a��RO�TZ�,E�卒}Lt���P�[���R61Հ�au��y3�\'��Γ0�u!�������M�317/�\n��V�I�\rdk�T��Ω���x��C���60��q�b�AѮ�.��9�~CD+0��[-��h��%I8 �e��&�|N����S� !iM�A^*�_���h���C�X6��q�\r�Q����\rr�CATg��C1�|(�D���NR\rk�[^^�ȓy|pfJ�l:3���8�`����h7��ѣ�H4��C\r��NGJ1y]�S��@3�6�6x�\r\"]�3�\'�]�I��[G�~h�zB02��͕�2M�:��L�9Io9?���:�cl�5��@>�����՛�X�f�}ߍ�;��sf��s�I��D�rSlqj��D�0,�2M\Z��6Ls��l�&����0`Az����C�칫��k�)2�{o�o���=UY(dfdĽ��}��{��������_R��5fs��V;�@	4�/�h�Xp�n�@�L0{�ɀ\'��3�,G>c����3��p�����k��\0��z�N���7k�u�\n	s��a��`��/X�Abe��E�!��rVPSZ�`�&S\n`�W�^�X��8�$;�c� �{���:,k�\\o�8�d��r\n�\0���>��)q��	��U��\r��j���u�l&���� _�{��(nSYԘ�X*�zx��h�����RI燿w��rg�f\\\0~�m�r�S�y�a�\'��N&UZ`�(f�n��2�lta[�\rU��c7�	�݋_�p�`	K+���k�eE�\Z�Ral�,�t	�u��.��s1�����B7��0�e���Nى�Ԙ���v:�i~pm����>���� :X<���z+t���X�*�(�:[�t�Z�@�C`	�2����UF��y�lveΰ�[ј����W9���\"-�|���X��dX�=���2)���t�Wģ��r��3�T���&�zF6r��~v$.^�<�j2�g��䵒q%Cꗌ���O\':]\0�2�?�Y^�?\'�� �����R��S�:0s����?���LF�᎐�;Z�v�\n�,�\n3n+�J���RM-J��2R(���2g.� ݦ�����	\\��l�\0]��>�JZ�\"V��Ob�I���tlʐ�#��GWKxT�{3P.9�FfG��E6��dv�\"��f\\r\0���#$��b��p���k�\0�R�X��hI٭f��2,�QX�!RP���F�6Pi��\Zl.I�Y�X\ndע�@��9�ՁɷDe~F�R!�L2���(K��Ëx���\\3�m�W�A���d�hKgj�Í��Q��=�3�N����烌{v*Y�s�vƣ��\'�xM%3\n㭭����ݎJSi�C4V\\�\0Y�F��ծ����.5X,��/];#�#�j��pd�B�g`���.>��-�����F_g=�o�4C6����^j�U���H\'�7�B]VQ��@e����U4�r/W�%yr�F? �����\0�X�r.�+�\ncY�ʸK�K?/�1��}/H�.%7������G�M��\"9	�U~�<�������QR��Ktx�QT�-R�v(�0��\\z����\"���\\���\\ɍ���	�yB0�\n���Gea1�hWo�Dx)2B6:�\\_E�> �k�M�Cf���&��c��\r�^�T$����ݵ8��s�i�	�Ng~�������۷��E�\n��flI/H�g����ǨNV�\rH�\\t15�\\�lLr7U��33:U��)���}�ڦ���ڗ���Q�;a�CA���9u2��XS(/0���\\��j�T�O ;;���p��.fm���ml���F[EJx�H�:lp�A��>��a��J�\0���ǬϦ�>�7mg�Sg��k+^\\\n��U��I�{�`,�2�z-Y�-Z�R�`Y�ՉȬ��67�s/��rs1o�0�zkb��;b��e]]%�t�<Q�p�>Ma�G1���ㆉ�����<�VUҊgW�P�j�च|�3��=��d棉��F���A��5�y�,)\ru��_���Q<,Z�$\nsOxE�:9eeIU�Ŵ`U\'}s�h�A��Nv�\nhV\nZ��L�N�l1\0��`9QV���\ZFՐ�J;�F��}����O�1A~䄖g��&�uz���ĒI����c?\0��O�u������J������hhk�\ndM��O`Hzf\Z���Q�ݽ� �{@`�<@��l�<ܮ�$�b`�f�?1���CaE�T�̹܏*��g�`�Es&�l�nA�;% ل��6f��\r�|2*K��J/}.bv�����P�\r���A�Uf޵<P��l �Q[7n��v�[�A%S�D���l�Սq�H���Ve�d <^�������A��4��[�\r�1�-e37�ԤQ7��xU\n�0-��gh`-Oƍ�}����/�y�`Țb��>��缞�;��1\'˟E�`\\�%,�w�l\0�E��]�T4�&�Lև^M�m1I`x�F����p����dl94�]{PƢ��=ԍ�t�H������)��t��`���,�Xm��H���L��\\�@mɁ�K�$���I}7�b���u�|��dY��y8��H�0��\\��F�S\n���7е9�D�f��wu{����m.��ʐ�害�`d�\\���i�@���t�s�y?�f8����4��|��]B�צ��mmﴍ�M��2����qʖ�t,�,V��0�7�ē����\"�^)`��`���PC1��2�K�({63�@��S��M���X�6�RR�7���*�/�B:�Έ����%#��|a���A\\����	�te�n޻׆kkm��)�jXdO��\rx{n��6�\\g,m-#��j����rC#Y�9���n��\'ym꠫�p�8`�r�hT�a�7���\Zz��v��uN�Φ��}��_��Z#޿��+�����}���Vv&)K���3�A��D漯�{�T�w:ȧ�sfĶr�g���׳G��t�/�	�A�_-�uޏ�\r��������dT����#�������#�f�V���}p��U�J���YM�0����4�s�0w����?%��rL��)9�����E�z�t]r�1a�k����;��:VI�}����(l,ߣT\'JJ�L\n�5�,!������}��[����vvvڭwdb!KT�K\r:�E�YT��K��^��k;}�L1Q��ޔ�Un�S<��gM�9K�mge��E��a�mſ��ֳZ�G%�Kq��e!@\r�c��Λ��z(�[���_���	F��m�K6:R<�2|i ʛ��{m���t�7�E��625c���L���*�6&Y:�]�4��\\��E�V�܄E�,��|�ĳ�y��Y�\n&�.Ƃ�jd\r���>V��9@�Nt��^�w�ªz�CNk�ו]���C���|-�}`?��{�����z?��F~�r�+}�?��?{m�\"�H�TGC\0�\ZW�W�_����	���h��CLYŃ`�IVD�����M����>.`�E�S�J�yc.Hz�,*?%Mcx@t̹�ȟ���(2k/��������+��9\r��il�#���݋$���S�\\��u13�=�ʰ��L���}���NY�L�F���\n�p+�������Bh͂�)H��3�	Z\Z�͙�3>�\Zs��+-s�+�TЄ�Q�ϳ���du�Sd���Ȫ�7�6t\r���\"~\0�鵰�2������B\'!�\n�C؝K��YV�K���r�_�i}ecW\n����jA�$�\Z尢��^�������UZp>���R% ���Z��	\n��Z�l~WvU�a�^Z֯�KeY�y�GV@J)����������\r\'.d.�so���\\�Ya�&�g��N���܏������߼�\0/��U�17E�5/��0�L�H�e�%5`�4�J��?->�`[}Y|�\0-�+K)I�ƭ��Լ����s@\0L�;�FY^�I���n�h��\"��bݮ�Io�O��Xy����2��T��[@�hჽ��,	��|?����{:�e^A�� �@f�*s�<aYp%�\Z���BY�+�.:/�)|O�)�5��t�h\'�_C��\nB�D���ɞR��\0\0 \0IDAT�:>>���@�6!Ya�\\�H?g!=�z%�����&��u��N�(ilب���|~��=\"�106\"�j�\'�k����Rm��$�s������٬�s���i�l��36����v�޽6Y]�ل�\"�4릿~�>	9�\\Ȭ�>LA)�C<��\0�5!Z�b�6�����sO�1%�$�g�v�:���|��৞J�Gy��J|藋]����������_ӆ��7�8�1�JmK}�]:�����ꚝg���oR,��ht�� ��%�X1�<���f�Չ46 �<�����F(ZW_Ȓ��5����|6�6�ض^��5\'V�$��}�Z�%ג���?��k��F>z�$J\n<.1x���n:iw�=PY*�-�2\0UF��S��	�9�4��\r&������Y�!\Z�����3��Y�]���K���x~20��T%X�|^��;�ȇ�Uw��A;��k͑�h業M(ɲ��x�r�#Q��\'�\"[��z���|m�\0~2A�f�����,X�?�2�e����Z�w�&�!᮴����񪵆L�\r�h����jۻ7d�����qs�R���T��Ƿ�*X(B�0�����{/k����ױ�%��`��+�[���E�ZtD	����\\G�W?��k���)=�\nj	T|M�����k2l���=��;T�N�u2si�6𢝚j�H�Ε���U���A-�0Q���C\Z���l�N8YL��:��s9�0���S���N�����|ܠ	z�u�\\|]�A�0[��%�&�R�\Z�1w�vd�@�P�%��	�?��F|�s��I_��2e�Ar#ߋM����P&\"#��1��Oqb]QEmx9�{K�K�0�}��cr$e�VtGټ��Ҹd�V�W�\"�2v&���?�*�:d��oBg�se���]����Ȅm��&�PH��mu�&J\0.9HCJ�K$�ݶs�V��,6���	}���@�\'�he�|�k���1]2{b kB�Ej���`���X2,��럀����7wt�:X� ([\0�e�﫟K���8������k�)�@Քɢ�c,�\"�AY�8Nu��_S^/�ɀz�g	b�\0�w�&���u�A*���b��K&����5t4�ep�2�Ŕ9��of��G���/��:ǦK.1,TI\'cu4��m~:-�M��x�=N�[��PG%���wu��\"t�p���qlF;A�G�f�_R^z�q=\"���e=�dY�3�N�+e�y����g\"�Ӵ�\0�t�H�tOp�QR���:������70�?�ae�\0i+D���z�T택��-uX�������N�e���\Z�������\0�~d���\0�	U`��j5>�s2��/D�$���嬚2�����C8S(�Z�Xo�76d�;�g;��i��ܭFL\'�\Z�� ����j�|g���\0� ����L��{�z�=\Zk�M��`�V�>kڃ�#]�	3�+\nXRn�A�����)�S�zA�����=��S\"ʬ���N|m�v.�TY$��$�T�N�S�G��$\r����KE�4A��^��p¾ϑ����ޚ���\\1���~U�9Ҩ��Z�aQ�c�	�bv��A�������[/�dR88t\rǨY?��sr*�.�C����b���J����#��O�<n��G�r$W���.Gi\0[���jB�Գ���ర,�\Z԰�Xï\\wJ7����:��k/��S���9]�W��亃q�ޕ$I�k��ua�Ymʦ~�c\Z�����溯�D�hTa|�LH�l82Ne>�:|��q����㹙�Wc8uR�@p#�,D�\nM-��\n*���f���7��r������_Ƭ*S%m�5���6���J��t�\'�U}\r�u��M9��=��}�ؽ���L���3s�w��?#Ƨ�b<��c���$��*����GL�0Y�_����8|�Zѕ]dJؓ��kE�\\�Gn��&����H52�D�ٔ_�_���j2����������C�@ͺ�!K�lQ8�Wp���3�`K9�=�����R-�����oQ�JRN~�7j��A|�wQ�2��&�����\'�Z^�b�\n�Z6!�Z܋�N���]�P�,�%�,⨸���J�gH���k��u�����h>�:3*C\02k���A�A���\rᎿ��_��N=-��z�0��gW��d Y�*!K69�7��9/M7�]��y��=7?��������G?���y�KM	ىy�P�:{��5���O��%q�g�J��N���-�\Z�-h^�{���8�����\"�<�y ��m}c��������N/��dU�� ��:qч�3X2,�n�V��^����Dmx@w�9���m:���0]nm�㠠:��P�SZm�ϰ�X����S�::Oh�f�A�v�w��P>����ylL�L��Ư�j��,�<>7J�p�Jr9��:*�`�oB�N��̵&H$x�����I�����\\�b��q�~u�_�ɨ���iF��e/-f�-w�!^�J�(��s���\nX|<E�S�(�Ƒ6 �S\re���IW��1��~o���w���|�	س�jVMf�/p3/T����Eptp��`�\Z5�Ʉ�\07�Ӈtj�!�E�Ld����ZX����\"qC��T,̩�?!L�&����\"qU�%�<�Byָ\n�C�IL0�`��.�?W\0�]�YH��� �RyO\0QFB���i�D%B�\rL���f:d��j)Dpz�����ʮ����h�su�m�Ѯ)�A5�W�Z܋dk\\��\r������?����r���O,f�V�m�EI*>���uO�-Y�ݠ	��  �\'�B�QT	�Jdc	�@�锥�Yo0�<�d{P-�*�6��ήTS��DO�\r�;J�����J�d)r��h�;���\ZU�\nS.u�4����e���i�u0��u�,k=���Gi���\n]o�l}�z]��&�M���b������=�\'q1���d�ъ����(�|�\Z3�\r�V������-I_$um�����Q��AЉQ��Qt5�Z���2���M�E�98�c\\�I�Z�ɜ��su���p��k����k6$`�SV�8��W���hz������h�����{ڇ?����@��ʰ6%H 5�l�F_���b�[&`�����\\��r*���&��/\"�3b��5/ic2`n�*2$)g-H��ò6\Z� 	2��r��>������]�d\"ET�FBa������]���	~(�ʾ�R0����F+�8h,:���\'Xq_���3��g|,��;��a��)�Ok��y�F=����v:wi��\'#S���j�C��vz\\�g�5��>_��;���6R$����L2�9k&k+|2�.Ix_���go�����A��)�v�Z�������������t�ʨ,�|JƙC��Zu7�ʜ.`R�H���WUÚ�>a���z����\"I&��$)�p���h�v����,t���T57+�\'XR^#7GBnx�9�#r��\0�(ࠚ�� �����{�n>q�\\�id�����5��q\r�t���m����R���m�gid��2V���V���g�*he�ʑ��\\�����D�n�m��0�����v�/�[�Ƒ)&`�9Ӗ\Z�W��y�DyiǞ�0)2n�uVI����������m���U��G~�[̥��~(��\\a8���+��֦U��ʰt:˹��f�W���5u�8�RS������:�a�������(��������K�`:�lÆ\Z|^��P&H驤�\',I#�����[e$C�����@LV�&T��J�ʺO6�ϰ�YW?�z攵�`���uדF��Ă��g�*����$A�_��R<vAP����%r�J���7�;#,���l4�,�;\"���N�.�$��/��y�!�.^MZF���B�T��(��\r�\nON���T\"j���\r\n>�\"��>DN\0���Q�Iɤ���S�g��Ʌ��3�>0���+�:7�h�������c�ꨧ֙��r�>���QR�z�J�\n����7�k����1���/�����\'+��gl�]�`ژs9���BM��	�c6o�k�����mu�h̠]ή�������]�����}��\0�����ȞC��QAv�������h)CZ�����J�ky(���-�C�]�4u��!7��޶vnxrc4Q��Hk4r�l����=L����_�߼\'|8uk�(S~eCq�:�g��أ�C�F�+K�\'6��;�$#�����K��\rG�r�f�S7��j;#�~�y�I��	X��%��3Y�Y+�+����_�n��\'}x�k��C��3�E��uf_\r3Ϳ�PQ@�G�����qxˑ��W\n�%��*q2�JwY����x`����x��NJ��;V��Ylmk�6,L9)jDu4R*��vw�w�|��Ȅ�݋n\\RN������>9M�u�]��<������ؾ��vI������Ih-�,�����n[��jV��\0~��*oF�JYXy�dFz�UP�h4�N�d���Vd��?--i��Â\"r�(3��SO$P:ݹs�M���/����o6�r����KV������9�%��Z���x�bumM����P��\\��-)f�E��0� �1C��Mg8j���my��X#<kۛ��lckS-bǇ���!�7X����6�#�?�(B~����%��cD�mH��Қ�ϨN��6\"+����1���ʏTjm&�gg����.���x�#a	V9��$%���0V	1�;�@����e�d=��xb\Z���ui��=�L���@���cC֣?�e����b��g����s]�Ԯ��\\��٫%\Z=����	D9ÇgtFkI|)���U�7r�Y^R�EI�r%3�Li��qp�gϞ�I��\\pN�H�X^ri1�������L�LJ�t9��\\/wy\0Y	F���~��\0E7���\n�e�Fǰ}����.��Y;�V #Pk��%���Ƚ�ςK�?�{���:�#c8&�!|\r���(r��gO���~;>8n{OLaY^j�n�R �웟����ʤ��BeS\rdU�X\0Pq��ڴ*\'�gɞ)���.�����d>t\n��ɰ�:`���D��m�.ƥt�6w���ζ�)��|���#���k\ZJ;�PY+�O�������H0&�\"����LUQ@�l���:�0;����|�s\0]��*���l��Bf4m�j�E�)���9,��V�l���E})�`~��=�u�����)��A-�g��xt��F�d�^�xd\Z��4�4������GU���XD��kU.��J�L���M�É.lA����Q���F�V\Z��<,���\nXdX����w��U������A����]��Dk�T\"��ޗT���U>kRz��Z�p�ͳQ�Q��~��g�J`�/��\\	N���6���>�V��;�ۭ7��0���d�Na��ϵ��5!R�F�� �)ƍHls6�奲\n������t�����\'{��w���gτ�A`����.A����0@vI�>�i2ư�����������q��;逢��ōO ��,�џ7�C�iK��GR�Qr1dt�4#:�\\���f{wG� ������[\Z\\�{���7��{$c|�Z4T3��\n�����Z c�k���Ϥ0�ܖǣ���ç��Y1�L��l�μ��C�̍NM��܅�Q�2D1I���)���YNW~������S�H��zϚK�ʞH�˺N�OV�u��/��5-W�d��bn\r{[��aAgZj����\\�rs��t�K��#�VN�at�,K�O�\ZT8*�#QclA4��Eꥡ$\r����~_�(-d\'�i�\':���4��u��f�U������}1o�;�Zt|�i��ʩ����D���4]�K=U�,�.����4�F���2i;;7۽;wUZ��P�,2�����m�a-J���r�\\Oi�\rY�hJ�\"\0�����#aR\'\'�����g����\\XB�loue\"�\0�\nk+	B��q#���������6�Lč�i&\0��TתfB�l�q�,��aJ\'�\\_�r`�X_�4c�;�[����n���v8;oǇϤ1v��N���~۹y�ݼ{_N�p�t)	s��^Q3`}p�D�D���9Lx��hTA��k�����:��k�jX�,�;�����i� �!�^��]��,d�TFW��?���X��������_K �㬗~y�\0�?ē\0��.�@�{Y�-�C��z�6�O���\Z�L�yzR}��dX��K��Z��d�KU��$�	��0�܉�ə�AibK�Ȏμ\'3d6i�|����,/6��&�R�i�0�u!���͕���Ȣ�f\0�b��W�oO� �]�Eԟ?K-�*��x�̂o�ό�`��X�UIP��L��ՑT -j?�OvzM6���>x�V\'*vp@>>n�Ҍ:�}�h7FLW�N�i$�d(x�g(*:­�1��\\\n�����������?��5�����Y��?P;��:?��3GS\rUPm�b����j�>~��q74�$�|ݞ�\'��mJG�d�\"Jz�l:�^|Ǔ6Bx?��S�.�3N���2R����w>�l>�JAE>�A;:����n��m�?�\\�y�����ݛm�ƍ����152p%�hp�B���*���^I�1����\0kC���������\Z�&`�Q!����@D�{���E	Ґv����ղ/B�a�9U��F��4��L!���崪����r��h��Ş�>�\0jv�̷�4��2�Ђ9�\0�T���~p���=s���S��g�B4W��D���7i@u}���ɃS��µ\"�ˇ\Z-{J�z�w�Ċ�,��D�D���� �)�!�G�pIs����ὕBӱ�]X�/0$7T�������F9<�bvy���74�w�|\"�Y�ڥ�19��8��U##4/��/KmucGf�����\0�ӓ�6�������BԎ��^�\r2�%��K������J��|�Ɇ3��v�&Хk\Z�v����v|)k�gV�$hD؀k�kmg��J{��q{�����\"(jRa0h��N���e;�)�� {a��F\Z��P����\\Yj��q[���̻y�V��;��c��U��0�/����Pf��K��a�5j7��l[�Ƹ����ߤ۸Y�tY�&N	�W��eV�U�x��A�0!%3ܮ�0����v|z�\Z�Gd��C5\Z�Cf�m}cMt�F���D�90�Er�^�uC��rKN���<�RnqЪJV�钬�di��4DJ������Z��\Z��Ķ݊2��9ęI\r��A�*I�/�G�k�\"����������%L�K�\'Ł^�[���\'׾�K���\Z��Ƴ���F �`��1m\"7���22ie�¼XF�Ŗ��[�VE��+)�r�����q�I��֔�V*������d���B�FJ�~��9�����eRg�0k������7�<Q��n��Gei%�MF�(���4ݱ���+����4������L�X��p\\����ϗ����l�S��ʦ#,���l_0zS�%���ϧ0��&���37wya��v�������38Z�����=�{j����PCϗ��t�ŏu�de�6)�4�3lk�I�s������-uɔ���`{����ƽ�_��c}�l��#B裣�5�t1���t\'kmu��uw8���5\\5HY��\rs�h�\\X��kΡ�=���f[�	�C8K�-x��%�d�7n�l�ktהq.|\"{�5U_S��\"\r�F����$%�<|��f�2�c�	�Y����h��iR��.���t}H2��,9j�\nD�X�k�5~���::W�Gu���Hɟc3�v�b�l�!�4��4��.@6�\"�ʉW)-_����FrG��_7\n���ҕ؞4T��u2�{<O������C�/$��\r���Z2g���|��Yb �\"�A���/c�b�{�l���U\nTxܱ	5�W&�0��X_a�!W�E��|_�Z���p*���)��P6W��\Z��e�Y\'����ǀ;*p�f�r�S�1?��)�L�\r<<3K����2�@�����&A��;==�\'��\rNs�/�3����w�?j�+�6�࿱����-�u��T�n��`�p��\0\0 \0IDAT`0l�=j[���\Z\rC�ϳ���<���Y9�3�=o�5P���Ť�M�A��N��|&��4#�,��AJ�%���8$�M�L�ϕa1�-1�����̲��&Ҕ���Y�ey��3+3dC�u����Z4�3�\0���v�,&���~0���T�B^\'����{%?�`^��ؖ]ܳ��w�Yfx��M�����o������O��a&���@���3J+�����`���~�y1�I�d7U\Z�2���O��C�Y�	8�&���.;s�k$��!���&.𾑝`@�d{�A��;#y���,gLv��:��i-\Z9Q�ˁo���Zۓ�ݶ{�N�q��J)a�����vtp Հ�;�*af��T/����:����1 �T ����\ne~�m�Mwr|\":�J�\Z�4e��n�O0� D`.;P%X]��L\Zk1j\',K��P���G�h�匠B�x&�.2�>d+\'��@i89n㥕�����N�����x�ބ�k������=W:�\Z�R�m��i(<�nK&6Z���Ӓ)��H��x��L�ˮ��D��MJ�r����5�ꤝLg���ȴ�k�;�.�h�עMI�Cey�&���v)�Z�#Z��L��o�Ɏ�xh�r��EK�W��l�d[��tȳ���`~�v��㬥�ݯ@&:�ʢ�Ò���)�C�js:ٙTa�0�����U��J��¢\\*ʃ�K=��4/ä���!�t�/�ňcp�5]�B۷�t��,\'ø�9���ҥ�k�t!���K�6��l\Zt1�?����CY*9X�;fr^2<�\"����g��L�d\0v�g��{7)��0n7v�/�خ+m��9^�P0�q>mO�T>�~��}XK/��a&;���z2)���yu����z*1��%&��6��p��q�Og�\\�6c��k2�	)@A�M�\Z���������=� i��B�g}v��!qot�R-Xno��V���4��1��P���ՠ]#����{H�F`2\\`�� \n�����R;�[6=3�������\rdO��5�:�H��I\Z�0F��I,̕�܆&8,����I;8>V�R�\0@�}��j%�I�BȲ�7ڍ�7�b��\\��4��&��m�r>����(�yѢÎ�����m����������K��ώ��Eύ������R�vGc�\r`��y�)��2�~��S�]^�\"�Yz�D�U��}h� 0}��xAc�Y@�&��IX�xUj�LS���5O��B����E����F���I��zF��D;G�K��D�L��q&^,;�&����J[7�*��R�P�M�~[4���[�mg�F�u�v����\\7��࠭�s�v|�/�Ս�������>+���K)�%�g�.c��`���k�$�*q���l��0L+�{Ƣ�-Xw]�4�E�_0���E{��\'��Qk C-����S�	���H�S���s��`D���3h*��p^[_oۻ����i�(��p��4R�\\ZS��h(���TRG2�����7��HEy�N�ܸ6��e阡����Wh\rt	���9<9X��^>R��(\"T�Wmu}M����)�ӥ�[�m�0�d$t�)���7$�CƎɆ&HdxlC��i��j7��;���}�,�5�C����^���������<w-���$\r�	Ԛ,�?#|���d�\",+)�)KսsE&������Z��o��u����U�J8A�e��x�\0�+��#��v�_dg2E-�H�qL:\n	|�(5te���.�hSF����\0�*�~�1XpW�mY�Jm!�YD)W�7�dr�?�%�/ٓYM�+���r�g�� u��yS������ٳg{�8]N�ڌ���J��~���LJ�e�j=,k�/ڽ,a?�R�83m�b�����I9��0�X�3��ܗ� �����I{��T����[��̯�@(�3:���g��k�I���n����fDg���=%��{ttx�,E��8HV�y����\Zl�-Qj�9A�D��?_/�S�%��<�z�7ºJ���h�L��<Og��d-S�g!��t⮍�0\0}������`Q6<��w%c�o�4R�\'B4As}���l^��T���\\��g�B�]$�����ui���߿��唎V�v��!xbH��`�}�=Ě����;RC�Z��cM�H��$��E��g�8�ia�NǮ��m����xy`:��,����ͅ�O�����Yɨ�G�4�MRJ��Z֕�I���:�T����E#��L1{�ZE�\\kN\"aMU�%s�:m����&��:y�\\�y�ރ�j�;��EE�jP�)�dV�i8�Ύ�YV�G7�����	tH�V�{k\n���˞���:F�b����T��}^N�Y���.\\B#9\'n��g*�d&>�����vx|�Mw���L\0�ȼ��H���1�3U�c��\Z��z`^\'��i;=:ѾՆ��d�kU��Y|&>�?|�Ns�p�G-���I����F$�\\����\\����\"Y�5\\B����� �b�J4�r��oep��\0�d~)c@Q��j��C�	\r�(2��G��v$���KT�%4�<�>�CK��`�a�;eOc�O���T�\n*xj_����O@�K^KMuK�w(�����~�������~��e[\n�q���������>VP��o����D���A�e.:O1c$�.娡�_YR��,4&���%>)f:bp��;��%`d�:��I�r5b}�%�8?;iG��\"<�H�\Z��>e��_��x\rv|W&�1�|���l��ε�,-f��m�W�T(66��Ϸ�?��v��s*��se�|`3�3�f0���bz�N���޾�mst\r��_��:m�9ݵ��*�<\Zzd�,���f\\8�Vn������	�t���ʤB�3;�Ei\07�<�͑��Fk;�7,ٶ���p���m�y��̉�˅��t�����������-]M�Ж]LG,ɼam}U�Ȫ�e\Z���ZLq$�����}sW,�>/<+tږl9�B�22�����?�@���uoD�a�$�z?Ò�HQ�	,༚Q�7++���3�]]È�𥤼��D\"�`��ф�k9<s\rϵ�u�6�M���J�L�׳N�8�\Zt3�y��r�gO˝ዳ7�X�1���|ޯ�����g�zvw� g�M}٧������S��Gz�*���fg��?��߸��[��I��Z��7Nɨ�����vZ��2��JK\\�Ȅ�����k���	�+Z)o���z �]��TMeX�6�U�%*�0FJ�x)p��09i�-B>���Lq�*�*,\nm%8.�+���og(�B��sg\nw��o/~�#�����!���(hBqmO� ]��d4����~{�v8\'������\ZZ���e+\0t�M���.*�����!R�]V��.�3�~[�6QWʀ<\nt&9d�fdf��!�Ps�(��|d�c�*���X	Ȧ����a\"�2��J]P��#t$�XaN2��(X�jȴ�S�)��&Μ�WǢ8��0d���R&\\>���G�+<CeBQ��B�L���#��2`��LV��®�	�V\Z:�QQe����LJ�q��ã�vtx\\�#t��z��M1��l�r5GH�{b�0��R��Oƴ��ކ��\Z���;Z�F���B�qi�$р�s��+�-u�J�T�,�M�1��Tx��H�@D����$5:��c`\\\\�+W=�S��\Z�8Zf܄�P��\Z�ʿ��T������h6\nX�)��ӾP߼H��$J�U!~l}��7�)\Z�U�Z�\0�ʲ�z�e�+��O9s��\"֩��\"|,�-V���]��jeWKZA\Z�晁}���B�����:j�k<,��b.$��Ũ��n�[w|�;Ԗf��\0�J`�/�����;*�6�m+u��׾��+���N�}�^����T��଀qʜ�g�8N�=�=[X�d\r߮RBP�U�ՕC�O�!�@�Z�Kr�T\n�P$�3��	JŨ����p�)�+�\\.5q�t/k�~�겝��Uf\'�������p9���3a7���X����;wn����(f|62*�T	��]$f��%��y��9KI��u�+�{ܪ*��tɆ�=�����Ȱ�ӧO���^{8�@�kVe��%PL*)�^)�kw]�Zo�݃к��Q7Dcz����(��Z���A��mϿQF�=����˺��0�G�Ї���d(Hѹ-P?�N�^���n���%*ɩ`w/�#�B��m�����_ �,���g\\�/����7��Risc\0��>&8t<*]1��\nX�:�i�*���;����,�6�����A��n�9�����S�3S���[�8D����T��g� �2B4�����h��\'���a��0,|,%�(I��ǩ�M��gO�*\"w�N�÷�j�|�v�Ν���������!����n����ɁK�\n��\0�zq}���D��h?͛�{rrr$̈�P�Yc�1zD��|J7]n�t����(e\\��N�f�7�/\\.��\ZPG�qz&n���Q�Ͱ�����U9�%=���P#���d}U���7w���&e�-�zK�����F�|1e��փ� Li�IY��K|*eh��Ѭ5��D�u\n&������a[ҚW�iaY��y���0�a\rp`��t�/u4�G@�QED	�\nX@�a	��VU�B�=�TO�_p�;=��h�N=��19�Frq�`(�}��������&�]ũ����r�1�ǿ9`٘��3cy�ٔ9r���`K���=41TE|�w���Ϣ�ݱ~�����U�p^>�.NJ���\0^���ZsFn�چ^�՛W���L�JP%J�����mHKnp���r��$�m�>��2���\"�����\\ɰ�q�o���O>X��~��s�����޺y�#�(S!�����q(>6DJJ�����v|�ߘN �:�{�?z$}����n?���!m�0 �G%��C���d�09A�	��x�E���� i�*�<8�Q�����zڅ1p�y*gFHh�;�L�E~Z��ʸ�U��{�M�k��ә�8����&��ⲭ\"�,\0|�67����VN0�@%�>J�q�kUcA��w�.yv\"_*��2\r�d����9ݍt�X�\"��i�`�Z��meԶvv�?z؞>z�]NO4޶��u���=ZA�|>\\��\"�J�\"Y���J%iȁO�[4�!F�����7���\Z���bσ�i(]�߃����d�y���糤��6�����@By���=Aʝ��\r�g�N�q�`���)WG\Z�rg�3f5av�?�k�&H�^`T>$�mѠ�ʘj�\"��n�����O�2�eDRtpf�\Z;|���I\'��X�	��n�����q���u\r�@l�eyאc攭�g�L�b���pl%F��4������K��)���S	:{{O%��&?=:�uPΑ�Й�$������7ۛ�����m�9ɹ�\\��W�_��i?��?�99���ɡ��dd� �3@�ʔv����kp�dܓ��F�3�:�P\r�;W�N�/�$��}ᦅ:A�ub���?u��1|��T�gn�>$��|�RIςy�9�Ie.׍�:��B4#��,^_��2NƮ�l�Xʦd��<MVu����W5i1 Yʅ. \r�?\r(�\"��,�5~�@��a�.�~Ah}��ܺ�F����r{�՗�L����T\0��N䌃�@���B�zp��E�x��\n���mm��󺆬E����{�7�7u_:O����r�ʡ�ZҸU�ƫ���0@��4��P�-œ���Y�����}a�f\\;�!��K��h����8h�?��_�\'��eO�8\'T?�J4��*�$�����N�@�� ���\\D�,1�[�F2]_�!���uu^��G&����dgX�����@�j�Ș��xT]��ay.�8ykC�@��l������@���R��F���ىΦ����������DO�|m0��>{֞>~������YCJ����L��|���_�qy�y���eRн���t`�B�Zi{������g�6���0�.����LJ��\r��j��\r�f\\�@a��v�\\�\r���;2~Fݡr\rG��\r ���,�,��;�Ɗ�|)����L��J[]3������h���\'V��@�e֊G�\Z!PZ�M�p� ,�	����ດ<�-)��K���k-�n�\n�:Ϗ�����?|�?C�y��YP��P8{F@���Fb=\'�`	[q����5�U��8�Dtwu�`�C����nXz�2;��U�:�jӇm�t�F[��]�X�)嫿6��M����m�#7~�9Ƴ�+��u��5���,s����\\]��Xw���*���\\J>+�U�]l����ʥ��Ş�W�]S�X�&ˇ�M�C�����K�B�_1p]��a��)`�<��\r�Vڲ�I����->x�;7p���\rΦ&�a�I���r���Q�}cWR���<�[X���`�nZ���U+&��e��G>�����FxT�2wW���H�2B�2��p�j>+���C)AP��d�!��L��,t������-�_c�0���Q-�>�\'��.����=��z��gs��ŭ�җ07�K\"A�[�͒̐喹n�4���}�@q�D��@�L�N��o�3X�gip>2\r6=U�bvo��,4}N���(*���L ��dkk[�\Z^o+�X�\Z�����:[��y���ʷ��o��%��3g�����PM����B�S�s9PS�X���D\0)\r)i�����6�r�M���k���6Vv���9��ɵ��ُ����W��n�g��z� Q�������Pe�v�DM8U��l��<m��~�I�&h��(�\'o�8�}��3�~�۵<�i��Y�\"ॕ���MH칓T-��v�\r>&0)뫮d�R^�v�4���-+�KYPKm{{��o����v������g���%w�sM���?m/�+��*���9�#�[�A4t�K����Ǎ��=�浱�����������vy]]\Z(��\Z����=�2��hWK`sQD�e���OO���c�E�.��d�s�������`��p^�x�Eu���\0~�N�ٙ�k�2�  ^��^��㪝��4`�gZ�$�2Ƭ#��������[��߷����;<aa�y	��k8\Z�Ɇ;j��t\0����W72�@�\0����(������_o_����SZ2�3`U!5��r��*�T�P�R��V#d%]�];�wdXp���\Z�J�ǌ���_\\ݷ�vu��p�=��yUey��R�;��_�\ZTqچC�Fv�\ZCG�����\\W�B��P�8%�E�>���K1ضpb�� �g?����q\'gN���[?�b�͕�d�*)b0��g����y��\\G�\\�����&)�g�l��5�O*��\"�.���ݛms���?�^B�������\r0i`0������@�<��7�5��{e�������흷�m��,>|���>�ϴO�����ĵ1��M�)m�H��4�f��U�u>/��i�ueC��A�at�Q�������ug���5�%���UD���r�x]YEC��S*\r��,_s>=�:�\"�rP�hmd�b2\0�좜�yl\0���D\"�\Zi�f�dM�e)�	uwdf���R�T�_F�xM�b�bq���#���i\0o\"Ji�RN|��Pֈi��A;C���=G[l�}�k_n�����Wn��5��@���a늚�&��n2�Z���~����j2OJ��6�ဵ}�L`�C�������̊��ݛ-$�4�d�2U5���K4:��5I�q��ܮ�6���k��sɢ�6\n�����L#u�u�]����2:��V+���l	��nr��\"ާ6������D�쒕���g�s�X��@|/\'�1)}h�(;�1/����aw���«�(�^�<��SZ��h&�u�u�v���i��Y���eq��:xoh���=m������d�ƍZ�`Q�O��ö,�i�믿�NNϵ�>y��F����\'�_��OI@��aJ[\0����L=?J�G�g*��{�C�q�AI�X�q �GP��\\#`a���H��\nAC���:��]��BV4Y�M��0	e�_��e1�#	s�aX�*=�2�E���.t����LR��OpZ��������wȦ�	��\\+��U��\0\0 \0IDAT���1�(�%+2	���0h4�����* ��#�Q�y8�e���MF+���寷���iO�+@�3S�pf�{3�D�\n����\r_�Pu��4S�^X�9��d]��x&��.V�u�	��� ŉd<�G����Y����`�#Ѕ�=rR���˙<4�NY%I��!�]r��S�%�^���i���$���g��/t%aX�ʴ���N��*�tN�t�z��ܬ�M�H��%�Bi�_b�׼ XD�	X��|o��D��&/,G�%�����\"�6�؃�(\0`ȹ�S]wU������r�S�._h��S:ּS�}SI`�n�T)���X����ؒ�f��ZϞ>v&s9oo��n;�������mgs���?������8F׺Ɯ��i4�7�)>�jiK*�,T�v\'P��	�!*?��N�\r���ln6�8s�L��E;]�`��l� �3��{��y���+�[\Z+H���5F��iq��X��/�!��׋�r2��J�n�V\\��7�l�`K����Z�\\����6r\n`\r��55��M=\\���m��Jc=v2a�҅h�\"�g�������J;�qv�e�¼���^\rLg+���qG���^q� �P\"HHY� ؜��ȿ��K<����\Z2Y׽��	�ne5p88$yS27\r V��A��\n�L��TKJ2�(s���\'�0�^�=#�8EW\"�]�k\\G*$���6����E���Vp	1������b�{���9����漎F����М�o�g��}UҕʦF*JZ��Z��[��z\0J7YDf��t� ��i�\\s���P���\Z�����ml��4�w�D̞F\n`��0p���?::�C�\Z�+���믿��z�\r��׭=��o�G\'r���l?�w�v�ԧ>eyeJ��9\\Z��\"R��U ����2����l���\Z{)�D�=��t�(?�\'\'���s@q�ֶR$A>ن��\Z������1TJx�\Z�}<�����ڢ�c��d�ņ�N������j�ͯag;HI�c���3v�vE����@xeYA��^�\Z\n�}j��\\��tN��=�{�^|�E]�Tԍ�p0��ͬ�Jڀ��?�¿m{{����4<�Df��x4�(ٖWT���i%Y.�K�Ƒ��r�qЦ2X_�P�b��/Ʉ���/$���\\E���0\'Y-nԨ��P4A��ް��뒃��j�̜*�������i׀1l�}_ٺ9oޓ��I�<�����o��Ϫ$L����֩%X�\\��{����JU��(��٫���7ݑt�I�������\\!��f���kS��.���cX��L�Z$�E��.�KC9C�TI@I[r������+x.��`������ļ+M�K��LdH��	|���Y8�Ac|�+_��f��}����ֻ�E�\\\r�O���Q�H�m܁�FJ�kLg9)x؜���j�H�s����d���E�K\\�C]%�����M{�\r��mu��؃%�c2�5J�_?_�C/H��PRx�p�X/�i\0c\Z=�_!�W�O��3��E�u�2\Z:g}52�`���g��k񭐤YV�$|��ZƵ����%��\r�Vey�����{A�Tx]�[�[d[xA�M�Ʉ�Q��׿���>)�Y���k���r�*��Eײ��#D�)�Lm9�@�9@�,D�1�X-��3pI�Q5T�L�o�	�7:\"��\0���&��`ʲ�u0�t�H�ϲD�Pդ�{�������_�.�PӰ�\Z�G����+��iE\'P�JpR`�u2��/3@e��:���ʬ�a-�E�3Z`�\'D�W���]���2�$*�+i@n��>�e�AC��<�\r\r0�`�8!�{�����e�9n~!6���8�,�m܌��u��:Y��1g��f���B�2���Z{��@\0����ֻ���٬�n������}��|��[^��LY�F�3\"��\n�N��g)��^-�����Z*\r	���q���\'˂_��n�H�.ؑ��bP�lz!)�a�2�7��Ë`���互a\'���\n��!o�,��U];�Y;��q��;&�n�3���>ѧ����v_�h|G\\ pTJ���$�+�5Ϝ����Ƞ�����Ŧ�g-!3dq\0:������F�d����i��_�E;=|\"���f=�t	:\0������Wpd�q�D��>=\\3ֶTTWPP5���i�8���q�V�O��]�ҙ�$�;�\"\0;&C*ٚ*KәWP,����Af��E�߇��M��B%*��t-i~������� ��Csj`S\'�Ҳ�3\ZC��IE%bWmo9��[��\Z�Z����Ԅ��0����J������d!���9+bq�ҵJ��5K�C��tj�:�;�h�9Z�<�:���)���dĩw���	�Z�Gvz$�L?��i��<���D��k�~]��ko��=�k��Q;?�k�S����l����W��<aOi�܆n��7SrR��#X&��f���u���Ǣ\n���H,9rC:}e\0��^e�;���T�q?�3��� ]��5+��`Wsle�A\0���B�6l�~�O�#-{xE��\0����R�Ҩu�У��Ȑ��݄�L�I3���c��S�h᩺SeT�5;X�\Z��AemM�?r�ဠ�I0�-m|�3<N$�\Z\r�����,R�|�m���M��\0�=��]:�,p߬.B&���9c�2�e,H�^3��I/�UQ1Ԭ⍤��:ǉ��]���QP�u���.��>�Cux�Q�LY2L�i�ĤlƱ8�]r�Nb̛I�����*R���h��w��ϩ$�&m�U�	��ɨ�%��O�SvTc:�ÈU]�w���U������}R	4\\tL�*�G����j�+�c.�Ripɤ׫�tr>fu��s:�شD��H$�O팰�!���ϴP��0�������Q���aq�O5XL;\Z�*N��_y����o��V{��:/4���ug{��ݟ�������AX6�����lHj^����)(EG�����V�;�\'4��tqTDV)�r���������#60�r�G\\=���́�����OC���\Z��1�_�<��&(�T�G�W��6����\0u�������:P���ĩ#x�y�`�Z�:���z�,��K-)a�����&@�������	& #���.��TjT-{L�_���z睷�ۯ}�=z���d�.�ʸ��,) �ե���	uVU15�.յ����&�<1Qא�%��*��d}O����1h����K���2��^[�y�]��ֲ8�$�)��X�Y�:��1z]1\r��c�w��$p�b=��P��}�������x����x���#6խH9������y��}���&s�M�kk�VJ@N8��Sw	�ET��u�� �W�A�>Xm�S����;w�M���\0��49��Zh`a�;`A �!��C���T���R�����N`eIz�O��?�����^~�=;8Vw��9���F��?�S�����n,�pk���J)4�N�U!C�\0�h-��G�g�sTB�	�@��嚌��QEduk���ձ�S�V�éfY��%e����1�A��\"��B��g�*	�X&��y��m�$����9�	(�S��	��x�Z����T�.kȷ\rT�o��	l�⻡���:�����lz����do�4��|$ٜ�{.Od������e�������m��ö��X�f�dn�[#.����\n�r��<�1%�����3Z��2\\l}sG�TX��,\r�#zi.\\~8h�����p\'\Z����.l��K���\' 잕�� ШS)��\0��^F*�SӘѸɗ0YPN���s���˃\r攨���\0�#?�ii@�~@̍�{S���P:3]:�p�p$�Q�2d]���X��qs)�\0/�ڰ)vvo��훚��;��)�2�6��*\'��y0,Z���$?lp�#q��tlٙ��X���Gb7����4�K_}�}��W���Y����\"������3���V��p�\"�KU:��X���J,ٲ(\nE�C��$q��AN>�C|���=�\0�.��q�\'h��>s^�p��z&�m��J�!� �Z��C�X�.�ɘ�(��u	���d�yER[U�x����잾��?��.R~d1\n�\Z:C�q��pp�.�Sy2F�Se��q{�՗���Q۹�-�{4�k�1�\0��ȱ���o�G���)+F\n�T��7��j{�ۯ�q��x������,�;��q:���Pߩ|0+�35���5���}���NJz�*&��gxm�s{e�dm����ؖ@x�*~��p�)�H�x���V�k-��H\Z�M�3{--�����+����pL�,@�R��Ag!9#�1��.��{��Fx8�+E��s�fcY_��)`��/��\n��o�0�\Z�VIh�u�g*���Zڙh}��-��\\]Y������D�8cB�WN˥�pb����6�ҷ\":X��`�_�$1��;�������������Ź������[�_�e��~�S��۷�������K/)+�W�?eYՊV��9�Ĵ���\0��J���m��(,$a_���,���5E�4������qq��(�Y�h���^�xE��X��bu���]���ܧ<���\nW\'�9IR���9�\'�?��X��Z4��QS~/Q9$���!�+[���fɟ9��V��\n~Km�6����}��_i�g����U�N5D���E�����=֫���ٌ�W�^uZG+K�p�i��7�ڞ>zW�-�-I3�����Ga�o�C�\'I��x#�<)��#I����FD�>��̂C?P\\����g$��\Zd�����`���g���}�|�t&�$~)ȉ�V��h�����ULQ�����]GkH�fb�q�L����]]\"* Po+6�m��G�a�+/���II�H��-Vn�X�9�K����+�˒���c�v�T��Q��������Yڼ�nݑ��\\vjla���ż={��joB�TX(\"�e�8����ڇx1o7o�l�GGV�$�g�<>8>\\C�t���oۣ�=�!��OF���~������?��޽+ ێ+�X�Yeֵ1���{U?����S�\r�2s5�eO^NjY��J��l�8,l$�L5��F)�L؃�b\0���Au���)����,�)t�W��~[[t\rmf\n�mscS]M6kV�i���]�m��	����[A�:?�@\'�M[��(t�#��3Q]�����T7��?o\'��������˪��	�{q@��}�}+�\n�:gP��\\�w�y����o���q�����sɡK�0�ϩ�,s�B���.�4�-\r��hQ9m��ɳc��	�|��}\0f	?��4���K�r��G��Ȧ,>�p*��*��L���%��0o\r�$�u�˔6�]�*n[���?+=�]��ד�m��	g.(,}\\����T5��8��`��Rz�t�q-T�F��쮕Hc�J�ң��2z�&�r\'��*k���6^��B�����H��q�RD\0���N����^@�ȏx_Kmk}C�@�5a8p�vwv����pr,���޳���w�Y����T��9A�:9*�U�j������o��v��M��y��X��X�\rU�\r*-2�-=Y��d�N�RU�t\n�+@sd2/W�<�H\\�����q�Msɚj`G�.�)QX\"�������\r|��Xe��PT���|��!���>g����Ȟ>���s�D|70/��8-C��Yǩ1�Pw�<$���2C�SVP:�\0��D$�)� g�����/�����ݼ}C����F�@\'�=&j�DV�^��D��Į\\� CΒ7̩����;o��.Ώ���0f𜹎F���u��އ��/\'���s@���?\'H��۵1]}^�e�:���ge?��l$(�\0���T\\?�ە%��,`wVB�)es��!���K�H�|�7���e�@��ы��/��J��l\"���>�l���]�\"��@�4�Z�8%�6��\0�~����$��g���/I��:O*�VL�x��ʰݽ�\\�}�������*\r�`���gWb:%*��%�6;��X�\0���P���.�q�&���T���������q���^o�<|��>�t�(+@��U����d��?�Cmks�;��Mi�)�hX��Q69:�>T�n*	\'!CN;�J*l�u��fZ���q�~�ʂ��E���.e.�m�]ҘF���<�i��4��/������q�m�5�[m6!��x\"��%�M0!eX�X̃瀑�kQk�䎩\"�.Y�ѝPu!�V�dI7���2(K	*����]/]�;�d�MI͐�r(BgQ6K0Y�+�=��[ft����]��o�վ��/���j�sk�3�L&��^�vh泩#�-�a7;\Z����b\n�\n\Z⇛�y��e+/S�#��������̆\'�kmi�:��bD2�?��\nY/��u5�{$`	;��z\'�˗�ӓSTA��w�5�#~	3(7cPi�/�R�!���,2����>4Q7:��̮�{E\\��m�߫���(15�%>�`;�߲����<���/\r�m�Ɲ��Kԍ<;�*`)�.��7Nq��Ȣʧ 5}N\'cZ�50v\"�#f��PhM�����=~b���R���թ�������~���eH\r���4�	������c?��m}Ͳ�	�Ҫ/\\�z`\'~��)-����L\\�L9�D���X�%����.�g&=x\r���q���j�*�0\rJ<�׋���_�\r���E�x�s$�]5��UF��r���t����0w�|\'p*�NqxG���)ꨘ4@+\0ω�0 p2+���P���իKM/L���4V�	����n�m���_���<��~�n�{�F#�pt]�y��c�ҫ+3kм�s�\ZҼv����������}��o�uhep�քߑT����+��<0K}��(�T�rB�d�����-t\r�I��4\n��Cf)�8V�z�g�p��������3R�I�2t����\n,1#IN\Z~9��\\%$���_Q��?���Ih��r�SoOĸ�{=S\Z�]�H*좀G��e+.Ӛ�����kkb��H�x\r-��\'5�w�\0g�7���m��?��˵L�S\ZX���X���jS�5�D�4�\r��u;><Rp�M\'A3��%�G��\n�fG�=9�l� ɯ|���W�ݞk�6��8�� �ԟ��������.=H�e6��^��\Z~��`\":JQ ����,��1碗ҊWɄ����r7��R���xZ�=�]�;kΩ�L�c9?�8i�Y[%����F�+�����w�(�C�$±�xd����9�+��x��N�xȒ@�ó�AuE��^2�\ndK\nV*�Ԋw�%!Bx�s\r��g4���g��7_o�gv�Ƨqu}�M�����͡#9/�mL:��CȞ� (�f�t�h�G��՗�Ѿ��?j{O�\r�gQ|��$��R2$�%X&�ĲJp��~�xJc9�_r�L�$��~�g\r�����F����K���$�mu�m��0VEج�%��z��fq5\0���I���h�~@�\\�>�@�\nX]��\npx���猯�U�2.�.ߟ�PD�28�DɆ������V)\'A0�Dd�@�\'���[w۝�ϵ���\Zf6>�E6�|�pt6h���\0���\r��ݕ~8A���)!u��f�0�O\"܊l���6h���Е:a&o�^���g_�Z�;8hS���x���/�R9&�ڏ�Чۿ��ߵ��	���Dv�F��[�Jo�FM���N�F�\0�4R���C(p��6�F��7�&Y��\Z�i�p3�~|��CYAa&l�3/£?��0\r���QsSt�k��1:�Z��Îhԃ�L���MzrD�,^�7��F��tL=�Q�\ZG��eW\Z��U���p����,�ax\Z$�4�={�7���a[�Xo�;�m�_ x���ɪ�;���J�]X�3e�\Z٩��_`9���_�J�ַ��.ΎV���eJb�g��\Zd�/ٷ�pu?���U�&]�LM� �c5w���N���j��	ȇ��\n��А�q��]#�I�M{,y��DS�<\"`������I���\"h-ۢ��C	>�B-E������DxF����Lz�i���`��9-��g�A�%`9}�Sȍ�ū]��[�ڋ/~X5:�q	�d����Jt��͆=88�Z�X*�I\0\0 \0IDATn�b#)�����\nX���E�����C���y�������q{�d�=|���7�d\Z�i�Edc+x!�`�Z�O~���|��dt/k��}KF%Մ�zV������w=Z�,re`%\'b�,?_��X��]�����.���l#�l���1&:L|M|�e�8`xMH�Rh��/(��\nl��=�̧}h\Z)���ÜgD�-?B�ȸ$S�B�G)����Sy�$g A��n�=[s��X �\'*	y�To��Z{�[�h�K(wlJ�ae�*���ڤ�m�X)A��������{\'/E�\rv+�5`�����7_o����<l,0������f��2�-��g\'�w^�:���4r��=��|e�]��3�R-��l�ઽ\rT��\":�0F�գN:d�Fm��}Oh��!�w]�����]�!V�Z��e�Ue��-R0��>/�����g(�.�޼�Y�9���+6_ju��Ii�K;��\'��ʴ>�o�뚣�*w}��v����IC����:;A?��3�M�����n�.�ʔ`	\0l�)��%���sv1��S�?}���m�VX����7�j�寴�>iGP��eeDJ��3��/.��h�����3���5�Д*\"��c�*ѕ:{�ƣ4�Kf��*��񙨵V�+؁���2S\'Z����j��C5WiQ�]2m�1G��B́.37w`��R�:����������0���vcaM�����p�~r�qB�m�l�m���A���2w;�gn��!p����VI螀ŵ}������������K|IC��el`\nw����S��d�-3e���Ք2W�+��Зr��W���y�e96���09�dTE\'�j$�E1*	�8UL��kDJJ��@	��֤�V*���`���@9|�*\'�,��K&���RB�O�ĢW�z�]��A����_�9����n���y��bd����ԇ[dQ1g5�5bz}l+D\rŗ�K$�O(˫�,�7|Z���J\'R�;q�&2-/�`g�V[��m[[7�sI�q�Ύ�*>�[�f�pU����pEN\0|	́��|-5ك1\0�N͠��&�u���;��<#ͥw�Ծ�Gھ��.H�eI�.�f�M�(Hk;�k�\'���G_zQ[;�O<hH��(J��|�2��o�/����#Y�P��D�(C2!���2�3�<C�U��o�T�ҫ�x\0H�	v\\\ZDmx���.�R+e)g��LP>y��\"�U0)�d����.�99ØV�scW�(������,Muy���;M��r�X�\0l�)m�-�pz}Ѿ����}�����|�#����dYF����߆�.c��@Ɠ�\\P~��g2��E\r���}����^�ڗ�/P�l�h�[���9�$f�h)f�+�,RKFJ��E��p\'�9\0��U}�����%�Р�:2ԡ���Y�ε�*�N���6�Ra�5�9����y1��\n��T�>I$���k���L�K-5�\0��_\\,E����`���\n&�r3)]��U�����!=�\r<���&˼-��^�H�}����L��D����7m�j.�o\"//��ɩ�f��E�3Tm��X�<����Aȓc-\Z�� Կ�h�R{����F��v8�Qt\0�h����ſ�*2��!茊�z1k���6��v������ڃ�����lDZ&���A��Hkp�n��{tl������~Gq �R�Y�)2��:��;T�SԀ��,^�$�m��P�zr*0_�\0��w�M��pݼ���j�y=�\nYK)�9���!ij�	:�B� 66�d���\\P\0\n�7oޒ���y@���MO��,���x�4o��^A_-��������ռ�����o��Z�{�h\r�������RIQx4Y~�/몛����XWe��&�ѳ��������/}Q�ۘ�E�I��&A,=�=�ucu]�We�</T]O3�E4�ҡ��\'X�\0�W��s��HyS���4��Qw@����eO�����|O�������*�[{��>��P�]vێ\r��L�7H5��BZ��DM��M���V�D�DDjEI�(M0��`��eU��n���3�y�߳޵ϱ��|��=g�o���w�g=�y��s(�$	\Z��Τg2����(�0MC�g��As(g�e*\r��F6�����������\Z9.4�S��`�F��g[��|9Z�~�X���0�2�Mc#���L���m\'Մ��\\�h:��U\r�L#�L��s	�׭�=1l,���ʴ�\'c����p�=��v���H��pyP��T>>�ٽ���ko�q�	�RB 3��3�Q�U.ۍ��?�]����vU%��9Zx��-A´<D�H�E�X�؝���)0��p�i׋^\0��m2+�\"���\n���\"&�*�>�!y�r,PIV��vuoR�����z��Hu�[��(���2�PPv\0[H[<G�3�Aw���u:���o֚\Z�aVs��M2���T��+��O��YI��hXRd-p]^q�BJ�RA���ů?g�\'Ƕ�`մR�b}mKV���!�Ɔe��4��{�U�y�٬s����$���Y��i���w���;v��D�Vȵ\0�sP)�,ZY�34�`��I�t�R��͊DMde���Gp����1�]�/�RńF>0Ug�l�|2���i7q�g�����S\\�����Ud:磽G6\'�j�\'���)�ԝ��Vt�s?�u��SxK�JG�&��X�)=<{��A�<����Yꐤ�q21H���L�v�.jLF-r9�xd\n�ʒ��ƻ�2�w	:��҂1]�i����Pg	8Ap1���I�(.�Ó�#Yv�r��\"��Ãc{����I[鳟�l�&rV��Y*�SW��w|���l6\\[*i|�1\r6ZjvD�Gx�\\{�H�����[81U(~r�B�Y:�[�9���\'�pc\r%�i?O�hYa7��t2J�yH*Cu�{5EVg��?�SF=ƺ�V��adq≥�ͭ�\\�ҵ���Pԉ�m�\Z&�Uc�%9��V˶�wu�+���&�?�1�):��t�ɓ���2����+�:w�\0��&�!�yf�ѡ��_��t(��ڬ��L�>[��ި˾�!kcm���\'y=W�%��x��߻�.���Q	�qI>ǃ;���_������\Z�����1q䟇����)\\7�����2��m�%`���E�������Ԑ5����O����x���J�^�i�6�\Z��כ�����gzX�A��^��u�]����z���i$�g�V�i�zq�=����25�SgB�����n�����`���hd#_�;��fs�[AI`ݽ:�URZ�ߒB�\\�^���=\'tnn����H����>Rp�\\�6ty2�J�z�M�µ�m�����ܵ7޹mKJ\r~�2��VA��T�J6c�\\�a�}ﻵ�}���tRFb��tB��p>����\'N]J���9ڜ�d�\n1D��F�{t2``��,�rQ�`H�.�]���kcE�\0ſ��|HG��MSZ�n�ʶ`�\'\"YV��n�\0�A��.��PB��M�&31��[cލJT2fW:ݽ���,��4򲉠��b�b����u=�f�&���Fk�ιb\\�A�\r��Mϯ��oǐ�#�V���e�f�߷�~��6����g/ɚ�y~	�L��I�+����Rx���IJf1˗�0� .��S�QK��]N�����Z�7����KJ������٫J�2��#&8��W���D��8�>6��EK��ɕ�J@�~>i�DT�n�y3� ��w]v��dDf�^�T���(eODC\\�t�*�6\0)4��ͭ}�x��ϫ%���D��秵/d2�`�	�.2�f�)�7n.���|i�jY�\n�s�����Sm��=��ݾ}�^}�u����Ƌ�\r\'swƑ��Y}�,��E��M�{	X�o��\'nZ�U�\"gCd܄�Aw_�����d2rNv�.�����|,p��?\"x�h�[�O�8�����*k�UG泮$J@\Z\'7!�SCC��u��RUZ�s����䞫O�l���vw�pȼ$	���[[2V`� +]o6%i�I��^�����5��\0]j�L\r�Nm<��G1�B��έ���ĽtG|!?���R��\\ڝ۷5Gx��M����<&�04h�ދ�\nua��:�\Z�vq:�k��KV{i��q�B~>��y<�?^x�9�2�|2���M�7�W�=\'�F,�q_R���,z\"sF)��]r�	�>�X@8�X�D�[��at7�������D�x��:��(�����{�\\�b�f���OtO�|Qb[ j�H�e>*�4\Z�����ٱ\0W]��)�\r�E���8\"�Gj����\nE�%S[��\"�U��\rY�o�\\�|������M�l��!�2��uu#ø�qޏ`����������\0���\Z$����%S�����#{��7���i`̈́\'y7��V¼�D���\Z�C6kO߸a׮^V;\ZHK�/����|vٽ�\"�O�PZ��S����`�S��J��)F}h�3�&�����2Z��sf���4&(K�DD�{|f����J�\"*�4���(k����_+52Њ\\a�N��)�w?���@�oe$����cנ�	T�6�K\0;U�3*�╕��%���^}�vpp`/^�2NI(���@w�ްJ�!)t��t����d���%}dQR1\"���T�(um��X���ڇ�,��l&\0�W�e��������c\r�~ȏԻ��ZGN��!�	�cٱ/��v>p�� Z?Tt��:�iZp�	��*�����q�����̘��*uKy��f�~�I�=�.LuR�Ԡ�G?E��\'�F,<عNO��AL�Z���zJ�#͌q]��z�v��a�$S#6�^k%}�R�a7n>%-���Yۤ���8A�Y�����郞p(��0��W��M��M����٪^����A���P���n�d�.V�T�^�o��������bw&刅��2�N��UK�Y�V{���v��5�㥱.���*Փ��\ZIՂ����\0+�5��Z�/Z��\'�{��L�ʅ�c>a2�9�9�w�e�h�YI8�ſ+����{���^\"���E��(��%5�o��D_���A����}܄�{kc[Y��]ju�Irݩ�l�$�����R:㮼�6q�\'&��5�.�TE��y�(L)5W�ۋE�n �,ϡS��Iֽ��j͚-��9Qd w�a)a`�|ϲ�1�\0�Q�%Qi��4V�G�\"�����``�?�・�7\0xx�	O2����a������>jI%�l���D���\Z�:W��8>}@��JB�Қ�ͥ�6�0直���]�D�/ᘴ�	��З�B�����Oq�6p\n�raR����A���\nU\0�9�6��<���J�X�Q ��\r��x0�¤	�RZ��\n���Գ��6w� ��>��Ntq��K*��C�oh�nGx_��|6��	��J��Mߨ}|�z�Ӊ>	�\\�r=ҢaN��5]f��o�lo�y �V{L�\\�r��� u�R&gO_�nW�]��m��;g{8$I��h��\n$��R\Zg<I%s�i�KzXEw�y�w���1�`VD�ɱ��СĂ���%3�TY=u�vW��q�\0ޣ�G��2���_o���F�I�y���\nR���4�\'�\0��`�˼�9N�\n��u�k��<b\Z$�&t������ �<e��u�8�\'X�}�K_�\ZG����a-H�u,��RpX�]�&_���,k���]�]�0K`���!��ح���\r�٣�S�s�Y.��z�`�,#a�W���S���C���m��&|,\ZQ�Ʀ�ɩ2t-�i#hų�$�u�ҕ���Vk:@(-!i�V��q�e��G����a��SƬ�d�2����l���Tt�(~2; ���U��H>g��43]B~��3�x�5ȗʂ (r-�>w����vC,\0��*g��{���,�,7ut{����{�9\r{\"y��Yt��t�x�����aO���u2%(+������@������vpph���޾s�Nzc�.�Iefn%��k��V��$�ϫlO^�a��mk{�g�84���.�Q# o����xQ�#�(�4a�r;\r��㊳�L��%�x@�`�}\"S��@�;H��Ak�<\'}zy�u�Ӛ�1�1b�P҂�y��:�� �P����,�J�RUj�PW�%\'@����:���yr����8xa*h����Ⰼ��)dXtx&�g>̈́�w�����V\0��wa�._��f��w\\�V;`q!o��@��\0����̝k(W]Ɂ/7��\r\"�p=�l������_�7޼e�Rњ��5�%k��V˓A�l&(�Å8�A<����^��6�F�=#X�L#�{�T�n;J�&��j6Tu(���Yf4����~���@�&��Nr�|;dy2��W����b�U<�s\n�����A\\EB�\nF>����?u_<#����K�ZX�����$-���$(�w��nC�R��G�%ۻxŮ\\{�fs��~z:��]w	V�daˤ�t��rt=s� i7[[&<D�C?!()4�����ޮ6(��񁰂V�n����o�e��޷G�][d����O􁹕�v��T�p�f@�\Z�ݼ~]8Li�����G|��1gf�z�A��I\ZH���l�@q1�����b^�r��YûB��ݚ�p�C��8&4�!�:�&�d�ZM1�Hi\"��@�FJ�C����i�?q�ؠH��0�3g󇪀�qIA�S	���T1�����\"�2vLn��e�DX��B2�1��Q2\rGC���^��~�Ϭ^)��޶]�~�v�/�^�f��F��J�\' ��z���s\"�,��\"*C�@�=%�,j~�ތ�}w�lQ�ɢh_��7�_~A�q���6��n.��������4�N�M�<\'��^r��L�\'�*������\Z]V��0:Q��$3]�ֆm���A�ο9I؍S�9иXn>\'O�h��d8�uq�Q\n�H(�����W◤�У�8t��+pZL>��}��8��O��{��H\\;9�|����)]F�\r��.��o���Nx���Bž�M�3�5[v��Vo�X�ڰ\"���Xrg�a2\0E��a�<�l2��򅒎L%RJQ0�f�%�|>c�A�z����CR��ŋ�5u{=;|���߻c�j�7�dlw�=�{���ۏl���+�J9o�\\�v\Z5�AP�uN��W!�n���l���|ro־�i`W=����wS�s�q\'�ű1�6��|�ùz���d�\\�\\�H�$<�R������Vn����qf�64R�����i�߹V��X�d��\'t�}V����.8�%�g�`\nPl��%�{�Lܔ��\Z�����\r!\'�a�#��/�����9k�*v��eۿp��.\\�!���c�j�Éܖ��,#\r�\'1@�+k[a�\n,_�p�:�!�\'AIۅ�\r�+�u�������k(�lr9��F����֪3)1��M��[Z)�8\r���Č�P�w��s��_[S�Nl.܉������A,ٜ�g�\\�X�>���<�hCu��Ȫ�i�T�C���9��)Dp�]W=����P%ap���(� ,ǽ��@�.�,]�� ����Ú�K�J�$k�y���֩o2ii�ƛ��ዑ�嵐���%�wۥ�O�)��J��lb3H���M�a0!�+v5�NĎ���9\"�|�Hv�Y;^�+E�R����R�`o���<�F��מ/ك��}�k/�i�j���,���څVM�A\0x��2q��_�b�����ʰ��*��7>�\rF���8i\\�s�2�h��B)��6\Z(�4Ȍ�A]�7оw�w��\'��;\r[{7���\Zރ�6H�\0�\'���\0�Ǻ�;���g-tX�4��f����[�f;	�2��y\0g�LWe�t�R�����e4dn����2�\"�Y��:_\n\\����A0xO�����g?�Y�}��=����g�m�RM�b�մ��\rm�v�g��JT��G[8+V�5E��~P�p�ND���mu4�Sc�LҕMff���>��g��qߦ��*{	\\Y.���f�v���(Z��T���G�n�e�?���+��[�t�(�WT�R<aY������d�{���ֶ�!�VQ2��E�⢗^�̄1ä�&]@Z\0\0 \0IDAT�*���H���k,�~�7~Ʌ\r�J�~��b��(�?�`�\0����z`�V����BU����uݫ�w} ʝ�248���F��Bj�Kl�L�ӹm�^�w��}\n&�Qr%E\08�Pk~��籌#T��(ݛ�[�,��TM&2�d�@�V+�hصG��.p��5k5[\n`��S뜴u����:��V�V��M����}������R;Z�G��Պ9��Ѱ\Z\"t�la�֫�~�mlm$��3KJ4���K�\\J�\nqm<�(|�)���yX<[/���yM@xW%��B��hl����(�C�]��T����ώ%%�F\'\'��<�x���-�����/zN>�@�#��$CS�H���<\"Sa¡���U4�AnׅaI5�/)_��\r0�t�S���\r:�B�y:�;w�؟��X�Y�}�����V�oH�p4�?a�$�B�P�`�P�lh2������?��D��&�؇��9\\�26���ߴ?����=��+��g��\0�X���FͶ[e�jT-�#�Zv�0?A��yRmI�t�$\Z.���E� vU$~��&M�EۿpIg�ٰZ�&h\0�\Zi�N[��7gJ$(�XG���V�����]��������gZdPn]\\��S�%\n ����]�\0e�9\'k�^6��[����Owu��S����D�L������=UjNJK}[����~X$B9�,�Λ��e����53�ZZ\'�T���ў�\Z�\"����5\Z;9:�>�%�L�r4�[o��aj�!���:E�<8��xn��:��K�t�����vi�e�B.���p2�����n�:��,��E9� �50I��y~[�ځFЫ`G�W\"�>v\"E-V�^\n���;�	O&��:���$8�C��	Z?IUT~y�\"��sv�҅C�*�qd���*	�A0��y��[y7�3�4HF]����A.�Tʜo$�y��<�-�Vz�9�z��������^��=�̓��g��FcCj �p��Å�V�V(�AND��YAM5j4\nvw^�J{\"�~�1�J�5�@�r�|\nV6�౜ݺ}h��̟�K��#,��B�[Is��~�-K9��\n��Ӳ�V�J�aۦ�����u�`(�\ns�4��K(��r���F\\Z�Y�k\"�,=��Z>$��O&p=�h�Ir9u����0аZ�bI�?���A�����t�v��hH?$���y�aA8�&�~���]x):����YXl�a������Be���\nT2q �m�tH\'ٕ��g���}�C���ӑ��==T�V�U�<ѿ��Fh�Q��5j�͝c#�%>9�r2+h\nt�8��lq�,���<��ɉ�p��8��Mw0�/}�E{txj�펲�22Y��Wvi�i\r�W��bi��V�A��M#K��qP<2Z6ud�qO��ZhK���R�ltz��)�9��;����w9(�~�8��ֻ�g��Ί�g�5B=Rk$Hk����@t�)�H���i�Q����6J��T\'Ȯ�P�r�9X�%�����%�Wl\n���cC&�F4���\"��� I�P͈��el����}ዟ�ãC{�����޶��+Z\"�:�2�;�UM2p��dO\\7�4YK�ƴ�F�ϛ��{ƨ�W,�e\'f1+vpҷ��ԟ��>�5�,�@ο�h�+^¡B�D��N��Zu�(r@0�߷�b$W��4ODA&ε�����Î�(�\nQ�����h���k7Y��+�ݎM�C}6֊��@hBB��[I�Z��,dXё��)6��}���,Nw������F��3:�	؅r��G=z�-J:�JM�||�(7�gl��L��p����ͧT±�Fr�%5���v��O����^�M�ZB�^��O�3�G�\n]�%aD�ʬF�u���ْ&֣�����擉�58L�N�Ɠ�U���_|�˚�n��d��������4}�G��r��uiϚ-�b�8ŵ�	e[4H���(������5�)��g8VV&��3	��%�ى�A\n�������U���SH(�+���\"��!F�IJ/�$�S���L��p�\"���=�6�\"t�/]q�w��V8x)�	n@\ZrWk�U;d��	������!�`�9�+��c�ܽc/��\rkm4�]�y�U��_���Q�$��S\n�K��;&%�-��\"��C���س�X��]\\�t���0Tl��ӡ�K������o����Þ��[�,+�[pqr0}2�bN����֦�*k�K�j�m6�ؠ}`��ت��ft��d�dU�y��b����C�Bu��+,Q�Wj:HFc�¾\\���UtF��|ys�\r`b}빰���_��5�)t�ҁc��$8����/�ߑ��C?{-�.>^v$JF=$z�sN��NVy�i��V>�\'F���-��s\'���}�m�=Ϧ��ml��L�n*�.=�f���MvQ>糐)XX�����*%�e08X�}b�~G,��}\'nb}�?R�\\\'{k4tz|󵷭7Yح���b\r\rqo�V��ٰ�F��|^)G���l�Eu��#.�rC�I��t�Dg�����g�*�Ri\'Bir\"��|a�(lF6���t����Ē8�eyg���<�|8��0���9�\nCݔy;��m�DQ)&�.y�aӕL4H,C��L�<�B�T�cPA8����O\r��X�h�0Y��\n�;u�$@X�;;��z��O����x�^{�ukn6%��wkk�\nŊ=F��Uټ��e[�V*\"��sdJ8d���v���{��eacz&���W��8�|ɜ��j�?c���N{C�����ٿ|�\ny\Z5��!�\"S��z�*i�ai���S-m�U��f��9H�C���l6�r!c�2�3+��G�\0캼QL��>ߊ� �\n�/��Vm��6����O�R�R��h�ҩǤ���x&���wE:�	,<&�;(�K���bS�\Z�����߄DkL���%Kl\ZFB�FeM�ɈF��YL%��G[b\"p��Q��&K;>%8)S�����������*,����	�Εv.�\'��B��QC6i|&��\\#��jw�Bh@�xJK2,�g���2,X�<$1�ӈ	�蝇��;���a��#7�p�[_h��^�h�N�jX�2�4�l5moI����0�)*�jG���Vv��?߄�����Ω/Riʒ��,vO�uj�a��,�(�!����.�6΄���;��7��t/Su�PI��!��D[��:xG>�ޏ֏���̸�8؏��H����t����\0d_L��Mդ�JYЅP䁫Ez�TNe�6\Z��G���/كG��I_�vծ^�n.\\����<鴍��X�޲J�)�Sd�y�\r4�ju�F���Yq��p\"��/�.c��k�+��xb-ܝs�䣓���}ў��-r6_B������W*d�p�� ��4I�\"t� �V���Zռ�r^B�3�H������(\r*��]��r����\Z&H7��|(�t�0>�ٔp���=yr\r7�ߞ�D�!�_�������`w��q�b^/J\Z:mm�\0u������躈�� �Y�)��\0�g�f��������ݝ��ö��ad�R�~�g�����We�]-������4�F�5���~��L|��N��yS�MH&/Lbt�\'�[	�\"#(C���rI��P�L�ʬB�z���J��X�+oݶ���\n����/��-��߬څ��2,6��F�f{;�bv���rt�ɬ\0�	X�a����y\\1�E�r�\"{i.�X����\Zp5W�%�y�����<�@\'���M�����󳢳V_Ȉ�ʼ�»w~nY�L����K�#{x�\'�(2t:��\"�,\'�rp��MdH�C:L�B�T���G�)|�\"(h� ���0G8�֭�,��o�F�Ĥ�g�-���\04�2�����F��5g�@;RH�{�/\"#)�`4R����|���S�\r֔S]�o߾k�}�%{���tQ�U\\�1%�x(�I�@�?$kJ54��p�R!c;�Uk5\nV*��W�I��l>���+_Ϭ+q%9��	m���zdW͍\r˗j6Au��ϖ�Hπ\0�=��~�:��������Q��/t���w����˲�������*��w��,\0�k)g&��q�7��������h���v�n?8����&�i�==��j�~�?�)��w��J:o��l�9��踑�xgFһ�|)�J�չ�����5\Z���D�,Kj�	����a���L��x�<d��d��G��\"��ڋ�X��r�F����g#۪����}�C2��km6�V�U�w1��B��	��tO$�@\"50���;��AP�\r��s�\0B��D\'k� AP�bXz����Ɨ�J	��v_��h�$�� �tB�ZI\rc.�[$��ޏ@�!K�*꒖�(��?�4���sIY\"ծH�T4xLCa.�Q�؜��Q�f��H�2���\"����g��bMP�}�M{���ꍫ����̚kD���ATN�0�����|��@�@F��J�z���2�5����	\0떪G0�;e^�fN�C=��޹{׊Ն=��W��_��w�lda�ɬ��N��l�1<|i��u�g�ˮ�\\#�Z�^��J���e+�W6vm6l�-�V*��I��\nIviiϥ�!��|��H�_swN\"�Rc)�υ�2q��$�Ic���\n\\�������bƟ0��Jȉ�a7u��y�����B��9\"^C�����/�V�σM�M��ɢ,�<[���І���tj����,����^�Ȗ��m����?�����>+di�ZI�R%dN�aQ���-��R��͝f������R,\\>�JI�2V]I�JN0C��]��,���\r��N;=�V��[�ثo�˅y�p)Q2����jłݸ�k�r�2ӑ��a�Wju��*�G��I��24���I�?���qI?�Ӂ���U��?D0	\r��w�5@�LvYN�=�݁�o���z2�p����N�U6���;Ǎ�.5{\'�;�(��qu��4�����d������0>ag,�YR����%���D~^��H��w79\\�U�ͭ�h���7^�7o���u��E�v���kuq�N�m���>6�u���3�-�e���-}v�\r�\\�(	��q��H\'��\rn4��t���Խ�kX�K�R��w�<�����7���{�+�����SnHވ��}�\nE2�D�(��k�g�{U*Ek5kV*d�^)���\'�Z�l1�Y���3ffH\r�T�S)USS,o���NJ��s�]�i��5*\Z9T;To�u&��?�#�0����Xh2���8y�p�x��c�D��&;yȁ< N޴���Ѳ�Y�Ƴ��Gv:Z��i׎�Ol<^�d��noh�ZŪ���s���j%����G�o���$:����N�9�{GH����w��$[�d:PO�P)�t��EV6f�RRJy:���=V�.��be��P����^�G�9�%)�%�\'ܨ�������7k���%1��H0�S4���̸YR��ꚤ��{��ڵn��W�d����T��4CĚ:�����A\\���3/}/�-E%�?�6�\0�!J���pgx��Ǡ�%0]Cہ���	R2�|p҄���!�N���y�=$�δ���9H�>���|��\"#\'��m;<<���x�ڽ�]�vY����}�8¿�5\Zv���yv�x1�\r��Z��&\nj���BN�dU`�/,����1�`�$4�|��UAx���������n�y��b�V(��|>��U�$ I�.�d�>�����^�[��%5]L�۬��U+j��+dѓ�;���h*��Y��v�>t?4��<45���ʲW+�[tw��d��f��?�~\\���� ��`1ll�p�GF�Y?��CŇ�!Z!����	>Dʩ\rq\r�;/�u�V�R\rgKm������=��X����\0��<w�=O߰<���Y�^�dϾ뙤]\r��7^%E*A��!f�Y�|�dGkVɃ������P*�\0�Z�i\n��Ҫ���X�sb��@�]:�������`�N:���^��bi�oiJx����c���͖]�iY%����	�V�7�.ט�JX 7�����p�����:H���gS�i���q#���ɇ�)��X���^f��N� �Y�2+ϸ𡾰���\Zצ罹�#��C��(R(�+5\0([]\'J�mj.�����\Zs�鵳NŴ�Q�31<�ԩ3x�r*k�P�f888�G���wl��مK�a1�#��|�Z[�6�p���bCĜ��ζ,�~.��U�!������DVe<���d9���(d}4�j_ྴbTgew�?�O�ѧ��[����Ee_�T;����D͌�Jv��C�H�b���%-���6�,�RC�;Xk���F� ��%��e( ΋��<ء�ɠ�\0Eťa��ʹj\Z6OX���gD_��Y8�4�yGI�4�L	L%�e�JZ�,�j�t�L�An+b�B]pMfnr&&��/��6[�l�,Xw���pj�݁=>�Z8���u�\04	P��`\r\"UfVXM�������!uk�0�b	|���k���3W���i�6l܄�-�)\\��:����R&�3~;�?p��\nx�T�}JQSgn2�JJ�ҩ��q�g/�����Z�T�%a^�1\'c��Պ=AYX�Z9GIQ�:AY�5�ל�����e*}2E��Z���G	%�~&e�AG���28+��2=����u�S�/�Cc�=���rG�2\"�ˎ*���%��SG�u�(+K��1	���߱��{�̳�\0�\n�;Xrʞq�f:�$�FDא:	��_�<���c�s﮽��R?�|��]l�h�$W���}�|!W�F��������\rnE7������l\Z���u�␍zS�	�zl�Y2�Mj\ZdH�G�����ůؗ��<>����+ׄ�6Z�͂�Xk4�ݶn\"��5q�ӕ�p�T\\��?oKH��G�K]�V)ZI���5p*j���Z����	J�R�Іx���S�P��B=bW�e\\*��pO��ᰑ�c���C�?�ٟ��s4��d1P[��!x5t|��8wŝ5��pKn\rd�2$D|Y��r�ɗm4�Xo4����w�3��d*l�\\).;���Z�����˩}�;�=��}���n(���`�5�AI2C�JH�R:����i��x9���뜸d7e�����2\0���ό��ɱMG8�����t:m?�P6��6M�����+v��#�cd��7d����.�*������]�[9�Bp*\0�sÖV�#���c�	ҠpdG��,]S\Z�=�gq�D@{��\reג�u7e��>6B��wU�$�<����Z)]�H�M�\Z�/%|�v�9�H�K��#\0A���T%�\'fD�U����k]�ĳ�48-��lr��w	s�T)h���� ��g�L+���[���=::��߹e�^ךͺ]�|Q��F�aUș�%Œ��_p�l�P+���|3y\0�<��x�B�����`0���~�@�i�ϭ�-���eX�Je�︕�]��?&5P��-������������+�k�)c�{�ʪH�w��1]�rUDi2GJH�Q4:h\n���F��^��\"�9�bM6ƆP�<���1�\r�~��(f���Z5�m(�*�()\"�B+�=�<�>�Ct�mNk,(U:L��*Q`θV�5��m)x >~C�d^:��ȣ����j:]�`L����oe��ʾNo��\n._6��z\'].U4���f�]�A���u����?f��3v��NL7�SI%e�7�H\Z�ٓ:����2�f�hq�(�	X��?�1K(*�\'�@p��63���i_x�7_{�nݿ�k!S��8�Ȉ+�a>Q�`T�g��Ά]�j��ýf*]Bו?}�{�Z�\Z��l��i|&�،�R�W�%0$��DT�̚�Gw��f�J�gH�~d���˜�D��i��&��+��94aRpΊL(UR���aʞ�d�H�V\n�g&@��qp��/zt��9�QΦ\"~�~W�MvU�h�_J]2�����,��D:ݾ���+���߱+W.��ގ5[M�E�c��]�v�Ǔ�������^Y��y?M�r0�:^���[�`ص�n���VtW���ӃPmա!9��8�_�������G\"��h6Z:��0�e)�Z�a�B��������h�lӦ�&L&}���,h\ni_Θ0��%��X)Z���V�`�Ͳm7��_\rm�?��\"Y8�`�L\Z���7�Pr}�J����A�5���W��Ok�P�(�:҂�!�T\0\0 \0IDAT��F���4Ne��h_�u�%M��-�b9�(}\nv��Cu4XX��)�?@��sx;9a^>���N>��b�6�%�?�3v���*�\"�p�ei�&^��ykx�Q$q�D8��(_�q�)������Wun�\n����X���(<�IȆ����D��������=>:�;Xw0�؂��R����\\\Z�]�5e-���ŭ�=qq�Z��5��3��!N:����b��z�6)j�0AK���|pq��3���t�gi�a�*)KFLJ��	\'�H`P�h��:;��K�nIqt}��9�i�5����?���%��O��&��T��q(*XSB&�J�C�i��H\r ��s��P��Wõ(�E4��H�)&\Z#����㷃NY��-�r�.g��-����Bw�r��B2E��Y3k�[��G�0�5����ߵ�����fsC\0���T�Ý�5D�]\nt��s߰���ݾ{O�-�8�X�ֆ��\\\r�R�Nw��Sى����X���f|�\\�yy	����%M*7�a-��.��U�V�0�\\��Vն�e+䦖������LN%��\Z�b.�u�\ZRq�\Z՟��?�忷6R]��Ia�[t�]�6\\IJ���t.�p���Ĭݟ��I��;��m<A�>q��Pf#�	h^I�����\n��|YȀ�k�s�#�^����m�{�Յt�	�36#6F�,tm��)xT�x��L|n�\"A���Լ�m�}4\'XJAo��ͭ[�<�5\Z�\"M�9{퍷���åt\0\Z5Q�8o�/�tO|��bf{ͺ=uu�6+e��<`����0Rp�<	�҈�ְm�I�a�5f�2�����b\n\Z��Efq�i9�T�+�t��00��>	��,\'���E:�m%�h-�\r�j�~�rq�D	�R����(\'�*�>k�$�n�+:����N�swȮ���a+u���g��\0J����9�z];>=�w�޳ޠo��^�K�.�FUs���,lno	�d��j����e��*�$�|��d�!�f��z�������uN�V�ac���;AC1��;��j�U�&�����m���}�_I	�5+�8&=8�e_�\\��ё!�zp���=]C*�F�1�<�XQ\0:�bλ����hN�Z�/Y)0��F�hۭ�mo0%����2ˡ-��\nn<��B�Ve\\�0���M�U�~��K%�\Z���Yi�R��3����|�%8g���\r�x0��`!�j��.G��-g��i�Y�额�\n���!-��L����5���Ԟ��o?����|�)u+��QL���)@�*I҈e��18zy�\\?j�-9B�6n�H�xgwW�6|+���l6��Ŝ���y/���~��;��&Ҭ��s{��}�+ـb�Y��+e�J�qxh��>u�]�nI�ґ4$U�sD�$�J�\"�a/:��b`=E��*��c��<R�y�aM��QiX�7f\Z��ߓ��!�|E@���8��h�$�*����+r�C|,9m!�\'X�{��*פ{��P�E(��&빌2j֘�?*�Qp�,,�_���P�ٽ��$����+I�˗.Z���&�љ�Zo�����)�N��&	���DUi��/eX��`��P(F�=�|Ѻ��F���H�T�n��$�Ɉ¤^}�u��~F7{���FX�.]�d��Sk��l���ri[ۛV�լ�>VF���i.\\����-3ya[$�^_f\Z���!�e����_����KM��Bm�*�j�Q\\Z��r��b1���2�0�~̧�Z�M����J�N5nu�̦��Xꆹ%�,��3d��6��pU����zé���I_C���`�K^�(�|�4��.����	,�E�r�Y[Ωk�Vy�l��X����﷏��Z��d�It���zaOh�	��$�4@p˘����S1���E4�N���H�|l\02+��a�A��=����vpt�{����o�#����5z�2<���\'hp \r��]�޲\'.��V�d�%��5i���aOc�奤7r��P�7/فi�|��\'Wp餄��abh���#��k�oy͊f|�uY����=6��$K�\ZJ��]�Ü\"�ʮ�M1�T1#eFRԊd3��P\r?X�̊&$%��Ȗ�PV�Z����!m(I6TC�S4��݅�A�e|�>�oc���m���=,��AT^�566lcs[���i[�&Y�S��`	3��L�>��36��tu��Q\\k��p�z�����TB#� �����H��o��������|�u�=Sgջ���2[iX��i�)�D�:�%����,5�[!Ŧ��wn߶v�k\r��l0FU�6������U�v�\\s�2VW1g�Jњ�3楛X�2�3�̂��.��{�t�!�U}�e	D��Jփ��H,\r�fX,�X�z����K{ܙ��Iߎ�͖�5��}wVCV#!`�q>Cv��]�Ŷ�.�S��Ò��U/ۓ7.�\'>����3Oi@��0��HG5��>�^��.9d�oU�Rkz�!s�bJf	.��O�ふO�m8���C��{���?�M��GG�vr����P\'���hnoݺ}�QD�>)8�@�%du��j��s��֋��7�	����AW����q�Ri�.�(	c\\\'��^�8�[�D�;�	|hY��<���o�����S5\"�y��.dd[�\0�K��&�)@�,�N�f�]e{\n�RM�/��Dd\Z���l %�H�ŧ.\"Lw�9A�ʊea~���-��V�D�epɇ�����K��Ւ;�M4ڽ�ț(3lln	��\rB��H�d�?d��()o�;, <5\r�s�;�l��l�J�_`\\��F���t(uTI�6]�}����O��g��!�0a�:f>]����jmZ��R�����u{};8>�8�䅘%Ι5ke�~����i�޹wO�7�a�A�����lM�/���Q��Y�ڰ\n��z�67�\n�[)�tj���2L�@�1�Q��b����̿��l!�j�i�K����[A�����G���Ӂ�{|b�IF��!<��,�be󁳆>:1��<i9�� ��D��\"Z�ٕ}���O��ٕ��V�i��&�&2�I;\'Ed��(\Z�{,��\rWiL��l<R)��) �N��сf�Ҋ���;�n�k�nO�M��`l��>~,�����ʎ�O�m�Q��X��~�L+���?��]�nY��S�wY��ڂ��n���_�2�$+�!�hĂO�WL�G9!jG�цUy2�8�{ 9r��q�@�~����k�e:F�`��q�\"��fM�AmДQ��ߎxcY\nN�Y�Z�ȴA�׉N���$�Jq]`Ud�j-��QB�F�8Ýu�R���Gv|zb�?���m�v�5�u	������L�^��me�d`@|e��V�QP������T���U���hɥ\\�bf��n仳�R�P(�\\�����Й��W^�?����ndtj=����$���Me�hmڕk׭V�K�!J���@A�l�%��֖%UƃǏ�3F5��rM*��-�z����\r�jɚ\r�9p;�Z9���J�6kT3[MǖϑaR����&\"l�����UK�*5Q��R}�>Y�l8�Z{������o\'�dSV٬uz��?�\0\Z��\"��&�]�h�ʪݫ��7L��3�5w(�_����P2��~�}�?d��J��T�Rj�\\**@i�,g:�X\0���\"��Xpl��S�éR�p&�y�_��ݱ��e�,��p����xfc���T��)#3WI���k�+%К���A_��On�����7.�V�$�Lʢ(}$f�`�~:��ܓr)xF���q�yJ�a[~�GwOey£\"8h|9Lke���1��%�T�%ͫx����q_x.�J|��~�����\rɂ=�s>?\'�:M6��J�0��\")uP�3d�d幌磒)�Մ{�Y��NO�A���K��3OK�J��bn��(2sȘ�n;`��LD�U|��q5|��F�ƺ�.���iPT\\��~�k��[2)����j�OO����i��>y����Q*��H���+9\n3�)I&�{����������R6c[��2n���޲N�T����X{��Y+�AIdZ�v9b���mJy\\�j�sY�D@%pQ.V�{S߾�\0�s��r��������_Y��\"�HRB`�5�T����c;ꎭ;\\�i����� GL��`����}�`#�]B��4qJ�\r��A��٤i�Z����o��v�����.��H��΢�#GH��m��ԃ���J���\0X8dX�ñ�?KV��D���p,�qN[4���gac[r�X���S��ԉ��/ڽ����Z��,B��\\�ٍo\\�$��\"�z1o�{��]����ɻ�I��zR@�UZ�fT�����x���IY\Z�ʻ�\'_^2x�U�L@|\0����ӌ�o�5���(���(�� �*��+}��7�0:8g�9FA\Z:k#���{��֢\Z�X�JA�,*S~f]K�����42gk�P轋��}<V����C��]�q�n>��m\'�.�G2b%��vsg��͖�g ��m=hAS�_௦E�ҩ�v�3�jo8�A�\'�����v���Z��!�i�X��~�ө�醃\'j����>����>�g��Od[	_de~��3�̐D�f��H.pY��m�x�5[�:���5,/�Jh�*M��D\'�1޻�Xt������:KR�`�}*�|�Z�M�x�]���|�lV�QZ(x�eO6�Alf5��o��/�h󋆹b�@�/�p��/\'];��Q{`\"�ԧ]�qe��GXn����xf���f㡲\'���\Z��,�\\@T�%�=k�jӮ^��ag���z�u�g�v�ʾ}���g�~B�Y+��.J�l�LYl<X�\\0V�V�`ZfRv���}r(��6�X��o8�OO�4t�HgJ��г��V��z��Ȁ�o߹k��&�y�m�-����Ї��\nj\rܠ�u��=��5�\"^��&�N�]����y��LAԂ�y�~�/�{xI�2��|?0�����\"�U\"ַ~������%���\'E�.JC�/:�y)`&I]e���\0�,��1dH�>p�x�u�3��#������;	\'����Zj>���:d�&�ONl@�^�Z��a�;[v��M���-�\rJ0��h.�Y�BW���K��٬h���~��r\'�K�i̚j�?�����fw{K�x	�A\'�F\Z��I���$�\'s;9���_ɞ{�y�������qUZI�ʡ\n�=D�f0���+�Ռ�����w�*W�wxr,����fӚ\r\'�r����!N��b	:t~��\nr*�k�7��i�W��Z�Ղ��U�m��J\'}e���2��D��3�&dsMu���3�u4[��ٕ�\nN�3(�rؘLz\Zt\r���Zr�\r~�Z��Ė_��Kj��]�e�}C<h����z�M�~��>n���R$���d��MK�c��A��{2�`Q�Ί5�1����Yf9Q\'����b�o!��\0��d��F����c>���CM����Kߴ�h�F������K�U:��Jd&<�P�:)G*xS�Ϭ�e�i���g�Q.Z1�(O)�e��@p�<��\'#�$Өk	�/�$�|6\Z�2J��p�>6����d�0� �R�*K��Iۓ���T���zV��,Q��p�&3��xm�\\�g���|`:�3I�4�dP(���)��{�r_�1q�B�U��KD��������ɡmnm���~rZ^ʊI��4����\Z5����54�5�XM�.y�A2��I�\06 `Qz�Փe���(E;:��:���ĝ�G�t�$�Ԇ{y����S�g2���9����S)�����W�K*��L\r�����-9��!㡆�ٟO���v��e;8<ֽ�?ay��tGww��<1\\�����������1\Z��Vc0�X���dI8�r����r+	v^ܮ[���̯����gg@�/+���I�;S�{P��\Z�&#��_��5V�} je�x�*�\0��Ń�?�R���`p��9@<��._�Ӂnh�J�J��Ğy����ٵ+��\0��5(g���0�\\�=K���z�jCe�iL����i:���hd�n�N�9�����(Z�D{&F}�G�vzr�2�٬�����pt�7d�ӻP\0��:��́d�%��T���sK�гﶋۮD�H�$\'\'_�U���l�.���9�����@��t>Ӊ�,�Y���	,&a^�)\"�J2=>�]:X�naʾ�>��R�T�\'���4;��2/t������z�Tk�=27܎��NWF�tX��ʹZ�x\'\ZsC.u5;(\r���v����hkkS���h�\r������w���8��ݽ������#@��QA�N��Ng4��A�LF���J��˖2���8UX�k����O<׸�h7�Ü\rX����?#�1�h2�n7ٲ:mZ#^-��i#C�ޕ�#UN�#�O\\�	��9�߿d;;���)��i�\'6A�}$*	A\"*_$0�y�T2�J�n^{Rds~�y�G�\'j� \'D���TYYB�����V�`�_���\Z�\n֟��=�aBw0��#3��!v懶Α��|6V�rGN\0��c���̉��tE�\n&�y�û��o�԰y��+/�%�ai�P�7��$,��Q�O�������A\r��nFve8!��IcP�g�ޕKJ�I�� ��t�\"�Uk8���/� |��)�rs��/z�Y.:E#)8��F~��?8\0���m����=|l��}(�r�bŦ2/J����P\"|I��g��r��sq5�\'�\\��>u�Z����h+�E�Y�(�|f�8�\"�PJ���$�+�$�t$x���h���r<�L�z]&\nY��ѧȞ�2ޅ:Ϸ�M��\'f���3��F\0F��hdx��0G�֘R�Z���#Ss%SM1h������+�ڹN�\0���w���0�x�	q��:Q�mn����H}r| ],�1�H oǬ��)YW�~�@��%,�u�x-�2X����/�\'�t����$R�[L#p?\0����zS���������J-Fr��W^��:jJH��6�����ވA�caKM\Zdm6���Z����ݿ$F?����c��\rb����D���1�_t]�/\\T&�l�l��JK���*3mwzV�0>��� e6���r�2?�����;��`.��p&�GLq�(20p�^2:[\Z����dE�kj^h�rI];6?<J�ͭ�d\0�P*X*c!cB�,i��]0�z\'\'�$��я~�~��>*��J�1�0�RD�0��	\Z�V�x\"[�[�k�+�N�6�n�-��;����hw�ﴷ�:H�8�������7�?:T�Bo�exg$\"PF@��\"�_\'�Ge�hQ�MT������]�۶R��c=I���]p��Ž�ϓ�C�!�TO��/��\nF����ฏ����ܸ���8\n}�g,c�3�Z6�~V/�g:�^ʾ��$��=�\Z��� ,r\0�����@�4�\"����٧q+�\Z\"�z���##su˩���t�=1ڷv7U�Ac�k	}����<Ȭ��˗%������\'��9��*�0;��.��|x�]��6!`�gu�O��蘲6y����%N����I��k�E�ý��]�̿���6T�|tYY��dt��d��R�[�\'p��a\"�	�.3�D�|��Q�mk{Wr�4֘\0����>��L&X���Ư��h~�Y�{}�6�-��c{tx(It�~���6��{~��h[b��c��\n΂SD#q��tx@Y[�\'IL	WoWp���*x��٭��ڠಥ�=|�����0`\nT�Q�lno$�|`�\'�s�������]�vE7@\'�VO�i��P\0%��$�T�N�ƴtq��#����qPV����z+-�g�@˾===J�jnFκ����ڛ�Uzpxh�\'����P�̷g\\Q���l�,�$��wO_ڳ�ܼ�:�\nx�����%��!^7�9� |*8����A*2/���Dfԁ3����z��\neD�Ў��EV�\0�h���)�}�]�Ub�G��ф�%�Sq�S�g\r��1q�n�b%Ie��� *�e��f6��a��)�]ܳ�7�YYC�%5q|������~��#�J�qp�AT�T��xIg�}��j�3w*�Z5�����\\Ho�%7�a<����VȽ�	�A,AEj09e>���\0\0 \0IDATS\Z,dn��,VY{��;�������ƛNq�bQ��c��]���4:\'e\\�����7� �.W��V6�\05�t�\\����ꕚ��+�խ�f�}��\r�H\"\'N�u��;vr|,�xscC6�`Z�\'m{��H\"�*����Y�%�)�M�ҢBVISRt�&\n>S��Q�5��\0�\nj��U���R�ޠ��9]�\r���V9G�\r��T���cu����v����_��~�{�^++�(^�+(����e��,\Z��S�mK�����\n�tw4�#]��-gS�Z�|N�>\'6Fd��.��j�j�y�:݁���-{��];<��tB\'���<Vt�\"��#2�hQnE&VϬ�}Oߴ�׮J�>\Z �b�\'��v��;�z|�(�x����{�h]v%y2�oX���R�K�Pn�w ���tNi���bg���;��&�	�{t;�W���Ac�D�f���.��|�\n�Le�ȣ�\rs*��JGiOa22������N���G��+��h*� c-}����b2�\n)%���Kn�V*��i[����R��޹�̯r}�3\ZA����`�X�f�dYdh\\㍟���$b�딪h�S���Jx���\ZKU�\rf��?������BP�-��֩\0���#�@�%�5oNxs��_u��<*��d��o�72���*��\n��>�~��h�M�Q�s�4*vmw��]�zC����#�u{���o{�<H��NN{���>fv��O�QN9�-h@ˉJ�p��C�+h݀�,p����� 隕&��Yo*\rf�\n��S��Ì���.\0w\'l.��=�J��3n��O?i?�w~ڮ^��E���nG�jղ�W���r:� �������KIq��3&��3���M�h������-gVBw�TV����P�-�*؃��v��~뎝t������&��Ȟ����W��>��>���ψZ0ؕ������65��MF��	v�h�49%�>L#F�_�\n0y�I�?q��h�\n�R��@#�;v����Xt���8��%��<�d<O��D��f�ߏﻙ+I�����K\n�!�Q���:#e�ʟIaU��d�i^254\"�^:�|��m8��ӳ����*j�7oX��.�����J������]Ɋټ�ON-_.��ήf��M����(����cS�\Zr����\0����\\�� �B��߻w�vw�8)�	��Q~�-�y\\�`����o���O�g���d�A�\rx�^�ƙ�~zy�8p�O��a\n9��qm��?&��<�(��@�򛠋�MN�k��Pa�`����<g��������m47t\Z�9Ӻ#�d�r���\rZ��O�鮨��C��D����IO�%s�WK�b��e���A�,�qR(�>�������Q]:\Z�U�M\'��aѱᨯ.�FL�Q��dVi������>��8�]��#��[[-�PaP�R^2\'2,N1@:v�F#���� ?K	���O��?�g�aW�k+I���!��ãC;8~dĳ�daO��|�(D�������|Iv�:ǈ��?�ũ�����\'�O^�2�良Jm���ǲ��r�}$r�:>��$�>e�p�D��`�l��MR#p&���Ę�N\\dU^\n0/�R���y9φ����ϛ2FW���b�+�H\n���]����-2?>[x\0P6���Z(v�=��=��Cy�ja�\ZT��+���c�zd��u�=i̓�����+��+���e�ֆ3��៕R�w�}�}��k�:��F�Z\"�\rYxW��Pi&���t��lm�\0�qzkI���6���^R�Nc���Q۞�E������p��T��;��H����`̎�r���I�R������-NF�^����yt�%��cmdW2#����T>h�y�`��n�tk\'�ɕ��ܰfcӶ�v��¬��C\ZODX/��S�X��p��Q�je����@9��>(I�\'���v�s\"<���NK��ӃaHj����-u�x���l8��T�D�eP2_��|���lή]����>����z�&�#��9�T��to57Y��^�c��*���׋9�5�ߵѰ�㡘��5m�Y�i����$�;��}����I��\ZU<^N�D=��cZэ���y�>�|��(�KiU\n��x�]�ߵJ�+2)�+�СM|�0���! E���S�s�+���\'�+��}Ͽ�s�����Xd�t����)\ZY�3�Y�|Ŝa��.��(�(P\'�6��9�ޒy��0:�R�3.�Ҝul9��]sN�B�wb�1�#����\"66�Z���,Wȸ��1����ҍ��Be��r5�[�hn\Z�^�,5TL)%M��ʪ��I�TrɘS�����	�L98{��Fq��\"���FsC�@t�ɄI�����=�/ۣ���~�S��_vk=��9��^�{��^�#SB���W���+�	�4!p�*�m��<�֍�5\'1��P��UR�P3����\r����;`\Z��Ui�(enV*��ެ��+W�ʕkڧ���^}�2��߿r�,�W|y��שּׁ�r\0V+�ms�)\0\0����Z�����CEMHb�rU���=T�W獖<6��\r���Z�{*�J�֌����UB�o��#�����e�zU\\$:pz8��O#����]�N7�XZ�Pz��Rm2Dٺef����D]8W,e�ϜG����d��?��pj�b�FӾ��{����W��n�����S����y�˦3+�h��y�K�	��R���/���y�v7�~p$�0u\r�P�9��Ƹ�\0�)��N8�ʩ�5��%g��D�=�u.�FD�Λ���e�o�)x[�ͦ<����<@R�³rNY|6:���\rlN��-���vaP5J��q��%	�80��P��D9PG��P^�\'V������vqO�Bs(x���0tL��P#�ʫ�fC�\r�6j�	�~�K�t�R˓��u�/2G�23�CwprBtIA�ak:j:�8Й�+��`����;�ʳE�>����|�Ӛ�$+F�LJ�@���!\\�vP<1�\"I�u���j5$�2h���q��:���X���ɝ�ʾ�u��,m�O@L֙����8Q͐�{\Z1%r̻�{v��M�[2��]�wO)����Ɔ0,<�.lo�i���X�����>x���r�ͻ��l���R��ʶ76��N���?��l�������a�I��\"�;��qrƟ��\'�����F��^�p�TW��R���d%���;�B�,���5�n6T������m��f\\�1T=`дۓl�7�{w��|9��|l�1�1o�m{卷��ё�E�_)M��X�q\"x}{��\Z9�����$dfV�f���W�}�z�J9ӳ�M�|c	*BdCQ���z�)��\'q�C2p���P�\0���3�<���o#; �r�c`48�{��8gE�Px��H�>��_�uGf���)��^��/�R�!>gdx��z��L�r�J���J�w��i�f!�8]N���G&Ym4-�\\)3����5.eV�U��xJ��&�^Ju�4 @㠢9E��l�0��S\n�U������\rQ���SI��g)=0�kQv��8�0�H�d���[w����mh}��\n����ISt���~��eqo�����eF#F`�2Y.����Փ����f��p��e\Zg��;�k6�\0H�S�d�ù[\n2t&��*�-�}�#�z�h͆�:���xؗ\"�R��>�}\\�MǽC�7�J�9@1���V��4&C�g!{�u\n�B�T�%�w�n9��ms�a������ۅ�R��Ϫl#3�5#��}�\r�I���Ɩmm�u�D&�+#EJEFPѾ\"ۃ�%��4���n��i��~�*�(�g<�3W�q;�\r�@KK�����R�C��}�Ch%��R!��\"j�PD�@p����j{����>>Da���\\������Zk����L6�fen\\]-�{_o����a�����ŵ(��K��GV��#Px]�q�C�D��T��\'�ٵˏK$])A��q���nN��.�!�6}�b$�&)�:vX������C� Pv�1Tf�\nu?#!!`-t�\nAO�\Z�>\r��S\Z<K�Fr�\rL�����{reH�D�<W4��R�/^�L�Fx�����=s�[vyuYk��pt�S��5Dm�V>%\r*ѐ�\\u�KV-��^�Y��4��c�Fj���d�t(���(@�}1��3�ظ��KhX�T�XdH�5��r�b��G�a����~���ۭ��k]�	���aC�ʭ��v|�I\n����5�C�/1�]F�1aHX��[t���ВgZj��=���Ξ��z�n2��\Z+S@�}��ޤc��`ixԕ~��3���n���g�;H�6��IS҈�a-��%=X�mul:�]��T��͓Ӎ����֬�ƈ�����ڨ��wT��hdO^[�W~�ٳ��I;����ixX\r�=\r�ؼf�J!_inh�-#2��B~�@�t�����t�z� � r�\\�/�j��G����Wf�U��{l�|�����#ۦ��ϒ�#P(xd_�{�y��b1`�p�/����e\r]��Ě�<����`NHY����ic\'��Sͼ��l*��i�;%�r��Q�E��0�9��&L�i�zܠ0�}����7�aq�9 \"@*h%��<(��)p��s	3d�k<���#&��1(���\\:M�	���&�S.J�g���w���3����NX!W����X�դ�dL�����`��C-[��ƑA�K�R��\\�hm=��О�p��A_���(Ѭ�apt����\Z����D�L+;����u������}p�#��Ѐj�s\"�iI�4\'��H��I�Cg	�@9�ei�ݪ$<��g��]YZ\'��3�s�e�8sQ��q&)��2�����/h�CxN��ǘ�A���/�p%�$\'ݡM\r�\Z�_�,!k(��\Z@Ǆ����%���S�Ȥ��J�!9k�@	�+[����p�Ғ`�1a�S{�G?��_zI\nu|�X<��p��.\0�1I���K��>��/�>�[o8��Mw�#�ְ�	V��5���a\'�%Dׂ���;0\ri�Ґ����=�s�c�r�k��(`Q�@��9)Q͕Y���D�9\rj^��r��U.���3��,u���4a&e.�\"��1a*����X��U�LT�\"&��X|^ǚ]��S\n|�.ba��|~�u\rR�Ňd�0X\r�D��`�dW\'~�I=�L�C#�9Ҥ\"q���V�cs����8?Fv3���%\"R�t��r����2�fû��MxSq\r���]||�J������������W���@��mx�ќr��l�&�weLZ�S��\ZO��@VG�\\��C����@�A�5�Ĭ읽)0��GS�D�5W����[{۶��d�G�Ec�jD�v���|�NdҔgt�<��{�\Z:QRSh[�#K�6S�J�UPRV�<��z���̋�W��{�-����a���c⓱�&�M�A�.�|gƛb�tp�l��&��2��<��.D5F���p����7���������К>�	p�Q�F ��ͯe�>�]9�f5� ���Ķx���oڽ�#���[qbd3�x)#�}�>\0��a_�F�{�;�4­�spR�ww��;��;6<<Ԣ�_hk��[_����ٻ�޷���2��`�kU,���b)T�|�MK����x���̉Yε�slv�1`�W.��K�r��*�9�w/f&`L���S�4��:���vdP\ZY���H��^~�{�R��Y�����sg������G16ezd��J�M%�_�[y�)<� ��!(�XHD�(wx�\0���p�\"��G�Ǡ�df���s���re՞��\"�_��~�=����\Z�\"�=��ҙ�֙_T��P�4�3�n*�\rIX*4���?�˅��a/��x0�&�4f��>���sޕ2S��]o��VD�<�����Ɵ߲�o����9��~|&�5מ���c�J� ��t(�j��I�1s����W��	�,�I��@	�O�<I�Co� �=��d�,_2`!M�w,T0��9o����ACL��iY7\0��8z����@�Ƌ����O?.��,u�՟L@R�f� �pxB�s�\r�y��N]�J��,-؍7�g?���?�dpT��\0*�7�K\r��(���Sz}u8k�&)5Q�Cf�dC?a�C_у���@�㤡�L���۵��C�ɐ�Q��y���RMm݇���s�=�����ǅD�Ir����?��?��,ʱ|*��~�S#�@ �mfve墭\\\\Nx�����Fd+\n��]sv��A!PF�����OJ�ࡕsw���\\rlV�&zq�Ei8X���YR��a���\ZAR\r�g�>O��f�I�\0�.%q�,J@�#���@\ZT	���V���rmP]t����l}��=y���m|uOAq��D�Y��\r\rb$S�ɿM��㱾��̵���5�\Z�\"�h&����H7����,,����mn>\'L�2y���rMj\r<�(�̚YKA\rN�fkZ�n����|�mY�(pP��J���\"�/�v�*�ˡ�r��+r�`�A���!J#:s�	����;˔�^�).�F\n�w0�7��DW����G��T!�U�\\K��%�T{-}�{/B\rSD�gV�J �m@7�r^�Ɛ7�O\0-�N\"�����t�J6�̼ɜ�$�C�n�=|���{�����eUk��<�:ط�{�≝?{V�4�I�z���\00a\0�)A4��-�#�V��(%%���:+�l8g�c�{$���~����#����������߁f/咋h���(�\rbhN\'3�_�����J�[V���l�)�7����~�i����l��&�]�o�f�9��\Z����S6v������>�Ia\"�p��8ɂ\"��9����&p�<�J��^O�}Q�s�)�?:���B��&� �a�s�[\r���5�������+>ѥ^ӡ)N����&��-l10�����VI��Y�#?,5���M���⾪�[�\\�Gc���M�6!�f�l=�T�A�Oglkk�Ν;����� J��w{~^��F�\'�~1�n,��>�Hpǐ�T�����$5��=�~����q,�kw�C�G��§�#�^Rf��D�G�r����{�/�i��[Esh�Rw��K�B�IQ����)Y�ά��rȉ!թ,&��jMEG6�w<��W�>���m)|.?a}��FT%!�(i��|�����.^��^{���הY�Y���u_m�[���;[�%���	�]���ς\"��i��*v�+��$���dMT�\\Ʉ4[�K����zd��7�/�mػ��H�)ϭ�qⴏ�w��T��	��\\qm�yt�������ܯ�W.���N[�LKܖ$Gq�(!;����@I�S`T���?��|Qz&�G��6d͒��M��zAJD����E�����p؟x`��Nr��K�4X�o�\'�玓W����HdP��\n7�\"��YiS�pdk�Wlm��*%��� uɚ*�v��ma~A�F�k�jC�\rחN\"�$ék���=#ȸ<�1#�&<���h\"~�!��$1��9y�[�pQ�u^����� �\0��r�N�*s�z읻Jݱ�r%S��������7�����;c�\"`�@��F�e�m�(S���\Z��w)�[�$҆jp�ω��%4�qσ���s}´��� �@{ ��n���[��J���.5�Y��u~��v������+%�pp ���!�ˏƹn�恆��dM�=��=}��=��JչY������M`�v���B���\0dG�RM\'%�W����8��%A�����Y�x8-Ci�<��8*������}q����(`	�KX�B�E�7��e)�0�>G<+�_q�#`�-�ٓ#[�v��҂]���*�M8v� �-,�z��BV���k\n�,ȳ0�Lr�>&¨sH+N\r&s9�K�#8yi�pOrvz�\r\n����*҅�q�B����� �&�}�lS\"Qjh���)�}m\\�,�\"�-W/_����V�8�Od��.�>�)�K筚����\0zZ��z=p//�C}��b�q\r�9T��`dլ&L�#���[L^��j��BW��r��E�C����n��X�8x������[]��Zv��]{��o�g��W�\0܎�q8�}��T����B0��\"�$��>�I4,\0\0\0BIDATS*)8���Cd�0��Eƹ�~����=��{�pm����>ұ4\\��0�d�@�:��Z����D�S�\0\0\0\0IEND�B`�','2015-07-28 04:26:33',NULL);
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
