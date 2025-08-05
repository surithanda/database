DELIMITER //
CREATE PROCEDURE `eb_profile_views_get_viewed_me`(
    IN p_profile_id INT,
    IN p_created_user VARCHAR(100)
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
            'ERROR', error_message, p_created_user, 'PROFILE_VIEWS_GET_VIEWED_ME', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_VIEWS_GET_VIEWED_ME', 
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
        SET error_code = '59008';
        SET error_message = 'Profile ID must be provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Get all profiles that viewed this profile with required information
    SELECT 
        pv.profile_view_id,
        pv.from_profile_id,
        pv.to_profile_id,
        pv.profile_view_date,
        pp.first_name,
        pp.last_name,
        TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) AS age,
        lt.name AS country,
        'success' AS status,
        NULL AS error_type,
        NULL AS error_code,
        NULL AS error_message
    FROM profile_views pv
    INNER JOIN profile_personal pp ON pv.from_profile_id = pp.profile_id
    LEFT JOIN profile_address pa ON pp.profile_id = pa.profile_id
    LEFT JOIN lookup_table lt ON pa.country_id = lt.id AND lt.category = 'Country'
    WHERE pv.to_profile_id = p_profile_id
    GROUP BY pv.from_profile_id  -- To avoid duplicate profiles if multiple views or addresses
    ORDER BY pv.profile_view_date DESC;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful read
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'READ', 
        CONCAT('Profiles that viewed profile ID: ', p_profile_id),
        p_created_user, 
        'PROFILE_VIEWS_GET_VIEWED_ME', 
        CONCAT('Profile ID: ', p_profile_id),
        start_time, end_time, execution_time
    );
    
END //
DELIMITER ;
