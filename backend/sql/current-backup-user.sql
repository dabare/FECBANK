/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE TABLE IF NOT EXISTS `user` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` (`id`, `name`, `email`, `contactNo`, `uname`, `pass`, `db`, `privilege_id`, `req_date`, `req_user`) VALUES
	(1, 'superuser', 'superuser', 'superuser', 'superuser', '8721c7ddb78574979899d42e7bef4efb', 'fecbank', 13, '2019-09-25 04:19:11', -1),
	(2, 'Nuwan', '-', '-', 'nuwan', '25d55ad283aa400af464c76d713c07ad', 'fecbank', 13, '2019-10-19 16:12:34', 1),
	(3, 'Madhava', '-', '-', 'madhava', '8721c7ddb78574979899d42e7bef4efb', 'fecbank', 13, '2019-10-19 17:57:53', 1),
	(4, 'Nimeshi', '-', '-', 'nimeshi', '25d55ad283aa400af464c76d713c07ad', 'fecbank', 13, '2019-10-19 17:58:37', 1),
	(5, 'Avishka', '-', '-', 'avishka', '25d55ad283aa400af464c76d713c07ad', 'fecbank', 13, '2019-10-19 17:58:52', 1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
