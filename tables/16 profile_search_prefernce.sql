CREATE TABLE `profile_search_preference` (
  `search_preference_id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `min_age` int(11) DEFAULT NULL,
  `max_age` int(11) DEFAULT NULL,
  `religion` int(11) DEFAULT NULL,
  `max_education` int(11) DEFAULT NULL,
  `occupation` int(11) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL,
  `casete_id` int DEFAULT NULL,
  `marital_status` int DEFAULT NULL,
  `gender` int DEFAULT NULL,
  PRIMARY KEY (`search_preference_id`)
) ENGINE=InnoDB 
