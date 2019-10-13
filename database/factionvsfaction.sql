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

-- Dumping structure for table dex.factionvsfaction
DROP TABLE IF EXISTS `factionvsfaction`;
CREATE TABLE IF NOT EXISTS `factionvsfaction` (
  `ff_ffid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `ff_faid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ff_faidvs` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ff_diplomacy` enum('Friend','Enemy','Neutral') NOT NULL DEFAULT 'Friend',
  `ff_kills` smallint(5) unsigned DEFAULT '0',
  `ff_killsgen` smallint(5) unsigned DEFAULT '0',
  `ff_killscom` smallint(5) unsigned DEFAULT '0',
  `ff_dlkill` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ff_deaths` smallint(5) unsigned DEFAULT '0',
  `ff_deathsgen` smallint(5) unsigned DEFAULT '0',
  `ff_deathscom` smallint(5) unsigned DEFAULT '0',
  `ff_dldeath` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`ff_ffid`),
  UNIQUE KEY `ff_faid` (`ff_faid`,`ff_faidvs`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
