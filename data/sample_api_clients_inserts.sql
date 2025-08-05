-- Sample Data for admin_api_clients_create

-- Assuming partner_id 1 to 10 exist and are active from 'sample_partner_inserts.sql'

-- Statement 1
CALL admin_api_clients_create(1, 'techsolutions.com', 'admin.techsolutions.com', 'Initial activation for Tech Solutions Inc.', 1);

-- Statement 2
CALL admin_api_clients_create(2, 'greengardens.com', 'admin.greengardens.com', 'Initial activation for Green Gardens.', 1);

-- Statement 3
CALL admin_api_clients_create(3, 'innovatelabs.com', 'admin.innovatelabs.com', 'Initial activation for Innovate Labs.', 1);

-- Statement 4
CALL admin_api_clients_create(4, 'healthfirst.com', 'admin.healthfirst.com', 'Initial activation for HealthFirst Clinic.', 1);

-- Statement 5
CALL admin_api_clients_create(5, 'buildright.com', 'admin.buildright.com', 'Initial activation for BuildRight Construction.', 1);

-- Statement 6
CALL admin_api_clients_create(6, 'foodiefinds.com', 'admin.foodiefinds.com', 'Initial activation for Foodie Finds.', 1);

-- Statement 7
CALL admin_api_clients_create(7, 'autocare.com', 'admin.autocare.com', 'Initial activation for AutoCare Experts.', 1);

-- Statement 8
CALL admin_api_clients_create(8, 'legaleagles.com', 'admin.legaleagles.com', 'Initial activation for Legal Eagles.', 1);

-- Statement 9
CALL admin_api_clients_create(9, 'creativeminds.com', 'admin.creativeminds.com', 'Initial activation for Creative Minds Agency.', 1);

-- Statement 10
CALL admin_api_clients_create(10, 'globallogistics.com', 'admin.globallogistics.com', 'Initial activation for Global Logistics.', 1);
