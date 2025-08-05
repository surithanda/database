DELIMITER //
CREATE PROCEDURE `eb_profile_search_preference_delete`(
    IN p_preference_id INT,
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
    DECLARE record_exists INT DEFAULT 0;
    DECLARE profile_id_val INT;
    
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
            'ERROR', error_message, p_created_user, 'PROFILE_SEARCH_PREFERENCE_DELETE', 
            CONCAT('Error Code: ', error_code, ', Preference ID: ', p_preference_id),
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
            'ERROR', error_message, p_created_user, 'PROFILE_SEARCH_PREFERENCE_DELETE', 
            CONCAT('Error Code: ', error_code, ', Preference ID: ', p_preference_id),
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
    
    -- Validation: Ensure preference_id is valid
    IF p_preference_id IS NULL OR p_preference_id <= 0 THEN
        SET error_code = '57017';
        SET error_message = 'Invalid preference_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the preference record exists and get the profile_id
    SELECT COUNT(*), profile_id INTO record_exists, profile_id_val 
    FROM profile_search_preference 
    WHERE preference_id = p_preference_id;
    
    IF record_exists = 0 THEN
        SET error_code = '57018';
        SET error_message = CONCAT('Search preference with ID ', p_preference_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Soft delete by setting isverified = -1
    UPDATE profile_search_preference
    SET 
        isverified = -1,
        date_modified = NOW(),
        user_modified = p_created_user
    WHERE preference_id = p_preference_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful deletion
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'DELETE', 
        CONCAT('Search preference deleted with ID: ', p_preference_id), 
        p_created_user, 
        'PROFILE_SEARCH_PREFERENCE_DELETE', 
        CONCAT('Preference ID: ', p_preference_id, ', Profile ID: ', profile_id_val),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_preference_id AS preference_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
