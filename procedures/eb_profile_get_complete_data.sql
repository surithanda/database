DELIMITER //
CREATE PROCEDURE `eb_profile_get_complete_data`(
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
    
    -- Declare variables for metrics
    DECLARE address_count INT DEFAULT 0;
    DECLARE contact_count INT DEFAULT 0;
    DECLARE education_count INT DEFAULT 0;
    DECLARE employment_count INT DEFAULT 0;
    DECLARE profiles_viewed_by_me_count INT DEFAULT 0;
    DECLARE profiles_viewed_me_count INT DEFAULT 0;
    
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
            'ERROR', error_message, p_created_user, 'PROFILE_GET_COMPLETE_DATA', 
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
            'ERROR', error_message, p_created_user, 'PROFILE_GET_COMPLETE_DATA', 
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
        SET error_code = '59009';
        SET error_message = 'Profile ID must be provided.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Get count of addresses
    SELECT COUNT(*) INTO address_count
    FROM profile_address
    WHERE profile_id = p_profile_id;
    
    -- Get count of contacts
    SELECT COUNT(*) INTO contact_count
    FROM profile_contact
    WHERE profile_id = p_profile_id;
    
    -- Get count of education entries
    SELECT COUNT(*) INTO education_count
    FROM profile_education
    WHERE profile_id = p_profile_id;
    
    -- Get count of employment entries
    SELECT COUNT(*) INTO employment_count
    FROM profile_employment
    WHERE profile_id = p_profile_id;
    
    -- Get count of profiles viewed by me
    SELECT COUNT(DISTINCT to_profile_id) INTO profiles_viewed_by_me_count
    FROM profile_views
    WHERE from_profile_id = p_profile_id;
    
    -- Get count of profiles that viewed me
    SELECT COUNT(DISTINCT from_profile_id) INTO profiles_viewed_me_count
    FROM profile_views
    WHERE to_profile_id = p_profile_id;
    
    -- Get complete profile data with all metrics
    SELECT 
        pp.profile_id,
        pp.account_id,
        pp.first_name,
        pp.last_name,
        pp.middle_name,
        pp.prefix,
        pp.suffix,
        pp.gender,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.gender AND lt.category = 'Gender') AS gender_text,
        pp.birth_date,
        TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) AS age,
        pp.phone_mobile,
        pp.phone_home,
        pp.phone_emergency,
        pp.email_id,
        pp.marital_status,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.marital_status AND lt.category = 'Marital Status') AS marital_status_text,
        pp.religion,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.religion AND lt.category = 'Religion') AS religion_text,
        pp.nationality,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.nationality AND lt.category = 'Nationality') AS nationality_text,
        pp.caste,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.caste AND lt.category = 'Caste') AS caste_text,
        pp.height_inches,
        pp.height_cms,
        pp.weight,
        pp.weight_units,
        pp.complexion,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.complexion AND lt.category = 'Complexion') AS complexion_text,
        pp.linkedin,
        pp.facebook,
        pp.instagram,
        pp.whatsapp_number,
        pp.profession,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.profession AND lt.category = 'Profession') AS profession_text,
        pp.disability,
        (SELECT lt.name FROM lookup_table lt WHERE lt.id = pp.disability AND lt.category = 'Disability') AS disability_text,
        pp.created_user,
        pp.created_date,
        pp.updated_date,
        pp.is_active,
        -- Metrics
        address_count AS number_of_addresses,
        contact_count AS number_of_contacts,
        education_count AS number_of_education_entries,
        employment_count AS number_of_employment_entries,
        profiles_viewed_by_me_count AS profiles_viewed_by_me,
        profiles_viewed_me_count AS profiles_viewed_me,
        -- Additional profile information
        (SELECT GROUP_CONCAT(DISTINCT c.country_name SEPARATOR ', ')
         FROM profile_address pa
         JOIN country c ON pa.country_id = c.country_id
         WHERE pa.profile_id = pp.profile_id) AS countries,
        (SELECT GROUP_CONCAT(DISTINCT s.state_name SEPARATOR ', ')
         FROM profile_address pa
         JOIN state s ON pa.state = s.state_id
         WHERE pa.profile_id = pp.profile_id) AS states,
        (SELECT GROUP_CONCAT(DISTINCT pe.institution_name SEPARATOR ', ')
         FROM profile_education pe
         WHERE pe.profile_id = pp.profile_id) AS education_institutions,
        (SELECT GROUP_CONCAT(DISTINCT pe.institution_name SEPARATOR ', ')
         FROM profile_employment pe
         WHERE pe.profile_id = pp.profile_id) AS employment_institutions,
        -- Additional lookup values for address types
        (SELECT GROUP_CONCAT(DISTINCT lt.name SEPARATOR ', ')
         FROM profile_address pa
         JOIN lookup_table lt ON pa.address_type = lt.id AND lt.category = 'Address Type'
         WHERE pa.profile_id = pp.profile_id) AS address_types,
        -- Additional lookup values for contact types
        (SELECT GROUP_CONCAT(DISTINCT lt.name SEPARATOR ', ')
         FROM profile_contact pc
         JOIN lookup_table lt ON pc.contact_type = lt.id AND lt.category = 'Contact_type'
         WHERE pc.profile_id = pp.profile_id) AS contact_types,
        -- Additional lookup values for education levels
        (SELECT GROUP_CONCAT(DISTINCT lt.name SEPARATOR ', ')
         FROM profile_education pe
         JOIN lookup_table lt ON pe.education_level = lt.id AND lt.category = 'Education_level'
         WHERE pe.profile_id = pp.profile_id) AS education_levels,
        -- Additional lookup values for field of study
        (SELECT GROUP_CONCAT(DISTINCT lt.name SEPARATOR ', ')
         FROM profile_education pe
         JOIN lookup_table lt ON pe.field_of_study = lt.id AND lt.category = 'Field_of_study'
         WHERE pe.profile_id = pp.profile_id) AS fields_of_study,
        -- Additional lookup values for job titles
        (SELECT GROUP_CONCAT(DISTINCT lt.name SEPARATOR ', ')
         FROM profile_employment pe
         JOIN lookup_table lt ON pe.job_title_id = lt.id AND lt.category = 'JobTitle'
         WHERE pe.profile_id = pp.profile_id) AS job_titles,
        'success' AS status,
        NULL AS error_type,
        NULL AS error_code,
        NULL AS error_message
    FROM profile_personal pp
    WHERE pp.profile_id = p_profile_id;
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful read
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'READ', 
        CONCAT('Complete profile data retrieved for profile ID: ', p_profile_id),
        p_created_user, 
        'PROFILE_GET_COMPLETE_DATA', 
        CONCAT('Profile ID: ', p_profile_id),
        start_time, end_time, execution_time
    );
    
END //
DELIMITER ;
