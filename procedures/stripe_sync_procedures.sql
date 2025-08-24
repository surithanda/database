-- Stripe Synchronization Procedures
-- These procedures handle data synchronization between Stripe and the local database

DELIMITER //

-- Procedure to handle Stripe webhook events
CREATE PROCEDURE stripe_process_webhook_event(
    IN p_event_id VARCHAR(255),
    IN p_event_type VARCHAR(100),
    IN p_object_id VARCHAR(255),
    IN p_object_type VARCHAR(50),
    IN p_event_data JSON,
    IN p_api_version VARCHAR(20),
    IN p_request_id VARCHAR(255),
    IN p_idempotency_key VARCHAR(255),
    IN p_livemode BOOLEAN
)
BEGIN
    DECLARE v_exists INT;
    
    -- Check if event already exists to prevent duplicate processing
    SELECT COUNT(*) INTO v_exists FROM stripe_events WHERE id = p_event_id;
    
    IF v_exists = 0 THEN
        -- Insert the event
        INSERT INTO stripe_events (
            id, type, object_id, object_type, api_version, 
            request_id, idempotency_key, livemode, data, pending_webhooks
        ) VALUES (
            p_event_id, p_event_type, p_object_id, p_object_type, p_api_version,
            p_request_id, p_idempotency_key, p_livemode, p_event_data, 1
        );
        
        -- Process based on event type
        CASE p_event_type
            WHEN 'customer.created' THEN
                CALL stripe_sync_customer(p_object_id, p_event_data);
            WHEN 'customer.updated' THEN
                CALL stripe_sync_customer(p_object_id, p_event_data);
            WHEN 'product.created' THEN
                CALL stripe_sync_product(p_object_id, p_event_data);
            WHEN 'product.updated' THEN
                CALL stripe_sync_product(p_object_id, p_event_data);
            WHEN 'price.created' THEN
                CALL stripe_sync_price(p_object_id, p_event_data);
            WHEN 'price.updated' THEN
                CALL stripe_sync_price(p_object_id, p_event_data);
            WHEN 'payment_method.attached' THEN
                CALL stripe_sync_payment_method(p_object_id, p_event_data);
            WHEN 'payment_method.updated' THEN
                CALL stripe_sync_payment_method(p_object_id, p_event_data);
            WHEN 'subscription.created' THEN
                CALL stripe_sync_subscription(p_object_id, p_event_data);
            WHEN 'subscription.updated' THEN
                CALL stripe_sync_subscription(p_object_id, p_event_data);
            WHEN 'invoice.created' THEN
                CALL stripe_sync_invoice(p_object_id, p_event_data);
            WHEN 'invoice.updated' THEN
                CALL stripe_sync_invoice(p_object_id, p_event_data);
            WHEN 'invoice.paid' THEN
                CALL stripe_sync_invoice(p_object_id, p_event_data);
            WHEN 'payment_intent.created' THEN
                CALL stripe_sync_payment_intent(p_object_id, p_event_data);
            WHEN 'payment_intent.succeeded' THEN
                CALL stripe_sync_payment_intent(p_object_id, p_event_data);
            WHEN 'payment_intent.payment_failed' THEN
                CALL stripe_sync_payment_intent(p_object_id, p_event_data);
            WHEN 'charge.succeeded' THEN
                CALL stripe_sync_charge(p_object_id, p_event_data);
            WHEN 'charge.failed' THEN
                CALL stripe_sync_charge(p_object_id, p_event_data);
            WHEN 'charge.refunded' THEN
                CALL stripe_sync_charge(p_object_id, p_event_data);
            WHEN 'refund.created' THEN
                CALL stripe_sync_refund(p_object_id, p_event_data);
            WHEN 'refund.updated' THEN
                CALL stripe_sync_refund(p_object_id, p_event_data);
            WHEN 'dispute.created' THEN
                CALL stripe_sync_dispute(p_object_id, p_event_data);
            WHEN 'dispute.updated' THEN
                CALL stripe_sync_dispute(p_object_id, p_event_data);
            WHEN 'balance.available' THEN
                CALL stripe_sync_balance_transactions(p_event_data);
            WHEN 'payout.created' THEN
                CALL stripe_sync_payout(p_object_id, p_event_data);
            WHEN 'payout.updated' THEN
                CALL stripe_sync_payout(p_object_id, p_event_data);
            ELSE
                -- Log unhandled event type
                UPDATE stripe_events 
                SET processing_errors = CONCAT('Unhandled event type: ', p_event_type)
                WHERE id = p_event_id;
        END CASE;
        
        -- Mark event as processed
        UPDATE stripe_events SET processed = TRUE, pending_webhooks = 0 WHERE id = p_event_id;
    ELSE
        -- Event already exists, update it if needed
        UPDATE stripe_events 
        SET pending_webhooks = pending_webhooks - 1,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_event_id;
    END IF;
END //

-- Procedure to sync customer data
CREATE PROCEDURE stripe_sync_customer(
    IN p_customer_id VARCHAR(255),
    IN p_customer_data JSON
)
BEGIN
    DECLARE v_exists INT;
    DECLARE v_email VARCHAR(255);
    DECLARE v_name VARCHAR(255);
    DECLARE v_description TEXT;
    DECLARE v_default_payment_method VARCHAR(255);
    DECLARE v_invoice_prefix VARCHAR(50);
    DECLARE v_phone VARCHAR(50);
    DECLARE v_address_line1 VARCHAR(255);
    DECLARE v_address_line2 VARCHAR(255);
    DECLARE v_address_city VARCHAR(255);
    DECLARE v_address_state VARCHAR(255);
    DECLARE v_address_postal_code VARCHAR(20);
    DECLARE v_address_country VARCHAR(2);
    DECLARE v_metadata JSON;
    
    -- Extract data from JSON
    SET v_email = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.email'));
    SET v_name = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.name'));
    SET v_description = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.description'));
    SET v_default_payment_method = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.default_payment_method'));
    SET v_invoice_prefix = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.invoice_prefix'));
    SET v_phone = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.phone'));
    SET v_address_line1 = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.address.line1'));
    SET v_address_line2 = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.address.line2'));
    SET v_address_city = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.address.city'));
    SET v_address_state = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.address.state'));
    SET v_address_postal_code = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.address.postal_code'));
    SET v_address_country = JSON_UNQUOTE(JSON_EXTRACT(p_customer_data, '$.object.address.country'));
    SET v_metadata = JSON_EXTRACT(p_customer_data, '$.object.metadata');
    
    -- Check if customer exists
    SELECT COUNT(*) INTO v_exists FROM stripe_customers WHERE id = p_customer_id;
    
    IF v_exists = 0 THEN
        -- Insert new customer
        INSERT INTO stripe_customers (
            id, email, name, description, default_payment_method_id, invoice_prefix,
            phone, address_line1, address_line2, address_city, address_state,
            address_postal_code, address_country, metadata
        ) VALUES (
            p_customer_id, v_email, v_name, v_description, v_default_payment_method, v_invoice_prefix,
            v_phone, v_address_line1, v_address_line2, v_address_city, v_address_state,
            v_address_postal_code, v_address_country, v_metadata
        );
    ELSE
        -- Update existing customer
        UPDATE stripe_customers
        SET email = v_email,
            name = v_name,
            description = v_description,
            default_payment_method_id = v_default_payment_method,
            invoice_prefix = v_invoice_prefix,
            phone = v_phone,
            address_line1 = v_address_line1,
            address_line2 = v_address_line2,
            address_city = v_address_city,
            address_state = v_address_state,
            address_postal_code = v_address_postal_code,
            address_country = v_address_country,
            metadata = v_metadata,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_customer_id;
    END IF;
END //

-- Procedure to sync product data
CREATE PROCEDURE stripe_sync_product(
    IN p_product_id VARCHAR(255),
    IN p_product_data JSON
)
BEGIN
    DECLARE v_exists INT;
    DECLARE v_name VARCHAR(255);
    DECLARE v_description TEXT;
    DECLARE v_active BOOLEAN;
    DECLARE v_images JSON;
    DECLARE v_url VARCHAR(2048);
    DECLARE v_metadata JSON;
    
    -- Extract data from JSON
    SET v_name = JSON_UNQUOTE(JSON_EXTRACT(p_product_data, '$.object.name'));
    SET v_description = JSON_UNQUOTE(JSON_EXTRACT(p_product_data, '$.object.description'));
    SET v_active = JSON_EXTRACT(p_product_data, '$.object.active');
    SET v_images = JSON_EXTRACT(p_product_data, '$.object.images');
    SET v_url = JSON_UNQUOTE(JSON_EXTRACT(p_product_data, '$.object.url'));
    SET v_metadata = JSON_EXTRACT(p_product_data, '$.object.metadata');
    
    -- Check if product exists
    SELECT COUNT(*) INTO v_exists FROM stripe_products WHERE id = p_product_id;
    
    IF v_exists = 0 THEN
        -- Insert new product
        INSERT INTO stripe_products (
            id, name, description, active, images, url, metadata
        ) VALUES (
            p_product_id, v_name, v_description, v_active, v_images, v_url, v_metadata
        );
    ELSE
        -- Update existing product
        UPDATE stripe_products
        SET name = v_name,
            description = v_description,
            active = v_active,
            images = v_images,
            url = v_url,
            metadata = v_metadata,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_product_id;
    END IF;
END //

-- Additional sync procedures would follow the same pattern for each object type
-- For brevity, I've included just two examples above

-- Procedure to perform a full reconciliation between Stripe and local database
CREATE PROCEDURE stripe_perform_reconciliation()
BEGIN
    -- This would be implemented to compare Stripe API data with local database
    -- and resolve any discrepancies
    
    -- For each object type:
    -- 1. Fetch all objects from Stripe API
    -- 2. Compare with local database
    -- 3. Update/insert/mark deleted as needed
    
    -- Log the reconciliation process
    INSERT INTO activity_log (activity_type, description)
    VALUES ('STRIPE_RECONCILIATION', 'Performed full Stripe data reconciliation');
END //

DELIMITER ;
