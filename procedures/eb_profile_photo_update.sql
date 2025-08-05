DELIMITER //
CREATE PROCEDURE `eb_profile_photo_update`(
    IN p_profile_photo_id INT,
    IN p_url VARCHAR(100),
    IN p_photo_type INT,
    IN p_caption VARCHAR(100),
    IN p_description VARCHAR(255),
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
    DECLARE record_exists INT DEFAULT 0;
    DECLARE current_profile_id INT;
    
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
            'ERROR', error_message, p_modified_user, 'PROFILE_PHOTO_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Photo ID: ', p_profile_photo_id),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_PHOTO_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Photo ID: ', p_profile_photo_id),
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
    
    -- Validation: Ensure profile_photo_id is valid
    IF p_profile_photo_id IS NULL OR p_profile_photo_id <= 0 THEN
        SET error_code = '54006';
        SET error_message = 'Invalid profile_photo_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the photo record exists and get the profile_id
    SELECT COUNT(*), profile_id INTO record_exists, current_profile_id 
    FROM profile_photo 
    WHERE profile_photo_id = p_profile_photo_id;
    
    IF record_exists = 0 THEN
        SET error_code = '54007';
        SET error_message = CONCAT('Photo with ID ', p_profile_photo_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate URL if provided
    IF p_url IS NOT NULL AND p_url = '' THEN
        SET error_code = '54008';
        SET error_message = 'Photo URL cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate caption if provided
    IF p_caption IS NOT NULL AND p_caption = '' THEN
        SET error_code = '54009';
        SET error_message = 'Caption cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- No need to handle primary photo as the field doesn't exist in the table
    
    -- Update the photo record with non-null values
    UPDATE profile_photo
    SET 
        url = IFNULL(p_url, url),
        photo_type = IFNULL(p_photo_type, photo_type),
        caption = IFNULL(p_caption, caption),
        description = IFNULL(p_description, description),
        date_modified = NOW(),
        user_modified = p_modified_user
    WHERE profile_photo_id = p_profile_photo_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Photo updated with ID: ', p_profile_photo_id), 
        p_modified_user, 
        'PROFILE_PHOTO_UPDATE', 
        CONCAT('Photo ID: ', p_profile_photo_id, ', Profile ID: ', current_profile_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_profile_photo_id AS profile_photo_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
