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

-- Dumping structure for table dex.pvp_weapons
DROP TABLE IF EXISTS `pvp_weapons`;
CREATE TABLE IF NOT EXISTS `pvp_weapons` (
  `id` int(4) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `resref` text NOT NULL,
  `cost` int(10) NOT NULL DEFAULT '0',
  `damage1` text NOT NULL,
  `damage2` text NOT NULL,
  `masscrit` text NOT NULL,
  `skill1` text NOT NULL,
  `skill2` text NOT NULL,
  `skillminus` text NOT NULL,
  `enhance` tinyint(1) NOT NULL DEFAULT '0',
  `onhit` text NOT NULL,
  `keen` tinyint(1) NOT NULL DEFAULT '0',
  `feat1` text NOT NULL,
  `feat2` text NOT NULL,
  `spellslot1` text NOT NULL,
  `spellslot2` text NOT NULL,
  `vuln1` text NOT NULL,
  `vuln2` text NOT NULL,
  `resist1` text NOT NULL,
  `resist2` text NOT NULL,
  `onhitspell` text NOT NULL,
  `freedom` tinyint(1) NOT NULL DEFAULT '0',
  `vamp` tinyint(1) NOT NULL DEFAULT '0',
  `trueseeing` tinyint(1) NOT NULL DEFAULT '0',
  `holyavenger` tinyint(1) NOT NULL DEFAULT '0',
  `darkvision` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
