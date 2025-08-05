DELIMITER //
CREATE PROCEDURE `eb_profile_saved_for_later_get`(
    IN p_profile_id INT,
    IN p_id INT,
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE execution_time INT;
    
    -- Declare handler for SQL exceptions
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            error_message = MESSAGE_TEXT,
            error_code = MYSQL_ERRNO;
        
        -- Log error to activity_log
        INSERT INTO activity_log (
            log_type, message, created_by, activity_type, activity_details,
            start_time, end_time, execution_time
        ) VALUES (
            'ERROR', error_message, p_created_user, 'PROFILE_SAVED_FOR_LATER_GET', 
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
        -- Log error to activity_log
        INSERT INTO activity_log (
            log_type, message, created_by, activity_type, activity_details,
            start_time, end_time, execution_time
        ) VALUES (
            'ERROR', error_message, p_created_user, 'PROFILE_SAVED_FOR_LATER_GET', 
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
    
    -- Validation: Ensure at least one of profile_id or id is provided
    IF p_profile_id IS NULL AND p_id IS NULL THEN
        SET error_code = '56007';
        SET error_message = 'Either profile_id or id must be provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Query based on the provided parameters
    IF p_id IS NOT NULL THEN
        -- Get specific saved for later record by ID
        SELECT 
            psfl.*,
            pp.first_name, 
            pp.last_name,
            pp.gender,
            pp.date_of_birth,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_saved_for_later psfl
        LEFT JOIN profile_personal pp ON psfl.saved_profile_id = pp.profile_id
        WHERE psfl.id = p_id
        AND (psfl.isverified != -1 OR psfl.isverified IS NULL); -- Exclude soft-deleted records
        
    ELSEIF p_profile_id IS NOT NULL THEN
        -- Get all saved for later records for a profile
        SELECT 
            psfl.*,
            pp.first_name, 
            pp.last_name,
            pp.gender,
            pp.date_of_birth,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_saved_for_later psfl
        LEFT JOIN profile_personal pp ON psfl.saved_profile_id = pp.profile_id
        WHERE psfl.profile_id = p_profile_id
        AND (psfl.isverified != -1 OR psfl.isverified IS NULL) -- Exclude soft-deleted records
        ORDER BY psfl.date_created DESC;
    END IF;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful read
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'READ', 
        CASE 
            WHEN p_id IS NOT NULL THEN CONCAT('Saved for later record retrieved by ID: ', p_id)
            ELSE CONCAT('Saved for later records retrieved for profile ID: ', p_profile_id)
        END, 
        p_created_user, 
        'PROFILE_SAVED_FOR_LATER_GET', 
        CASE 
            WHEN p_id IS NOT NULL THEN CONCAT('ID: ', p_id)
            ELSE CONCAT('Profile ID: ', p_profile_id)
        END,
        start_time, end_time, execution_time
    );
    
END //
DELIMITER ;
