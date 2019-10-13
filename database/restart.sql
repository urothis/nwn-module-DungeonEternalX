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

-- Dumping structure for table dex.restart
DROP TABLE IF EXISTS `restart`;
CREATE TABLE IF NOT EXISTS `restart` (
  `NbPlayerMax` tinyint(4) DEFAULT '0',
  `NbPlayerAvg` tinyint(4) DEFAULT '0',
  `NbPlayerLast` tinyint(4) NOT NULL DEFAULT '0',
  `NbDMMax` tinyint(4) DEFAULT '0',
  `NbDMAvg` tinyint(4) DEFAULT '0',
  `NbDMLast` tinyint(4) NOT NULL DEFAULT '0',
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `CPUAvg` int(11) DEFAULT '0',
  `CPUMax` int(11) DEFAULT '0',
  `CPULast` int(11) NOT NULL DEFAULT '0',
  `MemoryMax` int(11) DEFAULT '0',
  `MemoryMin` int(11) DEFAULT '0',
  `MemoryLast` int(11) NOT NULL DEFAULT '0',
  `sModName` char(60) NOT NULL DEFAULT '',
  `CauseRestart` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
