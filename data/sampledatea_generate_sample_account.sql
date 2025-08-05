DELIMITER //

CREATE PROCEDURE `sampledata_generate_sample_account`()
BEGIN
    -- Declare variables for account_login_create procedure parameters
    DECLARE v_email VARCHAR(150);
    DECLARE v_user_pwd VARCHAR(150);
    DECLARE v_first_name VARCHAR(45);
    DECLARE v_middle_name VARCHAR(45);
    DECLARE v_last_name VARCHAR(45);
    DECLARE v_birth_date DATE;
    DECLARE v_gender INT;
    DECLARE v_primary_phone VARCHAR(10);
    DECLARE v_primary_phone_country VARCHAR(5);
    DECLARE v_primary_phone_type INT;
    DECLARE v_secondary_phone VARCHAR(10);
    DECLARE v_secondary_phone_country VARCHAR(5);
    DECLARE v_secondary_phone_type INT;
    DECLARE v_address_line1 VARCHAR(45);
    DECLARE v_address_line2 VARCHAR(45);
    DECLARE v_city VARCHAR(45);
    DECLARE v_state VARCHAR(45);
    DECLARE v_zip VARCHAR(45);
    DECLARE v_country VARCHAR(45);
    DECLARE v_photo VARCHAR(45);
    DECLARE v_secret_question VARCHAR(45);
    DECLARE v_secret_answer VARCHAR(45);
    DECLARE v_country_id INT;
    DECLARE v_created_account_id INT;
    DECLARE v_status VARCHAR(50);
    
    -- Generate random data for account_login_create procedure
    SET v_first_name = ELT(FLOOR(1 + RAND() * 10), 'John', 'Jane', 'Peter', 'Mary', 'David', 'Sarah', 'Michael', 'Emily', 'Robert', 'Lisa');
    SET v_last_name = ELT(FLOOR(1 + RAND() * 10), 'Smith', 'Jones', 'Williams', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson');
    SET v_email = CONCAT(LOWER(v_first_name), '.', LOWER(v_last_name), '_', FLOOR(RAND() * 10000), '@example.com');
    SET v_user_pwd = CONCAT('Pass', FLOOR(1000 + RAND() * 9000));
    SET v_middle_name = ELT(FLOOR(1 + RAND() * 5), 'A', 'B', 'C', 'D', 'E');
    
    -- Generate birth date between 20 and 60 years ago
    SET v_birth_date = DATE_SUB(CURDATE(), INTERVAL (20 + FLOOR(RAND() * 40)) YEAR);
    
    -- Get random gender from lookup table
    SELECT id INTO v_gender FROM lookup_table WHERE category = 'Gender' ORDER BY RAND() LIMIT 1;
    
    -- Generate random phone numbers
    SET v_primary_phone = LPAD(FLOOR(RAND() * 10000000000), 10, '0');
    SET v_primary_phone_country = '+1';
    SELECT id INTO v_primary_phone_type FROM lookup_table WHERE category = 'phone_type' ORDER BY RAND() LIMIT 1;
    
    -- Secondary phone is optional, 30% chance of being NULL
    IF RAND() > 0.3 THEN
        SET v_secondary_phone = LPAD(FLOOR(RAND() * 10000000000), 10, '0');
        SET v_secondary_phone_country = '+1';
        SELECT id INTO v_secondary_phone_type FROM lookup_table WHERE category = 'phone_type' ORDER BY RAND() LIMIT 1;
    ELSE
        SET v_secondary_phone = NULL;
        SET v_secondary_phone_country = NULL;
        SET v_secondary_phone_type = NULL;
    END IF;
    
    -- Generate random address
    SET v_address_line1 = CONCAT(FLOOR(100 + RAND() * 9900), ' ', 
                               ELT(FLOOR(1 + RAND() * 5), 'Main St', 'Oak Ave', 'Maple Rd', 'Washington Blvd', 'Park Lane'));
    
    -- Address line 2 is optional, 50% chance of being NULL
    IF RAND() > 0.5 THEN
        SET v_address_line2 = CONCAT('Apt ', FLOOR(1 + RAND() * 500));
    ELSE
        SET v_address_line2 = NULL;
    END IF;
    
    -- Generate random city, zip
    SET v_city = ELT(FLOOR(1 + RAND() * 10), 'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 
                    'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose');
    SET v_zip = LPAD(FLOOR(RAND() * 100000), 5, '0');
    
     -- Select a random country from the countries table
    SELECT country_id, country_name INTO v_country_id, v_country 
    FROM country 
    WHERE is_active = TRUE and country_id = 1
    ORDER BY RAND() 
    LIMIT 1;
    
    -- Select a random state from the state table that matches the selected country
    SELECT state_id INTO v_state 
    FROM state 
    WHERE country_id = 1 AND is_active = TRUE 
    ORDER BY RAND() 
    LIMIT 1;    
    -- Photo is optional, 70% chance of having one
    IF RAND() > 0.3 THEN
        SET v_photo = CONCAT('/photos/user_', FLOOR(RAND() * 1000), '.jpg');
    ELSE
        SET v_photo = NULL;
    END IF;
    
    -- Generate security question and answer
    SET v_secret_question = ELT(FLOOR(1 + RAND() * 5), 
                              'What is your favorite color?', 
                              'What was your first pet\'s name?', 
                              'What city were you born in?', 
                              'What is your mother\'s maiden name?', 
                              'What was your first car?');
    
    SET v_secret_answer = ELT(FLOOR(1 + RAND() * 5), 'Blue', 'Fluffy', 'Chicago', 'Smith', 'Toyota');
    
    
    -- Call the account_login_create procedure with generated data
    CALL eb_account_login_create(
        v_email, 
        v_user_pwd, 
        v_first_name, 
        v_middle_name, 
        v_last_name, 
        v_birth_date, 
        v_gender,
        v_primary_phone, 
        v_primary_phone_country, 
        v_primary_phone_type,
        v_secondary_phone, 
        v_secondary_phone_country, 
        v_secondary_phone_type,
        v_address_line1, 
        v_address_line2, 
        v_city, 
        v_state, 
        v_zip, 
        v_country,
        v_photo, 
        v_secret_question, 
        v_secret_answer
    );
    
    -- Get the ID of the newly created account
    SELECT LAST_INSERT_ID() INTO v_created_account_id
    FROM account limit 1;
    
    -- If account creation was successful, enable the account
    IF v_created_account_id IS NOT NULL THEN
        -- Enable the account (set is_active to 1)
        CALL eb_enable_disable_account(
            v_created_account_id,  -- account ID
            1,                     -- is_active (1 = enable)
            'Account enabled during sample data generation'  -- reason
        );
        
        -- Return the account ID
        SELECT v_created_account_id AS account_id, 'Account created and enabled successfully' AS message;
    ELSE
        -- Return error if account creation failed
        SELECT NULL AS account_id, 'Failed to create account' AS message;
    END IF;
    
END //

DELIMITER ;
