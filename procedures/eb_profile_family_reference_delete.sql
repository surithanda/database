DELIMITER //
CREATE PROCEDURE `eb_profile_family_reference_delete`(
    IN p_profile_family_reference_id INT,
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
    DECLARE reference_exists INT DEFAULT 0;
    
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
            'ERROR', error_message, p_created_user, 'PROFILE_FAMILY_REFERENCE_DELETE', 
            CONCAT('Error Code: ', error_code, ', Reference ID: ', p_profile_family_reference_id),
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
            'ERROR', error_message, p_created_user, 'PROFILE_FAMILY_REFERENCE_DELETE', 
            CONCAT('Error Code: ', error_code, ', Reference ID: ', p_profile_family_reference_id),
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
    
    -- Validation: Ensure profile_family_reference_id is valid
    IF p_profile_family_reference_id IS NULL OR p_profile_family_reference_id <= 0 THEN
        SET error_code = '51016';
        SET error_message = 'Invalid profile_family_reference_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the family reference record exists
    SELECT COUNT(*) INTO reference_exists FROM profile_family_reference WHERE profile_family_reference_id = p_profile_family_reference_id;
    
    IF reference_exists = 0 THEN
        SET error_code = '51017';
        SET error_message = CONCAT('Family reference with ID ', p_profile_family_reference_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Soft delete by setting isverified = -1
    UPDATE profile_family_reference
    SET 
        isverified = -1,
        date_modified = NOW(),
        user_modified = p_created_user
    WHERE profile_family_reference_id = p_profile_family_reference_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful deletion
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'DELETE', 
        CONCAT('Family reference deleted with ID: ', p_profile_family_reference_id), 
        p_created_user, 
        'PROFILE_FAMILY_REFERENCE_DELETE', 
        CONCAT('Reference ID: ', p_profile_family_reference_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_profile_family_reference_id AS profile_family_reference_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
