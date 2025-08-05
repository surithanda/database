
-- This table can be used for both metrics. profiles contacted by self (where from_profile_id = profile_id)
CREATE TABLE `profile_contacted` (
  `profile_view_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_profile_id` int(11) NOT NULL,
  `to_profile_id` int(11) DEFAULT NULL,
  `profile_contact_date` datetime DEFAULT NULL,
  `profile_contact_result` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`profile_view_id`)
) ENGINE=InnoDB;
