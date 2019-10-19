DROP SCHEMA IF EXISTS `fecbank`;
CREATE SCHEMA `fecbank`;
USE `fecbank`;

DROP TABLE IF EXISTS `bank_book`;
CREATE TABLE `bank_book` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL DEFAULT '-',
  `bank` varchar(100) NOT NULL DEFAULT '-',
  `description` varchar(100) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `bank_book_ledger`;
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
);

DROP TABLE IF EXISTS `member`;
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
);

DROP TABLE IF EXISTS `member_loan`;
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
);

DROP TABLE IF EXISTS `member_loan_deposit`;
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
);

DROP TABLE IF EXISTS `member_loan_plan`;
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
);

DROP TABLE IF EXISTS `member_saving`;
CREATE TABLE `member_saving` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `member_saving_rate`;
CREATE TABLE `member_saving_rate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL DEFAULT '-',
  `rate` varchar(45) NOT NULL DEFAULT '1.0',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `member_withdraw`;
CREATE TABLE `member_withdraw` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL,
  `note` varchar(150) NOT NULL DEFAULT '-',
  `status` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `payment_type`;
CREATE TABLE `payment_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` int(10) NOT NULL,
  `description` varchar(45) NOT NULL DEFAULT '-',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
