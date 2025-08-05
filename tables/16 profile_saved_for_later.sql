CREATE TABLE `profile_saved_for_later` (
  `profile_saveforlater_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_profile_id` int(11) NOT NULL,
  `to_profile_id` int(11) NOT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `is_active` bit(1) DEFAULT b'1',
  `date_updated` datetime DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`profile_saveforlater_id`)
) ENGINE=InnoDB ;
