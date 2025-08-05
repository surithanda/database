DELIMITER //
CREATE PROCEDURE `eb_profile_address_update`(
    IN p_profile_address_id INT,
    IN p_address_type INT,
    IN p_address_line1 VARCHAR(100),
    IN p_address_line2 VARCHAR(100),
    IN p_city VARCHAR(100),
    IN p_state VARCHAR(100),
    IN p_country_id INT,
    IN p_zip VARCHAR(100),
    IN p_landmark1 VARCHAR(100),
    IN p_landmark2 VARCHAR(100),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_ADDRESS_UPDATE', 
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
            'ERROR', error_message, p_modified_user, 'PROFILE_ADDRESS_UPDATE', 
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
        SET error_code = '47009';
        SET error_message = 'Invalid profile_address_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the address exists
    SELECT COUNT(*) INTO address_exists FROM profile_address WHERE profile_address_id = p_profile_address_id;
    
    IF address_exists = 0 THEN
        SET error_code = '47010';
        SET error_message = CONCAT('Address with ID ', p_profile_address_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate address_type if provided
    IF p_address_type IS NOT NULL AND p_address_type <= 0 THEN
        SET error_code = '47011';
        SET error_message = 'Invalid address type.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate address_line1 if provided
    IF p_address_line1 IS NOT NULL AND TRIM(p_address_line1) = '' THEN
        SET error_code = '47012';
        SET error_message = 'Address line 1 cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate state if provided
    IF p_state IS NOT NULL AND TRIM(p_state) = '' THEN
        SET error_code = '47013';
        SET error_message = 'State cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate country_id if provided
    IF p_country_id IS NOT NULL AND p_country_id <= 0 THEN
        SET error_code = '47014';
        SET error_message = 'Country ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate zip if provided
    IF p_zip IS NOT NULL AND TRIM(p_zip) = '' THEN
        SET error_code = '47015';
        SET error_message = 'ZIP code cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the address with non-null values
    UPDATE profile_address
    SET 
        address_type = IFNULL(p_address_type, address_type),
        address_line1 = IFNULL(p_address_line1, address_line1),
        address_line2 = IFNULL(p_address_line2, address_line2),
        city = IFNULL(p_city, city),
        state = IFNULL(p_state, state),
        country_id = IFNULL(p_country_id, country_id),
        zip = IFNULL(p_zip, zip),
        landmark1 = IFNULL(p_landmark1, landmark1),
        landmark2 = IFNULL(p_landmark2, landmark2),
        date_modified = NOW(),
        user_modified = p_modified_user
    WHERE profile_address_id = p_profile_address_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Address updated with ID: ', p_profile_address_id), 
        p_modified_user, 
        'PROFILE_ADDRESS_UPDATE', 
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
