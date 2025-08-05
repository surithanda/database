-- Test cases for eb_profile_personal_create stored procedure
-- These tests cover all validation and error scenarios

-- ===== SETUP =====
-- First, let's ensure we have a valid account to use for testing
-- Note: In a real test environment, you might want to create a test account first
-- For this example, we'll assume account_id 1 exists

-- ===== SUCCESSFUL CASE =====
-- Test Case 1: Valid profile creation with all required fields
CALL eb_profile_personal_create(
    1,                              -- accountid
    'John',                         -- first_name
    'Doe',                          -- last_name
    'Robert',                       -- middle_name
    'Mr',                           -- prefix
    'Jr',                           -- suffix
    1,                              -- gender (assuming 1 is Male in lookup_table)
    '1990-01-15',                   -- birth_date (35 years old)
    '9876543210',                   -- phone_mobile
    '1234567890',                   -- phone_home
    '5555555555',                   -- phone_emergency
    'john.doe@example.com',         -- email_id
    1,                              -- marital_status
    1,                              -- religion
    1,                              -- nationality
    1,                              -- caste
    70,                             -- height_inches
    178,                            -- height_cms
    180,                            -- weight
    'lbs',                          -- weight_units
    1,                              -- complexion
    'linkedin.com/johndoe',         -- linkedin
    'facebook.com/johndoe',         -- facebook
    'instagram.com/johndoe',        -- instagram
    '9876543210',                   -- whatsapp_number
    1,                              -- profession
    0,                              -- disability
    'test_user'                     -- created_user
);

-- ===== ERROR SCENARIOS =====

-- Test Case 2: Invalid accountid (negative value)
CALL eb_profile_personal_create(
    -1,                             -- accountid (invalid)
    'John',                         -- first_name
    'Doe',                          -- last_name
    'Robert',                       -- middle_name
    'Mr',                           -- prefix
    'Jr',                           -- suffix
    1,                              -- gender
    '1990-01-15',                   -- birth_date
    '9876543210',                   -- phone_mobile
    '1234567890',                   -- phone_home
    '5555555555',                   -- phone_emergency
    'john.doe@example.com',         -- email_id
    1, 1, 1, 1, 70, 178, 180, 'lbs', 1, 'linkedin.com/johndoe', 'facebook.com/johndoe', 
    'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 3: Invalid accountid (zero value)
CALL eb_profile_personal_create(
    0,                              -- accountid (invalid)
    'John', 'Doe', 'Robert', 'Mr', 'Jr', 1, '1990-01-15', '9876543210', '1234567890',
    '5555555555', 'john.doe@example.com', 1, 1, 1, 1, 70, 178, 180, 'lbs', 1,
    'linkedin.com/johndoe', 'facebook.com/johndoe', 'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 4: Missing first name
CALL eb_profile_personal_create(
    1,                              -- accountid
    NULL,                           -- first_name (missing)
    'Doe', 'Robert', 'Mr', 'Jr', 1, '1990-01-15', '9876543210', '1234567890',
    '5555555555', 'john.doe@example.com', 1, 1, 1, 1, 70, 178, 180, 'lbs', 1,
    'linkedin.com/johndoe', 'facebook.com/johndoe', 'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 5: Empty first name
CALL eb_profile_personal_create(
    1,                              -- accountid
    '',                             -- first_name (empty)
    'Doe', 'Robert', 'Mr', 'Jr', 1, '1990-01-15', '9876543210', '1234567890',
    '5555555555', 'john.doe@example.com', 1, 1, 1, 1, 70, 178, 180, 'lbs', 1,
    'linkedin.com/johndoe', 'facebook.com/johndoe', 'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 6: Missing last name
CALL eb_profile_personal_create(
    1,                              -- accountid
    'John',                         -- first_name
    NULL,                           -- last_name (missing)
    'Robert', 'Mr', 'Jr', 1, '1990-01-15', '9876543210', '1234567890',
    '5555555555', 'john.doe@example.com', 1, 1, 1, 1, 70, 178, 180, 'lbs', 1,
    'linkedin.com/johndoe', 'facebook.com/johndoe', 'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 7: Empty last name
CALL eb_profile_personal_create(
    1,                              -- accountid
    'John',                         -- first_name
    '',                             -- last_name (empty)
    'Robert', 'Mr', 'Jr', 1, '1990-01-15', '9876543210', '1234567890',
    '5555555555', 'john.doe@example.com', 1, 1, 1, 1, 70, 178, 180, 'lbs', 1,
    'linkedin.com/johndoe', 'facebook.com/johndoe', 'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 8: Invalid gender (not in lookup table)
CALL eb_profile_personal_create(
    1,                              -- accountid
    'John',                         -- first_name
    'Doe',                          -- last_name
    'Robert',                       -- middle_name
    'Mr',                           -- prefix
    'Jr',                           -- suffix
    999,                            -- gender (invalid)
    '1990-01-15',                   -- birth_date
    '9876543210',                   -- phone_mobile
    '1234567890',                   -- phone_home
    '5555555555',                   -- phone_emergency
    'john.doe@example.com',         -- email_id
    1, 1, 1, 1, 70, 178, 180, 'lbs', 1, 'linkedin.com/johndoe', 'facebook.com/johndoe', 
    'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 9: Missing birth date
CALL eb_profile_personal_create(
    1, 'John', 'Doe', 'Robert', 'Mr', 'Jr', 1, 
    NULL,                           -- birth_date (missing)
    '9876543210', '1234567890', '5555555555', 'john.doe@example.com', 
    1, 1, 1, 1, 70, 178, 180, 'lbs', 1, 'linkedin.com/johndoe', 'facebook.com/johndoe', 
    'instagram.com/johndoe', '9876543210', 1, 0, 'test_user'
);

-- Test Case 10: Duplicate profile (same first_name, last_name, birth_date)
-- First create a profile
CALL eb_profile_personal_create(
    1, 'Jane', 'Smith', 'Marie', 'Ms', '', 2, '1985-05-20', '5551234567', '5559876543',
    '5552468101', 'jane.smith@example.com', 2, 2, 2, 2, 65, 165, 140, 'lbs', 2,
    'linkedin.com/janesmith', 'facebook.com/janesmith', 'instagram.com/janesmith', '5551234567', 2, 0, 'test_user'
);

-- Then try to create the same profile again
CALL eb_profile_personal_create(
    2, 'Jane', 'Smith', 'Marie', 'Ms', '', 2, '1985-05-20', '5551112222', '5553334444',
    '5555556666', 'jane.smith2@example.com', 2, 2, 2, 2, 65, 165, 140, 'lbs', 2,
    'linkedin.com/janesmith2', 'facebook.com/janesmith2', 'instagram.com/janesmith2', '5551112222', 2, 0, 'test_user'
);

-- Test Case 11: Duplicate email
CALL eb_profile_personal_create(
    2, 'Different', 'Person', 'Middle', 'Dr', '', 1, '1980-10-10', '1112223333', '4445556666',
    '7778889999', 'john.doe@example.com', 1, 1, 1, 1, 72, 183, 190, 'lbs', 1,
    'linkedin.com/different', 'facebook.com/different', 'instagram.com/different', '1112223333', 1, 0, 'test_user'
);

-- Test Case 12: Duplicate phone
CALL eb_profile_personal_create(
    2, 'Another', 'Person', 'Middle', 'Dr', '', 1, '1982-11-11', '9876543210', '1231231234',
    '4564564567', 'another.person@example.com', 1, 1, 1, 1, 71, 180, 185, 'lbs', 1,
    'linkedin.com/another', 'facebook.com/another', 'instagram.com/another', '9876543210', 1, 0, 'test_user'
);

-- Test Case 13: Age too young (< 21)
CALL eb_profile_personal_create(
    2, 'Young', 'Person', 'Kid', 'Mr', '', 1, 
    DATE_SUB(CURDATE(), INTERVAL 20 YEAR),  -- 20 years old (too young)
    '1231231231', '4564564564', '7897897897', 'young.person@example.com', 
    1, 1, 1, 1, 68, 173, 160, 'lbs', 1, 'linkedin.com/young', 'facebook.com/young', 
    'instagram.com/young', '1231231231', 1, 0, 'test_user'
);

-- Test Case 14: Age too old (> 85)
CALL eb_profile_personal_create(
    2, 'Old', 'Person', 'Senior', 'Mr', '', 1, 
    DATE_SUB(CURDATE(), INTERVAL 86 YEAR),  -- 86 years old (too old)
    '9879879879', '6546546546', '3213213213', 'old.person@example.com', 
    1, 1, 1, 1, 67, 170, 150, 'lbs', 1, 'linkedin.com/old', 'facebook.com/old', 
    'instagram.com/old', '9879879879', 1, 0, 'test_user'
);

-- Test Case 15: Non-existent account ID
CALL eb_profile_personal_create(
    99999,                          -- accountid (non-existent)
    'Invalid', 'Account', 'Test', 'Mr', '', 1, '1990-01-15', '1212121212', '3434343434',
    '5656565656', 'invalid.account@example.com', 1, 1, 1, 1, 70, 178, 180, 'lbs', 1,
    'linkedin.com/invalid', 'facebook.com/invalid', 'instagram.com/invalid', '1212121212', 1, 0, 'test_user'
);

-- Test Case 16: Invalid mobile phone (too short)
CALL eb_profile_personal_create(
    2, 'Short', 'Phone', 'Test', 'Mr', '', 1, '1990-01-15', 
    '123456',                       -- phone_mobile (too short)
    '1234567890', '5555555555', 'short.phone@example.com', 
    1, 1, 1, 1, 70, 178, 180, 'lbs', 1, 'linkedin.com/short', 'facebook.com/short', 
    'instagram.com/short', '123456', 1, 0, 'test_user'
);

-- Test Case 17: Invalid home phone (too short)
CALL eb_profile_personal_create(
    2, 'Short', 'HomePhone', 'Test', 'Mr', '', 1, '1990-01-15', '9090909090',
    '12345',                        -- phone_home (too short)
    '5555555555', 'short.homephone@example.com', 
    1, 1, 1, 1, 70, 178, 180, 'lbs', 1, 'linkedin.com/shorthome', 'facebook.com/shorthome', 
    'instagram.com/shorthome', '9090909090', 1, 0, 'test_user'
);

-- Test Case 18: Invalid emergency phone (too short)
CALL eb_profile_personal_create(
    2, 'Short', 'EmergencyPhone', 'Test', 'Mr', '', 1, '1990-01-15', '8080808080', '7070707070',
    '12345',                        -- phone_emergency (too short)
    'short.emergency@example.com', 
    1, 1, 1, 1, 70, 178, 180, 'lbs', 1, 'linkedin.com/shortemergency', 'facebook.com/shortemergency', 
    'instagram.com/shortemergency', '8080808080', 1, 0, 'test_user'
);

-- Test Case 19: Invalid email format
CALL eb_profile_personal_create(
    2, 'Invalid', 'Email', 'Test', 'Mr', '', 1, '1990-01-15', '6060606060', '5050505050',
    '4040404040', 
    'invalid-email',                -- email_id (invalid format)
    1, 1, 1, 1, 70, 178, 180, 'lbs', 1, 'linkedin.com/invalidemail', 'facebook.com/invalidemail', 
    'instagram.com/invalidemail', '6060606060', 1, 0, 'test_user'
);

-- Test Case 20: Invalid height (zero or negative)
CALL eb_profile_personal_create(
    2, 'Zero', 'Height', 'Test', 'Mr', '', 1, '1990-01-15', '3030303030', '2020202020',
    '1010101010', 'zero.height@example.com', 
    1, 1, 1, 1, 
    0,                              -- height_inches (invalid)
    0, 180, 'lbs', 1, 'linkedin.com/zeroheight', 'facebook.com/zeroheight', 
    'instagram.com/zeroheight', '3030303030', 1, 0, 'test_user'
);

-- Test Case 21: Invalid weight (zero or negative)
CALL eb_profile_personal_create(
    2, 'Zero', 'Weight', 'Test', 'Mr', '', 1, '1990-01-15', '9999999999', '8888888888',
    '7777777777', 'zero.weight@example.com', 
    1, 1, 1, 1, 70, 178, 
    0,                              -- weight (invalid)
    'lbs', 1, 'linkedin.com/zeroweight', 'facebook.com/zeroweight', 
    'instagram.com/zeroweight', '9999999999', 1, 0, 'test_user'
);

-- Test Case 22: Negative height
CALL eb_profile_personal_create(
    2, 'Negative', 'Height', 'Test', 'Mr', '', 1, '1990-01-15', '1111111111', '2222222222',
    '3333333333', 'negative.height@example.com', 
    1, 1, 1, 1, 
    -10,                            -- height_inches (negative)
    -25, 180, 'lbs', 1, 'linkedin.com/negheight', 'facebook.com/negheight', 
    'instagram.com/negheight', '1111111111', 1, 0, 'test_user'
);

-- Test Case 23: Negative weight
CALL eb_profile_personal_create(
    2, 'Negative', 'Weight', 'Test', 'Mr', '', 1, '1990-01-15', '4444444444', '5555555555',
    '6666666666', 'negative.weight@example.com', 
    1, 1, 1, 1, 70, 178, 
    -50,                            -- weight (negative)
    'lbs', 1, 'linkedin.com/negweight', 'facebook.com/negweight', 
    'instagram.com/negweight', '4444444444', 1, 0, 'test_user'
);
