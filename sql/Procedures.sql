-- Deleting an employee
DROP PROCEDURE IF EXISTS delete_an_emp;
DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `delete_an_emp`(IN `emp_id` INT(11))
    MODIFIES SQL DATA
BEGIN
DELETE FROM employees
WHERE employees.employee_id = emp_id;
DELETE FROM employeeAddress
WHERE employeeAddress.employee_id = emp_id;
DELETE FROM employeePhones
WHERE employeePhones.employee_id = emp_id;
DELETE FROM users
WHERE users.employee_id = emp_id;
END$$
DELIMITER ;

-- Inserting an employee
DROP PROCEDURE IF EXISTS insert_emp;
DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `insert_emp`(IN `name` VARCHAR(50), IN `dob` DATE, IN `ssn` CHAR(12), IN `address` VARCHAR(50), IN `phone` VARCHAR(50), IN `usern` VARCHAR(24), IN `pw` CHAR(64), IN `manager` TINYINT(1))
    MODIFIES SQL DATA
BEGIN
INSERT INTO employees(employees.employee_id, employees.name, employees.dob, employees.ssn) 
VALUES (null, name, dob, ssn);
INSERT INTO employeeAddress(employeeAddress.employee_id, employeeAddress.address)
VALUES (last_insert_id(), address);
INSERT INTO employeePhones
(employeePhones.employee_id, employeePhones.phoneNumber)
VALUES (last_insert_id(), phone);
INSERT INTO users(users.username, users.password, users.isManager, users.employee_id) 
VALUES (usern, pw, manager, last_insert_id());
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

-- View an employee appointment
DROP PROCEDURE IF EXISTS view_emp_appointments;
DELIMITER $$
CREATE PROCEDURE view_emp_appointments(IN employee_id INT, IN date DATE)
	READS SQL DATA
BEGIN
	SELECT * FROM appointment WHERE appointment.employee_id = employee_id AND appointment.date = date;
END $$
DELIMITER ;

-- Add an appointment
DROP PROCEDURE IF EXISTS add_emp_appointment;
DELIMITER $$
CREATE PROCEDURE add_emp_appointment(IN employee_id INT, IN startTime TIME, IN endTime TIME, IN date DATE, IN service VARCHAR(50), IN customer_name VARCHAR(50))
	MODIFIES SQL DATA
BEGIN
	INSERT INTO appointment VALUES (employee_id, starTime, endTime, date, service, customer_name);
END $$
DELIMITER ;


CALL view_all_emp;
CALL view_all_appointments;
CALL view_today_appointments;
CALL view_emp_appointments(1,'2017-05-03');
CALL insert_emp('Huy Nguyen', '19920118', '555-55-5555', '312 Broad St.', '123-123-1234', 'huyng', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',1);
CALL delete_an_emp(5);