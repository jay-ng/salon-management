DELIMITER $$

CREATE OR REPLACE TRIGGER `delete_emp_trig` BEFORE DELETE ON `employees`
 FOR EACH ROW BEGIN
DELETE FROM employeeAddress where employeeAddress.employee_id = OLD.employee_id;
DELETE FROM employeePhones WHERE
employeePhones.employee_id = OLD.employee_id;
DELETE FROM users WHERE 
users.employee_id = OLD.employee_id;
END$$
DELIMITER ;