-- Deleting an employee
DROP PROCEDURE IF EXISTS delete_an_emp;
DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `delete_an_emp`(IN `emp_id` INT(11))
    MODIFIES SQL DATA
BEGIN
DELETE FROM employees 
WHERE employees.employee_id = emp_id;
END$$
DELIMITER ;

-- Inserting an employee
DROP PROCEDURE IF EXISTS insert_emp;
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

-- View an employee
DROP PROCEDURE IF EXISTS view_an_employee;
DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_an_employee`(IN `employee_id` INT(11))
BEGIN
SELECT * FROM employees
NATURAL JOIN employeeAddress
NATURAL JOIN employeePhones
WHERE employees.employee_id = employee_id;
END$$
DELIMITER ;

-- View all employees
DROP PROCEDURE IF EXISTS view_all_emp;
DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_all_emp`()
BEGIN
SELECT * FROM employees NATURAL JOIN
employeeAddress NATURAL JOIN employeePhones;
END$$
DELIMITER ;

-- View all customers
DROP PROCEDURE IF EXISTS view_all_customers;
DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_all_customers`()
BEGIN
SELECT * FROM customers;
END$$
DELIMITER ;

-- View customers served by an employee
DROP PROCEDURE IF EXISTS view_customers;
DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_customers`(IN `id` INT(11))
BEGIN
SELECT * FROM customers
WHERE stylistID = id;
END$$
DELIMITER ;

-- View all appointments
DROP PROCEDURE IF EXISTS view_all_appointments;
DELIMITER $$
CREATE PROCEDURE view_all_appointments()
BEGIN
	SELECT date as 'Date', name as 'Employee', startTime as 'Start Time', endTime as 'End Time', service as 'Service', customer_name as 'Customer'
    FROM appointment NATURAL JOIN (SELECT employee_id, name FROM employees) as getEmpName
    ORDER BY date;
END $$
DELIMITER ;

-- View today appointments
DROP PROCEDURE IF EXISTS view_today_appointments;
DELIMITER $$
CREATE PROCEDURE view_today_appointments()
BEGIN
	SELECT date as 'Date', name as 'Employee', startTime as 'Start Time', endTime as 'End Time', service as 'Service', customer_name as 'Customer'
    FROM appointment NATURAL JOIN (SELECT employee_id, name FROM employees) as getEmpName
    WHERE date = date_format(sysdate(), '%Y-%m-%d')
    ORDER BY date;
END $$
DELIMITER ;

CALL view_all_emp;
CALL view_all_appointments;
CALL view_today_appointments;