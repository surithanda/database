DELIMITER //
CREATE PROCEDURE `eb_profile_favorites_create`(
    IN p_from_profile_id INT,
    IN p_to_profile_id INT,
    IN p_account_id INT,
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_favorite_id INT;
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
            'ERROR', error_message, p_created_user, 'PROFILE_FAVORITES_CREATE', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_FAVORITES_CREATE', 
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
    
    -- Validation: Ensure from_profile_id is valid
    IF p_from_profile_id IS NULL OR p_from_profile_id <= 0 THEN
        SET error_code = '58001';
        SET error_message = 'Invalid from_profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if from profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_from_profile_id) THEN
        SET error_code = '58002';
        SET error_message = 'From profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate to_profile_id
    IF p_to_profile_id IS NULL OR p_to_profile_id <= 0 THEN
        SET error_code = '58003';
        SET error_message = 'To profile ID is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if to profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_to_profile_id) THEN
        SET error_code = '58004';
        SET error_message = 'To profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if profile is trying to favorite itself
    IF p_from_profile_id = p_to_profile_id THEN
        SET error_code = '58005';
        SET error_message = 'A profile cannot favorite itself.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if this profile has already favorited the other profile
    IF EXISTS (
        SELECT 1 
        FROM profile_favorites 
        WHERE from_profile_id = p_from_profile_id 
        AND to_profile_id = p_to_profile_id
        AND is_active = b'1'
    ) THEN
        SET error_code = '58006';
        SET error_message = 'This profile has already favorited the specified profile.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate account_id
    IF p_account_id IS NULL OR p_account_id <= 0 THEN
        SET error_code = '58007';
        SET error_message = 'Account ID is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new favorite record
    INSERT INTO profile_favorites (
        from_profile_id,
        to_profile_id,
        date_created,
        is_active,
        date_updated,
        account_id
    ) VALUES (
        p_from_profile_id,
        p_to_profile_id,
        NOW(),
        b'1',
        NOW(),
        p_account_id
    );
    
    -- Get the new favorite ID
    SET new_favorite_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Profile ', p_from_profile_id, ' favorited profile ', p_to_profile_id), 
        p_created_user, 
        'PROFILE_FAVORITES_CREATE', 
        CONCAT('From Profile ID: ', p_from_profile_id, ', To Profile ID: ', p_to_profile_id, ', Account ID: ', p_account_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new favorite ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_favorite_id AS id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
