DELIMITER //
CREATE PROCEDURE `eb_profile_lifestyle_update`(
    IN p_profile_lifestyle_id INT,
    IN p_eating_habit VARCHAR(45),
    IN p_diet_habit VARCHAR(45),
    IN p_cigarettes_per_day VARCHAR(10),
    IN p_drink_frequency VARCHAR(45),
    IN p_gambling_engage VARCHAR(45),
    IN p_physical_activity_level VARCHAR(45),
    IN p_relaxation_methods VARCHAR(45),
    IN p_additional_info VARCHAR(255),
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
            'ERROR', error_message, p_modified_user, 'PROFILE_LIFESTYLE_UPDATE', 
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
            'ERROR', error_message, p_modified_user, 'PROFILE_LIFESTYLE_UPDATE', 
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
    
    -- Validation: Ensure profile_lifestyle_id is valid
    IF p_profile_lifestyle_id IS NULL OR p_profile_lifestyle_id <= 0 THEN
        SET error_code = '53006';
        SET error_message = 'Invalid profile_lifestyle_id. It must be a positive integer.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if the lifestyle record exists and get the profile_id
    SELECT COUNT(*), profile_id INTO record_exists, current_profile_id 
    FROM profile_lifestyle 
    WHERE profile_lifestyle_id = p_profile_lifestyle_id;
    
    IF record_exists = 0 THEN
        SET error_code = '53007';
        SET error_message = CONCAT('Lifestyle record with ID ', p_profile_lifestyle_id, ' does not exist.');
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Update the lifestyle record with non-null values
    UPDATE profile_lifestyle
    SET 
        eating_habit = IFNULL(p_eating_habit, eating_habit),
        diet_habit = IFNULL(p_diet_habit, diet_habit),
        cigarettes_per_day = IFNULL(p_cigarettes_per_day, cigarettes_per_day),
        drink_frequency = IFNULL(p_drink_frequency, drink_frequency),
        gambling_engage = IFNULL(p_gambling_engage, gambling_engage),
        physical_activity_level = IFNULL(p_physical_activity_level, physical_activity_level),
        relaxation_methods = IFNULL(p_relaxation_methods, relaxation_methods),
        additional_info = IFNULL(p_additional_info, additional_info),
        modified_date = NOW(),
        modified_user = p_modified_user
    WHERE profile_lifestyle_id = p_profile_lifestyle_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful update
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'UPDATE', 
        CONCAT('Lifestyle record updated with ID: ', p_profile_lifestyle_id), 
        p_modified_user, 
        'PROFILE_LIFESTYLE_UPDATE', 
        CONCAT('ID: ', p_profile_lifestyle_id, ', Profile ID: ', current_profile_id),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success
    SELECT 
        'success' AS status,
        NULL AS error_type,
        p_profile_lifestyle_id AS id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
