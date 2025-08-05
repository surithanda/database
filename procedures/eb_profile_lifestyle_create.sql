DELIMITER //
CREATE PROCEDURE `eb_profile_lifestyle_create`(
    IN p_profile_id INT,
    IN p_eating_habit VARCHAR(45),
    IN p_diet_habit VARCHAR(45),
    IN p_cigarettes_per_day VARCHAR(10),
    IN p_drink_frequency VARCHAR(45),
    IN p_gambling_engage VARCHAR(45),
    IN p_physical_activity_level VARCHAR(45),
    IN p_relaxation_methods VARCHAR(45),
    IN p_additional_info VARCHAR(255),
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_lifestyle_id INT;
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
            'ERROR', error_message, p_created_user, 'PROFILE_LIFESTYLE_CREATE', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_LIFESTYLE_CREATE', 
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
        SET error_code = '53001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '53002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if this profile already has lifestyle information
    IF EXISTS (
        SELECT 1 
        FROM profile_lifestyle 
        WHERE profile_id = p_profile_id 
        AND is_active = 1
    ) THEN
        SET error_code = '53004';
        SET error_message = 'Lifestyle information already exists for this profile.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new lifestyle record
    INSERT INTO profile_lifestyle (
        profile_id,
        eating_habit,
        diet_habit,
        cigarettes_per_day,
        drink_frequency,
        gambling_engage,
        physical_activity_level,
        relaxation_methods,
        additional_info,
        created_date,
        modified_date,
        created_user,
        modified_user,
        is_active
    ) VALUES (
        p_profile_id,
        p_eating_habit,
        p_diet_habit,
        p_cigarettes_per_day,
        p_drink_frequency,
        p_gambling_engage,
        p_physical_activity_level,
        p_relaxation_methods,
        p_additional_info,
        NOW(),
        NOW(),
        p_created_user,
        p_created_user,
        1 -- Active by default
    );
    
    -- Get the new lifestyle ID
    SET new_lifestyle_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Lifestyle created for profile ID: ', p_profile_id), 
        p_created_user, 
        'PROFILE_LIFESTYLE_CREATE', 
        CONCAT('Profile ID: ', p_profile_id, ', Lifestyle created'),

        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new lifestyle ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_lifestyle_id AS id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
