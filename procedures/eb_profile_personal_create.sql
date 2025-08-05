
DELIMITER //
CCREATE DEFINER=`admin-test`@`%` PROCEDURE `eb_profile_personal_create`(
    accountid int,
    first_name varchar(45),
    last_name varchar(45),
    middle_name varchar(45),
    prefix varchar(45),
    suffix varchar(45),
    gender int,
    birth_date date,
    phone_mobile varchar(15),
    phone_home varchar(15),
    phone_emergency varchar(15),
    email_id varchar(150),
    marital_status int, 
    religion int, 
    nationality int, 
    caste int, 
    height_inches int, 
    height_cms int,
    weight int, 
    weight_units varchar(4), 
    complexion int, 
    linkedin varchar(450), 
    facebook varchar(450), 
    instagram varchar(450), 
    whatsapp_number varchar(15), 
    profession int, 
    disability int,
    created_user varchar(45)
)
BEGIN
    -- Declare variables for error handling
    DECLARE age INT;
    DECLARE duplicate_profile INT DEFAULT 0;
    DECLARE duplicate_email INT DEFAULT 0;
    DECLARE duplicate_phone INT DEFAULT 0;
    DECLARE account_exists INT DEFAULT 0;
    DECLARE error_msg VARCHAR(1000);
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE new_profile_id INT;
    
    -- Declare handler for SQL exceptions 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
            error_message = MESSAGE_TEXT,
            error_code = MYSQL_ERRNO;
        SELECT 
            'fail' AS status,
            'SQL Exception' as error_type,
            null AS profile_id,
            error_code,
            error_message;
    END;
    
    -- Declare handler for custom errors (SQLSTATE starting with '45')
    DECLARE EXIT HANDLER FOR SQLSTATE '45000'
    BEGIN
        ROLLBACK;
        -- Return error information
        SELECT 
            'fail' AS status,
            'Validation Exception' as error_type,
            null AS profile_id,
            error_code,
            error_message;
    END;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Validation: Ensure accountid is a valid positive integer
    IF accountid <= 0 THEN
        SET error_code = '46001_INVALID_ACCOUNTID';
        SET error_message = 'Invalid accountid. It must be a positive integer.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Validation: Ensure essential fields are not NULL or empty
    IF first_name IS NULL OR TRIM(first_name) = '' THEN
        SET error_code = '46002_MISSING_FIRST_NAME';
        SET error_message = 'First name cannot be empty.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    IF last_name IS NULL OR TRIM(last_name) = '' THEN
        SET error_code = '46003_MISSING_LAST_NAME';
        SET error_message = 'Last name cannot be empty.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    IF gender NOT IN (SELECT id FROM lookup_table WHERE category = 'Gender' ) THEN
        SET error_code = '46004_INVALID_GENDER';
        SET error_message = 'Invalid gender. Please provide a valid gender (1 for Male, 2 for Female).';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    IF birth_date IS NULL THEN
        SET error_code = '46005_MISSING_BIRTH_DATE';
        SET error_message = 'Date of birth is required.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

     -- Check for duplicate profile
    SELECT COUNT(*) INTO duplicate_profile 
    FROM profile_personal p
    WHERE p.last_name = last_name 
    AND p.first_name = first_name 
    AND p.birth_date = birth_date;
    
    IF duplicate_profile > 0 THEN
        SET error_code = '46006_DUPLICATE_PROFILE';
        SET error_message = CONCAT('Profile with First Name: ', first_name, 
                          ', Last Name: ', last_name, 
                          ' and DOB: ', birth_date, 
                          ' already exists.');
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Check for duplicate email
    IF email_id IS NOT NULL THEN
        SELECT COUNT(*) INTO duplicate_email 
        FROM profile_personal p
        WHERE p.email_id = email_id;
        
        IF duplicate_email > 0 THEN
            SET error_code = '46007_DUPLICATE_EMAIL';
            SET error_message = CONCAT('Profile with email: ', email_id, ' already exists.');
            SET custom_error = TRUE;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    END IF;

    IF EXISTS (SELECT 1 FROM account a WHERE a.account_id = accountid AND is_active != 1) THEN
        SET error_code = '46017_ACCOUNT_IS_NOT_ACTIVE';
        SET error_message = 'This account is not active. Please contact administrator to enable your account.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;


    -- Check for duplicate phone
    IF phone_mobile IS NOT NULL THEN
        SELECT COUNT(*) INTO duplicate_phone 
        FROM profile_personal p
        WHERE p.phone_mobile = phone_mobile;
        
        IF duplicate_phone > 0 THEN
            SET error_code = '46008_DUPLICATE_PHONE';
            SET error_message = CONCAT('Profile with mobile phone: ', phone_mobile, ' already exists.');
            SET custom_error = TRUE;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;
    END IF;


    -- Age validation
    SET age = TIMESTAMPDIFF(YEAR, birth_date, CURDATE());
    IF age < 21 OR age > 85 THEN
        SET error_code = '46009_INVALID_AGE';
        SET error_message = CONCAT('Age should be between 21 and 85. Provided age is ', age, ' years.');
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Check if account exists
    SELECT COUNT(*) INTO account_exists 
    FROM account 
    WHERE account_id = accountid;
    
    IF account_exists = 0 THEN
        SET error_code = '46010_INVALID_ACCOUNT';
        SET error_message = 'Invalid Account ID. The account does not exist.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Validate phone number formats
    IF phone_mobile IS NOT NULL AND LENGTH(phone_mobile) < 10 THEN
        SET error_code = '46011_INVALID_MOBILE';
        SET error_message = 'Invalid mobile phone number. It should contain at least 10 digits.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    IF phone_home IS NOT NULL AND LENGTH(phone_home) < 10 THEN
        SET error_code = '46012_INVALID_HOME_PHONE';
        SET error_message = 'Invalid home phone number. It should contain at least 10 digits.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    IF phone_emergency IS NOT NULL AND LENGTH(phone_emergency) < 10 THEN
        SET error_code = '46013_INVALID_EMERGENCY_PHONE';
        SET error_message = 'Invalid emergency phone number. It should contain at least 10 digits.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Validate email format
    IF email_id IS NOT NULL AND email_id NOT LIKE '%_@__%.__%' THEN
        SET error_code = '46014_INVALID_EMAIL';
        SET error_message = 'Invalid email format.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Validate height and weight
    IF height_inches <= 0  THEN
        SET error_code = '46015_INVALID_HEIGHT';
        SET error_message = 'Invalid height. Height must be greater than 0.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    IF weight <= 0 THEN
        SET error_code = '46016_INVALID_WEIGHT';
        SET error_message = 'Invalid weight. Weight must be greater than 0.';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;

    -- Insert the profile
    INSERT INTO profile_personal (
        account_id,
        first_name,
        last_name,
        middle_name,
        prefix,
        suffix,
        gender,
        birth_date,
        phone_mobile,
        phone_home,
        phone_emergency,
        email_id,
        marital_status, 
        religion, 
        nationality, 
        caste, 
        height_inches, 
        height_cms,
        weight, 
        weight_units, 
        complexion, 
        linkedin, 
        facebook, 
        instagram, 
        whatsapp_number, 
        profession, 
        disability,
        is_active, 
        created_date, 
        created_user 
    ) VALUES (
        accountid,
        first_name,
        last_name,
        middle_name,
        prefix,
        suffix,
        gender,
        birth_date,
        phone_mobile,
        phone_home,
        phone_emergency,
        email_id,
        marital_status, 
        religion, 
        nationality, 
        caste, 
        height_inches, 
        height_cms,
        weight, 
        weight_units, 
        complexion, 
        linkedin, 
        facebook, 
        instagram, 
        whatsapp_number, 
        profession, 
        disability,
        1, 
        NOW(), 
        created_user
    );
    
    -- Get the newly inserted profile ID
    SET new_profile_id = LAST_INSERT_ID();
    
    -- If we got here, everything succeeded, so commit
    COMMIT;
    
    -- Return success results
    SELECT 
        'success' AS status,
        NULL as error_type,
        new_profile_id AS profile_id,
        NULL as error_code,
        NULL as error_message;
END //
DELIMITER ;