CREATE TABLE `profile_favorites` (
  `profile_favorite_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_profile_id` int(11) NOT NULL,
  `to_profile_id` int(11) NOT NULL,
  `date_created` datetime DEFAULT current_timestamp(),
  `is_active` bit(1) DEFAULT b'1',
  `date_updated` datetime DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`profile_favorite_id`)
) ENGINE=InnoDB ;
