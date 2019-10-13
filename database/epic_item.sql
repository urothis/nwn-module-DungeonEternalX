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

-- Dumping structure for table dex.epic_item
DROP TABLE IF EXISTS `epic_item`;
CREATE TABLE IF NOT EXISTS `epic_item` (
  `eiid` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `tag` text NOT NULL,
  `trueid` int(6) unsigned NOT NULL DEFAULT '0',
  `acid` int(8) unsigned NOT NULL DEFAULT '0',
  `plid` int(8) unsigned NOT NULL DEFAULT '0',
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paid` int(9) unsigned NOT NULL DEFAULT '0',
  `req` tinyint(4) unsigned NOT NULL DEFAULT '0',
  `status` enum('active','sold','trashed') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`eiid`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
