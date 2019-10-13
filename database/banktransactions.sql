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

-- Dumping structure for table dex.banktransactions
DROP TABLE IF EXISTS `banktransactions`;
CREATE TABLE IF NOT EXISTS `banktransactions` (
  `bt_btid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bt_trueid` int(10) unsigned NOT NULL DEFAULT '0',
  `bt_liid` int(10) unsigned NOT NULL DEFAULT '0',
  `bt_bankxpold` int(10) unsigned DEFAULT NULL,
  `bt_bankgoldold` int(10) unsigned DEFAULT NULL,
  `bt_bankxpnew` int(10) unsigned DEFAULT NULL,
  `bt_bankgoldnew` int(10) unsigned DEFAULT NULL,
  `bt_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bt_btid`),
  KEY `bt_liid` (`bt_liid`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=8334 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
