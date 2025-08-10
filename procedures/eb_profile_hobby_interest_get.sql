DELIMITER //
CREATE PROCEDURE `eb_profile_hobby_interest_get`(
    IN p_profile_id INT,
    IN p_category VARCHAR(45), -- 'hobby' or 'interest'
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE start_time DATETIME;
    DECLARE end_time DATETIME;
    DECLARE execution_time INT;
    
    -- Declare handler for SQL exceptions
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            error_message = MESSAGE_TEXT,
            error_code = MYSQL_ERRNO;
        
        -- Log error to activity_log
        INSERT INTO activity_log (
            log_type, message, created_by, activity_type, activity_details,
            start_time, end_time, execution_time
        ) VALUES (
            'ERROR', error_message, p_created_user, 'PROFILE_HOBBY_INTEREST_GET', 
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
        -- Log error to activity_log
        INSERT INTO activity_log (
            log_type, message, created_by, activity_type, activity_details,
            start_time, end_time, execution_time
        ) VALUES (
            'ERROR', error_message, p_created_user, 'PROFILE_HOBBY_INTEREST_GET', 
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
    
    -- Validation: Ensure profile_id is provided
    IF p_profile_id IS NULL THEN
        SET error_code = '52005';
        SET error_message = 'Profile ID must be provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validation: Ensure category is provided
    IF p_category IS NULL OR (p_category != 'hobby' AND p_category != 'interest') THEN
        SET error_code = '52006';
        SET error_message = 'Category must be either "hobby" or "interest".';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Get all records for a profile matching the specified category
    SELECT 
        phi.*,
        hi.name AS hobby_interest_name,
        hi.description AS hobby_interest_description,
        'success' AS status,
        NULL AS error_type,
        NULL AS error_code,
        NULL AS error_message
    FROM profile_hobby_interest phi
    INNER JOIN lookup_table hi ON phi.hobby_interest_id = hi.id AND hi.category = p_category
    WHERE phi.profile_id = p_profile_id
    AND (phi.isverified != -1 OR phi.isverified IS NULL); -- Exclude soft-deleted records
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful read
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'READ', 
        CONCAT(p_category, 's retrieved for profile ID: ', p_profile_id),
        p_created_user, 
        'PROFILE_HOBBY_INTEREST_GET', 
        CONCAT('Profile ID: ', p_profile_id, ', Category: ', p_category),
        start_time, end_time, execution_time
    );
    
END //
DELIMITER ;
