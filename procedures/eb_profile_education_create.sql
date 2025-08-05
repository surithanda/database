DELIMITER //
CREATE PROCEDURE `eb_profile_education_create`(
    IN p_profile_id INT,
    IN p_education_level INT,
    IN p_year_completed INT,
    IN p_institution_name VARCHAR(255),
    IN p_address_line1 VARCHAR(100),
    IN p_city VARCHAR(45),
    IN p_state_id INT,
    IN p_country_id INT,
    IN p_zip VARCHAR(8),
    IN p_field_of_study INT,
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_education_id INT;
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
            'ERROR', error_message, p_created_user, 'PROFILE_EDUCATION_CREATE', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_EDUCATION_CREATE', 
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
        SET error_code = '49001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '49002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate education_level
    IF p_education_level IS NULL THEN
        SET error_code = '49003';
        SET error_message = 'Education level is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate year_completed
    IF p_year_completed IS NULL OR p_year_completed <= 0 THEN
        SET error_code = '49004';
        SET error_message = 'Year completed is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate institution_name
    IF p_institution_name IS NULL OR TRIM(p_institution_name) = '' THEN
        SET error_code = '49005';
        SET error_message = 'Institution name is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate state_id
    IF p_state_id IS NULL OR p_state_id <= 0 THEN
        SET error_code = '49006';
        SET error_message = 'State ID is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate country_id
    IF p_country_id IS NULL OR p_country_id <= 0 THEN
        SET error_code = '49007';
        SET error_message = 'Country ID is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate zip
    IF p_zip IS NULL OR TRIM(p_zip) = '' THEN
        SET error_code = '49008';
        SET error_message = 'ZIP code is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate field_of_study
    IF p_field_of_study IS NULL THEN
        SET error_code = '49009';
        SET error_message = 'Field of study is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new education record
    INSERT INTO profile_education (
        profile_id,
        education_level,
        year_completed,
        institution_name,
        address_line1,
        city,
        state_id,
        country_id,
        zip,
        field_of_study,
        date_created,
        user_created,
        date_modified,
        user_modified,
        isverified
    ) VALUES (
        p_profile_id,
        p_education_level,
        p_year_completed,
        p_institution_name,
        p_address_line1,
        p_city,
        p_state_id,
        p_country_id,
        p_zip,
        p_field_of_study,
        NOW(),
        p_created_user,
        NOW(),
        p_created_user,
        0 -- Not verified by default
    );
    
    -- Get the new education ID
    SET new_education_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Education record created for profile ID: ', p_profile_id), 
        p_created_user, 
        'PROFILE_EDUCATION_CREATE', 
        CONCAT('Education ID: ', new_education_id, ', Institution: ', p_institution_name),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new education ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_education_id AS profile_education_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
