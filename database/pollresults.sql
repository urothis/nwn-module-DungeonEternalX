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

-- Dumping structure for table dex.pollresults
DROP TABLE IF EXISTS `pollresults`;
CREATE TABLE IF NOT EXISTS `pollresults` (
  `pr_poll_id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `pr_topic` text NOT NULL,
  `pr_opt1` text NOT NULL,
  `pr_opt2` text NOT NULL,
  `pr_opt3` text NOT NULL,
  `pr_opt4` text NOT NULL,
  `pr_opt_val1` tinyint(4) NOT NULL DEFAULT '0',
  `pr_opt_val2` tinyint(4) NOT NULL DEFAULT '0',
  `pr_opt_val3` tinyint(4) NOT NULL DEFAULT '0',
  `pr_opt_val4` tinyint(4) NOT NULL DEFAULT '0',
  `pr_duration` tinyint(3) NOT NULL DEFAULT '30',
  `pr_first` date NOT NULL,
  `pr_last` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `pr_expired` tinyint(1) NOT NULL DEFAULT '0',
  KEY `pr_id` (`pr_poll_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
