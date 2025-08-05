DELIMITER //

-- This procedure to validate email and create OTP.
-- This procedures will be used when forgot the password

CREATE PROCEDURE `eb_validate_mail_and_generate_OTP`(
    IN email VARCHAR(150), 
    IN ip VARCHAR(20), 
    IN sysname VARCHAR(45), 
    IN usragent VARCHAR(45), 
    IN location VARCHAR(45))
BEGIN
    DECLARE id_login INT;
    DECLARE email_otp INT;
    DECLARE start_date DATETIME;

    -- Check if the email exists in the login table 
    IF EXISTS (
        SELECT 1 FROM uvw_get_login_info 
        WHERE email = email) THEN

        -- Generate email OTP 
        SET email_otp = FLOOR(1000 + RAND() * 9000);
        SET start_date = NOW();

        -- Get Login ID (use LIMIT 1 to ensure only one row is selected)
        SELECT login_id INTO id_login 
        FROM login 
        WHERE email = email
        LIMIT 1;

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

        -- Return the OTP
        SELECT email_otp AS otp;

    ELSE 
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
        -- Return -1 if the email is invalid
        SELECT '45008_LOGIN_FAILED' as error_code, 'Either Email does not or NOT active yet.' as error_message, -1 AS otp;
    END IF;
END 