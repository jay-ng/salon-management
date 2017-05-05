-- Delete an employee from employees table will remove all their info from other tables 
DROP TRIGGER IF EXISTS delete_emp_trig;
DELIMITER $$
CREATE TRIGGER delete_emp_trig BEFORE DELETE ON employees
 FOR EACH ROW BEGIN
DELETE FROM employeeAddress where employeeAddress.employee_id = OLD.employee_id;
DELETE FROM employeePhones WHERE
employeePhones.employee_id = OLD.employee_id;
DELETE FROM users WHERE 
users.employee_id = OLD.employee_id;
END $$
DELIMITER ;

-- Update periodPay after an insert or an update to service count.
DROP TRIGGER IF EXISTS update_period_pay_after_update;
DELIMITER $$
CREATE TRIGGER update_period_pay_after_update AFTER UPDATE ON serviceDone
 FOR EACH ROW BEGIN
UPDATE employees set periodPay = IFNULL((SELECT sum(serviceDone.count * services.price) FROM
serviceDone join services on serviceDone.service = services.name
where employees.employee_id = serviceDone.employee_id),0);
END $$
DELIMITER ;
-- Note: Since MySQL server didn't let me use AFTER INSERT OR UPDATE, I had to split it into two triggers.
DROP TRIGGER IF EXISTS update_period_pay_after_insert;
DELIMITER $$
CREATE TRIGGER update_period_pay_after_update AFTER INSERT ON serviceDone
 FOR EACH ROW BEGIN
UPDATE employees set periodPay = IFNULL((SELECT sum(serviceDone.count * services.price) FROM
serviceDone join services on serviceDone.service = services.name
where employees.employee_id = serviceDone.employee_id),0);
END $$
DELIMITER ;