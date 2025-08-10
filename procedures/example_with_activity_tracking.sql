DELIMITER //
CREATE PROCEDURE `example_with_activity_tracking`(
    IN p_profile_id INT,
    IN p_data VARCHAR(100),
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_record_id INT;
    DECLARE start_time DATETIME;
    
    -- Declare handler for SQL exceptions
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            error_message = MESSAGE_TEXT,
            error_code = MYSQL_ERRNO;
        
        -- Log error using the reusable procedure
        CALL eb_log_error(
            error_code,
            error_message,
            p_created_user,
            'EXAMPLE_PROCEDURE',
            start_time
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
        
        -- Log error using the reusable procedure
        CALL eb_log_error(
            error_code,
            error_message,
            p_created_user,
            'EXAMPLE_PROCEDURE',
            start_time
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
        SET error_code = '60001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Example business logic
    -- Insert a new record
    INSERT INTO example_table (
        profile_id,
        data,
        date_created,
        user_created
    ) VALUES (
        p_profile_id,
        p_data,
        NOW(),
        p_created_user
    );
    
    -- Get the new record ID
    SET new_record_id = LAST_INSERT_ID();
    
    -- Log the successful creation using the reusable procedure
    CALL eb_log_activity(
        'CREATE',                                                 -- log_type
        CONCAT('Record created for profile ID: ', p_profile_id),  -- message
        p_created_user,                                           -- created_by
        'EXAMPLE_PROCEDURE',                                      -- activity_type
        CONCAT('Record ID: ', new_record_id),                     -- activity_details
        start_time,                                               -- start_time
        NOW()                                                     -- end_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new record ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_record_id AS record_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
