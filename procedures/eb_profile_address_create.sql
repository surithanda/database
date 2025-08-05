DELIMITER //
CREATE PROCEDURE `eb_profile_address_create`(
    IN p_profile_id INT,
    IN p_address_type INT,
    IN p_address_line1 VARCHAR(100),
    IN p_address_line2 VARCHAR(100),
    IN p_city VARCHAR(100),
    IN p_state INT,
    IN p_country_id INT,
    IN p_zip VARCHAR(100),
    IN p_landmark1 VARCHAR(100),
    IN p_landmark2 VARCHAR(100),
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_address_id INT;
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
        
        -- Log error to activity_log
        INSERT INTO activity_log (
            log_type, message, created_by, activity_type, activity_details,
            start_time, end_time, execution_time
        ) VALUES (
            'ERROR', error_message, p_created_user, 'PROFILE_ADDRESS_CREATE', 
            CONCAT('Error Code: ', error_code),
            start_time, NOW(), TIMESTAMPDIFF(MICROSECOND, start_time, NOW()) / 1000
        );
        
        SELECT 
            'fail' AS status,
            'SQL Exception' as error_type,
            error_code,
            error_message;            
    END;
    
    -- Declare handler for custom errors
    DECLARE EXIT HANDLER FOR SQLSTATE '45000'
    BEGIN
        ROLLBACK;
        
        -- Log error to activity_log
        INSERT INTO activity_log (
            log_type, message, created_by, activity_type, activity_details,
            start_time, end_time, execution_time
        ) VALUES (
            'ERROR', error_message, p_created_user, 'PROFILE_ADDRESS_CREATE', 
            CONCAT('Error Code: ', error_code),
            start_time, NOW(), TIMESTAMPDIFF(MICROSECOND, start_time, NOW()) / 1000
        );
        
        SELECT 
            'fail' AS status,
            'Validation Exception' as error_type,
            error_code,
            error_message;
    END;
    
    -- Record start time for performance tracking
    SET start_time = NOW();
    
    -- Start transaction
    START TRANSACTION;
    
    -- Validation: Ensure profile_id is valid
    IF p_profile_id IS NULL OR p_profile_id <= 0 THEN
        SET error_code = '47001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '47002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate address_type
    IF p_address_type IS NULL THEN
        SET error_code = '47003';
        SET error_message = 'Address type is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate address_line1
    IF p_address_line1 IS NULL OR TRIM(p_address_line1) = '' THEN
        SET error_code = '47004';
        SET error_message = 'Address line 1 is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate state
    IF p_state IS NULL OR TRIM(p_state) = '' THEN
        SET error_code = '47005';
        SET error_message = 'State is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate country_id
    IF p_country_id IS NULL OR p_country_id <= 0 THEN
        SET error_code = '47006';
        SET error_message = 'Country ID is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate zip
    IF p_zip IS NULL OR TRIM(p_zip) = '' THEN
        SET error_code = '47007';
        SET error_message = 'ZIP code is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;

    -- Validate country_id
    IF p_state IS NULL OR p_state <= 0 THEN
        SET error_code = '47008';
        SET error_message = 'State ID is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;

    
    -- Insert the new address
    INSERT INTO profile_address (
        profile_id,
        address_type,
        address_line1,
        address_line2,
        city,
        state,
        country_id,
        zip,
        landmark1,
        landmark2,
        date_created,
        user_created,
        date_modified,
        user_modified,
        isverified
    ) VALUES (
        p_profile_id,
        p_address_type,
        p_address_line1,
        p_address_line2,
        p_city,
        p_state,
        p_country_id,
        p_zip,
        p_landmark1,
        p_landmark2,
        NOW(),
        p_created_user,
        NOW(),
        p_created_user,
        0 -- Not verified by default
    );
    
    -- Get the new address ID
    SET new_address_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Address created for profile ID: ', p_profile_id), 
        p_created_user, 
        'PROFILE_ADDRESS_CREATE', 
        CONCAT('Address ID: ', new_address_id, ', Type: ', p_address_type),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new address ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_address_id AS profile_address_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
