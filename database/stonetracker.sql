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

-- Dumping structure for table dex.stonetracker
DROP TABLE IF EXISTS `stonetracker`;
CREATE TABLE IF NOT EXISTS `stonetracker` (
  `st_stid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `st_name` varchar(64) DEFAULT '',
  `st_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `st_plid` mediumint(8) unsigned DEFAULT '0',
  `st_used` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `st_usedplid` mediumint(8) unsigned DEFAULT '0',
  PRIMARY KEY (`st_stid`),
  KEY `st_plid` (`st_plid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
