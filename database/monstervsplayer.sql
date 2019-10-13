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

-- Dumping structure for table dex.monstervsplayer
DROP TABLE IF EXISTS `monstervsplayer`;
CREATE TABLE IF NOT EXISTS `monstervsplayer` (
  `mp_mpid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `mp_seid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `mp_arid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `mp_moid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `mp_plid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `mp_pvid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `mp_plevel` tinyint(3) unsigned DEFAULT '0',
  `mp_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mp_mpid`),
  KEY `mp_plid` (`mp_plid`) USING BTREE,
  KEY `mp_moid` (`mp_moid`) USING BTREE,
  KEY `mp_arid` (`mp_arid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
