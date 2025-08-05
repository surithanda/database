-- Table structure for storing zip codes for different countries
CREATE TABLE zip_code (
    zip_code_id SERIAL PRIMARY KEY,
    country_id INTEGER NOT NULL,
    state_id INTEGER, -- Foreign key to the state table
    city VARCHAR(100),
    zip_code VARCHAR(20) NOT NULL, -- To accommodate various formats like ZIP+4
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);