DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `eb_enable_disable_account`(
    IN p_account_id INT,
    IN p_is_active TINYINT,
    IN p_reason VARCHAR(255),
    IN p_modified_user VARCHAR(50)
)
BEGIN
    -- Declare variables for error handling
    DECLARE custom_error BOOLEAN DEFAULT FALSE;
    DECLARE error_code VARCHAR(100) DEFAULT NULL;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE account_exists INT DEFAULT 0;
    
    
    -- Declare handler for SQL exceptions
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
    
        -- Only get SQL diagnostic info if we don't already have a custom error
        IF error_code IS NULL THEN
            GET DIAGNOSTICS CONDITION 1
                @sqlstate = RETURNED_SQLSTATE,
                @errno = MYSQL_ERRNO,
                @text = MESSAGE_TEXT;                
            SET error_code = CONCAT('SQL_ERROR_', @errno);
            SET error_message = @text;
		ELSE 
			set error_message = error_message; 
        END IF;
        
        -- Rollback the transaction
        ROLLBACK;
        

        -- Return error information in result sets
        SELECT NULL AS account_id;
        SELECT error_code AS error_code, error_message AS error_message;
        -- Ensure client sees the error
		RESIGNAL;
    END;
    
     -- Check if account_id is provided
    IF p_account_id IS NULL THEN
        SET error_code = '45010_MISSING_ACCOUNT_ID';
        SET error_message = 'Account ID is required';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if is_active is provided
    IF p_is_active IS NULL THEN
        SET error_code = '45060_MISSING_IS_ACTIVE';
        SET error_message = 'Active status is required';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
    
    -- Check if account exists
    SELECT COUNT(*) INTO account_exists 
    FROM account 
    WHERE account_id = p_account_id 
    AND (is_deleted IS NULL OR is_deleted = 0);
    
    
    IF account_exists = 0 THEN
        SET error_code = '45011_ACCOUNT_NOT_FOUND';
        SET error_message = 'Account not found';
        SET custom_error = TRUE;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
    END IF;
 
    -- Start transaction
    START TRANSACTION;
    
    -- Update account status
    UPDATE account
    SET 
        is_active = p_is_active,
        modified_date = NOW(),
        modified_user = p_modified_user,
        -- Set activation or deactivation information based on the status
        activation_date = CASE WHEN p_is_active = 1 THEN NOW() ELSE activation_date END,
        activated_user = CASE WHEN p_is_active = 1 THEN p_modified_user ELSE activated_user END,
        deactivated_date = CASE WHEN p_is_active = 0 THEN NOW() ELSE deactivated_date END,
        deactivated_user = CASE WHEN p_is_active = 0 THEN p_modified_user ELSE deactivated_user END,
        deactivation_reason = CASE WHEN p_is_active = 0 THEN p_reason ELSE deactivation_reason END
    WHERE 
        account_id = p_account_id;
	
   
    -- Update login status
    UPDATE login
    SET 
        is_active = p_is_active,
        modified_date = NOW(),
        modified_user = p_modified_user
    WHERE 
        account_id = p_account_id
	LIMIT 1;

     -- Commit the transaction
    COMMIT;
     
    -- Return success results
    SELECT 
        p_account_id AS account_id,
        CASE WHEN p_is_active = 1 THEN 'Account enabled successfully' ELSE 'Account disabled successfully' END AS message;
    
    SELECT 
        NULL AS error_code,
        NULL AS error_message;
END //
DELIMITER ;