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

-- Dumping structure for table dex.player
DROP TABLE IF EXISTS `player`;
CREATE TABLE IF NOT EXISTS `player` (
  `plid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `trueid` mediumint(6) unsigned NOT NULL DEFAULT '0',
  `acid` int(8) unsigned NOT NULL DEFAULT '0',
  `name` varchar(80) DEFAULT NULL,
  `dm` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `pker` smallint(8) unsigned NOT NULL DEFAULT '0',
  `dlpker` datetime DEFAULT NULL,
  `pked` smallint(8) unsigned NOT NULL DEFAULT '0',
  `dlpked` datetime DEFAULT NULL,
  `kills` smallint(5) unsigned NOT NULL DEFAULT '0',
  `deaths` smallint(5) unsigned NOT NULL DEFAULT '0',
  `logins` smallint(8) unsigned NOT NULL DEFAULT '0',
  `lastlogin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `bind` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `time` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `damage` smallint(5) unsigned DEFAULT '0',
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `highxp` mediumint(9) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`plid`),
  KEY `pl_acid` (`trueid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=560 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
