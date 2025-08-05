DELIMITER //
CREATE PROCEDURE `eb_profile_family_reference_create`(
    IN p_profile_id INT,
    IN p_first_name VARCHAR(45),
    IN p_last_name VARCHAR(45),
    IN p_reference_type INT,
    IN p_primary_phone VARCHAR(15),
    IN p_email VARCHAR(45),
    IN p_address_line1 VARCHAR(100),
    IN p_city VARCHAR(45),
    IN p_state INT,
    IN p_country INT,
    IN p_zip VARCHAR(8),
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_reference_id INT;
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
            'ERROR', error_message, p_created_user, 'PROFILE_FAMILY_REFERENCE_CREATE', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_FAMILY_REFERENCE_CREATE', 
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
        SET error_code = '51001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '51002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate first_name
    IF p_first_name IS NULL OR TRIM(p_first_name) = '' THEN
        SET error_code = '51003';
        SET error_message = 'First name is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate last_name
    IF p_last_name IS NULL OR TRIM(p_last_name) = '' THEN
        SET error_code = '51004';
        SET error_message = 'Last name is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate reference_type
    IF p_reference_type IS NULL OR p_reference_type <= 0 THEN
        SET error_code = '51005';
        SET error_message = 'Reference type is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate primary_phone
    IF p_primary_phone IS NULL OR TRIM(p_primary_phone) = '' THEN
        SET error_code = '51006';
        SET error_message = 'Primary phone number is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate email format if provided
    IF p_email IS NOT NULL AND p_email NOT LIKE '%_@_%._%' THEN
        SET error_code = '51007';
        SET error_message = 'Invalid email format.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new family reference record
    INSERT INTO profile_family_reference (
        profile_id,
        first_name,
        last_name,
        reference_type,
        primary_phone,
        email,
        address_line1,
        city,
        state,
        country,
        zip,
        date_created,
        user_created,
        date_modified,
        user_modified,
        isverified
    ) VALUES (
        p_profile_id,
        p_first_name,
        p_last_name,
        p_reference_type,
        p_primary_phone,
        p_email,
        p_address_line1,
        p_city,
        p_state,
        p_country,
        p_zip,
        NOW(),
        p_created_user,
        NOW(),
        p_created_user,
        0 -- Not verified by default
    );
    
    -- Get the new reference ID
    SET new_reference_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Family reference created for profile ID: ', p_profile_id), 
        p_created_user, 
        'PROFILE_FAMILY_REFERENCE_CREATE', 
        CONCAT('Reference ID: ', new_reference_id, ', Name: ', p_first_name, ' ', p_last_name),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new reference ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_reference_id AS profile_family_reference_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
