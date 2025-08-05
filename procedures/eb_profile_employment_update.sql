DELIMITER //
CREATE PROCEDURE `eb_profile_employment_update`(
    IN p_profile_employment_id INT,
    IN p_institution_name VARCHAR(255),
    IN p_address_line1 VARCHAR(100),
    IN p_city VARCHAR(45),
    IN p_state_id INT,
    IN p_country_id INT,
    IN p_zip VARCHAR(8),
    IN p_start_year INT,
    IN p_end_year INT,
    IN p_job_title_id INT,
    IN p_other_title VARCHAR(50),
    IN p_last_salary_drawn DECIMAL,
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
    DECLARE employment_exists INT DEFAULT 0;
    DECLARE current_start_year INT;
    
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
            'ERROR', error_message, p_modified_user, 'PROFILE_EMPLOYMENT_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Employment ID: ', p_profile_employment_id),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_EMPLOYMENT_UPDATE', 
            CONCAT('Error Code: ', error_code, ', Employment ID: ', p_profile_employment_id),
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
    
    -- Validation: Ensure profile_employment_id is valid
    IF p_profile_employment_id IS NULL OR p_profile_employment_id <= 0 THEN
        SET error_code = '50013';
        SET error_message = 'Invalid profile_employment_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the employment record exists
    SELECT COUNT(*), start_year INTO employment_exists, current_start_year 
    FROM profile_employment 
    WHERE profile_employment_id = p_profile_employment_id;
    
    IF employment_exists = 0 THEN
        SET error_code = '50014';
        SET error_message = CONCAT('Employment record with ID ', p_profile_employment_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate institution_name if provided
    IF p_institution_name IS NOT NULL AND TRIM(p_institution_name) = '' THEN
        SET error_code = '50015';
        SET error_message = 'Institution name cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate city if provided
    IF p_city IS NOT NULL AND TRIM(p_city) = '' THEN
        SET error_code = '50016';
        SET error_message = 'City cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate state_id if provided
    IF p_state_id IS NOT NULL AND p_state_id <= 0 THEN
        SET error_code = '50017';
        SET error_message = 'State ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate country_id if provided
    IF p_country_id IS NOT NULL AND p_country_id <= 0 THEN
        SET error_code = '50018';
        SET error_message = 'Country ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate zip if provided
    IF p_zip IS NOT NULL AND TRIM(p_zip) = '' THEN
        SET error_code = '50019';
        SET error_message = 'ZIP code cannot be empty if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate start_year if provided
    IF p_start_year IS NOT NULL AND p_start_year <= 0 THEN
        SET error_code = '50020';
        SET error_message = 'Start year must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate job_title_id if provided
    IF p_job_title_id IS NOT NULL AND p_job_title_id <= 0 THEN
        SET error_code = '50021';
        SET error_message = 'Job title ID must be valid if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate last_salary_drawn if provided
    IF p_last_salary_drawn IS NOT NULL AND p_last_salary_drawn < 0 THEN
        SET error_code = '50022';
        SET error_message = 'Last salary drawn must be non-negative if provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate end_year if provided (must be greater than or equal to start_year)
    IF p_end_year IS NOT NULL AND p_start_year IS NULL AND p_end_year < current_start_year THEN
        SET error_code = '50023';
        SET error_message = 'End year must be greater than or equal to start year.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate end_year and start_year if both provided
    IF p_end_year IS NOT NULL AND p_start_year IS NOT NULL AND p_end_year < p_start_year THEN
        SET error_code = '50024';
        SET error_message = 'End year must be greater than or equal to start year.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the employment record with non-null values
    UPDATE profile_employment
    SET 
        institution_name = IFNULL(p_institution_name, institution_name),
        address_line1 = IFNULL(p_address_line1, address_line1),
        city = IFNULL(p_city, city),
        state_id = IFNULL(p_state_id, state_id),
        country_id = IFNULL(p_country_id, country_id),
        zip = IFNULL(p_zip, zip),
        start_year = IFNULL(p_start_year, start_year),
        end_year = IFNULL(p_end_year, end_year),
        job_title_id = IFNULL(p_job_title_id, job_title_id),
        other_title = IFNULL(p_other_title, other_title),
        last_salary_drawn = IFNULL(p_last_salary_drawn, last_salary_drawn),
        date_modified = NOW(),
        user_modified = p_modified_user
    WHERE profile_employment_id = p_profile_employment_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Employment record updated with ID: ', p_profile_employment_id), 
        p_modified_user, 
        'PROFILE_EMPLOYMENT_UPDATE', 
        CONCAT('Employment ID: ', p_profile_employment_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_profile_employment_id AS profile_employment_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
