DELIMITER //
CREATE PROCEDURE `eb_profile_contact_update`(
    IN p_contact_id INT,
    IN p_contact_type INT,
    IN p_contact_value VARCHAR(255),
    IN p_isverified INT,
    IN p_isvalid INT,
    IN p_modified_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE execution_time INT;
    DECLARE contact_exists INT DEFAULT 0;
    
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
            'ERROR', error_message, p_modified_user, 'PROFILE_CONTACT_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Contact ID: ', p_contact_id),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_CONTACT_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Contact ID: ', p_contact_id),
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
    
    -- Validation: Ensure contact_id is valid
    IF p_contact_id IS NULL OR p_contact_id <= 0 THEN
        SET error_code = '48006';
        SET error_message = 'Invalid contact_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the contact exists
    SELECT COUNT(*) INTO contact_exists FROM profile_contact WHERE id = p_contact_id;
    
    IF contact_exists = 0 THEN
        SET error_code = '48007';
        SET error_message = CONCAT('Contact with ID ', p_contact_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate contact_type if provided
    IF p_contact_type IS NOT NULL AND p_contact_type <= 0 THEN
        SET error_code = '48008';
        SET error_message = 'Invalid contact type.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate contact_value if provided
    IF p_contact_value IS NOT NULL AND TRIM(p_contact_value) = '' THEN
        SET error_code = '48009';
        SET error_message = 'Contact value cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the contact with non-null values
    UPDATE profile_contact
    SET 
        contact_type = IFNULL(p_contact_type, contact_type),
        contact_value = IFNULL(p_contact_value, contact_value),
        isverified = IFNULL(p_isverified, isverified),
        isvalid = IFNULL(p_isvalid, isvalid)
    WHERE id = p_contact_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Contact updated with ID: ', p_contact_id), 
        p_modified_user, 
        'PROFILE_CONTACT_UPDATE', 
        CONCAT('Contact ID: ', p_contact_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_contact_id AS contact_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
