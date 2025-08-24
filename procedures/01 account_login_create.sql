Delimiter //;
CREATE DEFINER=`admin-test`@`%` PROCEDURE `eb_account_login_create`(
    IN p_email VARCHAR(150),
    IN p_user_pwd VARCHAR(150),
    IN p_first_name VARCHAR(45),
    IN p_middle_name VARCHAR(45),
    IN p_last_name VARCHAR(45),
    IN p_birth_date DATE,
    IN p_gender INT,
    IN p_primary_phone VARCHAR(10),
    IN p_primary_phone_country VARCHAR(5),
    IN p_primary_phone_type INT,
    IN p_secondary_phone VARCHAR(10),
    IN p_secondary_phone_country VARCHAR(5),
    IN p_secondary_phone_type INT,
    IN p_address_line1 VARCHAR(45),
	IN p_address_line2 VARCHAR(45),
    IN p_city VARCHAR(45),
    IN p_state VARCHAR(45),
    IN p_zip VARCHAR(45),
    IN p_country VARCHAR(45),
    IN p_photo VARCHAR(45),
    IN p_secret_question VARCHAR(45),
    IN p_secret_answer VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_account_id INT;
    DECLARE sno VARCHAR(25) DEFAULT '';
    DECLARE account_code VARCHAR(50);
	DECLARE min_birth_date DATE;
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE execution_time INT;
	
  -- Declare handler for SQL exceptions 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
		GET DIAGNOSTICS CONDITION 1
			error_message = MESSAGE_TEXT,
			error_code = MYSQL_ERRNO;
		
		-- Log error using common_log_error procedure
		CALL common_log_error(
			error_code,
			error_message,
			p_email,
			'ACCOUNT_LOGIN_CREATE',
			start_time
		);
		
		SELECT 
			'fail' AS status,
			'SQL Exception' as error_type,
			null AS account_id,
			null AS account_code,
			null AS email,
            error_code,
            error_message;	            
    END;
    
    -- Declare handler for custom errors (SQLSTATE starting with '45')
    DECLARE EXIT HANDLER FOR SQLSTATE '45000'
    BEGIN
        ROLLBACK;
        
        -- Log error using common_log_error procedure
        CALL common_log_error(
            error_code,
            error_message,
            p_email,
            'ACCOUNT_LOGIN_CREATE',
            start_time
        );
        
        -- Return error information
		SELECT 
            'fail' AS status,
			'Validation Exception' as error_type,
			null AS account_id,
			null AS account_code,
			null AS email,
            error_code,
            error_message;	
    END;
    
    -- Record start time for performance tracking
    SET start_time = NOW();
    
    -- Start transaction at the beginning
    START TRANSACTION;

    -- Calculate the minimum birth date (20 years ago from today)
    SET min_birth_date = DATE_SUB(CURDATE(), INTERVAL 20 YEAR);
    
    -- Validation logic
    -- Check if email is provided
    IF p_email IS NULL OR p_email = '' THEN
        SET error_code = '45001_MISSING_EMAIL';
        SET error_message = 'Email is required';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if password is provided
    IF p_user_pwd IS NULL OR p_user_pwd = '' THEN
        SET error_code = '45002_MISSING_PASSWORD';
        SET error_message = 'Password is required';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if first name is provided
    IF p_first_name IS NULL OR p_first_name = '' THEN
        SET error_code = '45003_MISSING_FIRST_NAME';
        SET error_message = 'First name is required';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if last name is provided
    IF p_last_name IS NULL OR p_last_name = '' THEN
        SET error_code = '45004_MISSING_LAST_NAME';
        SET error_message = 'Last name is required';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    
    -- Check if birth date is in the future
    IF p_birth_date > CURDATE() THEN
        SET error_code = '45007_INVALID_BIRTH_DATE';
        SET error_message = 'Birth date cannot be in the future';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if user is at least 20 years old
    IF p_birth_date > min_birth_date THEN
        SET error_code = '45008_UNDERAGE';
        SET error_message = 'User must be at least 20 years old';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM account a WHERE a.email = p_email) THEN
        SET error_code = '45005_DUPLICATE_EMAIL';
        SET error_message = 'Email already exists';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if phone already exists
    IF EXISTS(SELECT 1 FROM account as a WHERE a.primary_phone = p_primary_phone) THEN
        SET error_code = '45006_DUPLICATE_PHONE';
        SET error_message = 'Primary phone number already exists';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
		-- Get today created account count to prepare account_id
		SELECT COUNT(*) + 1
		INTO sno
		FROM account
		WHERE DATE_FORMAT(created_date, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');
		
		-- Assign Account Code
		SET account_code = CONCAT(DATE_FORMAT(NOW(), '%Y%m%d-%H%i%s'), CONCAT('-', sno));
		
		-- Insert into account table
		INSERT INTO account (
			account_code,
			email, 
			first_name,
			middle_name,
			last_name,
			primary_phone,
			primary_phone_country,
			primary_phone_type,
			secondary_phone,
			secondary_phone_country,
			secondary_phone_type,
			birth_date,
			gender,
			address_line1,
			address_line2,
			city,
			state,
			zip,
			country,
			photo,
			secret_question,
			secret_answer
		)
		VALUES (
			account_code,
			p_email,
			p_first_name,
			p_middle_name,
			p_last_name,
			p_primary_phone,
			p_primary_phone_country,
			p_primary_phone_type,
			p_secondary_phone,
			p_secondary_phone_country,
			p_secondary_phone_type,
			p_birth_date,
			p_gender,
			p_address_line1,
			p_address_line2,
			p_city,
			p_state,
			p_zip,
			p_country,
			p_photo,
			p_secret_question,
			p_secret_answer
		);
		
		-- Get latest account table inserted record id
		SET new_account_id = LAST_INSERT_ID();
		
		-- Insert into login table
		INSERT INTO login (
			account_id,
			user_name,
			password
            -- p_account_type
		)
		VALUES (
			new_account_id,
			p_email, -- Using email as username
			p_user_pwd
            -- p_account_type
		);
    
    -- If we got here, everything succeeded, so commit
    COMMIT;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    CALL common_log_activity(
        'CREATE', 
        CONCAT('Account created: ', p_email), 
        p_email, 
        'ACCOUNT_LOGIN_CREATE', 
        CONCAT('Account ID: ', new_account_id, ', Account Code: ', account_code),
        start_time,
        end_time
    );
    
    -- Return success results
	SELECT 
        'success' AS status,
        null as error_type,
		new_account_id AS account_id,
		account_code,
		p_email AS email,
		null as error_code,
		null as error_message;		

END //
DELIMITER ;
