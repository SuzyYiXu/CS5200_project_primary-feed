-- ───────────────────────────────────────
-- Drop all tables and database if exists
-- ───────────────────────────────────────
SELECT '(Clean up all tables and database if any.)' as message;
source dbDROP.sql;

-- ───────────────────────────────────────
-- Create database and tables
-- ───────────────────────────────────────
SELECT 'Create database PrimaryFeed and tables...' as message;
source dbDDL.sql;

-- ───────────────────────────────────────
-- Seed sample data
-- ───────────────────────────────────────
SELECT 'Seed tables with sample data...' as message;
source dbDML.sql;

SELECT 'addresses' AS table_name; SELECT * FROM addresses;
SELECT 'food_banks' AS table_name; SELECT * FROM food_banks;
SELECT 'food_bank_branches' AS table_name; SELECT * FROM food_bank_branches;
SELECT 'users' AS table_name; SELECT * FROM users;
SELECT 'volunteers' AS table_name; SELECT * FROM volunteers;
SELECT 'staff' AS table_name; SELECT * FROM staff;
SELECT 'admin_permissions' AS table_name; SELECT * FROM admin_permissions;
SELECT 'staff_admin_permissions' AS table_name; SELECT * FROM staff_admin_permissions;
SELECT 'food_categories' AS table_name; SELECT * FROM food_categories;
SELECT 'food_items' AS table_name; SELECT * FROM food_items;
SELECT 'volunteer_shifts' AS table_name; SELECT * FROM volunteer_shifts;
SELECT 'donors' AS table_name; SELECT * FROM donors;
SELECT 'donations' AS table_name; SELECT * FROM donations;
SELECT 'donation_items' AS table_name; SELECT * FROM donation_items;
SELECT 'inventories' AS table_name; SELECT * FROM inventories;
SELECT 'beneficiaries' AS table_name; SELECT * FROM beneficiaries;
SELECT 'distributions' AS table_name; SELECT * FROM distributions;
SELECT 'distribution_items' AS table_name; SELECT * FROM distribution_items;
SELECT 'trigger_logs' AS table_name; SELECT * FROM trigger_logs;

-- ─────────────────────────────────────────
-- TEST OUT VIEWS
-- ─────────────────────────────────────────
SELECT 'Testing out views...' as message;

SELECT 'Inventory items expiring within next 6 months' as description;
SELECT * from vw_expiring_inventory;
SELECT 'Hours worked by volunteers' as description;
SELECT * from vw_volunteer_hours_log;

-- ───────────────────────────────────────
-- Sample SQL queries
-- ───────────────────
SELECT 'Running sample queries...' as message;
source dbSQL.sql;


-- ───────────────────────────────────────
-- Sample procedure calls
-- ───────────────────────────────────────
SELECT 'Test calling procedures...' as message;
source dbPROCSCALL.sql;
