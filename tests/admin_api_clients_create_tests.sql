-- Test cases for admin_api_clients_create procedure

-- To run these tests, ensure you have partners with IDs 1 and 2 created and active.
-- You may need to manually update a partner to be inactive for the negative test case.

-- =============================================
-- Positive Test Cases
-- =============================================

-- Test Case 1: Successful API client creation
-- Expect: success
CALL admin_api_clients_create(
    1, 
    'testpartner.com', 
    'admin.testpartner.com', 
    'Activating client for testing purposes.', 
    1
);


-- =============================================
-- Negative Test Cases
-- =============================================

-- Test Case 2: Null partner_id
-- Expect: fail, 'Partner ID is required and must be valid.'
CALL admin_api_clients_create(NULL, 'domain.com', 'admin.domain.com', 'Notes', 1);

-- Test Case 3: Invalid partner_id (zero)
-- Expect: fail, 'Partner ID is required and must be valid.'
CALL admin_api_clients_create(0, 'domain.com', 'admin.domain.com', 'Notes', 1);

-- Test Case 4: Non-existent partner_id
-- Expect: fail, 'Partner with ID ... does not exist or is not active.'
CALL admin_api_clients_create(9999, 'domain.com', 'admin.domain.com', 'Notes', 1);

-- Test Case 5: Inactive partner_id
-- Note: This requires a partner (e.g., ID 2) to be set to Is_active = 0 manually before running.
-- UPDATE registered_partner SET Is_active = 0 WHERE reg_partner_id = 2;
-- Expect: fail, 'Partner with ID ... does not exist or is not active.'
CALL admin_api_clients_create(2, 'inactivepartner.com', 'admin.inactivepartner.com', 'Notes', 1);
-- UPDATE registered_partner SET Is_active = 1 WHERE reg_partner_id = 2; -- Revert change after test

-- Test Case 6: Null partner_root_domain
-- Expect: fail, 'Partner root domain is required.'
CALL admin_api_clients_create(1, NULL, 'admin.domain.com', 'Notes', 1);

-- Test Case 7: Empty partner_root_domain
-- Expect: fail, 'Partner root domain is required.'
CALL admin_api_clients_create(1, '', 'admin.domain.com', 'Notes', 1);

-- Test Case 8: Null activation_notes
-- Expect: fail, 'Activation notes are required.'
CALL admin_api_clients_create(1, 'domain.com', 'admin.domain.com', NULL, 1);

-- Test Case 9: Empty activation_notes
-- Expect: fail, 'Activation notes are required.'
CALL admin_api_clients_create(1, 'domain.com', 'admin.domain.com', '', 1);

-- Test Case 10: Null activated_by (assuming this is handled by foreign key or other constraint if applicable)
-- The procedure does not explicitly check for p_activated_by being NULL, but a table constraint might.
CALL admin_api_clients_create(1, 'domain.com', 'admin.domain.com', 'Notes', NULL);
