DELIMITER //
CREATE PROCEDURE `eb_registered_partner_create`(
    IN p_business_name VARCHAR(155),
    IN p_alias VARCHAR(45),
    IN p_business_email VARCHAR(155),
    IN p_primary_phone VARCHAR(10),
    IN p_primary_phone_country_code INT,
    IN p_secondary_phone VARCHAR(10),
    IN p_address_line1 VARCHAR(150),
    IN p_city VARCHAR(45),
    IN p_state INT,
    IN p_country INT,
    IN p_zip VARCHAR(8),
    IN p_business_registration_number VARCHAR(155),
    IN p_business_ITIN VARCHAR(155),
    IN p_business_description VARCHAR(255),
    IN p_primary_contact_first_name VARCHAR(45),
    IN p_primary_contact_last_name VARCHAR(45),
    IN p_primary_contact_gender INT,
    IN p_primary_contact_date_of_birth DATE,
    IN p_primary_contact_email VARCHAR(45),
    IN p_business_linkedin VARCHAR(155),
    IN p_business_website VARCHAR(155),
    IN p_business_facebook VARCHAR(155),
    IN p_business_whatsapp VARCHAR(155),
    IN p_domain_root_url VARCHAR(255),
    IN p_created_user VARCHAR(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_partner_id INT;
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
            'ERROR', error_message, p_created_user, 'REGISTERED_PARTNER_CREATE', 
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
            'ERROR', error_message, p_created_user, 'REGISTERED_PARTNER_CREATE', 
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
    
    -- Validation: Required fields
    -- Validate business_name
    IF p_business_name IS NULL OR TRIM(p_business_name) = '' THEN
        SET error_code = '48001';
        SET error_message = 'Business name is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate alias
    IF p_alias IS NULL OR TRIM(p_alias) = '' THEN
        SET error_code = '48002';
        SET error_message = 'Alias is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate primary_phone
    IF p_primary_phone IS NULL OR TRIM(p_primary_phone) = '' THEN
        SET error_code = '48003';
        SET error_message = 'Primary phone is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate primary_phone_country_code
    IF p_primary_phone_country_code IS NULL OR p_primary_phone_country_code <= 0 THEN
        SET error_code = '48004';
        SET error_message = 'Primary phone country code is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate address_line1
    IF p_address_line1 IS NULL OR TRIM(p_address_line1) = '' THEN
        SET error_code = '48005';
        SET error_message = 'Address line 1 is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate state
    IF p_state IS NULL OR p_state <= 0 THEN
        SET error_code = '48006';
        SET error_message = 'State is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate country
    IF p_country IS NULL OR p_country <= 0 THEN
        SET error_code = '48007';
        SET error_message = 'Country is required and must be valid.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate zip
    IF p_zip IS NULL OR TRIM(p_zip) = '' THEN
        SET error_code = '48008';
        SET error_message = 'ZIP code is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate business_registration_number
    IF p_business_registration_number IS NULL OR TRIM(p_business_registration_number) = '' THEN
        SET error_code = '48009';
        SET error_message = 'Business registration number is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate business_ITIN
    IF p_business_ITIN IS NULL OR TRIM(p_business_ITIN) = '' THEN
        SET error_code = '48010';
        SET error_message = 'Business ITIN is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate business_description
    IF p_business_description IS NULL OR TRIM(p_business_description) = '' THEN
        SET error_code = '48011';
        SET error_message = 'Business description is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate primary_contact_first_name
    IF p_primary_contact_first_name IS NULL OR TRIM(p_primary_contact_first_name) = '' THEN
        SET error_code = '48012';
        SET error_message = 'Primary contact first name is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate primary_contact_last_name
    IF p_primary_contact_last_name IS NULL OR TRIM(p_primary_contact_last_name) = '' THEN
        SET error_code = '48013';
        SET error_message = 'Primary contact last name is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Validate business_website
    IF p_business_website IS NULL OR TRIM(p_business_website) = '' THEN
        SET error_code = '48014';
        SET error_message = 'Business website is required.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Insert the new registered partner
    INSERT INTO registered_partner (
        business_name,
        alias,
        business_email,
        primary_phone,
        primary_phone_country_code,
        secondary_phone,
        address_line1,
        city,
        state,
        country,
        zip,
        business_registration_number,
        business_ITIN,
        business_description,
        primary_contact_first_name,
        primary_contact_last_name,
        primary_contact_gender,
        primary_contact_date_of_birth,
        primary_contact_email,
        business_linkedin,
        business_website,
        business_facebook,
        business_whatsapp,
        date_created,
        user_created,
        date_modified,
        user_modified,
        isverified,
        Is_active,
        domain_root_url
    ) VALUES (
        p_business_name,
        p_alias,
        p_business_email,
        p_primary_phone,
        p_primary_phone_country_code,
        p_secondary_phone,
        p_address_line1,
        p_city,
        p_state,
        p_country,
        p_zip,
        p_business_registration_number,
        p_business_ITIN,
        p_business_description,
        p_primary_contact_first_name,
        p_primary_contact_last_name,
        p_primary_contact_gender,
        p_primary_contact_date_of_birth,
        p_primary_contact_email,
        p_business_linkedin,
        p_business_website,
        p_business_facebook,
        p_business_whatsapp,
        NOW(),
        p_created_user,
        NOW(),
        p_created_user,
        0, -- Not verified by default
        b'0', -- Not active by default
        p_domain_root_url
    );
    
    -- Get the new partner ID
    SET new_partner_id = LAST_INSERT_ID();
    
    -- Record end time and calculate execution time
    SET end_time = NOW();
    SET execution_time = TIMESTAMPDIFF(MICROSECOND, start_time, end_time) / 1000; -- Convert to milliseconds
    
    -- Log the successful creation
    INSERT INTO activity_log (
        log_type, message, created_by, activity_type, activity_details,
        start_time, end_time, execution_time
    ) VALUES (
        'CREATE', 
        CONCAT('Registered partner created with ID: ', new_partner_id), 
        p_created_user, 
        'REGISTERED_PARTNER_CREATE', 
        CONCAT('Business Name: ', p_business_name),
        start_time, end_time, execution_time
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Return success with the new partner ID
    SELECT 
        'success' AS status,
        NULL AS error_type,
        new_partner_id AS reg_partner_id,
        NULL AS error_code,
        NULL AS error_message;
    
END //
DELIMITER ;
