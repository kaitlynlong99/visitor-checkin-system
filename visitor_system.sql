-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: visitor_system
-- ------------------------------------------------------
-- Server version	8.4.6

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
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES (1,'admin','scrypt:32768:8:1$J8scaqeES4wRv1SA$bd797d0c13c51a3cd296176ea1e9faaa1a0f9a69fa25186e478124b86dd5f295f3426d59b7a96e0626e4cc41d08db8de9a33ea0b7454c100c55ce5cf79f95d3f');
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visits`
--

DROP TABLE IF EXISTS `visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visits` (
  `visit_id` int NOT NULL AUTO_INCREMENT,
  `visitor_name` varchar(100) NOT NULL,
  `purpose` varchar(260) NOT NULL,
  `visiting_person` varchar(100) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `checkin_time` datetime NOT NULL,
  `checkout_time` datetime DEFAULT NULL,
  PRIMARY KEY (`visit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visits`
--

LOCK TABLES `visits` WRITE;
/*!40000 ALTER TABLE `visits` DISABLE KEYS */;
INSERT INTO `visits` VALUES (1,'John Doe','School Tour','Dr. Smith','Admissions','2025-11-19 23:34:48','2025-11-20 00:27:08'),(2,'John Doe','School Tour','Dr. Smith','Admissions','2025-11-19 23:56:15','2025-11-20 00:27:13'),(3,'Jane Doe','School Tour','Dr. Smith','Admissions','2025-11-20 00:22:47','2025-11-20 00:27:14'),(4,'Johnathan ','School Tour','Dr. Smith','Admissions','2025-11-20 00:27:03','2025-11-20 00:27:16'),(5,'John Doe','School Tour','Dr. Smith','Admissions','2025-11-20 00:28:12','2025-11-20 00:28:15'),(6,'Emily Rodgers','Campus Tour','Dr. Patel','Admissions','2025-11-20 00:40:02','2025-11-20 00:42:14'),(7,'Michael Thompson','Financial Aid Appointment','Ms. Clark','Other','2025-11-20 00:41:19','2025-11-20 00:42:12'),(8,'Samantha Lee','Nursing Program Interview','Professor Martinez','Other','2025-11-20 00:42:06','2025-11-20 00:42:09'),(9,'John Doe','School Tour','Dr. Smith','Admissions','2025-11-20 01:04:47','2025-11-20 01:05:24'),(10,'Jane Doe','Campus Tour','Dr. Patel','Other','2025-11-20 01:05:05','2025-11-20 01:05:26'),(11,'Jane Doe','School Tour','Dr. Patel','Admissions','2025-11-20 01:57:35','2025-11-20 02:32:50'),(12,'Jessica','Campus Tour','Dr. Smith','Other','2025-11-20 02:06:24','2025-11-20 02:54:22'),(13,'Abby','Financial Aid','Mr. Johnson','Other','2025-11-20 02:18:07','2025-11-20 02:54:31'),(14,'Maria Grant','Financial Aid','Mr. Johnson','Other','2025-11-20 02:32:32','2025-11-20 20:45:50'),(15,'Daniel Brooks','Internship Interview','Dr. Oliver','HR','2025-11-20 02:35:02','2025-11-20 20:45:49'),(16,'Samuel Parker','Job Application','Mr. Gomez','HR','2025-11-20 02:54:01','2025-11-20 20:45:48');
/*!40000 ALTER TABLE `visits` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-20 21:34:20
