-- --------------------------------------------------------
-- Host:                         nwn.dungeoneternalx.com
-- Server version:               5.5.62 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table dex.tradeskills
DROP TABLE IF EXISTS `tradeskills`;
CREATE TABLE IF NOT EXISTS `tradeskills` (
  `ts_id` int(11) NOT NULL AUTO_INCREMENT,
  `ts_trueid` int(11) NOT NULL DEFAULT '1',
  `ts_melting` int(11) NOT NULL DEFAULT '1',
  `ts_milling` int(11) NOT NULL DEFAULT '1',
  `ts_brewing` int(11) NOT NULL DEFAULT '1',
  `ts_alchemy` int(11) NOT NULL DEFAULT '1',
  `ts_farming` int(11) NOT NULL DEFAULT '1',
  `ts_free` int(11) NOT NULL DEFAULT '0',
  `ts_last` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ts_id`),
  UNIQUE KEY `ts_ckid` (`ts_trueid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
