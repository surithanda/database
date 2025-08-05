DELIMITER //
CREATE PROCEDURE `eb_profile_family_reference_update`(
    IN p_profile_family_reference_id INT,
    IN p_first_name VARCHAR(45),
    IN p_last_name VARCHAR(45),
    IN p_relationship_id INT,
    IN p_phone VARCHAR(15),
    IN p_email VARCHAR(45),
    IN p_address_line1 VARCHAR(100),
    IN p_city VARCHAR(45),
    IN p_state_id INT,
    IN p_country_id INT,
    IN p_zip VARCHAR(8),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_FAMILY_REFERENCE_UPDATE', 
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
            'ERROR', error_message, p_modified_user, 'PROFILE_FAMILY_REFERENCE_UPDATE', 
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
        SET error_code = '51009';
        SET error_message = 'Invalid profile_family_reference_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the family reference record exists
    SELECT COUNT(*) INTO reference_exists FROM profile_family_reference WHERE profile_family_reference_id = p_profile_family_reference_id;
    
    IF reference_exists = 0 THEN
        SET error_code = '51010';
        SET error_message = CONCAT('Family reference with ID ', p_profile_family_reference_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate first_name if provided
    IF p_first_name IS NOT NULL AND TRIM(p_first_name) = '' THEN
        SET error_code = '51011';
        SET error_message = 'First name cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate last_name if provided
    IF p_last_name IS NOT NULL AND TRIM(p_last_name) = '' THEN
        SET error_code = '51012';
        SET error_message = 'Last name cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate relationship_id if provided
    IF p_relationship_id IS NOT NULL AND p_relationship_id <= 0 THEN
        SET error_code = '51013';
        SET error_message = 'Relationship ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate phone if provided
    IF p_phone IS NOT NULL AND TRIM(p_phone) = '' THEN
        SET error_code = '51014';
        SET error_message = 'Phone number cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate email format if provided
    IF p_email IS NOT NULL AND p_email NOT LIKE '%_@_%._%' THEN
        SET error_code = '51015';
        SET error_message = 'Invalid email format.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the family reference record with non-null values
    UPDATE profile_family_reference
    SET 
        first_name = IFNULL(p_first_name, first_name),
        last_name = IFNULL(p_last_name, last_name),
        relationship_id = IFNULL(p_relationship_id, relationship_id),
        phone = IFNULL(p_phone, phone),
        email = IFNULL(p_email, email),
        address_line1 = IFNULL(p_address_line1, address_line1),
        city = IFNULL(p_city, city),
        state_id = IFNULL(p_state_id, state_id),
        country_id = IFNULL(p_country_id, country_id),
        zip = IFNULL(p_zip, zip),
        date_modified = NOW(),
        user_modified = p_modified_user
    WHERE profile_family_reference_id = p_profile_family_reference_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Family reference updated with ID: ', p_profile_family_reference_id), 
        p_modified_user, 
        'PROFILE_FAMILY_REFERENCE_UPDATE', 
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
