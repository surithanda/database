DELIMITER //
CREATE PROCEDURE `eb_profile_education_update`(
    IN p_profile_education_id INT,
    IN p_education_level INT,
    IN p_year_completed INT,
    IN p_institution_name VARCHAR(255),
    IN p_address_line1 VARCHAR(100),
    IN p_city VARCHAR(45),
    IN p_state_id INT,
    IN p_country_id INT,
    IN p_zip VARCHAR(8),
    IN p_field_of_study INT,
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
    DECLARE education_exists INT DEFAULT 0;
    
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
            'ERROR', error_message, p_modified_user, 'PROFILE_EDUCATION_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Education ID: ', p_profile_education_id),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_EDUCATION_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Education ID: ', p_profile_education_id),
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
    
    -- Validation: Ensure profile_education_id is valid
    IF p_profile_education_id IS NULL OR p_profile_education_id <= 0 THEN
        SET error_code = '49011';
        SET error_message = 'Invalid profile_education_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the education record exists
    SELECT COUNT(*) INTO education_exists FROM profile_education WHERE profile_education_id = p_profile_education_id;
    
    IF education_exists = 0 THEN
        SET error_code = '49012';
        SET error_message = CONCAT('Education record with ID ', p_profile_education_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate year_completed if provided
    IF p_year_completed IS NOT NULL AND p_year_completed <= 0 THEN
        SET error_code = '49013';
        SET error_message = 'Year completed must be a valid year.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate institution_name if provided
    IF p_institution_name IS NOT NULL AND TRIM(p_institution_name) = '' THEN
        SET error_code = '49014';
        SET error_message = 'Institution name cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate state_id if provided
    IF p_state_id IS NOT NULL AND p_state_id <= 0 THEN
        SET error_code = '49015';
        SET error_message = 'State ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate country_id if provided
    IF p_country_id IS NOT NULL AND p_country_id <= 0 THEN
        SET error_code = '49016';
        SET error_message = 'Country ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate zip if provided
    IF p_zip IS NOT NULL AND TRIM(p_zip) = '' THEN
        SET error_code = '49017';
        SET error_message = 'ZIP code cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the education record with non-null values
    UPDATE profile_education
    SET 
        education_level = IFNULL(p_education_level, education_level),
        year_completed = IFNULL(p_year_completed, year_completed),
        institution_name = IFNULL(p_institution_name, institution_name),
        address_line1 = IFNULL(p_address_line1, address_line1),
        city = IFNULL(p_city, city),
        state_id = IFNULL(p_state_id, state_id),
        country_id = IFNULL(p_country_id, country_id),
        zip = IFNULL(p_zip, zip),
        field_of_study = IFNULL(p_field_of_study, field_of_study),
        date_modified = NOW(),
        user_modified = p_modified_user
    WHERE profile_education_id = p_profile_education_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Education record updated with ID: ', p_profile_education_id), 
        p_modified_user, 
        'PROFILE_EDUCATION_UPDATE', 
        CONCAT('Education ID: ', p_profile_education_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_profile_education_id AS profile_education_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
