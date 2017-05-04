DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `add_new_count`(IN `id` INT(11), IN `service` VARCHAR(50), IN `count` DECIMAL(5,0))
    MODIFIES SQL DATA
BEGIN
INSERT INTO serviceDone
VALUES (id, service, count);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `update_count_emp_ver`(IN `id` INT(11), IN `service` VARCHAR(50))
    MODIFIES SQL DATA
BEGIN
UPDATE serviceDone
SET serviceDone.count = serviceDone.count + 1
WHERE serviceDone.employee_id = id
AND trim(serviceDone.service) = trim(service);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `edit_count`(IN `id` INT(11), IN `service` VARCHAR(50), IN `new_count` DECIMAL(5,0))
    MODIFIES SQL DATA
BEGIN
UPDATE serviceDone
SET serviceDone.count = new_count
WHERE serviceDone.employee_id = id 
	AND trim(serviceDone.service) = trim(service);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `add_service`(IN `name` VARCHAR(50), IN `price` DECIMAL(5,0), IN `time` TIME)
    MODIFIES SQL DATA
BEGIN
INSERT INTO services 
VALUES (name,price,time);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `edit_a_service`(IN `name` VARCHAR(50), IN `new_price` DECIMAL(5,0), IN `new_time` TIME)
    MODIFIES SQL DATA
BEGIN
UPDATE services
SET services.price = new_price,
	services.time = new_time
WHERE trim(services.name) = trim(name);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_all_services`()
    READS SQL DATA
BEGIN
SELECT *
FROM services;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `delete_a_service`(IN `name` VARCHAR(50))
    MODIFIES SQL DATA
BEGIN
DELETE FROM services
WHERE trim(services.name) = trim(name);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_all_employees_service_counts`()
    READS SQL DATA
BEGIN
SELECT employees.employee_id, employees.name,
	serviceDone.service, serviceDone.count
FROM employees NATURAL JOIN serviceDone;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`cmsc508`@`localhost` PROCEDURE `view_personal_count`(IN `id` INT(11))
    READS SQL DATA
BEGIN
SELECT employees.employee_id, employees.name,
	serviceDone.service, serviceDone.count
FROM employees NATURAL JOIN serviceDone
WHERE employees.employee_id = id;
END$$
DELIMITER ;
