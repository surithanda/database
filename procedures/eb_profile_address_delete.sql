DELIMITER //
CREATE PROCEDURE `eb_profile_address_delete`(
    IN p_profile_address_id INT,
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
    DECLARE address_exists INT DEFAULT 0;
    
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
            'ERROR', error_message, p_created_user, 'PROFILE_ADDRESS_DELETE', 
            CONCAT('Error Code: ', error_code, ', Address ID: ', p_profile_address_id),
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
            'ERROR', error_message, p_created_user, 'PROFILE_ADDRESS_DELETE', 
            CONCAT('Error Code: ', error_code, ', Address ID: ', p_profile_address_id),
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
    
    -- Validation: Ensure profile_address_id is valid
    IF p_profile_address_id IS NULL OR p_profile_address_id <= 0 THEN
        SET error_code = '47016';
        SET error_message = 'Invalid profile_address_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the address exists
    SELECT COUNT(*) INTO address_exists FROM profile_address WHERE profile_address_id = p_profile_address_id;
    
    IF address_exists = 0 THEN
        SET error_code = '47017';
        SET error_message = CONCAT('Address with ID ', p_profile_address_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Soft delete by adding isverified = -1 (assuming -1 means deleted)
    -- Note: Since the table structure doesn't have an is_active field, we're using isverified as a status indicator
    UPDATE profile_address
    SET 
        isverified = -1,
        date_modified = NOW(),
        user_modified = p_created_user
    WHERE profile_address_id = p_profile_address_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful deletion
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'DELETE', 
        CONCAT('Address deleted with ID: ', p_profile_address_id), 
        p_created_user, 
        'PROFILE_ADDRESS_DELETE', 
        CONCAT('Address ID: ', p_profile_address_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_profile_address_id AS profile_address_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
