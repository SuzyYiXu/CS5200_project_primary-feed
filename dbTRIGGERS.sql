-- PrimaryFeed Triggers
-- Enforce subtype integrity: a user's role must match
-- the subtype table they are inserted into.
-- role: 0=Staff, 1=Volunteer
-- NOTE: MySQL does not support CREATE TRIGGER IF NOT EXISTS.
--       DROP TRIGGER IF EXISTS is used before each definition
--       to safely recreate triggers without errors on re-runs.

USE primaryfeed;

DELIMITER $$

-- ─────────────────────────────────────────
-- TRIGGER 1: validate role before inserting into staff
-- Only users with role=0 may have a row in the staff table
-- ─────────────────────────────────────────
DROP TRIGGER IF EXISTS trg_staff_check_role$$

CREATE TRIGGER trg_staff_check_role
BEFORE INSERT ON staff
FOR EACH ROW
BEGIN
  DECLARE user_role INT;
  SELECT role INTO user_role FROM users WHERE user_id = NEW.user_id;

  IF user_role IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot insert into staff: user does not exist.';
  END IF;

  IF user_role != 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot insert into staff: user role is not Staff (0).';
  END IF;
END$$

-- ─────────────────────────────────────────
-- TRIGGER 2: validate role before inserting into volunteers
-- Only users with role=1 may have a row in the volunteers table
-- ─────────────────────────────────────────
DROP TRIGGER IF EXISTS trg_volunteers_check_role$$

CREATE TRIGGER trg_volunteers_check_role
BEFORE INSERT ON volunteers
FOR EACH ROW
BEGIN
  DECLARE user_role INT;
  SELECT role INTO user_role FROM users WHERE user_id = NEW.user_id;

  IF user_role IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot insert into volunteers: user does not exist.';
  END IF;

  IF user_role != 1 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot insert into volunteers: user role is not Volunteer (1).';
  END IF;
END$$

-- ─────────────────────────────────────────
-- TRIGGER 3: prevent role from being changed on users
--            if it would orphan or conflict with subtype rows
-- ─────────────────────────────────────────
DROP TRIGGER IF EXISTS trg_users_prevent_role_change$$

CREATE TRIGGER trg_users_prevent_role_change
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
  IF NEW.role != OLD.role THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Cannot change user role directly. Delete the subtype row first, then update the role.';
  END IF;
END$$

DELIMITER ;
