-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: noisewatch
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `health_records`
--

DROP TABLE IF EXISTS `health_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_records` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `device_id` varchar(200) NOT NULL,
  `record_type` varchar(30) NOT NULL,
  `value` double NOT NULL,
  `unit` varchar(50) NOT NULL,
  `start_time` datetime(6) NOT NULL,
  `end_time` datetime(6) NOT NULL,
  `source` varchar(255) DEFAULT NULL,
  `received_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_health_records_type_time` (`record_type`,`start_time`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_records`
--

LOCK TABLES `health_records` WRITE;
/*!40000 ALTER TABLE `health_records` DISABLE KEYS */;
INSERT INTO `health_records` VALUES (1,'NoiseWatch_Test001','heart_rate',78,'bpm','2026-10-11 04:30:00.000000','2026-10-11 04:31:00.000000','manual_test','2026-10-11 10:25:29.210118'),(2,'NoiseWatch_Test001','steps',1250,'steps','2026-10-11 04:00:00.000000','2026-10-11 05:00:00.000000','manual_test','2026-10-11 10:25:29.210118'),(3,'NoiseWatch_Test001','heart_rate',78,'bpm','2026-10-11 04:30:00.000000','2026-10-11 04:31:00.000000','manual_test','2026-10-11 10:25:32.472701'),(4,'NoiseWatch_Test001','steps',1250,'steps','2026-10-11 04:00:00.000000','2026-10-11 05:00:00.000000','manual_test','2026-10-11 10:25:32.472701'),(5,'NoiseWatch_Android001','heart_rate',78,'bpm','2026-10-12 05:00:00.000000','2026-10-12 05:01:00.000000','android_test','2026-10-12 13:13:35.987185'),(6,'NoiseWatch_Android001','heart_rate',78,'bpm','2026-10-12 05:00:00.000000','2026-10-12 05:01:00.000000','android_test','2026-10-12 13:13:41.326143'),(7,'NoiseWatch_Android001','heart_rate',78,'bpm','2026-10-12 05:00:00.000000','2026-10-12 05:01:00.000000','android_test','2026-10-12 13:13:42.259248'),(8,'NoiseWatch_Android001','heart_rate',78,'bpm','2026-10-12 05:00:00.000000','2026-10-12 05:01:00.000000','android_test','2026-10-12 13:13:46.830813'),(9,'string','steps',0,'string','2026-10-12 07:44:59.011000','2026-10-12 07:44:59.011000','string','2026-10-12 13:15:42.175510'),(10,'string','steps',0,'string','2026-10-12 07:44:59.011000','2026-10-12 07:44:59.011000','string','2026-10-12 13:15:54.701656');
/*!40000 ALTER TABLE `health_records` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-27  9:49:41
