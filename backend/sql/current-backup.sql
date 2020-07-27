/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE TABLE IF NOT EXISTS `bank_book` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL DEFAULT '-',
  `bank` varchar(100) NOT NULL DEFAULT '-',
  `description` varchar(100) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `bank_book` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_book` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `bank_book_ledger` (
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

/*!40000 ALTER TABLE `bank_book_ledger` DISABLE KEYS */;
INSERT INTO `bank_book_ledger` (`id`, `bank_book_id`, `amount`, `rate`, `req_date`, `req_user`, `note`, `status`) VALUES
	(1, -1, 1500000, '0.0', '2018-11-26 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(2, -1, 2000000, '0.0', '2018-11-27 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(3, -1, 1300000, '0.0', '2019-02-25 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(4, -1, 3973000, '0.0', '2019-03-15 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(5, -1, 8500000, '0.0', '2019-03-13 00:00:00', 2, 'Withdrawal for Loan 1 & 2', 9),
	(6, -1, 2000000, '0.0', '2019-04-01 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(7, -1, 1200000, '0.0', '2019-04-08 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(8, -1, 1500000, '0.0', '2019-04-28 00:00:00', 2, 'Loan Installment for loan 1 & 2', 7),
	(9, -1, 3000000, '0.0', '2019-05-02 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(10, -1, 1000000, '0.0', '2019-05-08 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(11, -1, 1500000, '0.0', '2019-05-27 00:00:00', 2, 'Loan Installments for 1 & 2', 7),
	(12, -1, 3500000, '0.0', '2019-06-03 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(13, -1, 1500000, '0.0', '2019-06-30 00:00:00', 2, 'Loan installments for 1 & 2', 7),
	(14, -1, 4600000, '0.0', '2019-07-08 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(15, -1, 6037500, '0.0', '2019-07-28 00:00:00', 2, 'Savings & Loan installments for 1 & 2', 7),
	(16, -1, 10000000, '0.0', '2019-07-29 00:00:00', 2, 'Withdrawal for Loan # 3', 9),
	(17, -1, 10000000, '0.0', '2019-08-04 00:00:00', 2, 'Withdrawals for Loan # 4', 9),
	(18, -1, 1470000, '0.0', '2019-08-19 00:00:00', 2, 'Loan installments for 1 & 2', 7),
	(19, -1, 1782000, '0.0', '2019-09-03 00:00:00', 2, 'Loan Installments for 3 & 4', 7),
	(20, -1, 6000000, '0.0', '2019-09-05 00:00:00', 2, 'Withdrawal for loan 5', 9),
	(21, -1, 1000000, '0.0', '2019-09-10 00:00:00', 2, 'Savings Deposit in Wealth Account', 7),
	(22, -1, 2500000, '0.0', '2019-09-11 00:00:00', 2, 'Withdrawal for Loan #6', 11),
	(23, -1, 4000000, '0.0', '2019-09-23 00:00:00', 2, 'Savings & Loan Installments for 1 & 2', 7),
	(24, -1, 2000000, '0.0', '2019-09-30 00:00:00', 2, 'Savings & Loan Installments for 3 & 4', 7),
	(25, -1, 2500000, '0.0', '2019-09-11 00:00:00', 2, 'Withdrawal for Loan #6', 9),
	(26, -1, 5000000, '0.0', '2019-10-14 00:00:00', 2, 'Withdrawal for Loan #7', 9),
	(27, -1, 1555000, '0.0', '2019-10-29 00:00:00', 2, 'Loan Installments for 5 & 6', 7);
/*!40000 ALTER TABLE `bank_book_ledger` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `member` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` (`id`, `code`, `name`, `nic`, `dob`, `tel`, `address`, `email`, `representative`, `bondsman`, `bondsman_nic`, `status`, `req_date`, `req_user`) VALUES
	(1, '', 'test', '', '2012-12-12 00:00:00', '123', '', '', -1, '', '', 0, '2019-10-19 17:12:07', 2),
	(2, '', 'Madhawa Dabare', '', '2012-12-12 00:00:00', '0774457794', '', 'dabareisnow@gmail.com', -1, '', '', 1, '2019-10-22 03:49:09', 2),
	(3, '', 'Avishka Jayaweera', '', '2012-12-12 00:00:00', '0772623567', '', 'avishkajayaweera@gmail.com', -1, '', '', 1, '2019-10-22 03:50:10', 2),
	(4, '', 'Nimeshi Wickramsinghe', '', '2012-12-12 00:00:00', '0778991803', '', 'nimeshikawickramasinghe19@gmail.com', -1, '', '', 1, '2019-10-22 03:50:57', 2),
	(5, '', 'Shehala Jayaweera', '', '2012-12-12 00:00:00', '0722500671', '', 'shehalajayaweera@gmail.com', -1, '', '', 1, '2019-10-22 03:51:43', 2),
	(6, '', 'Savani Dhabare', '', '2012-12-12 00:00:00', '0713807436', '', 'dilankadabare@gmail.com', -1, '', '', 1, '2019-10-22 03:52:52', 2),
	(7, '', 'Naduni Wickramasinghe', '', '2012-12-12 00:00:00', '111', '', 'aa', -1, '', '', 1, '2019-10-22 03:53:15', 2),
	(8, '', 'Mareen Wickramsinghe', '', '2012-12-12 00:00:00', '222', '', 'bb', -1, '', '', 1, '2019-10-22 03:56:32', 2),
	(9, '', 'Neha Wickramasinghe', '', '2012-12-12 00:00:00', '333', '', 'ccc', -1, '', '', 1, '2019-10-22 04:01:29', 2),
	(10, '', 'Richard Wickramasinghe', '', '2012-12-12 00:00:00', '0114970531', '', 'ddd', 2, '', '', 1, '2019-10-22 04:02:35', 2),
	(11, '', 'Rowina Dabare', '', '2012-12-12 00:00:00', '0112249706', '', 'ddd', 6, '', '', 1, '2019-10-22 04:03:45', 2),
	(12, '', 'Vajira Dabare', '', '2012-12-12 00:00:00', '0112249706', '', 'eee', 6, '', '', 1, '2019-10-22 04:04:20', 2),
	(13, '', 'Chanuki Jayaweera', '', '2012-12-12 00:00:00', '444', '', 'Chanukiejayaweera@gmail.com', -1, '', '', 1, '2019-10-22 04:07:44', 2),
	(14, '', 'Chandana Jayaweera', '', '2012-12-12 00:00:00', '0712756370', '', 'fff', 13, '', '', 1, '2019-10-22 04:08:39', 2),
	(15, '', 'Janaki Jayaweera', '', '2012-12-12 00:00:00', '0112241191', '', 'hhh', 13, '', '', 1, '2019-10-22 04:09:25', 2),
	(16, '', 'Ruwan Wickramasinghe', '', '2012-12-12 00:00:00', '0773207142', '', 'ruwan@texlan.lk', 4, '', '', 1, '2019-10-22 04:10:21', 2),
	(17, '', 'Sujeewa Wickramasinghe', '', '2012-12-12 00:00:00', '0767753812', '', 'jjj', 4, '', '', 1, '2019-10-22 04:11:06', 2),
	(18, '', 'FEC NDB Wealth Account', '', '2012-12-12 00:00:00', '0764228111', '', 'fecb1112018@gmail.com', 8, '', '', 0, '2019-10-22 04:13:01', 2),
	(19, '', 'Nuwan Wickramasinghe', '', '2012-12-12 00:00:00', '0764228111', '', 'nuwandw1980@gmail.com', 8, '', '', 1, '2019-10-22 04:13:02', 2),
	(20, '', 'FEC Membership', '', '2012-12-12 00:00:00', '777', '', 'hhh', 2, '', '', 1, '2019-10-22 10:14:04', 3);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `member_loan` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `member_loan` DISABLE KEYS */;
INSERT INTO `member_loan` (`id`, `member_id`, `member_loan_plan_id`, `req_date`, `rate`, `amount`, `rental`, `charges`, `duration_months`, `grace_period_days`, `late_payment_charge`, `reject_cheque_penalty`, `req_user`, `note`, `status`) VALUES
	(1, 1, -1, '2019-01-01 00:00:00', '14', 10000000, 897872, 0, 12, 0, 0, 0, 2, '-', 1),
	(2, 1, -1, '2019-10-05 00:00:00', '14', 12000000, 1579816, 0, 8, 0, 0, 0, 3, '-', 1),
	(3, 1, -1, '2019-10-21 00:00:00', '10', 1200000, 306276, 0, 4, 0, 0, 0, 3, '-', 1),
	(4, 15, -1, '2019-03-15 00:00:00', '12.5', 6000000, 1036774, 0, 6, 0, 0, 0, 2, 'Loan #1 Disbursed fro 6 Months', 2),
	(5, 19, -1, '2019-03-15 00:00:00', '12.5', 2500000, 431989, 0, 6, 0, 0, 0, 2, 'Loan #2 Disbursed for 6 Months', 2),
	(6, 15, -1, '2019-07-29 00:00:00', '12.5', 10000000, 890829, 0, 12, 0, 0, 0, 2, 'Loan #3 Disbursed for 12 Months', 1),
	(7, 19, -1, '2019-08-02 00:00:00', '12.5', 10000000, 890829, 0, 12, 0, 0, 0, 2, 'Loan #4 Disbursed for 12 Months', 1),
	(8, 14, -1, '2019-09-06 00:00:00', '12.5', 6000000, 1036774, 0, 6, 0, 0, 0, 2, 'Loan #5 Disbursed for 6 Months', 1),
	(9, 4, -1, '2019-09-12 00:00:00', '12.5', 2500000, 515733, 0, 5, 0, 0, 0, 3, 'Loan #6 Disbursed for 5 Months', 1),
	(10, 19, -1, '2019-10-15 00:00:00', '12.5', 5000000, 445415, 0, 12, 0, 0, 0, 2, 'Loan #7 Disbursed for 12 Months', 1),
	(11, 0, -1, '2019-12-19 00:00:00', '5', 2000000, 338212, 0, 6, 0, 0, 0, 3, '-', 1),
	(12, 2, -1, '2019-12-19 00:00:00', '5', 2000000, 338212, 0, 6, 0, 0, 0, 3, '-', 0);
/*!40000 ALTER TABLE `member_loan` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `member_loan_deposit` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `member_loan_deposit` DISABLE KEYS */;
INSERT INTO `member_loan_deposit` (`id`, `member_loan_id`, `amount`, `payment_type`, `cheque_no`, `cheque_date`, `cheque_cancel_date`, `req_date`, `req_user`, `note`, `status`) VALUES
	(1, 3, 300000, 1, '-', '2019-10-21 17:42:16', '2019-10-21 17:42:16', '2019-10-02 00:00:00', 2, '-', 4),
	(2, 3, 300000, 1, '-', '2019-10-21 17:42:28', '2019-10-21 17:42:28', '2019-10-12 00:00:00', 2, '-', 4),
	(3, 3, 300000, 1, '-', '2019-10-21 17:42:41', '2019-10-21 17:42:41', '0000-00-00 00:00:00', 2, '-', 4),
	(4, 3, 300000, 1, '-', '2019-10-21 17:43:47', '2019-10-21 17:43:47', '2019-10-27 00:00:00', 2, '-', 4),
	(5, 3, 50000, 1, '-', '2019-10-21 17:44:38', '2019-10-21 17:44:38', '2019-10-27 00:00:00', 2, '-', 4),
	(6, 2, 80000, 1, '-', '2019-10-21 17:45:32', '2019-10-21 17:45:32', '2019-10-12 00:00:00', 2, '-', 4),
	(7, 4, 1037500, 1, '-', '2019-10-22 16:47:05', '2019-10-22 16:47:05', '2019-04-15 00:00:00', 2, 'Loan #1 Rental 1', 1),
	(8, 4, 1037500, 1, '-', '2019-10-22 16:49:35', '2019-10-22 16:49:35', '2019-05-15 00:00:00', 2, 'Loan #1 Rental 2', 1),
	(9, 4, 1037500, 1, '-', '2019-10-22 16:50:43', '2019-10-22 16:50:43', '2019-06-15 00:00:00', 2, 'Loan #1 Rental 3', 1),
	(10, 4, 1037500, 1, '-', '2019-10-22 16:51:54', '2019-10-22 16:51:54', '2019-10-15 00:00:00', 2, 'Loan #1 Rental 5', 1),
	(11, 4, 1037500, 1, '-', '2019-10-22 16:53:06', '2019-10-22 16:53:06', '2019-08-15 00:00:00', 2, 'Loan #1 Rental 4', 1),
	(12, 4, 1037500, 1, '-', '2019-10-22 16:54:27', '2019-10-22 16:54:27', '2019-09-15 00:00:00', 2, 'Loan #1 Rental 6', 1),
	(13, 6, 891000, 1, '-', '2019-10-22 16:57:20', '2019-10-22 16:57:20', '2019-09-05 00:00:00', 2, 'Loan #3 Rental 1', 1),
	(14, 6, 891000, 1, '-', '2019-10-22 16:58:00', '2019-10-22 16:58:00', '2019-10-05 00:00:00', 2, 'Loan #3 Rental 2', 1),
	(15, 8, 1038000, 1, '-', '2019-10-22 17:02:45', '2019-10-22 17:02:45', '2019-10-05 00:00:00', 2, 'Loan #5 Rental 1', 1),
	(16, 8, 103800000, 1, '-', '2019-10-22 17:02:58', '2019-10-22 17:02:58', '2019-10-05 00:00:00', 2, 'Loan #5 Rental 1', 4),
	(17, 5, 482500, 1, '-', '2019-10-22 17:10:43', '2019-10-22 17:10:43', '2019-04-25 00:00:00', 2, 'Loan #2 Rental 1', 4),
	(18, 5, 462500, 1, '-', '2019-10-22 17:11:24', '2019-10-22 17:11:24', '2019-05-15 00:00:00', 2, 'Loan #2 Rental 2', 4),
	(19, 5, 462500, 1, '-', '2019-10-22 17:12:31', '2019-10-22 17:12:31', '2019-04-15 00:00:00', 2, 'Loan #2 Rental 1', 1),
	(20, 5, 463500, 1, '-', '2019-10-22 17:13:02', '2019-10-22 17:13:02', '2019-05-15 00:00:00', 2, 'Loan #2 Rental 2', 4),
	(21, 5, 462500, 1, '-', '2019-10-22 17:13:31', '2019-10-22 17:13:31', '2019-05-15 00:00:00', 2, 'Loan #2 Rental 2', 1),
	(22, 5, 462500, 1, '-', '2019-10-22 17:14:07', '2019-10-22 17:14:07', '2019-06-15 00:00:00', 2, 'Loan #2 Rental 3', 1),
	(23, 5, 462500, 1, '-', '2019-10-22 17:14:47', '2019-10-22 17:14:47', '2019-07-15 00:00:00', 2, 'Loan #2 Rental 4', 1),
	(24, 5, 432500, 1, '-', '2019-10-22 17:15:28', '2019-10-22 17:15:28', '2019-08-15 00:00:00', 2, 'Loan #2 Rental 5', 1),
	(25, 5, 462000, 1, '-', '2019-10-22 17:16:06', '2019-10-22 17:16:06', '2019-09-15 00:00:00', 2, 'Loan #2 Rental 6', 1),
	(26, 7, 891000, 1, '-', '2019-10-22 17:18:33', '2019-10-22 17:18:33', '2019-09-05 00:00:00', 2, 'Loan #4 Rental 1', 1),
	(27, 7, 891000, 1, '-', '2019-10-22 17:19:02', '2019-10-22 17:19:02', '2019-10-05 00:00:00', 2, 'Loan #4 Rental 2', 1),
	(29, 6, 891000, 1, '-', '2019-12-18 11:26:47', '2019-12-18 11:26:47', '2019-11-14 00:00:00', 2, 'Loan #3 Rental 3', 1),
	(30, 6, 891000, 1, '-', '2019-12-18 11:28:04', '2019-12-18 11:28:04', '2019-12-16 00:00:00', 2, 'Loan #3 Rental 4', 1),
	(31, 8, 1039000, 1, '-', '2019-12-18 11:36:06', '2019-12-18 11:36:06', '2019-11-14 00:00:00', 2, 'Loan #5 Rental 2', 1),
	(32, 8, 1109000, 1, '-', '2019-12-18 11:38:12', '2019-12-18 11:38:12', '2019-12-16 00:00:00', 2, 'Loan #5 Rental 3', 1),
	(33, 10, 445400, 1, '-', '2019-12-18 11:40:18', '2019-12-18 11:40:18', '2019-11-25 00:00:00', 2, 'Loan #7 Rental 1', 1),
	(34, 7, 890900, 1, '-', '2019-12-18 11:45:41', '2019-12-18 11:45:41', '2019-11-25 00:00:00', 2, 'Loan #4 Rental 3', 1),
	(38, 9, 517000, 1, '-', '2019-12-19 07:48:13', '2019-12-19 07:48:13', '2019-10-15 00:00:00', 3, 'Loan #6 -1st Installment', 1),
	(40, 9, 515700, 1, '-', '2019-12-19 07:50:33', '2019-12-19 07:50:33', '2019-11-25 00:00:00', 3, 'Loan #6 Rental 2', 1),
	(41, 9, 515700, 1, '-', '2019-12-19 07:51:20', '2019-12-19 07:51:20', '2019-11-25 00:00:00', 2, 'Loan #6 Rental 2', 4),
	(42, 9, 520000, 1, '-', '2019-12-19 07:52:48', '2019-12-19 07:52:48', '2019-12-18 00:00:00', 3, 'Loan #6 Rental 3', 1),
	(43, 7, 890900, 1, '-', '2019-12-31 10:00:39', '2019-12-31 10:00:39', '2019-12-05 00:00:00', 2, 'Loan #4 Nuwan 4th Installment ', 1),
	(44, 10, 446100, 1, '-', '2019-12-31 10:01:45', '2019-12-31 10:01:45', '2019-12-15 00:00:00', 2, 'Loan #7 Nuwan 2nd Installment ', 1);
/*!40000 ALTER TABLE `member_loan_deposit` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `member_loan_plan` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `member_loan_plan` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_loan_plan` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `member_saving` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `member_saving` DISABLE KEYS */;
INSERT INTO `member_saving` (`id`, `member_id`, `req_date`, `amount`, `req_user`, `note`, `status`) VALUES
	(2, 10, '2018-11-26 00:00:00', 100000, 2, 'Savings', 1),
	(3, 8, '2018-11-26 00:00:00', 300000, 2, 'Savings', 1),
	(4, 11, '2018-11-26 00:00:00', 100000, 2, 'Savings', 1),
	(5, 17, '2018-11-26 00:00:00', 500000, 2, 'Savings', 1),
	(6, 4, '2018-11-26 00:00:00', 500000, 2, 'Savings', 1),
	(7, 3, '2018-11-27 00:00:00', 500000, 2, 'Savings', 1),
	(8, 6, '2019-02-25 00:00:00', 200000, 2, 'Savings', 1),
	(9, 17, '2019-02-25 00:00:00', 500000, 2, 'Savings', 1),
	(10, 6, '2019-02-25 00:00:00', 100000, 2, 'Savings from Card Project', 1),
	(11, 4, '2019-02-25 00:00:00', 25000, 2, 'Savings from Card Project', 1),
	(12, 5, '2019-02-25 00:00:00', 40000, 2, 'Savings from Card Project', 1),
	(13, 7, '2019-02-25 00:00:00', 40000, 2, 'Savings from Card Project', 1),
	(14, 13, '2019-02-25 00:00:00', 40000, 2, 'Savings from Card Project', 1),
	(15, 8, '2019-02-25 00:00:00', 30000, 2, 'Savings from Card Project', 1),
	(16, 9, '2019-02-25 00:00:00', 25000, 2, 'Savings from Card Project', 1),
	(17, 8, '2019-02-25 00:00:00', 300000, 2, 'Savings', 1),
	(18, 15, '2019-03-05 00:00:00', 500000, 2, 'Savings', 1),
	(19, 5, '2019-03-05 00:00:00', 1000000, 2, 'Savings', 1),
	(20, 11, '2019-03-05 00:00:00', 100000, 2, 'Savings', 1),
	(21, 2, '2019-03-05 00:00:00', 1000000, 2, 'Savings', 1),
	(22, 20, '2019-03-05 00:00:00', 1373000, 2, 'Savings Membership Fees ', 1),
	(23, 15, '2019-04-01 00:00:00', 500000, 2, 'Savings', 1),
	(24, 5, '2019-04-01 00:00:00', 1000000, 2, 'Savings', 1),
	(25, 19, '2019-04-01 00:00:00', 500000, 2, 'Savings', 1),
	(26, 2, '2019-04-08 00:00:00', 1000000, 2, 'Savings', 1),
	(27, 6, '2019-04-08 00:00:00', 100000, 2, 'Savings', 1),
	(28, 11, '2019-04-08 00:00:00', 100000, 2, 'Savings', 1),
	(29, 15, '2019-05-02 00:00:00', 500000, 2, 'Savings', 1),
	(30, 5, '2019-05-02 00:00:00', 2000000, 2, 'Savings', 1),
	(31, 19, '2019-05-02 00:00:00', 500000, 2, 'Savings', 1),
	(32, 2, '2019-05-06 00:00:00', 1000000, 2, 'Savings', 1),
	(33, 15, '2019-06-03 00:00:00', 500000, 2, 'Savings', 1),
	(34, 5, '2019-06-03 00:00:00', 2000000, 2, 'Savings', 1),
	(35, 19, '2019-06-03 00:00:00', 500000, 2, 'Savings', 1),
	(36, 3, '2019-06-03 00:00:00', 500000, 2, 'Savings', 1),
	(37, 15, '2019-07-08 00:00:00', 500000, 2, 'Savings', 1),
	(38, 5, '2019-07-08 00:00:00', 1000000, 2, 'Savings', 1),
	(39, 10, '2019-07-08 00:00:00', 500000, 2, 'Savings', 1),
	(40, 3, '2019-07-08 00:00:00', 500000, 2, 'Savings', 1),
	(41, 6, '2019-07-08 00:00:00', 100000, 2, 'Savings', 1),
	(42, 2, '2019-07-08 00:00:00', 2000000, 2, 'Savings', 1),
	(43, 15, '2019-07-26 00:00:00', 500000, 2, 'Savings', 1),
	(44, 5, '2019-07-26 00:00:00', 3000000, 2, 'Savings', 1),
	(45, 2, '2019-07-26 00:00:00', 1000000, 2, 'Savings', 1),
	(46, 19, '2019-07-26 00:00:00', 37500, 2, 'Savings', 1),
	(47, 2, '2019-09-09 00:00:00', 1000000, 2, 'Savings', 1),
	(48, 15, '2019-09-23 00:00:00', 500000, 2, 'Savings', 1),
	(49, 5, '2019-09-23 00:00:00', 2000000, 2, 'Savings', 1),
	(50, 19, '2019-09-30 00:00:00', 218000, 2, 'Savings', 1),
	(51, 19, '2018-11-16 00:00:00', 1500000, 2, 'Savings', 1);
/*!40000 ALTER TABLE `member_saving` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `member_saving_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT '-',
  `rate` varchar(45) NOT NULL DEFAULT '1.0',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `member_saving_rate` DISABLE KEYS */;
INSERT INTO `member_saving_rate` (`id`, `description`, `rate`, `req_date`, `req_user`, `status`) VALUES
	(1, '-', '8', '2018-11-01 00:00:00', 2, 1),
	(2, '-', '10', '2019-08-01 00:00:00', 2, 1);
/*!40000 ALTER TABLE `member_saving_rate` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `member_withdraw` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `member_withdraw` DISABLE KEYS */;
INSERT INTO `member_withdraw` (`id`, `member_id`, `amount`, `req_date`, `req_user`, `note`, `status`) VALUES
	(1, 1, 6000, '2019-10-13 00:00:00', 2, '-', 0),
	(2, 18, 8500000, '2019-03-13 00:00:00', 2, 'Loan 1 & 2 Disbursed', 0),
	(3, 18, 10000000, '2019-07-29 00:00:00', 2, 'Loan 3 Disbursed ', 0),
	(4, 18, 10000000, '2019-08-04 00:00:00', 2, 'Loan 4 Disbursed ', 0),
	(5, 18, 6000000, '2019-09-05 00:00:00', 2, 'Loan 5 Disbursed', 0),
	(6, 18, 2500000, '2019-09-11 00:00:00', 2, 'Loan 6 Disbursed', 0),
	(7, 18, 5000000, '2019-10-14 00:00:00', 2, 'Loan 7 Disbursed', 0);
/*!40000 ALTER TABLE `member_withdraw` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `payment_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `payment_type` DISABLE KEYS */;
INSERT INTO `payment_type` (`id`, `type`, `description`) VALUES
	(1, 1, 'CASH'),
	(2, 2, 'CREDIT'),
	(3, 3, 'CHEQUE');
/*!40000 ALTER TABLE `payment_type` ENABLE KEYS */;

CREATE TABLE IF NOT EXISTS `status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` int(10) NOT NULL,
  `description` varchar(45) NOT NULL DEFAULT '-',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` (`id`, `status`, `description`, `req_date`) VALUES
	(1, 0, 'inactive', '2019-09-23 11:33:52'),
	(2, 1, 'active', '2019-09-23 11:33:52'),
	(3, 3, 'pending', '2019-09-23 11:33:52'),
	(4, 4, 'cancelled', '2019-09-23 11:33:52'),
	(5, 5, 'cheque returned', '2019-09-23 11:33:52'),
	(6, 6, 'loan completed', '2019-09-23 11:33:52'),
	(8, 2, 'completed', '2019-10-05 14:32:21');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;

CREATE TABLE `bank_book_total` (
	`type` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`amount` DECIMAL(42,0) NULL
) ENGINE=MyISAM;

CREATE TABLE `member_count` (
	`type` VARCHAR(12) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`amount` BIGINT(21) NOT NULL
) ENGINE=MyISAM;

CREATE TABLE `member_loan_total` (
	`type` VARCHAR(17) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`amount` DECIMAL(42,0) NULL
) ENGINE=MyISAM;

CREATE TABLE `member_savings_top_5` (
	`member_id` INT(11) NOT NULL,
	`amount` DECIMAL(42,0) NULL,
	`name` VARCHAR(100) NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

CREATE TABLE `member_saving_history` (
	`member_id` INT(11) NOT NULL,
	`description` VARCHAR(150) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`value` BIGINT(20) NOT NULL,
	`req_date` TIMESTAMP NOT NULL,
	`trx_type` VARCHAR(10) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`id` INT(11) NOT NULL
) ENGINE=MyISAM;

CREATE TABLE `member_saving_ledger` (
	`id` INT(11) NOT NULL,
	`member_id` INT(11) NOT NULL,
	`req_date` TIMESTAMP NOT NULL,
	`amount` BIGINT(20) NOT NULL,
	`req_user` INT(11) NOT NULL,
	`note` VARCHAR(150) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`status` INT(11) NOT NULL,
	`trx_type` VARCHAR(7) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

CREATE TABLE `member_saving_total` (
	`type` VARCHAR(19) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`amount` DECIMAL(42,0) NULL
) ENGINE=MyISAM;

CREATE TABLE `statistics` (
	`type` VARCHAR(15) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`amount` DECIMAL(42,0) NULL
) ENGINE=MyISAM;

DROP TABLE IF EXISTS `bank_book_total`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `bank_book_total` AS select 'bank_book_total' AS `type`,(`s`.`amount` - `w`.`amount`) AS `amount` from ((select sum(`bank_book_ledger`.`amount`) AS `amount` from `bank_book_ledger` where (`bank_book_ledger`.`status` = 7)) `s` join (select sum(`bank_book_ledger`.`amount`) AS `amount` from `bank_book_ledger` where (`bank_book_ledger`.`status` = 9)) `w`);

DROP TABLE IF EXISTS `member_count`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `member_count` AS select 'member_count' AS `type`,count(`member`.`id`) AS `amount` from `member` where (`member`.`status` = 1);

DROP TABLE IF EXISTS `member_loan_total`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `member_loan_total` AS select 'member_loan_total' AS `type`,(`l`.`amount` - `d`.`amount`) AS `amount` from ((select sum(`member_loan`.`amount`) AS `amount` from `member_loan` where (`member_loan`.`status` = 1)) `l` join (select sum(`member_loan_deposit`.`amount`) AS `amount` from `member_loan_deposit` where (`member_loan_deposit`.`status` = 1)) `d`);

DROP TABLE IF EXISTS `member_savings_top_5`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `member_savings_top_5` AS select `tt`.`member_id` AS `member_id`,`tt`.`amount` AS `amount`,`member`.`name` AS `name` from ((select `t`.`member_id` AS `member_id`,sum(`t`.`amount`) AS `amount` from (select `member_saving`.`member_id` AS `member_id`,`member_saving`.`amount` AS `amount` from `member_saving` where (`member_saving`.`status` = 1) union select `member_withdraw`.`member_id` AS `member_id`,(-(1) * `member_withdraw`.`amount`) AS `amount` from `member_withdraw` where (`member_withdraw`.`status` = 1)) `t` group by `t`.`member_id` order by `amount` desc limit 5) `tt` left join `member` on((`member`.`id` = `tt`.`member_id`)));

DROP TABLE IF EXISTS `member_saving_history`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `member_saving_history` AS select `member_saving_ledger`.`member_id` AS `member_id`,`member_saving_ledger`.`note` AS `description`,`member_saving_ledger`.`amount` AS `value`,`member_saving_ledger`.`req_date` AS `req_date`,`member_saving_ledger`.`trx_type` AS `trx_type`,`member_saving_ledger`.`id` AS `id` from `member_saving_ledger` where (`member_saving_ledger`.`status` = 1) union select -(1) AS `member_id`,`member_saving_rate`.`description` AS `description`,`member_saving_rate`.`rate` AS `value`,`member_saving_rate`.`req_date` AS `req_date`,'RATE' AS `trx_type`,-(1) AS `id` from `member_saving_rate` where (`member_saving_rate`.`status` = 1) order by `req_date`;

DROP TABLE IF EXISTS `member_saving_ledger`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `member_saving_ledger` AS select `member_saving`.`id` AS `id`,`member_saving`.`member_id` AS `member_id`,`member_saving`.`req_date` AS `req_date`,`member_saving`.`amount` AS `amount`,`member_saving`.`req_user` AS `req_user`,`member_saving`.`note` AS `note`,`member_saving`.`status` AS `status`,'DEPOSIT' AS `trx_type` from `member_saving` union select `member_withdraw`.`id` AS `id`,`member_withdraw`.`member_id` AS `member_id`,`member_withdraw`.`req_date` AS `req_date`,`member_withdraw`.`amount` AS `amount`,`member_withdraw`.`req_user` AS `req_user`,`member_withdraw`.`note` AS `note`,`member_withdraw`.`status` AS `status`,'WITHDRAWAL' AS `trx_type` from `member_withdraw` order by `req_date` desc;

DROP TABLE IF EXISTS `member_saving_total`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `member_saving_total` AS select 'member_saving_total' AS `type`,(`s`.`amount` - `w`.`amount`) AS `amount` from ((select coalesce(sum(`member_saving`.`amount`),0) AS `amount` from `member_saving` where (`member_saving`.`status` = 1)) `s` join (select coalesce(sum(`member_withdraw`.`amount`),0) AS `amount` from `member_withdraw` where (`member_withdraw`.`status` = 1)) `w`);

DROP TABLE IF EXISTS `statistics`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `statistics` AS select `bank_book_total`.`type` AS `type`,`bank_book_total`.`amount` AS `amount` from `bank_book_total` union select `member_loan_total`.`type` AS `type`,`member_loan_total`.`amount` AS `amount` from `member_loan_total` union select `member_count`.`type` AS `type`,`member_count`.`amount` AS `amount` from `member_count` union select `member_saving_total`.`type` AS `type`,`member_saving_total`.`amount` AS `amount` from `member_saving_total`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
