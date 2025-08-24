CREATE TABLE IF NOT EXISTS stripe_products (
    id VARCHAR(255) PRIMARY KEY COMMENT 'Stripe product ID (e.g., prod_XXX)',
    name VARCHAR(255) NOT NULL COMMENT 'Product name',
    description TEXT COMMENT 'Product description',
    active BOOLEAN DEFAULT TRUE COMMENT 'Whether the product is active',
    images JSON COMMENT 'URLs of product images',
    url VARCHAR(2048) COMMENT 'URL where the product can be viewed',
    metadata JSON COMMENT 'Additional product metadata',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Record creation timestamp',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record update timestamp',
    deleted_at TIMESTAMP NULL COMMENT 'Soft delete timestamp',
    INDEX idx_name (name),
    INDEX idx_active (active),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stripe products data';
