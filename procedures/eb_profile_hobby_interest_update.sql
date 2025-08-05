DELIMITER //
CREATE PROCEDURE `eb_profile_hobby_interest_update`(
    IN p_id INT,
    IN p_hobby_interest_id INT,
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
            'ERROR', error_message, p_modified_user, 'PROFILE_HOBBY_INTEREST_UPDATE', 
            CONCAT('Error Code: ', error_code, ', ID: ', p_id),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_HOBBY_INTEREST_UPDATE', 
            CONCAT('Error Code: ', error_code, ', ID: ', p_id),
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
    
    -- Validation: Ensure id is valid
    IF p_id IS NULL OR p_id <= 0 THEN
        SET error_code = '52006';
        SET error_message = 'Invalid id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the hobby/interest record exists and get the profile_id
    SELECT COUNT(*), profile_id INTO record_exists, current_profile_id 
    FROM profile_hobby_interest 
    WHERE id = p_id;
    
    IF record_exists = 0 THEN
        SET error_code = '52007';
        SET error_message = CONCAT('Hobby/Interest record with ID ', p_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate hobby_interest_id if provided
    IF p_hobby_interest_id IS NOT NULL AND p_hobby_interest_id <= 0 THEN
        SET error_code = '52008';
        SET error_message = 'Hobby/Interest ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if this hobby/interest is already associated with this profile
    IF p_hobby_interest_id IS NOT NULL AND EXISTS (
        SELECT 1 
        FROM profile_hobby_interest 
        WHERE profile_id = current_profile_id 
        AND hobby_interest_id = p_hobby_interest_id
        AND id != p_id
        AND (isverified != -1 OR isverified IS NULL)
    ) THEN
        SET error_code = '52009';
        SET error_message = 'This hobby/interest is already associated with this profile.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the hobby/interest record with non-null values
    UPDATE profile_hobby_interest
    SET 
        hobby_interest_id = IFNULL(p_hobby_interest_id, hobby_interest_id),
        date_modified = NOW(),
        user_modified = p_modified_user
    WHERE id = p_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Hobby/Interest record updated with ID: ', p_id), 
        p_modified_user, 
        'PROFILE_HOBBY_INTEREST_UPDATE', 
        CONCAT('ID: ', p_id, ', Profile ID: ', current_profile_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_id AS id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
