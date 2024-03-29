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

-- Dumping structure for table dex.dmg_stones
DROP TABLE IF EXISTS `dmg_stones`;
CREATE TABLE IF NOT EXISTS `dmg_stones` (
  `ds_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `ds_tag` varchar(64) DEFAULT NULL,
  `ds_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ds_used` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ds_plid` int(8) unsigned DEFAULT '0',
  PRIMARY KEY (`ds_id`),
  KEY `ds_plid` (`ds_plid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=1933 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
