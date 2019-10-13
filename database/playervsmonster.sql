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

-- Dumping structure for table dex.playervsmonster
DROP TABLE IF EXISTS `playervsmonster`;
CREATE TABLE IF NOT EXISTS `playervsmonster` (
  `pm_pmid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `pm_seid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pm_arid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pm_moid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pm_plid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pm_pvid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pm_level` tinyint(3) unsigned DEFAULT '0',
  `pm_xp` mediumint(8) unsigned DEFAULT '0',
  `pm_partycnt` tinyint(3) unsigned DEFAULT '0',
  `pm_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`pm_pmid`),
  KEY `pm_moid` (`pm_moid`) USING BTREE,
  KEY `pm_plid` (`pm_plid`) USING BTREE,
  KEY `pm_arid` (`pm_arid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
