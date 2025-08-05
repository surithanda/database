CALL eb_account_login_create(
    'test.user@example.com',        -- p_email
    'SecurePass123!',               -- p_user_pwd
    'John',                         -- p_first_name
    'Q',                            -- p_middle_name
    'Doe',                          -- p_last_name
    '1990-05-15',                   -- p_birth_date
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
);

-- Email already exists
CALL eb_account_login_create(
    'test.user@example.com',        -- p_email
    'SecurePass123!',               -- p_user_pwd
    'John',                         -- p_first_name
    'Q',                            -- p_middle_name
    'Doe',                          -- p_last_name
    '1990-05-15',                   -- p_birth_date
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
);

-- Phone already exists
CALL eb_account_login_create(
    'testk12.user@example.com',        -- p_email
    'SecurePass123!',               -- p_user_pwd
    'John',                         -- p_first_name
    'Q',                            -- p_middle_name
    'Doe',                          -- p_last_name
    '1990-05-15',                   -- p_birth_date
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
);


-- Missing email
CALL eb_account_login_create(NULL, 'SecurePass123!', 'John', NULL, 'Doe',
    '1990-05-15',                   -- p_birth_date
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
);

-- Missing password
CALL eb_account_login_create('test@example.com', NULL, 'John', NULL, 'Doe', 
    '1990-05-15',                   -- p_birth_date
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
);

-- Missing first name
CALL eb_account_login_create('test@example.com', 'SecurePass123!', NULL, NULL, 'Doe', 
    '1990-05-15',                   -- p_birth_date
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
    );

-- Missing last name
CALL eb_account_login_create('test@example.com', 'SecurePass123!', 'John', NULL, NULL, 
    '1990-05-15',                   -- p_birth_date
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
    );

-- Birth date in future
CALL eb_account_login_create(
    'test21.user@example.com',        -- p_email
    'SecurePass123!',               -- p_user_pwd
    'John',                         -- p_first_name
    'Q',                            -- p_middle_name
    'Doe',                          -- p_last_name, 
    '2050-01-01', 
       1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
   );

-- User under 20 years old
CALL eb_account_login_create(
    'test21.user@example.com',        -- p_email
    'SecurePass123!',               -- p_user_pwd
    'John',                         -- p_first_name
    'Q',                            -- p_middle_name
    'Doe',                          -- p_last_name, , 
	DATE_SUB(CURDATE(), INTERVAL 19 YEAR), 
    1,                              -- p_gender
    '5551234567',                   -- p_primary_phone
    1,                              -- p_primary_phone_country
    1,                              -- p_primary_phone_type
    '5559876543',                   -- p_secondary_phone
    1,                              -- p_secondary_phone_country
    2,                              -- p_secondary_phone_type
    '123 Main St',                  -- p_address_line1
    'Apt 4B',                       -- p_address_line2
    'New York',                     -- p_city
    'NY',                           -- p_state
    '10001',                        -- p_zip
    'US',                           -- p_country
    'profile.jpg',                  -- p_photo
    'Mother''s maiden name?',       -- p_secret_question
    'Smith'                         -- p_secret_answer
);