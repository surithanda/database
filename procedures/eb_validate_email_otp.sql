DELIMITER //
CREATE DEFINER=`admin-test`@`%` PROCEDURE `eb_validate_email_otp`(IN email VARCHAR(150), IN user_otp INT)
BEGIN
    -- validate email OTP 
    IF EXISTS (SELECT * FROM login_history 
		WHERE 
			login_name = email AND
			email_otp = user_otp AND 
            email_otp_valid_end > NOW()) THEN
        SELECT 
			'Success' AS status,
            'OTP Verified successfully' as message,
            email,
            account_id,
            account_code
		FROM account
        WHERE email =email    ;
    ELSE
        SELECT 
			'Fail' AS status,
			'Invalid OTP presented' as message,
            null AS email,
            null AS account_id,
            null AS account_code 
		FROM DUAL;
    END IF;
END //

DELIMITER ;
