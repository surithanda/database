CREATE TABLE `profile_address` (
  `profile_address_id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `address_type` int(11) NOT NULL,
  `address_line1` varchar(100) NOT NULL,
  `address_line2` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` int(11) NOT NULL,
  `country_id` int(11) NOT NULL,
  `zip` varchar(10) NOT NULL,
  `landmark1` varchar(100) DEFAULT NULL,
  `landmark2` varchar(100) DEFAULT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `user_created` varchar(45) DEFAULT NULL,
  `date_modified` datetime DEFAULT current_timestamp(),
  `user_modified` varchar(45) DEFAULT NULL,
  `isverified` int(11) DEFAULT NULL,
  PRIMARY KEY (`profile_address_id`)
) ENGINE=InnoDB ;
