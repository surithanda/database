
-- This table can be used for both metrics. Profiles viewed by others (where to_profile_id = profileid), profiles viewed by self (where from_profile_id = profile_id)
CREATE TABLE `profile_views` (
`profile_view_id` int(11) NOT NULL AUTO_INCREMENT,
  `from_profile_id` int(11) NOT NULL,
  `to_profile_id` int(11) NOT NULL,
  `profile_view_date` datetime DEFAULT current_timestamp(),
  `account_id` int(11) ,
  PRIMARY KEY (`profile_view_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
