-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: localhost    Database: finance
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bank_book`
--

DROP TABLE IF EXISTS `bank_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_book` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL DEFAULT '-',
  `bank` varchar(100) NOT NULL DEFAULT '-',
  `description` varchar(100) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_book`
--

LOCK TABLES `bank_book` WRITE;
/*!40000 ALTER TABLE `bank_book` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_book_ledger`
--

DROP TABLE IF EXISTS `bank_book_ledger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_book_ledger` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bank_book_id` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `rate` varchar(45) NOT NULL DEFAULT '1',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_book_ledger`
--

LOCK TABLES `bank_book_ledger` WRITE;
/*!40000 ALTER TABLE `bank_book_ledger` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_book_ledger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL DEFAULT '-',
  `name` varchar(100) NOT NULL DEFAULT '-',
  `nic` varchar(45) NOT NULL DEFAULT '-',
  `dob` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tel` varchar(45) NOT NULL DEFAULT '-',
  `address` varchar(100) NOT NULL DEFAULT '-',
  `email` varchar(100) NOT NULL DEFAULT '-',
  `representative` int(11) NOT NULL DEFAULT '1',
  `bondsman` varchar(100) NOT NULL DEFAULT '-',
  `bondsman_nic` varchar(45) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (14,'','madhava','','2012-12-11 18:30:00','123','','',-1,'','',1,'2019-10-11 14:03:12',2),(15,'','asd','','2012-12-11 18:30:00','123','','',-1,'','',0,'2019-10-11 14:04:03',1),(16,'','gadol','','2012-12-11 18:30:00','123','','',-1,'','',1,'2019-10-13 08:57:12',1),(17,'','asd','','2012-12-11 18:30:00','asd','','',-1,'','',1,'2019-10-13 17:33:34',1);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_loan`
--

DROP TABLE IF EXISTS `member_loan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_loan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `member_loan_plan_id` int(11) NOT NULL DEFAULT '-1',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rate` varchar(45) NOT NULL DEFAULT '1',
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `rental` bigint(20) NOT NULL DEFAULT '0',
  `charges` bigint(20) NOT NULL DEFAULT '0',
  `duration_months` int(11) NOT NULL,
  `grace_period_days` int(11) NOT NULL DEFAULT '0',
  `late_payment_charge` int(11) NOT NULL DEFAULT '0',
  `reject_cheque_penalty` int(11) NOT NULL DEFAULT '0',
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_loan`
--

LOCK TABLES `member_loan` WRITE;
/*!40000 ALTER TABLE `member_loan` DISABLE KEYS */;
INSERT INTO `member_loan` VALUES (27,14,-1,'2019-10-26 18:30:00','12',10000000,888488,0,12,0,0,0,1,'-',2),(28,14,-1,'2019-10-02 18:30:00','12',12000000,1066186,0,12,0,0,0,1,'-',2),(29,14,-1,'2019-10-22 18:30:00','1',2300,102,0,23,0,0,0,1,'-',1),(30,14,-1,'2019-10-01 18:30:00','12',12000000,1066186,0,12,0,0,0,1,'-',1);
/*!40000 ALTER TABLE `member_loan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_loan_deposit`
--

DROP TABLE IF EXISTS `member_loan_deposit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_loan_deposit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_loan_id` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `payment_type` int(11) NOT NULL DEFAULT '1',
  `cheque_no` varchar(100) NOT NULL DEFAULT '-',
  `cheque_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cheque_cancel_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_loan_deposit`
--

LOCK TABLES `member_loan_deposit` WRITE;
/*!40000 ALTER TABLE `member_loan_deposit` DISABLE KEYS */;
INSERT INTO `member_loan_deposit` VALUES (7,23,1000000,1,'-','2019-10-11 18:36:39','2019-10-11 18:36:39','2019-10-01 18:30:00',1,'-',1),(8,23,1000000,1,'-','2019-10-11 18:36:54','2019-10-11 18:36:54','2019-10-19 18:30:00',1,'-',4),(9,23,20000000,1,'-','2019-10-12 04:50:37','2019-10-12 04:50:37','2019-10-24 18:30:00',1,'close',4),(10,-1,70000,1,'-','2019-10-13 15:13:53','2019-10-13 15:13:53','2019-10-04 18:30:00',1,'-',1),(11,-1,60000,1,'-','2019-10-13 15:14:17','2019-10-13 15:14:17','2019-10-10 18:30:00',1,'-',1),(12,-1,56700,1,'-','2019-10-13 15:14:53','2019-10-13 15:14:53','2019-10-11 18:30:00',1,'-',1),(13,-1,3400,1,'-','2019-10-13 15:17:16','2019-10-13 15:17:16','2019-10-22 18:30:00',1,'-',1),(14,24,23400,1,'-','2019-10-13 15:20:15','2019-10-13 15:20:15','2019-10-22 18:30:00',1,'-',1),(15,24,34200,1,'-','2019-10-13 15:20:28','2019-10-13 15:20:28','2019-10-26 18:30:00',1,'-',1),(16,27,500000,1,'-','2019-10-13 17:57:18','2019-10-13 17:57:18','2019-10-22 18:30:00',1,'-',4),(17,27,400000,1,'-','2019-10-13 17:57:30','2019-10-13 17:57:30','2019-10-26 18:30:00',1,'-',1),(18,28,50000000,1,'-','2019-10-13 17:59:04','2019-10-13 17:59:04','2019-10-10 18:30:00',1,'-',4),(19,28,500000,1,'-','2019-10-13 17:59:19','2019-10-13 17:59:19','2019-10-04 18:30:00',1,'-',4),(20,29,32423400,1,'-','2019-10-13 18:31:54','2019-10-13 18:31:54','2019-10-22 18:30:00',1,'-',1);
/*!40000 ALTER TABLE `member_loan_deposit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_loan_plan`
--

DROP TABLE IF EXISTS `member_loan_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_loan_plan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL DEFAULT '-',
  `description` varchar(100) NOT NULL DEFAULT '-',
  `duration_months` int(11) NOT NULL DEFAULT '0',
  `rate` varchar(45) NOT NULL DEFAULT '1.0',
  `grace_period_days` int(11) NOT NULL DEFAULT '0',
  `late_payment_charge` int(11) NOT NULL DEFAULT '0',
  `reject_cheque_penalty` int(11) NOT NULL DEFAULT '0',
  `charges` int(11) NOT NULL DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '1',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_loan_plan`
--

LOCK TABLES `member_loan_plan` WRITE;
/*!40000 ALTER TABLE `member_loan_plan` DISABLE KEYS */;
INSERT INTO `member_loan_plan` VALUES (1,'-','asd',0,'1.0',0,0,0,0,0,'2019-09-29 16:43:39',1),(2,'-','aswd',0,'1.0',0,0,0,0,1,'2019-09-28 18:30:00',1),(3,'8','1',7,'6',5,4,3,2,1,'2019-09-28 18:30:00',1);
/*!40000 ALTER TABLE `member_loan_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_saving`
--

DROP TABLE IF EXISTS `member_saving`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_saving` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_saving`
--

LOCK TABLES `member_saving` WRITE;
/*!40000 ALTER TABLE `member_saving` DISABLE KEYS */;
INSERT INTO `member_saving` VALUES (18,14,'2019-09-30 18:30:00',0,1,'-',4),(19,14,'2018-11-07 18:30:00',500000,1,'-',4),(20,14,'2018-11-27 18:30:00',500000,1,'-',4),(21,14,'2018-11-14 18:30:00',5000000,1,'-',4),(22,14,'2018-12-25 18:30:00',1000000,1,'-',4),(23,14,'2019-01-09 18:30:00',5000000,1,'-',4),(24,14,'2024-02-29 18:30:00',500000,1,'-',4),(25,14,'2019-10-04 18:30:00',45600,1,'-',4),(28,14,'2019-10-03 18:30:00',34500,1,'-',4),(29,16,'2019-10-22 18:30:00',66400,1,'-',1),(30,14,'2019-10-03 18:30:00',2340000,1,'-',1),(31,16,'2019-10-19 18:30:00',345345300,1,'-',1),(32,14,'2019-10-11 18:30:00',450000,1,'-',1),(33,14,'2019-10-22 18:30:00',30000,1,'-',1),(34,14,'2019-10-19 18:30:00',40000,1,'-',1),(35,14,'2019-10-26 18:30:00',44400,1,'-',1);
/*!40000 ALTER TABLE `member_saving` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `member_saving_history`
--

DROP TABLE IF EXISTS `member_saving_history`;
/*!50001 DROP VIEW IF EXISTS `member_saving_history`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `member_saving_history` AS SELECT 
 1 AS `member_id`,
 1 AS `description`,
 1 AS `value`,
 1 AS `req_date`,
 1 AS `trx_type`,
 1 AS `id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `member_saving_ledger`
--

DROP TABLE IF EXISTS `member_saving_ledger`;
/*!50001 DROP VIEW IF EXISTS `member_saving_ledger`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `member_saving_ledger` AS SELECT 
 1 AS `id`,
 1 AS `member_id`,
 1 AS `req_date`,
 1 AS `amount`,
 1 AS `req_user`,
 1 AS `note`,
 1 AS `status`,
 1 AS `trx_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `member_saving_rate`
--

DROP TABLE IF EXISTS `member_saving_rate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_saving_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT '-',
  `rate` varchar(45) NOT NULL DEFAULT '1.0',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_saving_rate`
--

LOCK TABLES `member_saving_rate` WRITE;
/*!40000 ALTER TABLE `member_saving_rate` DISABLE KEYS */;
INSERT INTO `member_saving_rate` VALUES (8,'-','8','2018-10-31 18:30:00',1,4),(9,'-','10','2019-10-31 18:30:00',1,4),(10,'-','8','2018-10-31 18:30:00',1,1),(11,'-','10','2018-12-31 18:30:00',2,1);
/*!40000 ALTER TABLE `member_saving_rate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_withdraw`
--

DROP TABLE IF EXISTS `member_withdraw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_withdraw` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_withdraw`
--

LOCK TABLES `member_withdraw` WRITE;
/*!40000 ALTER TABLE `member_withdraw` DISABLE KEYS */;
INSERT INTO `member_withdraw` VALUES (10,14,1000000,'2019-10-03 18:30:00',1,'-',4),(11,14,10000,'2019-10-03 18:30:00',1,'100',4),(12,-1,4934,'2019-10-08 18:30:00',1,'-',4),(13,-1,50000,'2019-10-01 18:30:00',1,'-',4),(14,16,12300,'2019-10-22 18:30:00',1,'-',4);
/*!40000 ALTER TABLE `member_withdraw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_type`
--

DROP TABLE IF EXISTS `payment_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_type`
--

LOCK TABLES `payment_type` WRITE;
/*!40000 ALTER TABLE `payment_type` DISABLE KEYS */;
INSERT INTO `payment_type` VALUES (1,1,'CASH'),(2,2,'CREDIT'),(3,3,'CHEQUE');
/*!40000 ALTER TABLE `payment_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` int(10) NOT NULL,
  `description` varchar(45) NOT NULL DEFAULT '-',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,0,'inactive','2019-09-23 11:33:52'),(2,1,'active','2019-09-23 11:33:52'),(3,3,'pending','2019-09-23 11:33:52'),(4,4,'cancelled','2019-09-23 11:33:52'),(5,5,'cheque returned','2019-09-23 11:33:52'),(6,6,'loan completed','2019-09-23 11:33:52'),(8,2,'completed','2019-10-05 14:32:21');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `member_saving_history`
--

/*!50001 DROP VIEW IF EXISTS `member_saving_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `member_saving_history` AS select `member_saving_ledger`.`member_id` AS `member_id`,`member_saving_ledger`.`note` AS `description`,`member_saving_ledger`.`amount` AS `value`,`member_saving_ledger`.`req_date` AS `req_date`,`member_saving_ledger`.`trx_type` AS `trx_type`,`member_saving_ledger`.`id` AS `id` from `member_saving_ledger` where (`member_saving_ledger`.`status` = 1) union select -(1) AS `member_id`,`member_saving_rate`.`description` AS `description`,`member_saving_rate`.`rate` AS `value`,`member_saving_rate`.`req_date` AS `req_date`,'RATE' AS `trx_type`,-(1) AS `id` from `member_saving_rate` where (`member_saving_rate`.`status` = 1) order by `req_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `member_saving_ledger`
--

/*!50001 DROP VIEW IF EXISTS `member_saving_ledger`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `member_saving_ledger` AS select `member_saving`.`id` AS `id`,`member_saving`.`member_id` AS `member_id`,`member_saving`.`req_date` AS `req_date`,`member_saving`.`amount` AS `amount`,`member_saving`.`req_user` AS `req_user`,`member_saving`.`note` AS `note`,`member_saving`.`status` AS `status`,'DEPOSIT' AS `trx_type` from `member_saving` union select `member_withdraw`.`id` AS `id`,`member_withdraw`.`member_id` AS `member_id`,`member_withdraw`.`req_date` AS `req_date`,`member_withdraw`.`amount` AS `amount`,`member_withdraw`.`req_user` AS `req_user`,`member_withdraw`.`note` AS `note`,`member_withdraw`.`status` AS `status`,'WITHDRAWAL' AS `trx_type` from `member_withdraw` order by `req_date` desc */;
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

-- Dump completed on 2019-10-19 18:29:50
