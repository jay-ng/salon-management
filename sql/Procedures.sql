-- Application Level Setup Procedures
DROP PROCEDURE IF EXISTS get_employees;
DELIMITER $$
CREATE PROCEDURE get_employees()
	READS SQL DATA
BEGIN
	SELECT employees.name as 'Employee Name'
    FROM employees;
END $$
DELIMiTER ;

DROP PROCEDURE IF EXISTS get_customers;
DELIMITER $$
CREATE PROCEDURE get_customers()
	READS SQL DATA
BEGIN
	SELECT name as 'Customer Name'
    FROM customers;
END $$
DELIMiTER ;

DROP PROCEDURE IF EXISTS get_product;
DELIMITER $$
CREATE PROCEDURE get_product()
	READS SQL DATA
BEGIN
	SELECT name as 'Product Name'
    FROM product;
END $$
DELIMiTER ;

DROP PROCEDURE IF EXISTS get_services;
DELIMITER $$
CREATE PROCEDURE get_services()
	READS SQL DATA
BEGIN
	SELECT name as 'Service Name'
    FROM services;
END $$
DELIMiTER ;

-- Deleting an employee
DROP PROCEDURE IF EXISTS delete_an_emp;
DELIMITER $$
CREATE PROCEDURE delete_an_emp(IN emp_id INT)
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
CREATE PROCEDURE insert_emp(IN name VARCHAR(50), IN dob DATE, IN ssn CHAR(12), IN address VARCHAR(50), IN phone VARCHAR(50), IN usern VARCHAR(24), IN pw CHAR(64), IN manager TINYINT(1))
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
CREATE PROCEDURE view_an_employee(IN employee_id INT)
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
CREATE PROCEDURE view_all_emp()
BEGIN
SELECT * FROM employees NATURAL JOIN
employeeAddress NATURAL JOIN employeePhones;
END$$
DELIMITER ;

-- View all customers
DROP PROCEDURE IF EXISTS view_all_customers;
DELIMITER $$
CREATE PROCEDURE view_all_customers()
BEGIN
SELECT * FROM customers;
END$$
DELIMITER ;

-- View customers served by an employee
DROP PROCEDURE IF EXISTS view_customers;
DELIMITER $$
CREATE PROCEDURE view_customers(IN id INT(11))
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
	SELECT date as 'Date', appointment.employee_id as 'Employee ID', name as 'Employee', startTime as 'Start Time', endTime as 'End Time', service as 'Service', customer_name as 'Customer'
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
CREATE PROCEDURE view_emp_appointments(IN employee_id INT)
	READS SQL DATA
BEGIN
	SELECT * FROM appointment WHERE appointment.employee_id = employee_id;
END $$
DELIMITER ;

-- View an employee appointment on date
DROP PROCEDURE IF EXISTS view_emp_appointments_date;
DELIMITER $$
CREATE PROCEDURE view_emp_appointments_date(IN employee_id INT, IN date DATE)
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
	INSERT INTO appointment VALUES (employee_id, startTime, endTime, date, service, customer_name);
END $$
DELIMITER ;

-- Delete an appointment
DROP PROCEDURE IF EXISTS del_emp_appointment;
DELIMITER $$
CREATE procedure del_emp_appointment(IN employee_id INT, IN startTime TIME, IN date DATE)
	MODIFIES SQL DATA
BEGIN
	DELETE FROM appointment WHERE appointment.employee_id = employee_id AND appointment.startTime = startTime AND appointment.date = date;
END $$
DELIMITER ;

-- Update an appointment
DROP PROCEDURE IF EXISTS update_emp_appointment;
DELIMITER $$
CREATE PROCEDURE update_emp_appointment(IN old_empid INT, IN old_startTime TIME, IN old_date DATE, IN employee_id INT, IN startTime TIME, IN date DATE, IN serviceName VARCHAR(50), IN customerName VARCHAR(50))
	MODIFIES SQL DATA
BEGIN
	DECLARE endTime TIME;
    SET endTime = (SELECT f_getEndTime(startTime, serviceName));
	UPDATE appointment
    SET appointment.employee_id = employee_id, appointment.startTime = startTime, appointment.endTime = endTime, appointment.date = date, appointment.service = serviceName, appointment.customer_name = customerName
    WHERE appointment.employee_id = old_empid AND appointment.startTime = old_startTime AND appointment.date = old_date;
END $$
DELIMITER ;

-- End period, update yearToDatePay and reset all counts
DROP PROCEDURE IF EXISTS end_period;
DELIMITER $$
CREATE PROCEDURE end_period()
    MODIFIES SQL DATA
BEGIN
UPDATE employees SET yearToDatePay = IFNULL(yearToDatePay,0) + IFNULL(periodPay,0);
UPDATE serviceDone SET serviceDone.count = 0;
END$$
DELIMITER ;

# Testing Procedures
CALL get_employees();
CALL get_customers();
CALL get_product();
CALL get_services();
CALL view_all_emp;
CALL view_all_appointments;
CALL view_today_appointments;
CALL view_emp_appointments(1,'2017-05-03');
CALL insert_emp('Huy Nguyen', '19920118', '555-55-5555', '312 Broad St.', '123-123-1234', 'huyng', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',1);
CALL delete_an_emp(5);
CALL update_emp_appointment(3,'09:00','2017-05-10',3,'16:00','2017-05-04','Male Hair Cut','Customer A');