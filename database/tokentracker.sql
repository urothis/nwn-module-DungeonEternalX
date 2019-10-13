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

-- Dumping structure for table dex.tokentracker
DROP TABLE IF EXISTS `tokentracker`;
CREATE TABLE IF NOT EXISTS `tokentracker` (
  `tt_ttid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `tt_seid` mediumint(8) unsigned DEFAULT '0',
  `tt_dmplid` mediumint(8) unsigned DEFAULT '0',
  `tt_plid` mediumint(8) unsigned DEFAULT '0',
  `tt_msg` varchar(255) DEFAULT '',
  `tt_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tt_redemed` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `tt_rplid` mediumint(8) unsigned DEFAULT '0',
  `tt_rmsg` varchar(255) DEFAULT '',
  PRIMARY KEY (`tt_ttid`),
  KEY `tt_plid` (`tt_plid`) USING BTREE,
  KEY `tt_dmplid` (`tt_dmplid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=91 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
