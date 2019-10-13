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

-- Dumping structure for table dex.playervsplayer
DROP TABLE IF EXISTS `playervsplayer`;
CREATE TABLE IF NOT EXISTS `playervsplayer` (
  `pp_ppid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pp_seid` int(10) unsigned NOT NULL DEFAULT '0',
  `pp_arid` int(10) unsigned NOT NULL DEFAULT '0',
  `pp_plid` int(10) unsigned NOT NULL DEFAULT '0',
  `pp_pvid` int(10) unsigned NOT NULL DEFAULT '0',
  `pp_plevel` tinyint(3) unsigned DEFAULT '0',
  `pp_kplid` int(10) unsigned NOT NULL DEFAULT '0',
  `pp_kpvid` int(10) unsigned NOT NULL DEFAULT '0',
  `pp_klevel` tinyint(3) unsigned DEFAULT '0',
  `pp_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pp_xp` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pp_ppid`),
  KEY `pp_plid` (`pp_plid`) USING BTREE,
  KEY `pp_kplid` (`pp_kplid`) USING BTREE,
  KEY `pp_arid` (`pp_arid`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
