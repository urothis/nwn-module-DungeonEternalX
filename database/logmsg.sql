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

-- Dumping structure for table dex.logmsg
DROP TABLE IF EXISTS `logmsg`;
CREATE TABLE IF NOT EXISTS `logmsg` (
  `lmid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` varchar(45) NOT NULL,
  `trueid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `dexid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `liid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `plid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `msg` text NOT NULL,
  PRIMARY KEY (`lmid`),
  KEY `lm_acid` (`trueid`) USING BTREE,
  KEY `lm_plid` (`dexid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=2344 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
