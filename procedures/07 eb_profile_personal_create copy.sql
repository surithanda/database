
DELIMITER //
CREATE  PROCEDURE `eb_profile_personal_create`(
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
    DECLARE age INT;
    DECLARE duplicate_profile INT DEFAULT 0;
    DECLARE duplicate_email INT DEFAULT 0;
    DECLARE duplicate_phone INT DEFAULT 0;
    DECLARE account_exists INT DEFAULT 0;
    DECLARE error_msg VARCHAR(1000);
	DECLARE MESSAGE_TEXT VARCHAR(1000);
    DECLARE MYSQL_ERRNO INT DEFAULT 0;
    
    -- Validation: Ensure accountid is a valid positive integer
    IF accountid <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid accountid. It must be a positive integer.',
        MYSQL_ERRNO = 46001;
    END IF;

    -- Validation: Ensure essential fields are not NULL or empty
    IF first_name IS NULL OR TRIM(first_name) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'First name cannot be empty.',
        MYSQL_ERRNO = 46002;
    END IF;

    IF last_name IS NULL OR TRIM(last_name) = '' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Last name cannot be empty.',
        MYSQL_ERRNO = 46003;
    END IF;

    IF gender NOT IN (SELECT id FROM lookup_table WHERE category = 'Gender' ) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid gender. Please provide a valid gender (1 for Male, 2 for Female).',
        MYSQL_ERRNO = 46004;
    END IF;
    
    IF birth_date IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Date of birth is required.',
        MYSQL_ERRNO = 46005;
    END IF;

    -- Check for duplicate profile
    SELECT COUNT(*) INTO duplicate_profile 
    FROM profile_personal 
    WHERE last_name = last_name 
    AND first_name = first_name 
    AND birth_date = birth_date;
    
    IF duplicate_profile > 0 THEN
        SET error_msg = CONCAT('Profile with First Name: ', first_name, 
                          ', Last Name: ', last_name, 
                          ' and DOB: ', birth_date, 
                          ' already exists.');
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = error_msg,
        MYSQL_ERRNO = 46006;
    END IF;

    -- Check for duplicate email
    IF email_id IS NOT NULL THEN
        SELECT COUNT(*) INTO duplicate_email 
        FROM profile_personal 
        WHERE email_id = email_id;
        
        IF duplicate_email > 0 THEN
			SET error_msg = CONCAT('Profile with email: ', email_id, ' already exists.');
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = error_msg,
            MYSQL_ERRNO = 46007;
        END IF;
    END IF;

    -- Check for duplicate phone
    IF phone_mobile IS NOT NULL THEN
        SELECT COUNT(*) INTO duplicate_phone 
        FROM profile_personal 
        WHERE phone_mobile = phone_mobile;
        
        IF duplicate_phone > 0 THEN
			SET error_msg = CONCAT('Profile with mobile phone: ', phone_mobile, ' already exists.');
            SIGNAL SQLSTATE '45000' ;
            SET MESSAGE_TEXT = error_msg,
            MYSQL_ERRNO = 46008;
        END IF;
    END IF;

    -- Age validation
    SET age = TIMESTAMPDIFF(YEAR, birth_date, CURDATE());
    IF age < 21 OR age > 85 THEN
		set error_msg = CONCAT('Age should be between 21 and 85. Provided age is ', age, ' years.');
        SIGNAL SQLSTATE '45000' ;
        SET MESSAGE_TEXT = error_msg,
        MYSQL_ERRNO = 46009;
    END IF;

    -- Check if account exists
    SELECT COUNT(*) INTO account_exists 
    FROM account 
    WHERE account_id = accountid;
    
    IF account_exists = 0 THEN
        SIGNAL SQLSTATE '45000' ;
        SET MESSAGE_TEXT = 'Invalid Account ID. The account does not exist.',
        MYSQL_ERRNO = 46010;
    END IF;

    -- Validate phone number formats
    IF phone_mobile IS NOT NULL AND LENGTH(phone_mobile) < 10 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid mobile phone number. It should contain at least 10 digits.',
        MYSQL_ERRNO = 46011;
    END IF;

    IF phone_home IS NOT NULL AND LENGTH(phone_home) < 10 THEN
        SIGNAL SQLSTATE '45000' ;
        SET MESSAGE_TEXT = 'Invalid home phone number. It should contain at least 10 digits.',
        MYSQL_ERRNO = 46012;
    END IF;

    IF phone_emergency IS NOT NULL AND LENGTH(phone_emergency) < 10 THEN
        SIGNAL SQLSTATE '45000' ;
        SET MESSAGE_TEXT = 'Invalid emergency phone number. It should contain at least 10 digits.',
        MYSQL_ERRNO = 46013;
    END IF;

    -- Validate email format
    IF email_id IS NOT NULL AND email_id NOT LIKE '%_@__%.__%' THEN
        SIGNAL SQLSTATE '45000' ;
        SET MESSAGE_TEXT = 'Invalid email format.',
        MYSQL_ERRNO = 46014;
    END IF;

    -- Validate height and weight
    IF height_inches <= 0 OR height_cms <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid height. Height must be greater than 0.',
        MYSQL_ERRNO = 46015;
    END IF;

    IF weight <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid weight. Weight must be greater than 0.',
        MYSQL_ERRNO = 46016;
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
    
    SELECT LAST_INSERT_ID() AS profile_id;
END //
DELIMITER ;