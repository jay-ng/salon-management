DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `delete_an_emp`(IN `emp_id` INT(11))
    MODIFIES SQL DATA
BEGIN
DELETE FROM employees 
WHERE employees.employee_id = emp_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `insert_emp`(IN `id` INT(11), IN `name` VARCHAR(50), IN `dob` DATE, IN `ssn` CHAR(12), IN `address` VARCHAR(50), IN `phone` VARCHAR(50), IN `usern` VARCHAR(24), IN `pw` CHAR(64), IN `manager` TINYINT(1))
    MODIFIES SQL DATA
BEGIN
INSERT INTO employees(employees.employee_id, employees.name, employees.dob, employees.ssn) 
VALUES (id, name, dob, ssn);
INSERT INTO employeeAddress(employeeAddress.employee_id, employeeAddress.address)
VALUES (id, address);
INSERT INTO employeePhones
(employeePhones.employee_id, employeePhones.phoneNumber)
VALUES (id, phone);
INSERT INTO users(users.username, users.password, users.isManager, users.employee_id) 
VALUES (usern, pw, manager, id);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_an_employee`(IN `employee_id` INT(11))
BEGIN
SELECT * FROM employees
NATURAL JOIN employeeAddress
NATURAL JOIN employeePhones
WHERE employees.employee_id = employee_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_all_emp`()
BEGIN
SELECT * FROM employees NATURAL JOIN
employeeAddress NATURAL JOIN employeePhones;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_all_customers`()
BEGIN
SELECT * FROM customers;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_customers`(IN `id` INT(11))
BEGIN
SELECT * FROM customers
WHERE stylistID = id;
END$$
DELIMITER ;
