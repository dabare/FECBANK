DROP SCHEMA IF EXISTS `user`;
CREATE SCHEMA `user`;
USE `user`;
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '-',
  `email` varchar(50) NOT NULL DEFAULT '-',
  `contactNo` varchar(50) NOT NULL DEFAULT '-',
  `uname` varchar(50) NOT NULL DEFAULT '-',
  `pass` varchar(1000) NOT NULL DEFAULT '25d55ad283aa400af464c76d713c07ad',
  `db` varchar(100) NOT NULL DEFAULT '-',
  `privilege_id` int(11) NOT NULL DEFAULT '0',
  `req_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `req_user` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
);
INSERT INTO `user` VALUES (1,'superuser','superuser','superuser','superuser','25d55ad283aa400af464c76d713c07ad','fecbank',13,'2019-09-25 04:19:11',-1);
