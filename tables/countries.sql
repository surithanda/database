DROP TABLE country ;
CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    official_name VARCHAR(150),
    country_code_2 CHAR(2) UNIQUE NOT NULL,  -- ISO 3166-1 alpha-2
    country_code_3 CHAR(3) UNIQUE,           -- ISO 3166-1 alpha-3
    country_number CHAR(3),                  -- ISO 3166-1 numeric
    country_calling_code VARCHAR(5),          -- Can include + and up to 4 digits
    region VARCHAR(50),
    latitude DECIMAL(8,5),
    longitude DECIMAL(8,5),
    flag_emoji VARCHAR(10),
    flag_image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_country_name ON country(country_name);
CREATE INDEX idx_country_code2 ON country(country_code_2);
CREATE INDEX idx_country_code3 ON country(country_code_3);
