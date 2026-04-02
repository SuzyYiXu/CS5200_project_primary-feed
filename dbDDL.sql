-- PrimaryFeed DDL
-- Conventions: plural snake_case table names, surrogate PKs,
--              unique constraints preserving original business keys,
--              meaningful constraint names

CREATE DATABASE IF NOT EXISTS primaryfeed;
USE primaryfeed;

-- ─────────────────────────────────────────
-- ADDRESSES (pure lookup table, no ownership)
-- Uniqueness is intentionally not enforced at the DB level.
-- Address normalization (e.g. trimming whitespace, expanding abbreviations)
-- and deduplication logic is handled at the application layer,
-- where the app can standardize input and reuse existing address_id values
-- before inserting, providing a better experience than a raw constraint error.
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS addresses (
  address_id     INT          NOT NULL AUTO_INCREMENT,
  address_line_1 VARCHAR(100) NOT NULL,
  address_line_2 VARCHAR(45)  NULL,
  city           VARCHAR(45)  NOT NULL,
  state          VARCHAR(5)   NOT NULL,
  zip_code       VARCHAR(10)  NOT NULL,
  PRIMARY KEY (address_id)
);

-- ─────────────────────────────────────────
-- FOOD_BANKS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS food_banks (
  food_bank_id INT          NOT NULL AUTO_INCREMENT,
  name         VARCHAR(100) NOT NULL,
  email        VARCHAR(100) NOT NULL UNIQUE,
  phone        VARCHAR(20)  NOT NULL,
  address_id   INT          NULL,
  PRIMARY KEY (food_bank_id),
  CONSTRAINT fk_food_banks_address
    FOREIGN KEY (address_id)
    REFERENCES addresses (address_id)
);

-- ─────────────────────────────────────────
-- FOOD_BANK_BRANCHES
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS food_bank_branches (
  branch_id    INT         NOT NULL AUTO_INCREMENT,
  branch_num   INT         NOT NULL,
  branch_name  VARCHAR(45) NOT NULL,
  food_bank_id INT         NOT NULL,
  address_id   INT         NULL,
  PRIMARY KEY (branch_id),
  UNIQUE KEY uq_branch_num_per_food_bank (branch_num, food_bank_id),
  CONSTRAINT fk_branches_food_bank
    FOREIGN KEY (food_bank_id)
    REFERENCES food_banks (food_bank_id),
  CONSTRAINT fk_branches_address
    FOREIGN KEY (address_id)
    REFERENCES addresses (address_id)
);

-- ─────────────────────────────────────────
-- USERS
-- Roles: 0=Staff, 1=Volunteer (map to @Enumerated in Spring Boot)
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  user_id             INT          NOT NULL AUTO_INCREMENT,
  first_name          VARCHAR(100) NOT NULL,
  last_name           VARCHAR(50)  NOT NULL,
  email               VARCHAR(100) NOT NULL UNIQUE,
  phone               VARCHAR(20)  NOT NULL,
  password_hash       VARCHAR(255) NOT NULL,
  role                TINYINT      NOT NULL COMMENT '0=Staff,1=Volunteer',
  status              TINYINT      NOT NULL COMMENT '0=Inactive,1=Active',
  branch_id           INT          NOT NULL,
  address_id          INT          NULL,
  driving_license_num VARCHAR(45)  NULL,
  PRIMARY KEY (user_id),
  CONSTRAINT fk_users_branch
    FOREIGN KEY (branch_id)
    REFERENCES food_bank_branches (branch_id),
  CONSTRAINT fk_users_address
    FOREIGN KEY (address_id)
    REFERENCES addresses (address_id)
);

-- ─────────────────────────────────────────
-- VOLUNTEERS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS volunteers (
  volunteer_id     INT          NOT NULL AUTO_INCREMENT,
  user_id          INT          NOT NULL UNIQUE,
  availability     VARCHAR(255) NULL,
  background_check TINYINT      NULL COMMENT '0=Not cleared,1=Cleared',
  PRIMARY KEY (volunteer_id),
  CONSTRAINT fk_volunteers_user
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
);

-- ─────────────────────────────────────────
-- STAFF
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS staff (
  staff_id  INT         NOT NULL AUTO_INCREMENT,
  user_id   INT         NOT NULL UNIQUE,
  job_title VARCHAR(45) NULL,
  hire_date DATETIME    NULL,
  PRIMARY KEY (staff_id),
  CONSTRAINT fk_staff_user
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)
);

-- ─────────────────────────────────────────
-- ADMIN_PERMISSIONS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS admin_permissions (
  permission_id          INT          NOT NULL AUTO_INCREMENT,
  permission_type        TINYINT      NOT NULL COMMENT 'Enum value for permission type',
  permission_description VARCHAR(255) NULL,
  PRIMARY KEY (permission_id)
);

-- ─────────────────────────────────────────
-- STAFF_ADMIN_PERMISSIONS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS staff_admin_permissions (
  staff_permission_id INT NOT NULL AUTO_INCREMENT,
  staff_id            INT NOT NULL,
  permission_id       INT NOT NULL,
  PRIMARY KEY (staff_permission_id),
  UNIQUE KEY uq_staff_permission (staff_id, permission_id),
  CONSTRAINT fk_staff_permissions_staff
    FOREIGN KEY (staff_id)
    REFERENCES staff (staff_id),
  CONSTRAINT fk_staff_permissions_permission
    FOREIGN KEY (permission_id)
    REFERENCES admin_permissions (permission_id)
);

-- ─────────────────────────────────────────
-- FOOD_CATEGORIES
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS food_categories (
  category_id          INT          NOT NULL AUTO_INCREMENT,
  category_name        VARCHAR(100) NOT NULL,
  category_description VARCHAR(255) NULL,
  PRIMARY KEY (category_id)
);

-- ─────────────────────────────────────────
-- FOOD_ITEMS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS food_items (
  sku               VARCHAR(45)  NOT NULL,
  food_name         VARCHAR(100) NOT NULL,
  food_description  MEDIUMTEXT   NULL,
  storage_condition VARCHAR(100) NULL,
  category_id       INT          NOT NULL,
  PRIMARY KEY (sku),
  CONSTRAINT fk_food_items_category
    FOREIGN KEY (category_id)
    REFERENCES food_categories (category_id)
);

-- ─────────────────────────────────────────
-- INVENTORIES
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS inventories (
  inventory_id INT         NOT NULL AUTO_INCREMENT,
  food_sku     VARCHAR(45) NOT NULL,
  branch_id    INT         NOT NULL,
  quantity     INT         NOT NULL,
  unit         VARCHAR(45) NOT NULL,
  expiry_date  DATETIME    NOT NULL,
  PRIMARY KEY (inventory_id),
  CONSTRAINT fk_inventory_food_item
    FOREIGN KEY (food_sku)
    REFERENCES food_items (sku),
  CONSTRAINT fk_inventory_branch
    FOREIGN KEY (branch_id)
    REFERENCES food_bank_branches (branch_id)
);

-- ─────────────────────────────────────────
-- VOLUNTEER_SHIFTS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS volunteer_shifts (
  shift_id         INT        NOT NULL AUTO_INCREMENT,
  volunteer_id     INT        NOT NULL,
  branch_id        INT        NOT NULL,
  shift_date       DATE       NOT NULL,
  shift_time_start TIME       NOT NULL,
  shift_time_end   TIME       NOT NULL,
  shift_notes      MEDIUMTEXT NULL,
  PRIMARY KEY (shift_id),
  UNIQUE KEY uq_volunteer_shift_slot (volunteer_id, branch_id, shift_date, shift_time_start),
  CONSTRAINT fk_shifts_volunteer
    FOREIGN KEY (volunteer_id)
    REFERENCES volunteers (volunteer_id),
  CONSTRAINT fk_shifts_branch
    FOREIGN KEY (branch_id)
    REFERENCES food_bank_branches (branch_id)
);

-- ─────────────────────────────────────────
-- DONORS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS donors (
  donor_id   INT          NOT NULL AUTO_INCREMENT,
  donor_name VARCHAR(255) NOT NULL,
  donor_type TINYINT      NOT NULL COMMENT '0=Individual,1=Organization',
  email      VARCHAR(100) NULL UNIQUE,
  phone      VARCHAR(20)  NULL,
  address_id INT          NULL,
  PRIMARY KEY (donor_id),
  CONSTRAINT fk_donors_address
    FOREIGN KEY (address_id)
    REFERENCES addresses (address_id)
);

-- ─────────────────────────────────────────
-- BENEFICIARIES
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS beneficiaries (
  beneficiary_id        INT          NOT NULL AUTO_INCREMENT,
  beneficiary_full_name VARCHAR(255) NOT NULL,
  household_size        INT          NOT NULL,
  phone                 VARCHAR(20)  NOT NULL,
  email                 VARCHAR(100) NULL UNIQUE,
  eligibility_status    TINYINT      NOT NULL COMMENT '0=Ineligible,1=Eligible',
  address_id            INT          NULL,
  PRIMARY KEY (beneficiary_id),
  CONSTRAINT fk_beneficiaries_address
    FOREIGN KEY (address_id)
    REFERENCES addresses (address_id)
);

-- ─────────────────────────────────────────
-- DONATIONS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS donations (
  donation_id   INT      NOT NULL AUTO_INCREMENT,
  branch_id     INT      NOT NULL,
  donor_id      INT      NOT NULL,
  staff_id      INT      NOT NULL,
  donation_date DATETIME NOT NULL,
  PRIMARY KEY (donation_id),
  CONSTRAINT fk_donations_branch
    FOREIGN KEY (branch_id)
    REFERENCES food_bank_branches (branch_id),
  CONSTRAINT fk_donations_donor
    FOREIGN KEY (donor_id)
    REFERENCES donors (donor_id),
  CONSTRAINT fk_donations_staff
    FOREIGN KEY (staff_id)
    REFERENCES staff (staff_id)
);

-- ─────────────────────────────────────────
-- DONATION_ITEMS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS donation_items (
  donation_item_id INT NOT NULL AUTO_INCREMENT,
  donation_id      INT NOT NULL,
  quantity         INT NOT NULL,
  inventory_id     INT NULL,
  PRIMARY KEY (donation_item_id),
  UNIQUE KEY uq_donation_inventory (donation_id, inventory_id),
  CONSTRAINT fk_donation_items_donation
    FOREIGN KEY (donation_id)
    REFERENCES donations (donation_id),
  CONSTRAINT fk_donation_items_inventory
    FOREIGN KEY (inventory_id)
    REFERENCES inventories (inventory_id)
);

-- ─────────────────────────────────────────
-- DISTRIBUTIONS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS distributions (
  distribution_id   INT      NOT NULL AUTO_INCREMENT,
  branch_id         INT      NOT NULL,
  beneficiary_id    INT      NOT NULL,
  staff_id          INT      NOT NULL,
  distribution_date DATETIME NOT NULL,
  PRIMARY KEY (distribution_id),
  CONSTRAINT fk_distributions_branch
    FOREIGN KEY (branch_id)
    REFERENCES food_bank_branches (branch_id),
  CONSTRAINT fk_distributions_beneficiary
    FOREIGN KEY (beneficiary_id)
    REFERENCES beneficiaries (beneficiary_id),
  CONSTRAINT fk_distributions_staff
    FOREIGN KEY (staff_id)
    REFERENCES staff (staff_id)
);

-- ─────────────────────────────────────────
-- DISTRIBUTION_ITEMS
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS distribution_items (
  distribution_item_id INT NOT NULL AUTO_INCREMENT,
  distribution_id      INT NOT NULL,
  quantity             INT NOT NULL,
  inventory_id         INT NOT NULL,
  PRIMARY KEY (distribution_item_id),
  UNIQUE KEY uq_distribution_inventory (distribution_id, inventory_id),
  CONSTRAINT fk_distribution_items_distribution
    FOREIGN KEY (distribution_id)
    REFERENCES distributions (distribution_id),
  CONSTRAINT fk_distribution_items_inventory
    FOREIGN KEY (inventory_id)
    REFERENCES inventories (inventory_id)
);
