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

-- Dumping structure for table dex.trueid
DROP TABLE IF EXISTS `trueid`;
CREATE TABLE IF NOT EXISTS `trueid` (
  `trueid` smallint(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `dm` tinyint(1) DEFAULT '0',
  `chatdm` tinyint(1) DEFAULT '0',
  `ban` tinyint(1) DEFAULT '0',
  `shoutban` tinyint(1) DEFAULT '0',
  `xp` int(13) DEFAULT '0',
  `gp` int(13) DEFAULT '0',
  `donatedxp` int(13) DEFAULT '0',
  `logins` int(8) DEFAULT '0',
  `lastlogin` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `added` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `enemies` varchar(100) DEFAULT NULL,
  `faid` tinyint(2) DEFAULT '0',
  `farank` enum('Member','Lieutenant','General','Commander') DEFAULT 'Member',
  `fame` float DEFAULT '1',
  `famespent` float DEFAULT '0',
  `duper` tinyint(1) DEFAULT '0',
  `trainingtokens` smallint(4) DEFAULT '4',
  PRIMARY KEY (`trueid`)
) ENGINE=MyISAM AUTO_INCREMENT=195 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
