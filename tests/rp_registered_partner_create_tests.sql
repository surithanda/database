-- Test Case 1: Successful creation of a new registered partner
CALL eb_registered_partner_create(
    'Test Business Inc.',            -- p_business_name
    'TBI',                           -- p_alias
    'contact@testbusiness.com',      -- p_business_email
    '1234567890',                    -- p_primary_phone
    1,                               -- p_primary_phone_country_code
    '0987654321',                    -- p_secondary_phone
    '123 Innovation Drive',          -- p_address_line1
    'Tech City',                     -- p_city
    1,                               -- p_state (Assuming 1 is a valid state ID)
    1,                               -- p_country (Assuming 1 is a valid country ID)
    '94043',                         -- p_zip
    'REG123456789',                  -- p_business_registration_number
    'ITIN987654321',                 -- p_business_ITIN
    'A leading provider of innovative tech solutions.', -- p_business_description
    'John',                          -- p_primary_contact_first_name
    'Doe',                           -- p_primary_contact_last_name
    1,                               -- p_primary_contact_gender (Assuming 1 is Male)
    '1985-02-20',                    -- p_primary_contact_date_of_birth
    'john.doe@testbusiness.com',     -- p_primary_contact_email
    'linkedin.com/company/testbusiness', -- p_business_linkedin
    'https://www.testbusiness.com',  -- p_business_website
    'facebook.com/testbusiness',     -- p_business_facebook
    'whatsapp.com/testbusiness',     -- p_business_whatsapp
    'testbusiness.com',              -- p_domain_root_url
    'test_suite'                     -- p_created_user
);

-- Test Case 2: Missing business_name
CALL eb_registered_partner_create(
    NULL, -- p_business_name
    'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 3: Missing alias
CALL eb_registered_partner_create(
    'Test Business Inc.', NULL, 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 4: Missing primary_phone
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', NULL, 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 5: Missing primary_phone_country_code
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', NULL, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 6: Missing address_line1
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', NULL, 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 7: Missing state
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', NULL, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 8: Missing country
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, NULL, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 9: Missing zip
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, NULL, 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 10: Missing business_registration_number
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', NULL, 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 11: Missing business_ITIN
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', NULL, 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 12: Missing business_description
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', NULL, 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 13: Missing primary_contact_first_name
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', NULL, 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 14: Missing primary_contact_last_name
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', NULL, 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 15: Missing business_website
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', NULL, 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 16: Empty string for business_name
CALL eb_registered_partner_create(
    '  ', -- p_business_name (whitespace)
    'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 1, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 17: Invalid state ID (zero)
CALL eb_registered_partner_create(
    'Test Business Inc.', 'TBI', 'contact@testbusiness.com', '1234567890', 1, '0987654321', '123 Innovation Drive', 'Tech City', 0, 1, '94043', 'REG123456789', 'ITIN987654321', 'A leading provider of innovative tech solutions.', 'John', 'Doe', 1, '1985-02-20', 'john.doe@testbusiness.com', 'linkedin.com/company/testbusiness', 'https://www.testbusiness.com', 'facebook.com/testbusiness', 'whatsapp.com/testbusiness', 'testbusiness.com', 'test_suite'
);

-- Test Case 18: All optional fields NULL
CALL eb_registered_partner_create(
    'Optional Fields Test Inc.',     -- p_business_name
    'OFT',                           -- p_alias
    NULL,                            -- p_business_email
    '1122334455',                    -- p_primary_phone
    1,                               -- p_primary_phone_country_code
    NULL,                            -- p_secondary_phone
    '456 Optional Ave',              -- p_address_line1
    'Testville',                     -- p_city
    1,                               -- p_state
    1,                               -- p_country
    '12345',                         -- p_zip
    'REGOPT123',                     -- p_business_registration_number
    'ITINOPT123',                    -- p_business_ITIN
    'Testing with optional fields as NULL.', -- p_business_description
    'Jane',                          -- p_primary_contact_first_name
    'Smith',                         -- p_primary_contact_last_name
    NULL,                            -- p_primary_contact_gender
    NULL,                            -- p_primary_contact_date_of_birth
    NULL,                            -- p_primary_contact_email
    NULL,                            -- p_business_linkedin
    'https://www.optionaltest.com',   -- p_business_website
    NULL,                            -- p_business_facebook
    NULL,                            -- p_business_whatsapp
    NULL,                            -- p_domain_root_url
    'test_suite_edge'                -- p_created_user
);
