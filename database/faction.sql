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

-- Dumping structure for table dex.faction
DROP TABLE IF EXISTS `faction`;
CREATE TABLE IF NOT EXISTS `faction` (
  `fa_faid` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `fa_name` varchar(64) DEFAULT '',
  `fa_aura` smallint(5) unsigned DEFAULT '0',
  `fa_aura2` smallint(5) unsigned DEFAULT '0',
  `fa_shortcut` varchar(3) DEFAULT NULL,
  `fa_bankgold` int(10) unsigned DEFAULT '0',
  `fa_bossname` varchar(45) DEFAULT NULL,
  `fa_artifact` smallint(5) unsigned DEFAULT NULL,
  `fa_artifactname` varchar(45) DEFAULT NULL,
  `fa_bossskin` smallint(5) unsigned DEFAULT NULL,
  `fa_bankxp` int(10) unsigned DEFAULT NULL,
  `fa_fame` float unsigned DEFAULT '0',
  `fa_time` int(10) DEFAULT '0',
  `fa_enemies` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`fa_faid`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
