CREATE TABLE `profile_property` (
  `property_id` int(11) NOT NULL,
  `profile_id` int(11) DEFAULT NULL,
  `property_type` int(11) DEFAULT NULL,
  `ownership_type` int(11) DEFAULT NULL,
  `property_address` varchar(125) DEFAULT NULL,
  `property_value` decimal(10,2) DEFAULT NULL,
  `property_description` varchar(2000) DEFAULT NULL,
  `isoktodisclose` bit(1) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `created_by` varchar(45) DEFAULT NULL,
  `modifyed_by` varchar(45) DEFAULT NULL,
  `isverified` bit DEFAULT 0,
  PRIMARY KEY (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='	';
