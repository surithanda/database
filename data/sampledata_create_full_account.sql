DELIMITER //

CREATE PROCEDURE `sampledata_create_full_account`(
    -- Account and Login Parameters
    IN p_email VARCHAR(150),
    IN p_user_pwd VARCHAR(150),
    IN p_first_name VARCHAR(45),
    IN p_middle_name VARCHAR(45),
    IN p_last_name VARCHAR(45),
    IN p_birth_date DATE,
    IN p_gender INT,
    IN p_primary_phone VARCHAR(10),
    IN p_primary_phone_country VARCHAR(5),
    IN p_primary_phone_type INT,
    IN p_secondary_phone VARCHAR(10),
    IN p_secondary_phone_country VARCHAR(5),
    IN p_secondary_phone_type INT,
    IN p_secret_question VARCHAR(45),
    IN p_secret_answer VARCHAR(45),

    -- Profile Personal Parameters
    IN p_prefix VARCHAR(45),
    IN p_suffix VARCHAR(45),
    IN p_marital_status INT,
    IN p_religion INT,
    IN p_nationality INT,
    IN p_caste INT,
    IN p_height_inches INT,
    IN p_height_cms INT,
    IN p_weight INT,
    IN p_weight_units VARCHAR(4),
    IN p_complexion INT,
    IN p_linkedin VARCHAR(450),
    IN p_facebook VARCHAR(450),
    IN p_instagram VARCHAR(450),
    IN p_whatsapp_number VARCHAR(15),
    IN p_profession INT,
    IN p_disability INT,

    -- Profile Address Parameters
    IN p_address_line1 VARCHAR(45),
    IN p_address_line2 VARCHAR(45),
    IN p_city VARCHAR(45),
    IN p_state VARCHAR(45),
    IN p_zip VARCHAR(45),
    IN p_country VARCHAR(45),
    IN p_address_type INT,

    -- Profile Contact Parameters
    IN p_contact_name VARCHAR(100),
    IN p_contact_relationship VARCHAR(50),
    IN p_contact_phone VARCHAR(15),

    -- Profile Education Parameters
    IN p_degree VARCHAR(100),
    IN p_institution VARCHAR(100),
    IN p_year_of_completion INT,

    -- Profile Employment Parameters
    IN p_company_name VARCHAR(100),
    IN p_job_title VARCHAR(100),
    IN p_start_date DATE,
    IN p_end_date DATE,

    -- Profile Family Reference Parameters
    IN p_ref_name VARCHAR(100),
    IN p_ref_relationship VARCHAR(50),
    IN p_ref_phone VARCHAR(15),

    -- Profile Hobby/Interest Parameters
    IN p_hobby_name VARCHAR(100),

    -- Profile Lifestyle Parameters
    IN p_diet_preference INT,
    IN p_smoking_habit INT,
    IN p_drinking_habit INT,

    -- Profile Property Parameters
    IN p_property_type INT,
    IN p_property_value DECIMAL(18, 2),

    -- Profile Photo Parameters
    IN p_photo_path VARCHAR(255),
    IN p_is_profile_photo TINYINT
)
BEGIN
    DECLARE new_account_id INT;
    DECLARE error_occurred BOOLEAN DEFAULT FALSE;

    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET error_occurred = TRUE;
        SELECT 'fail' AS status, 'An error occurred during account creation.' AS message;
    END;

    START TRANSACTION;

    -- 1. Create Account and Login
    CALL eb_account_login_create(
        p_email, p_user_pwd, p_first_name, p_middle_name, p_last_name, p_birth_date, p_gender,
        p_primary_phone, p_primary_phone_country, p_primary_phone_type,
        p_secondary_phone, p_secondary_phone_country, p_secondary_phone_type,
        p_address_line1, p_address_line2, p_city, p_state, p_zip, p_country,
        p_photo_path, p_secret_question, p_secret_answer
    );

    -- Get the new account ID
    SELECT account_id INTO new_account_id FROM account WHERE email = p_email;

    -- 2. Enable the Account
    CALL eb_enable_disable_account(new_account_id, 1, 'New account activation');

    -- 3. Create Profile Personal
    CALL eb_profile_personal_create(
        new_account_id, p_first_name, p_last_name, p_middle_name, p_prefix, p_suffix, p_gender,
        p_birth_date, p_primary_phone, NULL, NULL, p_email, p_marital_status, p_religion, p_nationality,
        p_caste, p_height_inches, p_height_cms, p_weight, p_weight_units, p_complexion, p_linkedin,
        p_facebook, p_instagram, p_whatsapp_number, p_profession, p_disability, p_email
    );

    -- 4. Create other profile entries
    CALL eb_profile_address_create(new_account_id, p_address_type, p_address_line1, p_address_line2, p_city, p_state, p_zip, p_country, p_email);
    CALL eb_profile_contact_create(new_account_id, p_contact_name, p_contact_relationship, p_contact_phone, p_email);
    CALL eb_profile_education_create(new_account_id, p_degree, p_institution, p_year_of_completion, p_email);
    CALL eb_profile_employment_create(new_account_id, p_company_name, p_job_title, p_start_date, p_end_date, p_email);
    CALL eb_profile_family_reference_create(new_account_id, p_ref_name, p_ref_relationship, p_ref_phone, p_email);
    CALL eb_profile_hobby_interest_create(new_account_id, p_hobby_name, p_email);
    CALL eb_profile_lifestyle_create(new_account_id, p_diet_preference, p_smoking_habit, p_drinking_habit, p_email);
    CALL eb_profile_property_create(new_account_id, p_property_type, p_property_value, p_email);
    CALL eb_profile_photo_create(new_account_id, p_photo_path, p_is_profile_photo, p_email);

    IF NOT error_occurred THEN
        COMMIT;
        SELECT 'success' AS status, 'Account created successfully.' AS message, new_account_id AS account_id;
    END IF;

END //

DELIMITER ;
