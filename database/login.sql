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

-- Dumping structure for table dex.login
DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `liid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `seid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `trueid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `dexid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `plid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `login` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `statusin` enum('DM','OK','NEW','DEAD','INV','BAN') DEFAULT 'INV',
  `goldin` int(12) unsigned DEFAULT '0',
  `xpin` mediumint(8) unsigned DEFAULT '0',
  `logout` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `statusout` enum('OK','DEAD','INV','ATTACK') DEFAULT 'INV',
  `goldout` int(11) unsigned DEFAULT '0',
  `xpout` mediumint(8) unsigned DEFAULT '0',
  `kills` mediumint(8) unsigned DEFAULT '0',
  `attackplid` mediumint(8) unsigned DEFAULT '0',
  `famein` int(8) unsigned NOT NULL DEFAULT '0',
  `fameout` int(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`liid`),
  KEY `li_seid` (`seid`,`dexid`) USING BTREE,
  KEY `CAID` (`plid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=940 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
