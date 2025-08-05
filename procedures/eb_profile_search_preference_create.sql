DELIMITER //
CREATE PROCEDURE `eb_profile_search_preference_create`(
    IN p_profile_id INT,
    IN p_min_age INT,
    IN p_max_age INT,
    IN p_gender VARCHAR(45),
    IN p_location_preference VARCHAR(255),
    IN p_distance_preference INT,
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_preference_id INT;
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
            'ERROR', error_message, p_created_user, 'PROFILE_SEARCH_PREFERENCE_CREATE', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_SEARCH_PREFERENCE_CREATE', 
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
        SET error_code = '57001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '57002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate min_age
    IF p_min_age IS NOT NULL AND (p_min_age < 18 OR p_min_age > 100) THEN
        SET error_code = '57003';
        SET error_message = 'Minimum age must be between 18 and 100.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate max_age
    IF p_max_age IS NOT NULL AND (p_max_age < 18 OR p_max_age > 100) THEN
        SET error_code = '57004';
        SET error_message = 'Maximum age must be between 18 and 100.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate min_age and max_age relationship
    IF p_min_age IS NOT NULL AND p_max_age IS NOT NULL AND p_min_age > p_max_age THEN
        SET error_code = '57005';
        SET error_message = 'Minimum age cannot be greater than maximum age.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate gender
    IF p_gender IS NOT NULL AND p_gender NOT IN ('Male', 'Female', 'Any') THEN
        SET error_code = '57006';
        SET error_message = 'Gender preference must be Male, Female, or Any.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate distance_preference
    IF p_distance_preference IS NOT NULL AND p_distance_preference < 0 THEN
        SET error_code = '57007';
        SET error_message = 'Distance preference must be a non-negative value.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if this profile already has search preferences
    IF EXISTS (
        SELECT 1 
        FROM profile_search_preference 
        WHERE profile_id = p_profile_id
        AND (isverified != -1 OR isverified IS NULL)
    ) THEN
        SET error_code = '57008';
        SET error_message = 'This profile already has search preferences. Use the update procedure instead.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new search preference record
    INSERT INTO profile_search_preference (
        profile_id,
        min_age,
        max_age,
        gender,
        location_preference,
        distance_preference,
        date_created,
        user_created,
        date_modified,
        user_modified,
        isverified
    ) VALUES (
        p_profile_id,
        p_min_age,
        p_max_age,
        p_gender,
        p_location_preference,
        p_distance_preference,
        NOW(),
        p_created_user,
        NOW(),
        p_created_user,
        0 -- Not verified by default
    );
    
    -- Get the new preference ID
    SET new_preference_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Search preferences created for profile ID: ', p_profile_id), 
        p_created_user, 
        'PROFILE_SEARCH_PREFERENCE_CREATE', 
        CONCAT('Profile ID: ', p_profile_id, ', Preference ID: ', new_preference_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new preference ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_preference_id AS preference_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
