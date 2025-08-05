DELIMITER //

-- this procedure is called when forgot password option is used
-- this will called after OTP is validated
-- 1. 


CREATE PROCEDURE `eb_update_new_password_forgot_password`(
   IN email VARCHAR(45),
    IN new_password VARCHAR(45)
)
BEGIN
    DECLARE existing_password VARCHAR(45);
    DECLARE v_account_id INT;
    SET SQL_SAFE_UPDATES = 0;

    -- Retrieve the account_id and existing password for the given email
    SELECT a.account_id, l.password 
    INTO v_account_id, existing_password
    FROM account a
    JOIN login l ON a.account_id = l.account_id
    WHERE a.email = email
    LIMIT 1;  -- Ensure only one row is selected

    -- Check if the email exists
    IF v_account_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email not found.';
    END IF;
    -- Start transaction
    START TRANSACTION;
    -- Update password in the login information
    UPDATE login
    SET password = new_password
    WHERE account_id = v_account_id;  -- Reference the variable correctly
    -- Commit transaction
    COMMIT;
    -- Return success message
    SELECT 'Account password updated successfully.' AS message;
END