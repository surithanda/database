DELIMITER //
CREATE PROCEDURE lkp_get_Country_States(IN countryName varchar(100))
BEGIN
	SELECT * FROM state
    WHERE country_id = (SELECT country_id FROM country WHERE country_name = countryName);
END //
DELIMITER ;