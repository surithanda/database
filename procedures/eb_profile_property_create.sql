DELIMITER //
CREATE PROCEDURE `eb_profile_property_create`(
    IN p_profile_id INT,
    IN p_property_type INT,
    IN p_ownership_type INT,
    IN p_property_address VARCHAR(125),
    IN p_property_value DECIMAL(10,2),
    IN p_property_description VARCHAR(2000),
    IN p_isoktodisclose BIT(1),
    IN p_created_by VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_property_id INT;
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE execution_time INT;
    
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
            'ERROR', error_message, p_created_by, 'PROFILE_PROPERTY_CREATE', 
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
        ROLLBACK;
        
        -- Log error to activity_log
        INSERT INTO activity_log (
            log_type, message, created_by, activity_type, activity_details,
            start_time, end_time, execution_time
        ) VALUES (
            'ERROR', error_message, p_created_by, 'PROFILE_PROPERTY_CREATE', 
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
    
    -- Start transaction
    START TRANSACTION;
    
    -- Validation: Ensure profile_id is valid
    IF p_profile_id IS NULL OR p_profile_id <= 0 THEN
        SET error_code = '55001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '55002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate property_type
    IF p_property_type IS NULL THEN
        SET error_code = '55003';
        SET error_message = 'Property type is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate ownership_type
    IF p_ownership_type IS NULL THEN
        SET error_code = '55005';
        SET error_message = 'Ownership type is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate property_value
    IF p_property_value IS NULL THEN
        SET error_code = '55004';
        SET error_message = 'Property value is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new property record
    INSERT INTO profile_property (
        profile_id,
        property_type,
        ownership_type,
        property_address,
        property_value,
        property_description,
        isoktodisclose,
        created_date,
        modified_date,
        created_by,
        modifyed_by,
        isverified
    ) VALUES (
        p_profile_id,
        p_property_type,
        p_ownership_type,
        p_property_address,
        p_property_value,
        p_property_description,
        p_isoktodisclose,
        NOW(),
        NOW(),
        p_created_by,
        p_created_by,
        0 -- Not verified by default
    );
    
    -- Get the new property ID
    SET new_property_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Property created for profile ID: ', p_profile_id), 
        p_created_by, 
        'PROFILE_PROPERTY_CREATE', 
        CONCAT('Profile ID: ', p_profile_id, ', Property Type: ', p_property_type, ', Property Value: ', p_property_value),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new property ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_property_id AS profile_property_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
