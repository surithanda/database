DELIMITER //

CREATE PROCEDURE `sampledata_generate_complete_profile`()
BEGIN
    -- Declare variables for account creation
    DECLARE v_created_account_id INT;
    DECLARE v_profile_id INT;
    DECLARE v_status VARCHAR(50);
    DECLARE v_error_message VARCHAR(255);
    DECLARE v_photo_id INT;
    DECLARE v_contact_id INT;
    DECLARE v_education_id INT;
    DECLARE v_employment_id INT;
    DECLARE v_family_ref_id INT;
    DECLARE v_hobby_id INT;
    DECLARE v_interest_id INT;
    DECLARE v_lifestyle_id INT;
    DECLARE v_address_id INT;
    DECLARE v_property_id INT;
    
    -- Variables for lookup values
    DECLARE v_gender_id INT;
    DECLARE v_marital_status_id INT;
    DECLARE v_religion_id INT;
    DECLARE v_profession_id INT;
    DECLARE v_photo_type_id INT;
    DECLARE v_contact_type_id INT;
    DECLARE v_education_level_id INT;
    DECLARE v_field_of_study_id INT;
    DECLARE v_family_relation_id INT;
    DECLARE v_hobby_id_lookup INT;
    DECLARE v_interest_id_lookup INT;
    DECLARE v_address_type_id INT;
    DECLARE v_property_type_id INT;
    DECLARE v_ownership_type_id INT;
    
    -- First, create the account and login
    CALL sampledata_generate_sample_account();
    
    -- Get the ID of the newly created account using LAST_INSERT_ID()
    SELECT LAST_INSERT_ID() INTO v_created_account_id
    FROM account LIMIT 1;
    
    -- If account creation was successful, proceed with profile data insertion
    IF v_created_account_id IS NOT NULL THEN
        -- Get lookup values
        SELECT id INTO v_gender_id FROM lookup_table WHERE category = 'Gender' ORDER BY RAND() LIMIT 1;
        SELECT id INTO v_marital_status_id FROM lookup_table WHERE category = 'marital_status' ORDER BY RAND() LIMIT 1;
        SELECT id INTO v_religion_id FROM lookup_table WHERE category = 'religion' ORDER BY RAND() LIMIT 1;
        SELECT id INTO v_profession_id FROM lookup_table WHERE category = 'profession' ORDER BY RAND() LIMIT 1;
        
        -- 1. Insert personal profile data
        CALL eb_profile_personal_create(
            v_created_account_id,                                -- accountid
            CONCAT('First_', v_created_account_id),              -- first_name
            CONCAT('Last_', v_created_account_id),               -- last_name
            'Middle',                                            -- middle_name
            'Mr',                                                -- prefix
            NULL,                                                -- suffix
            v_gender_id,                                         -- gender
            DATE_SUB(CURDATE(), INTERVAL 25 YEAR),               -- birth_date
            CONCAT('555', LPAD(v_created_account_id, 7, '0')),   -- phone_mobile
            CONCAT('444', LPAD(v_created_account_id, 7, '0')),   -- phone_home
            CONCAT('333', LPAD(v_created_account_id, 7, '0')),   -- phone_emergency
            CONCAT('user', v_created_account_id, '@example.com'),-- email_id
            v_marital_status_id,                                 -- marital_status
            v_religion_id,                                       -- religion
            1,                                                   -- nationality (assuming 1 is valid)
            NULL,                                                -- caste
            70,                                                  -- height_inches
            178,                                                 -- height_cms
            180,                                                 -- weight
            'lbs',                                               -- weight_units
            NULL,                                                -- complexion
            CONCAT('linkedin.com/in/user', v_created_account_id),-- linkedin
            CONCAT('facebook.com/user', v_created_account_id),   -- facebook
            CONCAT('instagram.com/user', v_created_account_id),  -- instagram
            CONCAT('555', LPAD(v_created_account_id, 7, '0')),   -- whatsapp_number
            v_profession_id,                                     -- profession
            NULL,                                                -- disability
            'system'                                             -- created_user
        );
        
        -- Get the profile ID from the newly created personal profile
        SELECT LAST_INSERT_ID() INTO v_profile_id 
        FROM profile_personal limit 1;
        
        -- If profile creation was successful, continue with other profile data
        IF v_profile_id IS NOT NULL THEN
            -- 2. Insert profile photo
            SELECT id INTO v_photo_type_id FROM lookup_table WHERE category = 'photo_type' ORDER BY RAND() LIMIT 1;
            
            CALL eb_profile_photo_create(
                v_profile_id,                                     -- p_profile_id
                CONCAT('/photos/user_', v_profile_id, '.jpg'),    -- p_url
                v_photo_type_id,                                  -- p_photo_type
                'Profile Photo',                                  -- p_caption
                'Auto-generated profile photo',                   -- p_description
                'system'                                         -- p_created_user
            );
            
            -- 3. Insert profile contact
            SELECT id INTO v_contact_type_id FROM lookup_table WHERE category = 'contact_type' ORDER BY RAND() LIMIT 1;
            
            CALL eb_profile_contact_create(
                v_profile_id,                                     -- p_profile_id
                v_contact_type_id,                                -- p_contact_type
                CONCAT('contact_value_', v_profile_id),           -- p_contact_value
                'system'                                          -- p_created_user
            );
            
            -- 4. Insert profile education
            SELECT id INTO v_education_level_id FROM lookup_table WHERE category = 'education_level' ORDER BY RAND() LIMIT 1;
            SELECT id INTO v_field_of_study_id FROM lookup_table WHERE category = 'field_of_study' ORDER BY RAND() LIMIT 1;
            
            CALL eb_profile_education_create(
                v_profile_id,                                     -- p_profile_id
                v_education_level_id,                             -- p_education_level
                YEAR(CURDATE()) - 5,                              -- p_year_completed
                CONCAT('University of ', CHAR(65 + FLOOR(RAND() * 26))), -- p_institution_name
                CONCAT(FLOOR(100 + RAND() * 9900), ' Campus Dr'), -- p_address_line1
                'University City',                                -- p_city
                1,                                                -- p_state_id (assuming 1 is valid)
                1,                                                -- p_country_id (assuming 1 is valid)
                '12345',                                          -- p_zip
                v_field_of_study_id,                              -- p_field_of_study
                'system'                                          -- p_created_user
            );
            
            -- 5. Insert profile employment
            CALL eb_profile_employment_create(
                v_profile_id,                                     -- p_profile_id
                CONCAT('Company ', CHAR(65 + FLOOR(RAND() * 26))),-- p_institution_name
                CONCAT(FLOOR(100 + RAND() * 9900), ' Business Rd'),-- p_address_line1
                'Business City',                                  -- p_city
                1,                                                -- p_state_id
                1,                                                -- p_country_id
                '54321',                                          -- p_zip
                YEAR(CURDATE()) - 3,                              -- p_start_year
                NULL,                                             -- p_end_year
                v_profession_id,                                  -- p_job_title_id
                NULL,                                             -- p_other_title
                FLOOR(50000 + RAND() * 50000),                    -- p_last_salary_drawn
                'system'                                          -- p_created_user
            );
            
            -- 6. Insert family reference
            SELECT id INTO v_family_relation_id FROM lookup_table WHERE category = 'Family' ORDER BY RAND() LIMIT 1;
            
            CALL eb_profile_family_reference_create(
                v_profile_id,                                     -- p_profile_id
                CONCAT('Family_First_', v_profile_id),            -- p_first_name
                CONCAT('Family_Last_', v_profile_id),             -- p_last_name
                v_family_relation_id,                             -- p_reference_type
                CONCAT('555', LPAD(FLOOR(RAND() * 10000000), 7, '0')), -- p_primary_phone
                CONCAT('family', v_profile_id, '@example.com'),   -- p_email
                CONCAT(FLOOR(100 + RAND() * 9900), ' Family St'), -- p_address_line1
                'Family City',                                    -- p_city
                1,                                                -- p_state
                1,                                                -- p_country
                '54321',                                          -- p_zip
                'system'                                          -- p_created_user
            );
            
            -- 7. Insert hobby and interest
            SELECT id INTO v_hobby_id_lookup FROM lookup_table WHERE category = 'hobby' ORDER BY RAND() LIMIT 1;
            SELECT id INTO v_interest_id_lookup FROM lookup_table WHERE category = 'interest' ORDER BY RAND() LIMIT 1;
            
            CALL eb_profile_hobby_interest_create(
                v_profile_id,                                     -- p_profile_id
                v_hobby_id_lookup,                                -- p_hobby_id
                -- v_interest_id_lookup,                             -- p_interest_id
                'system'                                          -- p_created_user
            );
            
            -- 8. Insert lifestyle
            CALL eb_profile_lifestyle_create(
                v_profile_id,                                     -- p_profile_id
                CONCAT('Eating_', CHAR(65 + FLOOR(RAND() * 26))), -- p_eating_habit
                CONCAT('Diet_', CHAR(65 + FLOOR(RAND() * 26))),   -- p_diet_habit
                CONCAT(FLOOR(RAND() * 20), ' per day'),           -- p_cigarettes_per_day
                CONCAT('Drinks_', CHAR(65 + FLOOR(RAND() * 26))), -- p_drink_frequency
                CONCAT('Gambling_', CHAR(65 + FLOOR(RAND() * 26))), -- p_gambling_engage
                CONCAT('Activity_', CHAR(65 + FLOOR(RAND() * 26))), -- p_physical_activity_level
                CONCAT('Relaxation_', CHAR(65 + FLOOR(RAND() * 26))), -- p_relaxation_methods
                'Additional lifestyle information',               -- p_additional_info
                'system'                                          -- p_created_user
            );
            
            -- 9. Insert address
            SELECT id INTO v_address_type_id FROM lookup_table WHERE category = 'address_type' ORDER BY RAND() LIMIT 1;
            
            CALL eb_profile_address_create(
                v_profile_id,                                     -- p_profile_id
                v_address_type_id,                                -- p_address_type
                CONCAT(FLOOR(100 + RAND() * 9900), ' Residential St'), -- p_address_line1
                CONCAT('Apt ', FLOOR(1 + RAND() * 500)),          -- p_address_line2
                'Hometown',                                       -- p_city
                1,                                                -- p_state (assuming 1 is valid)
                1,                                                -- p_country_id (assuming 1 is valid)
                '98765',                                          -- p_zip
                'Near Park',                                      -- p_landmark1
                'Opposite Mall',                                  -- p_landmark2
                'system'                                          -- p_created_user
            );
            
            -- 10. Insert property  
            SELECT id INTO v_property_type_id FROM lookup_table WHERE category = 'property_type' ORDER BY RAND() LIMIT 1;
            SELECT id INTO v_ownership_type_id FROM lookup_table WHERE category = 'ownership_type' ORDER BY RAND() LIMIT 1;
            CALL eb_profile_property_create(
                v_profile_id,                                     -- p_profile_id
                v_property_type_id,                               -- p_property_type (assuming 1 is valid)
                v_ownership_type_id,                              -- p_ownership_type (assuming 1 is valid)
                CONCAT(FLOOR(100 + RAND() * 9900), ' Property St, Property City, 45678'), -- p_property_address
                FLOOR(1000 + RAND() * 9000),                      -- p_property_value
                'Beautiful property with modern amenities',        -- p_property_description
                1,                                                -- p_isoktodisclose (1 = true)
                'system'                                          -- p_created_by
            );
            
            -- Return success message with all created IDs
            SELECT 
                v_created_account_id AS account_id, 
                v_profile_id AS profile_id,
                'Complete profile created successfully' AS message;
        ELSE
            -- Return error if profile creation failed
            SELECT v_created_account_id AS account_id, NULL AS profile_id, 'Failed to create profile' AS message;
        END IF;
    ELSE
        -- Return error if account creation failed
        SELECT NULL AS account_id, NULL AS profile_id, 'Failed to create account' AS message;
    END IF;
END //

DELIMITER ;
