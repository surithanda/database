DELIMITER //
CREATE DEFINER=`admin-test`@`%` PROCEDURE `eb_login_validate`(
    IN email VARCHAR(45), 
    IN pwd VARCHAR(45),
    IN ip VARCHAR(20), 
    IN sysname VARCHAR(45), 
    IN usragent VARCHAR(45), 
    IN location VARCHAR(45))
BEGIN
    DECLARE id_login INT;
    DECLARE email_otp INT;
    DECLARE start_date DATETIME;
    DECLARE id_account INT;

    -- Check if the username and password match 
    IF EXISTS (
        SELECT user_name, password FROM login
        WHERE (user_name = email) 
        AND BINARY password = pwd) THEN
        /*
		-- Will uncomment below code if OTP is duplicated.
		REPEAT
		  SET email_otp = FLOOR(1000 + RAND() * 9000);
		  -- Check if this OTP exists and is still valid
		  SET @otp_exists = (SELECT COUNT(*) FROM login_history 
							WHERE email_otp = email_otp 
							AND email_otp_valid_end > NOW());
		UNTIL @otp_exists = 0 END REPEAT;
		*/
        
        -- Generate email OTP 
        SET email_otp = FLOOR(1000 + RAND() * 9000);
        SET start_date = NOW();

        -- Get Login ID and Account ID 
        SELECT 
        login_id, 
        a.account_id INTO id_login, id_account
        FROM account a INNER JOIN login l on a.account_id = l.account_id 
        WHERE user_name = email 
        AND BINARY password = pwd;

        -- Insert into login_history table
        INSERT INTO login_history(
            login_name,
            login_date, 
            login_status, 
            email_otp, 
            ip_address,
            system_name,
            user_agent,
            location,
            login_id_on_success,
            email_otp_valid_start,
            email_otp_valid_end)
        VALUES(
            email,
            NOW(), 
            1,
            email_otp,
            ip, 
            sysname, 
            usragent,
            location,
            id_login,
            start_date,
            DATE_ADD(start_date, INTERVAL 2 MINUTE));

        -- Return the OTP and Account ID
        SELECT 
        'success' as status,
        email_otp AS otp, 
        id_account AS account_id,
        null AS error_code,
        null AS error_message;

    ELSE 
        -- Insert failed login attempt into login_history
        INSERT INTO login_history(
            login_name,
            login_date, 
            login_status, 
            email_otp, 
            ip_address,
            system_name,
            user_agent,
            location)
        VALUES(
            email,
            NOW(), 
            0,
            -1,
            ip, 
            sysname, 
            usragent,
            location);

        -- Return -1 for OTP and NULL for Account ID if login fails
        SELECT
        'Fail' AS status,
        null AS otp, 
        NULL AS account_id,
        '45100_INVLID_EMAIL_PASSWORD' AS error_code,
        'Email or Password is NOT Correct' AS error_message;
    END IF;
END //

DELIMITER ;