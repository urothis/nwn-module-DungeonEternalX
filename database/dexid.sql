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

-- Dumping structure for table dex.dexid
DROP TABLE IF EXISTS `dexid`;
CREATE TABLE IF NOT EXISTS `dexid` (
  `dexid` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `trueid` int(6) unsigned NOT NULL DEFAULT '0',
  `acid` int(6) unsigned NOT NULL DEFAULT '0',
  `ckid` int(6) unsigned NOT NULL DEFAULT '0',
  `ipid` int(6) unsigned NOT NULL DEFAULT '0',
  `logins` int(8) unsigned NOT NULL DEFAULT '0',
  `lastlogin` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`dexid`)
) ENGINE=MyISAM AUTO_INCREMENT=202 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
