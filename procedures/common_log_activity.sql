DELIMITER //
CREATE PROCEDURE `common_log_activity`(
    IN p_log_type VARCHAR(45),           -- 'CREATE', 'UPDATE', 'DELETE', 'ERROR', etc.
    IN p_message VARCHAR(255),           -- Description of the activity
    IN p_created_by VARCHAR(150),        -- User who performed the action
    IN p_activity_type VARCHAR(100),     -- Type of activity (e.g., 'PROFILE_ADDRESS_CREATE')
    IN p_activity_details VARCHAR(255),  -- Additional details about the activity
    IN p_start_time DATETIME,            -- When the activity started
    IN p_end_time DATETIME               -- When the activity ended (NULL for ongoing)
)
BEGIN
    -- Calculate execution time in milliseconds
    DECLARE execution_time INT;
    
    -- If end_time is NULL, use current time
    IF p_end_time IS NULL THEN
        SET p_end_time = NOW();
    END IF;
    
    -- Calculate execution time
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, p_start_time, p_end_time) / 1000;
    
    -- Insert into activity_log table
    INSERT INTO activity_log (
        log_type, 
        message, 
        created_by, 
        activity_type, 
        activity_details,
        start_time, 
        end_time, 
        execution_time
    ) VALUES (
        p_log_type,
        p_message,
        p_created_by,
        p_activity_type,
        p_activity_details,
        p_start_time,
        p_end_time,
        execution_time
    );
END //
DELIMITER ;
