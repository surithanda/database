
DELIMITER //
CREATE PROCEDURE `lkp_get_LookupData`(IN m_category VARCHAR(100))
BEGIN
	
    IF (m_category IS NOT  NULL)  THEN
		SELECT id, name, description, category
		FROM lookup_table
		WHERE category = m_category AND isactive = 1;
	ELSE
		SELECT id, name, description, category
		FROM lookup_table
		WHERE isactive = 1;    
    END IF;
END //
DELIMITER ;