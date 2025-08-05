DELIMITER //

CREATE PROCEDURE `generate_sample_account_inserts`(IN p_record_count INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE generated_sql TEXT DEFAULT '';

    -- Temporary tables to hold sample data
    DROP TEMPORARY TABLE IF EXISTS first_names;
    CREATE TEMPORARY TABLE first_names (name VARCHAR(50));
    INSERT INTO first_names (name) VALUES
    ('John'), ('Jane'), ('Peter'), ('Mary'), ('David'), ('Susan'), ('Michael'), ('Laura'), ('Chris'), ('Patricia'),
    ('Robert'), ('Linda'), ('James'), ('Barbara'), ('William'), ('Elizabeth'), ('Richard'), ('Jennifer'), ('Charles'), ('Jessica');

    DROP TEMPORARY TABLE IF EXISTS last_names;
    CREATE TEMPORARY TABLE last_names (name VARCHAR(50));
    INSERT INTO last_names (name) VALUES
    ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Jones'), ('Garcia'), ('Miller'), ('Davis'), ('Rodriguez'), ('Martinez'),
    ('Hernandez'), ('Lopez'), ('Gonzalez'), ('Wilson'), ('Anderson'), ('Thomas'), ('Taylor'), ('Moore'), ('Jackson'), ('White');

    SET generated_sql = '-- Generated Sample Data for eb_account_login_create\n\n';

    WHILE i <= p_record_count DO
        SET @first_name = (SELECT name FROM first_names ORDER BY RAND() LIMIT 1);
        SET @last_name = (SELECT name FROM last_names ORDER BY RAND() LIMIT 1);
        SET @email = CONCAT(LOWER(@first_name), '.', LOWER(@last_name), i, '@example.com');
        SET @password = 'password123';
        SET @middle_name = CHAR(65 + FLOOR(RAND() * 26)); -- Random initial
        SET @birth_date = DATE_SUB('2004-01-01', INTERVAL FLOOR(RAND() * 20 * 365) DAY);
        SET @gender_id = IF(RAND() > 0.5, 9, 10); -- 9: Male, 10: Female
        SET @primary_phone = LPAD(FLOOR(RAND() * 10000000000), 10, '0');
        SET @primary_phone_type_id = IF(RAND() > 0.3, 6, 8); -- 6: Mobile, 8: Home
        SET @country_id = 1; -- USA
        SET @state_id = (SELECT id FROM state WHERE country_id = @country_id ORDER BY RAND() LIMIT 1);

        SET generated_sql = CONCAT(generated_sql, 'CALL eb_account_login_create(\n');
        SET generated_sql = CONCAT(generated_sql, '    ''', @email, ''', ''', @password, ''', ''', @first_name, ''', ''', @middle_name, ''', ''', @last_name, ''', ''', @birth_date, ''', ', @gender_id, ', \n');
        SET generated_sql = CONCAT(generated_sql, '    ''', @primary_phone, ''', ''+1'', ', @primary_phone_type_id, ', NULL, NULL, NULL, \n');
        SET generated_sql = CONCAT(generated_sql, '    ''', FLOOR(100 + RAND() * 900), ' Sample St'', NULL, ''Sample City'', ', @state_id, ', ''', LPAD(FLOOR(RAND() * 100000), 5, '0'), ''', ', @country_id, ', \n');
        SET generated_sql = CONCAT(generated_sql, '    ''photo', i, '.jpg'', ''What is your favorite color?'', ''Blue''\n');
        SET generated_sql = CONCAT(generated_sql, ');\n\n');

        SET i = i + 1;
    END WHILE;

    SELECT generated_sql;

    DROP TEMPORARY TABLE first_names;
    DROP TEMPORARY TABLE last_names;

END //

DELIMITER ;
