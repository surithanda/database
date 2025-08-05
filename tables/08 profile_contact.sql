CREATE TABLE `profile_contact` (
  `id` int  NOT NULL AUTO_INCREMENT,
  `profile_id` int NOT NULL,
  `contact_type` int NOT NULL,
  `contact_value` varchar(255) DEFAULT NULL,
  `date_created` timestamp NOT NULL DEFAULT current_timestamp(),
  `isverified` int DEFAULT 0,
  `isvalid` int DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB ;






