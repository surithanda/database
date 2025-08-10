DELIMITER //
CREATE PROCEDURE `common_log_error`(
    IN p_error_code VARCHAR(100),        -- Error code (e.g., '47001')
    IN p_error_message VARCHAR(255),     -- Error message
    IN p_created_by VARCHAR(150),        -- User who performed the action
    IN p_activity_type VARCHAR(100),     -- Type of activity (e.g., 'PROFILE_ADDRESS_CREATE')
    IN p_start_time DATETIME             -- When the activity started
)
BEGIN
    -- Log error to activity_log
    CALL common_log_activity(
        'ERROR',                                  -- log_type
        p_error_message,                          -- message
        p_created_by,                             -- created_by
        p_activity_type,                          -- activity_type
        CONCAT('Error Code: ', p_error_code),     -- activity_details
        p_start_time,                             -- start_time
        NOW()                                     -- end_time
    );
END //
DELIMITER ;
