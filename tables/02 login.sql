CREATE TABLE `login` (
   `login_id` int NOT NULL AUTO_INCREMENT,
   `account_id` int DEFAULT NULL,
   `user_name` varchar(45) NOT NULL,
   `password` varchar(45) NOT NULL,
   `is_active` tinyint DEFAULT 0,
   `active_date` varchar(45) DEFAULT NULL,
   `created_date` datetime NOT NULL DEFAULT current_timestamp(),
   `created_user` varchar(45) DEFAULT NULL,
   `modified_date` datetime DEFAULT NULL,
   `modified_user` varchar(45) DEFAULT NULL,
   `deactivation_date` datetime DEFAULT NULL,
   PRIMARY KEY (`login_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=23 