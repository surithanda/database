DELIMITER //
CREATE PROCEDURE `eb_profile_views_get`(
    IN p_profile_id INT,
    IN p_viewed_profile_id INT,
    IN p_id INT,
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
            'ERROR', error_message, p_created_user, 'PROFILE_VIEWS_GET', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_VIEWS_GET', 
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
    
    -- Validation: Ensure at least one parameter is provided
    IF p_profile_id IS NULL AND p_viewed_profile_id IS NULL AND p_id IS NULL THEN
        SET error_code = '59006';
        SET error_message = 'At least one of profile_id, viewed_profile_id, or id must be provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Query based on the provided parameters
    IF p_id IS NOT NULL THEN
        -- Get specific view by ID
        SELECT 
            pv.*,
            pp.first_name AS viewed_first_name, 
            pp.last_name AS viewed_last_name,
            pp.gender AS viewed_gender,
            pp.date_of_birth AS viewed_date_of_birth,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_views pv
        LEFT JOIN profile_personal pp ON pv.viewed_profile_id = pp.profile_id
        WHERE pv.id = p_id
        AND (pv.isverified != -1 OR pv.isverified IS NULL); -- Exclude soft-deleted records
        
    ELSEIF p_profile_id IS NOT NULL AND p_viewed_profile_id IS NOT NULL THEN
        -- Get views where a specific profile viewed another specific profile
        SELECT 
            pv.*,
            pp.first_name AS viewed_first_name, 
            pp.last_name AS viewed_last_name,
            pp.gender AS viewed_gender,
            pp.date_of_birth AS viewed_date_of_birth,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_views pv
        LEFT JOIN profile_personal pp ON pv.viewed_profile_id = pp.profile_id
        WHERE pv.profile_id = p_profile_id
        AND pv.viewed_profile_id = p_viewed_profile_id
        AND (pv.isverified != -1 OR pv.isverified IS NULL) -- Exclude soft-deleted records
        ORDER BY pv.view_date DESC;
        
    ELSEIF p_profile_id IS NOT NULL THEN
        -- Get all profiles viewed by this profile
        SELECT 
            pv.*,
            pp.first_name AS viewed_first_name, 
            pp.last_name AS viewed_last_name,
            pp.gender AS viewed_gender,
            pp.date_of_birth AS viewed_date_of_birth,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_views pv
        LEFT JOIN profile_personal pp ON pv.viewed_profile_id = pp.profile_id
        WHERE pv.profile_id = p_profile_id
        AND (pv.isverified != -1 OR pv.isverified IS NULL) -- Exclude soft-deleted records
        ORDER BY pv.view_date DESC;
        
    ELSEIF p_viewed_profile_id IS NOT NULL THEN
        -- Get all profiles that viewed this profile
        SELECT 
            pv.*,
            pp.first_name AS viewer_first_name, 
            pp.last_name AS viewer_last_name,
            pp.gender AS viewer_gender,
            pp.date_of_birth AS viewer_date_of_birth,
            'success' AS status,
            NULL AS error_type,
            NULL AS error_code,
            NULL AS error_message
        FROM profile_views pv
        LEFT JOIN profile_personal pp ON pv.profile_id = pp.profile_id
        WHERE pv.viewed_profile_id = p_viewed_profile_id
        AND (pv.isverified != -1 OR pv.isverified IS NULL) -- Exclude soft-deleted records
        ORDER BY pv.view_date DESC;
    END IF;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful read
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'READ', 
        CASE 
            WHEN p_id IS NOT NULL THEN CONCAT('Profile view retrieved by ID: ', p_id)
            WHEN p_profile_id IS NOT NULL AND p_viewed_profile_id IS NOT NULL THEN 
                CONCAT('Profile views retrieved for profile ID: ', p_profile_id, ' viewing profile ID: ', p_viewed_profile_id)
            WHEN p_profile_id IS NOT NULL THEN CONCAT('Profile views retrieved for profile ID: ', p_profile_id)
            ELSE CONCAT('Profile views retrieved for viewed profile ID: ', p_viewed_profile_id)
        END, 
        p_created_user, 
        'PROFILE_VIEWS_GET', 
        CASE 
            WHEN p_id IS NOT NULL THEN CONCAT('ID: ', p_id)
            WHEN p_profile_id IS NOT NULL AND p_viewed_profile_id IS NOT NULL THEN 
                CONCAT('Profile ID: ', p_profile_id, ', Viewed Profile ID: ', p_viewed_profile_id)
            WHEN p_profile_id IS NOT NULL THEN CONCAT('Profile ID: ', p_profile_id)
            ELSE CONCAT('Viewed Profile ID: ', p_viewed_profile_id)
        END,
        start_time, end_time, execution_time
    );
    
END //
DELIMITER ;
