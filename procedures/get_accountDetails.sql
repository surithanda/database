DELIMITER //

CREATE PROCEDURE get_accountDetails(IN email_id VARCHAR(150))
BEGIN

    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
	SET error_code = '45015_EMAIL_DOES_NOT_EXIST';
    SET error_message = 'Email doesn\'t exists';

	
	IF EXISTS(	SELECT * FROM account WHERE email = email_id) THEN
		SELECT 
				`account`.`account_code`,
				`account`.`email`,
				`account`.`primary_phone`,
				`account`.`primary_phone_country`,
				`account`.`primary_phone_type`,
				`account`.`secondary_phone`,
				`account`.`secondary_phone_country`,
				`account`.`secondary_phone_type`,
				`account`.`first_name`,
				`account`.`last_name`,
				`account`.`middle_name`,
				`account`.`birth_date`,
				`account`.`gender`,
				`account`.`address_line1`,
				`account`.`address_line2`,
				`account`.`city`,
				`account`.`state`,
				`account`.`zip`,
				`account`.`country`,
				`account`.`photo`,
				`account`.`secret_question`,
				`account`.`secret_answer`,
				`account`.`created_date`,
				`account`.`created_user`,
				`account`.`modified_date`,
				`account`.`modified_user`,
				`account`.`is_active`,
				`account`.`activation_date`,
				`account`.`activated_user`,
				`account`.`deactivated_date`,
				`account`.`deactivated_user`,
				`account`.`deactivation_reason`,
				`account`.`is_deleted`,
				`account`.`deleted_date`,
				`account`.`deleted_user`,
				`account`.`deleted_reason`
			FROM `matrimony_services`.`account`
			WHERE email = email_id;        
	ELSE
		SELECT error_code AS error_code, error_message AS error_message;		
    END IF;
END //

DELIMITER ;
