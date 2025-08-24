DELIMITER //

CREATE PROCEDURE `eb_profile_search_get` (
    IN p_profile_id INT,
    -- Optional override parameters
    IN p_min_age INT,
    IN p_max_age INT,
    IN p_religion INT,
    IN p_max_education INT,
    IN p_occupation INT,
    IN p_country INT,
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
    DECLARE v_country INT;
    DECLARE v_casete_id INT;
    DECLARE v_marital_status INT;
    
    -- Get search preferences from the profile_search_prefernce table
    SELECT 
        min_age, max_age, religion, max_education, occupation, country, casete_id, marital_status
    INTO 
        v_min_age, v_max_age, v_religion, v_max_education, v_occupation, v_country, v_casete_id, v_marital_status
    FROM 
        profile_search_preference
    WHERE 
        profile_id = p_profile_id
    LIMIT 1;
    
    -- Use input parameters if provided, otherwise use preferences from the table
    SET v_min_age = IFNULL(p_min_age, v_min_age);
    SET v_max_age = IFNULL(p_max_age, v_max_age);
    SET v_religion = IFNULL(p_religion, v_religion);
    SET v_max_education = IFNULL(p_max_education, v_max_education);
    SET v_occupation = IFNULL(p_occupation, v_occupation);
    SET v_country = IFNULL(p_country, v_country);
    SET v_casete_id = IFNULL(p_casete_id, v_casete_id);
    SET v_marital_status = IFNULL(p_marital_status, v_marital_status);

    -- Main query to search profiles based on preferences
    SELECT 
		pp.profile_id,
        pp.first_name,
        pp.last_name,
        lt.name AS gender,
        TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) AS age,
        pp.marital_status,
        pa.country_name,
        profile_photo.url,
        pp.religion
    FROM 
        profile_personal pp
	LEFT JOIN 
		(SELECT profile_photo.* FROM profile_photo INNER JOIN lookup_table on photo_type = id where name ='Clear Headshot') AS profile_photo  ON pp.profile_id = profile_photo.profile_id	
    LEFT JOIN 
        lookup_table lt ON lt.category = 'Gender' AND lt.id = pp.gender
    LEFT JOIN 
        (select pa.*, country_name from profile_address pa LEFT JOIN country c ON c.country_id = pa.country_id) pa ON pa.profile_id = pp.profile_id
    /*
    LEFT JOIN 
        profile_education pe ON pe.profile_id = pp.profile_id
    LEFT JOIN 
        profile_employment pem ON pem.profile_id = pp.profile_id */
    WHERE 
        pp.is_active = 1
        -- Apply age filter if specified
        AND (v_min_age IS NULL OR TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) >= v_min_age)
		AND (v_max_age IS NULL OR TIMESTAMPDIFF(YEAR, pp.birth_date, CURDATE()) <= v_max_age)
        -- Apply marital status filter if specified
        AND (v_marital_status IS NULL OR pp.marital_status = v_marital_status)         

        -- Apply religion filter if specified
        AND (v_religion IS NULL OR pp.religion = v_religion)
        /*
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
        )) */
        -- Apply caste filter if specified
        -- AND (v_casete_id IS NULL OR pp.caste = v_casete_id)
        -- Apply country filter if specified
        AND (v_country IS NULL OR EXISTS (
            SELECT 1 FROM profile_address pa2 
            WHERE pa2.profile_id = pp.profile_id 
            AND pa2.country_id = v_country
        ))

        -- Exclude the profile that is doing the search
        AND pp.profile_id <> p_profile_id
    GROUP BY 
        pp.profile_id
    ORDER BY 
        pp.first_name, pp.last_name;
END 
//
DELIMITER ;
