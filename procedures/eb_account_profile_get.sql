DELIMITER //
CREATE PROCEDURE `eb_account_profile_get`(
    IN p_account_id INT,
    IN p_email VARCHAR(100),
    IN p_username VARCHAR(45),
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
            'ERROR', error_message, p_created_user, 'ACCOUNT_PROFILE_GET', 
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
            'ERROR', error_message, p_created_user, 'ACCOUNT_PROFILE_GET', 
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
    
    -- Validation: Ensure at least one search parameter is provided
    IF p_account_id IS NULL AND p_email IS NULL AND p_username IS NULL THEN
        SET error_code = '47001';
        SET error_message = 'At least one search parameter (account_id, email, or username) must be provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Query based on the provided parameters
    SELECT 
        a.*,                                  -- All account fields
        l.login_id,                           -- Login information
        l.user_name,
        l.is_active AS login_is_active,
        l.active_date AS login_active_date,
        l.created_date AS login_created_date,
        l.modified_date AS login_modified_date,
        l.deactivation_date AS login_deactivation_date,
        pp.profile_id,                        -- Profile personal information
        pp.gender AS profile_gender,
        pp.birth_date AS profile_birth_date,
        pp.phone_mobile AS profile_phone_mobile,
        pp.phone_home AS profile_phone_home,
        pp.phone_emergency AS profile_phone_emergency,
        pp.email_id AS profile_email,
        pp.marital_status,
        pp.religion,
        pp.nationality,
        pp.caste,
        pp.height_inches,
        pp.height_cms,
        pp.weight,
        pp.weight_units,
        pp.complexion,
        pp.linkedin,
        pp.facebook,
        pp.instagram,
        pp.whatsapp_number,
        pp.profession,
        pp.disability,
        photo.url,
        pp.is_active AS profile_is_active,
        'success' AS status,
        NULL AS error_type,
        NULL AS error_code,
        NULL AS error_message
    FROM 
        account a
    LEFT JOIN 
        login l ON a.account_id = l.account_id
    LEFT JOIN 
        profile_personal pp ON a.account_id = pp.account_id
	LEFT JOIN 
		(SELECT profile_id, photo_type, url FROM profile_photo INNER JOIN lookup_table on photo_type = id where name ='Clear Headshot') photo  ON pp.profile_id = photo.profile_id
    WHERE 
        (p_account_id IS NULL OR a.account_id = p_account_id)
        AND (p_email IS NULL OR a.email = p_email)
        AND (p_username IS NULL OR l.user_name = p_username)
        AND (pp.is_active = 1 OR pp.is_active IS NULL);
    
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
            WHEN p_account_id IS NOT NULL THEN CONCAT('Account profile retrieved by ID: ', p_account_id)
            WHEN p_email IS NOT NULL THEN CONCAT('Account profile retrieved by email: ', p_email)
            ELSE CONCAT('Account profile retrieved by username: ', p_username)
        END, 
        p_created_user, 
        'ACCOUNT_PROFILE_GET', 
        CONCAT(
            IFNULL(CONCAT('Account ID: ', p_account_id), ''),
            IFNULL(CONCAT(', Email: ', p_email), ''),
            IFNULL(CONCAT(', Username: ', p_username), '')
        ),
        start_time, end_time, execution_time
    );
    
END 
//
DELIMITER ;