DELIMITER //
CREATE PROCEDURE `eb_profile_search_preference_update`(
    IN p_preference_id INT,
    IN p_min_age INT,
    IN p_max_age INT,
    IN p_gender VARCHAR(45),
    IN p_location_preference VARCHAR(255),
    IN p_distance_preference INT,
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
            'ERROR', error_message, p_modified_user, 'PROFILE_SEARCH_PREFERENCE_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Preference ID: ', p_preference_id),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_SEARCH_PREFERENCE_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Preference ID: ', p_preference_id),
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
    
    -- Validation: Ensure preference_id is valid
    IF p_preference_id IS NULL OR p_preference_id <= 0 THEN
        SET error_code = '57010';
        SET error_message = 'Invalid preference_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the preference record exists and get the profile_id
    SELECT COUNT(*), profile_id INTO record_exists, current_profile_id 
    FROM profile_search_preference 
    WHERE preference_id = p_preference_id;
    
    IF record_exists = 0 THEN
        SET error_code = '57011';
        SET error_message = CONCAT('Search preference with ID ', p_preference_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate min_age if provided
    IF p_min_age IS NOT NULL AND (p_min_age < 18 OR p_min_age > 100) THEN
        SET error_code = '57012';
        SET error_message = 'Minimum age must be between 18 and 100.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate max_age if provided
    IF p_max_age IS NOT NULL AND (p_max_age < 18 OR p_max_age > 100) THEN
        SET error_code = '57013';
        SET error_message = 'Maximum age must be between 18 and 100.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Get current min and max age values for validation
    DECLARE current_min_age INT;
    DECLARE current_max_age INT;
    
    SELECT min_age, max_age INTO current_min_age, current_max_age
    FROM profile_search_preference
    WHERE preference_id = p_preference_id;
    
    -- Validate min_age and max_age relationship
    IF (p_min_age IS NOT NULL AND p_max_age IS NULL AND p_min_age > current_max_age) OR
       (p_min_age IS NULL AND p_max_age IS NOT NULL AND current_min_age > p_max_age) OR
       (p_min_age IS NOT NULL AND p_max_age IS NOT NULL AND p_min_age > p_max_age) THEN
        SET error_code = '57014';
        SET error_message = 'Minimum age cannot be greater than maximum age.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate gender if provided
    IF p_gender IS NOT NULL AND p_gender NOT IN ('Male', 'Female', 'Any') THEN
        SET error_code = '57015';
        SET error_message = 'Gender preference must be Male, Female, or Any.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate distance_preference if provided
    IF p_distance_preference IS NOT NULL AND p_distance_preference < 0 THEN
        SET error_code = '57016';
        SET error_message = 'Distance preference must be a non-negative value.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the search preference record with non-null values
    UPDATE profile_search_preference
    SET 
        min_age = IFNULL(p_min_age, min_age),
        max_age = IFNULL(p_max_age, max_age),
        gender = IFNULL(p_gender, gender),
        location_preference = IFNULL(p_location_preference, location_preference),
        distance_preference = IFNULL(p_distance_preference, distance_preference),
        date_modified = NOW(),
        user_modified = p_modified_user
    WHERE preference_id = p_preference_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Search preference updated with ID: ', p_preference_id), 
        p_modified_user, 
        'PROFILE_SEARCH_PREFERENCE_UPDATE', 
        CONCAT('Preference ID: ', p_preference_id, ', Profile ID: ', current_profile_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_preference_id AS preference_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
