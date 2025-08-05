DELIMITER //
CREATE PROCEDURE `eb_profile_employment_get`(
    IN p_profile_id INT,
    IN p_profile_employment_id INT,
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
            'ERROR', error_message, p_created_user, 'PROFILE_EMPLOYMENT_GET', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_EMPLOYMENT_GET', 
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
    
    -- Validation: Ensure at least one of profile_id or profile_employment_id is provided
    IF p_profile_id IS NULL AND p_profile_employment_id IS NULL THEN
        SET error_code = '50012';
        SET error_message = 'Either profile_id or profile_employment_id must be provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Query based on the provided parameters
    IF p_profile_employment_id IS NOT NULL THEN
        -- Get specific employment record by ID
        SELECT 
            pe.*,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_employment pe
        WHERE pe.profile_employment_id = p_profile_employment_id
        AND (pe.isverified != -1 OR pe.isverified IS NULL); -- Exclude soft-deleted records
        
    ELSEIF p_profile_id IS NOT NULL THEN
        -- Get all employment records for a profile
        SELECT 
            pe.*,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_employment pe
        WHERE pe.profile_id = p_profile_id
        AND (pe.isverified != -1 OR pe.isverified IS NULL); -- Exclude soft-deleted records
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
            WHEN p_profile_employment_id IS NOT NULL THEN CONCAT('Employment record retrieved by ID: ', p_profile_employment_id)
            ELSE CONCAT('Employment records retrieved for profile ID: ', p_profile_id)
        END, 
        p_created_user, 
        'PROFILE_EMPLOYMENT_GET', 
        CASE 
            WHEN p_profile_employment_id IS NOT NULL THEN CONCAT('Employment ID: ', p_profile_employment_id)
            ELSE CONCAT('Profile ID: ', p_profile_id)
        END,
        start_time, end_time, execution_time
    );
    
END //
DELIMITER ;
