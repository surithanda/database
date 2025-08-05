DELIMITER //

CREATE PROCEDURE `eb_profile_search_get` (
    IN p_profile_id INT,
    -- Optional override parameters
    IN p_min_age INT,
    IN p_max_age INT,
    IN p_religion INT,
    IN p_max_education INT,
    IN p_occupation INT,
    IN p_country VARCHAR(45),
    IN p_casete_id INT,
    IN p_marital_status INT
)
BEGIN
    -- Declare variables to hold search preferences
    DECLARE v_min_age INT;
    DECLARE v_max_age INT;
    DECLARE v_religion INT;
    DECLARE v_max_education INT;
    DECLARE v_occupation INT;
    DECLARE v_country VARCHAR(45);
    DECLARE v_casete_id INT;
    DECLARE v_marital_status INT;
    DECLARE v_error_message VARCHAR(255);
    DECLARE v_preferences_found BOOLEAN DEFAULT FALSE;
    
    -- Declare handler for SQL exceptions
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Get the error message
        GET DIAGNOSTICS CONDITION 1
        v_error_message = MESSAGE_TEXT;
        
        -- Return error information
        SELECT 
            'ERROR' AS status,
            v_error_message AS message;
            
        -- Rollback any transaction if exists
        ROLLBACK;
    END;
    
    -- Validate input parameters
    IF p_profile_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Profile ID cannot be NULL';
    END IF;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Check if the profile exists
    IF NOT EXISTS (SELECT 1 FROM profile_personal WHERE profile_id = p_profile_id AND is_active = 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Profile not found or inactive';
    END IF;
    
    -- Get search preferences from the profile_search_prefernce table
    SELECT 
        min_age, max_age, religion, max_education, occupation, country, casete_id, marital_status,
        TRUE INTO v_min_age, v_max_age, v_religion, v_max_education, v_occupation, v_country, v_casete_id, v_marital_status, v_preferences_found
    FROM 
        profile_search_prefernce
    WHERE 
        profile_id = p_profile_id
    LIMIT 1;
    
    -- Check if preferences were found
    IF NOT v_preferences_found THEN
        -- No preferences found, but we'll continue with NULL values or overrides
        SET v_min_age = NULL;
        SET v_max_age = NULL;
        SET v_religion = NULL;
        SET v_max_education = NULL;
        SET v_occupation = NULL;
        SET v_country = NULL;
        SET v_casete_id = NULL;
        SET v_marital_status = NULL;
    END IF;
    
    -- Use input parameters if provided, otherwise use preferences from the table
    SET v_min_age = IFNULL(p_min_age, v_min_age);
    SET v_max_age = IFNULL(p_max_age, v_max_age);
    SET v_religion = IFNULL(p_religion, v_religion);
    SET v_max_education = IFNULL(p_max_education, v_max_education);
    SET v_occupation = IFNULL(p_occupation, v_occupation);
    SET v_country = IFNULL(p_country, v_country);
    SET v_casete_id = IFNULL(p_casete_id, v_casete_id);
    SET v_marital_status = IFNULL(p_marital_status, v_marital_status);
    
    -- Validate age range if both are provided
    IF v_min_age IS NOT NULL AND v_max_age IS NOT NULL AND v_min_age > v_max_age THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Minimum age cannot be greater than maximum age';
    END IF;
    
    -- Main query to search profiles based on preferences
    SELECT 
        pp.first_name,
        pp.last_name,
        lt.name AS gender,
        TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) AS age,
        pp.marital_status
    FROM 
        profile_personal pp
    LEFT JOIN 
        lookup_table lt ON lt.category = 'Gender' AND lt.id = pp.gender
    LEFT JOIN 
        profile_address pa ON pa.profile_id = pp.profile_id
    LEFT JOIN 
        profile_education pe ON pe.profile_id = pp.profile_id
    LEFT JOIN 
        profile_employment pem ON pem.profile_id = pp.profile_id
    WHERE 
        pp.is_active = 1
        -- Apply age filter if specified
        AND (v_min_age IS NULL OR TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) >= v_min_age)
        AND (v_max_age IS NULL OR TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) <= v_max_age)
        -- Apply religion filter if specified
        AND (v_religion IS NULL OR pp.religion = v_religion)
        -- Apply education filter if specified
        AND (v_max_education IS NULL OR EXISTS (
            SELECT 1 FROM profile_education pe2 
            WHERE pe2.profile_id = pp.profile_id 
            AND pe2.education_level <= v_max_education
        ))
        -- Apply occupation filter if specified
        AND (v_occupation IS NULL OR EXISTS (
            SELECT 1 FROM profile_employment pem2 
            WHERE pem2.profile_id = pp.profile_id 
            AND pem2.job_title_id = v_occupation
        ))
        -- Apply country filter if specified
        AND (v_country IS NULL OR EXISTS (
            SELECT 1 FROM profile_address pa2 
            WHERE pa2.profile_id = pp.profile_id 
            AND pa2.country_id = v_country
        ))
        -- Apply caste filter if specified
        AND (v_casete_id IS NULL OR pp.caste = v_casete_id)
        -- Apply marital status filter if specified
        AND (v_marital_status IS NULL OR pp.marital_status = v_marital_status)
        -- Exclude the profile that is doing the search
        AND pp.profile_id <> p_profile_id
    GROUP BY 
        pp.profile_id
    ORDER BY 
        pp.first_name, pp.last_name;
    
    -- Commit the transaction
    COMMIT;
    
    -- If no results found, return a message
    IF NOT FOUND_ROWS() THEN
        SELECT 'No matching profiles found' AS message;
    END IF;
END //

DELIMITER ;
