DELIMITER //
CREATE PROCEDURE `eb_profile_views_create`(
    IN p_profile_id INT,
    IN p_viewed_profile_id INT,
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_view_id INT;
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
            'ERROR', error_message, p_created_user, 'PROFILE_VIEWS_CREATE', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_VIEWS_CREATE', 
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
        SET error_code = '59001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '59002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate viewed_profile_id
    IF p_viewed_profile_id IS NULL OR p_viewed_profile_id <= 0 THEN
        SET error_code = '59003';
        SET error_message = 'Viewed profile ID is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if viewed profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_viewed_profile_id) THEN
        SET error_code = '59004';
        SET error_message = 'Viewed profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if profile is trying to view itself (this is allowed, but we'll log it)
    IF p_profile_id = p_viewed_profile_id THEN
        SET error_code = '59005';
        SET error_message = 'A profile is viewing itself.';
        -- We don't signal an error here, just log it
    END IF;
    
    -- Insert the new view record
    INSERT INTO profile_views (
        profile_id,
        viewed_profile_id,
        view_date,
        date_created,
        user_created,
        date_modified,
        user_modified,
        isverified
    ) VALUES (
        p_profile_id,
        p_viewed_profile_id,
        NOW(), -- view_date is set to current time
        NOW(),
        p_created_user,
        NOW(),
        p_created_user,
        0 -- Not verified by default
    );
    
    -- Get the new view ID
    SET new_view_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Profile ', p_profile_id, ' viewed profile ', p_viewed_profile_id), 
        p_created_user, 
        'PROFILE_VIEWS_CREATE', 
        CONCAT('Profile ID: ', p_profile_id, ', Viewed Profile ID: ', p_viewed_profile_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new view ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_view_id AS id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
