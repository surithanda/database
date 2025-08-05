CREATE TABLE state (
    state_id SERIAL PRIMARY KEY,
    country_id INTEGER NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    state_code VARCHAR(10),                  -- State abbreviation (e.g., CA for California)
    state_type VARCHAR(30),                  -- 'State', 'Province', 'Region', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE

);
