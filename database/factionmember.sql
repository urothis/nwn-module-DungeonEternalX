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

-- Dumping structure for table dex.factionmember
DROP TABLE IF EXISTS `factionmember`;
CREATE TABLE IF NOT EXISTS `factionmember` (
  `fm_fmid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `fm_faid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `fm_ckid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `fm_rank` enum('Member','Commander','Lieutenant','General') NOT NULL DEFAULT 'Member',
  PRIMARY KEY (`fm_fmid`)
) ENGINE=MyISAM AUTO_INCREMENT=840 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
