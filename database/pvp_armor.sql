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

-- Dumping structure for table dex.pvp_armor
DROP TABLE IF EXISTS `pvp_armor`;
CREATE TABLE IF NOT EXISTS `pvp_armor` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `resref` text NOT NULL,
  `cost` int(10) NOT NULL DEFAULT '0',
  `ac` text NOT NULL,
  `ability1` text NOT NULL,
  `ability2` text NOT NULL,
  `ability3` text NOT NULL,
  `abilityminus` text NOT NULL,
  `resistance` text NOT NULL,
  `vulnerability` text NOT NULL,
  `saves1` text NOT NULL,
  `saves2` text NOT NULL,
  `savesminus` text NOT NULL,
  `freedom` tinyint(1) NOT NULL DEFAULT '0',
  `evasion` tinyint(1) NOT NULL DEFAULT '0',
  `darkvision` tinyint(1) NOT NULL DEFAULT '0',
  `haste` tinyint(1) NOT NULL DEFAULT '0',
  `skill1` text NOT NULL,
  `skill2` text NOT NULL,
  `skillminus` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
