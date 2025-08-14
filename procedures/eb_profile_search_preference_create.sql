DELIMITER //
CREATE PROCEDURE `eb_profile_search_preference_create`(
    IN p_profile_id INT,
    IN p_min_age INT,
    IN p_max_age INT,
    IN p_gender INT,
    IN p_religion INT,
    IN p_max_education INT,
    IN p_occupation INT,
    IN p_country INT,
    IN p_casete_id INT,
    IN p_marital_status INT,
    IN p_created_user VARCHAR(40)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_preference_id INT;
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
            'ERROR', error_message, p_created_user, 'PROFILE_SEARCH_PREFERENCE_CREATE', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_SEARCH_PREFERENCE_CREATE', 
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
        SET error_code = '57001';
        SET error_message = 'Invalid profile_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate if profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id) THEN
        SET error_code = '57002';
        SET error_message = 'Profile does not exist.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate min_age
    IF p_min_age IS NOT NULL AND (p_min_age < 20 OR p_min_age > 70) THEN
        SET error_code = '57003';
        SET error_message = 'Minimum age must be between 20 and 70.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate max_age
    IF p_max_age IS NOT NULL AND (p_max_age < 20 OR p_max_age > 70) THEN
        SET error_code = '57004';
        SET error_message = 'Maximum age must be between 20 and 70.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate min_age and max_age relationship
    IF p_min_age IS NOT NULL AND p_max_age IS NOT NULL AND p_min_age > p_max_age THEN
        SET error_code = '57005';
        SET error_message = 'Minimum age cannot be greater than maximum age.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate gender from lookup table
    IF p_gender IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lookup_table WHERE category = 'gender' AND id = p_gender AND isactive = 1) THEN
        SET error_code = '57006';
        SET error_message = 'Invalid gender preference code.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate religion from lookup table
    IF p_religion IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lookup_table WHERE category = 'religion' AND id = p_religion AND isactive = 1) THEN
        SET error_code = '57007';
        SET error_message = 'Invalid religion code.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate education from lookup table
    IF p_max_education IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lookup_table WHERE category = 'education_level' AND id = p_max_education AND isactive = 1) THEN
        SET error_code = '57008';
        SET error_message = 'Invalid education level code.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate occupation from lookup table
    IF p_occupation IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lookup_table WHERE category = 'profession' AND id = p_occupation AND isactive = 1) THEN
        SET error_code = '57009';
        SET error_message = 'Invalid occupation code.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate caste from lookup table
    IF p_casete_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lookup_table WHERE category = 'caste' AND id = p_casete_id AND isactive = 1) THEN
        SET error_code = '57010';
        SET error_message = 'Invalid caste code.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate marital status from lookup table
    IF p_marital_status IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lookup_table WHERE category = 'marital_status' AND id = p_marital_status AND isactive = 1) THEN
        SET error_code = '57011';
        SET error_message = 'Invalid marital status code.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate country from countries table
    IF p_country IS NOT NULL AND NOT EXISTS (SELECT 1 FROM country WHERE  country_id= p_country) THEN
        SET error_code = '57012';
        SET error_message = 'Invalid country name.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if this profile already has search preferences
    IF EXISTS (
        SELECT 1 
        FROM profile_search_preference 
        WHERE profile_id = p_profile_id
    ) THEN
        SET error_code = '57013';
        SET error_message = 'This profile already has search preferences. Use the update procedure instead.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new search preference record
    INSERT INTO profile_search_preference (
        profile_id,
        min_age,
        max_age,
        gender,
        religion,
        max_education,
        occupation,
        country,
        casete_id,
        marital_status
    ) VALUES (
        p_profile_id,
        p_min_age,
        p_max_age,
        p_gender,
        p_religion,
        p_max_education,
        p_occupation,
        p_country,
        p_casete_id,
        p_marital_status
    );
    
    -- Get the new preference ID
    SET new_preference_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Search preferences created for profile ID: ', p_profile_id), 
        p_created_user, 
        'PROFILE_SEARCH_PREFERENCE_CREATE', 
        CONCAT('Profile ID: ', p_profile_id, 
               ', Preference ID: ', new_preference_id, 
               ', Min Age: ', IFNULL(p_min_age, 'NULL'), 
               ', Max Age: ', IFNULL(p_max_age, 'NULL'), 
               ', Gender: ', IFNULL(p_gender, 'NULL'), 
               ', Religion: ', IFNULL(p_religion, 'NULL'), 
               ', Education: ', IFNULL(p_max_education, 'NULL'), 
               ', Occupation: ', IFNULL(p_occupation, 'NULL'), 
               ', Country: ', IFNULL(p_country, 'NULL'), 
               ', Caste: ', IFNULL(p_casete_id, 'NULL'), 
               ', Marital Status: ', IFNULL(p_marital_status, 'NULL')),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new preference ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_preference_id AS preference_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
