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
-- Create triggers and procedures
-- ────────────────────
SELECT 'Create triggers...' as message;
source dbTRIGGERS.sql;
SELECT 'Create procedures...' as message;
source dbPROC.sql

-- ───────────────────────────────────────
-- Seed sample data
-- ───────────────────────────────────────
SELECT 'Seed tables with sample data...' as message;
source dbDML.sql;

-- ───────────────────────────────────────
-- Sample SQL queries
-- ───────────────────
SELECT 'Running sample queries...' as message;
source dbSQL.sql;


-- ───────────────────────────────────────
-- Sample procedure calls
-- ───────────────────────────────────────
SELECT 'Test calling procedures...' as message;
source dbEXAMPLES.sql;
