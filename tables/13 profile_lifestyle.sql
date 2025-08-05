CREATE TABLE `profile_lifestyle` (
  `profile_lifestyle_id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `eating_habit` varchar(45) DEFAULT NULL,
  `diet_habit` varchar(45) DEFAULT NULL,
  `cigarettes_per_day` varchar(10) DEFAULT NULL,
  `drink_frequency` varchar(45) DEFAULT NULL,
  `gambling_engage` varchar(45) DEFAULT NULL,
  `physical_activity_level` varchar(45) DEFAULT NULL,
  `relaxation_methods` varchar(45) DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `additional_info` varchar(255) DEFAULT NULL,
  `modified_date` datetime DEFAULT current_timestamp(),
  `created_user` varchar(45) DEFAULT NULL,
  `modified_user` varchar(45) DEFAULT NULL,
  `is_active` bit(1) DEFAULT NULL,
  PRIMARY KEY (`profile_lifestyle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
