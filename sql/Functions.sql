# f_loginCheck
# Inputs: username, password
# Output: Bool
# Check if a username and password exist in users table
DROP FUNCTION IF EXISTS f_loginCheck;
DELIMITER //
CREATE FUNCTION f_loginCheck (username VARCHAR(24), password CHAR(64)) RETURNS Bool
BEGIN
	DECLARE matched Bool;
    SET matched = false;
    SET matched = EXISTS(	SELECT * FROM users 
                            WHERE users.username = username AND users.password = password);
	RETURN matched;
END //
DELIMITER ;

# f_loginCheck
# Inputs: username, password
# Output: eid decimal(6,0)
DROP FUNCTION IF EXISTS f_getEID;
DELIMITER //
CREATE FUNCTION f_getEID (username VARCHAR(24), password CHAR(64)) RETURNS decimal(6,0)
BEGIN
	declare eid INT;
	set eid = (select employee_id from users
    where users.username = username and
    users.password = password);
    return eid;
END //
DELIMITER ;

# f_loginCheck
# Inputs: username, password
# Output: isManager bool
DROP FUNCTION IF EXISTS f_getEmployeeType;
DELIMITER //
CREATE FUNCTION f_getEmployeeType (username VARCHAR(24), password CHAR(64)) RETURNS bool
BEGIN
	DECLARE type Bool;
    SET type = (select isManager from users
                where users.username = username
                and users.password = password);
    RETURN type;
END //
DELIMITER ;

# f_appointmentCheck
# Input: employee_id, date, startTime
# Output: disallow bool
DROP FUNCTION IF EXISTS f_appointmentCheck;
DELIMITER //
CREATE FUNCTION f_appointmentCheck(employee_id INT, date DATE, startTime TIME) RETURNS bool
BEGIN
	DECLARE disallow Bool;
    SET disallow = EXISTS(
		SELECT * 
		FROM appointment
        WHERE appointment.employee_id = employee_id
			AND appointment.date = date
            AND startTime between appointment.startTime AND appointment.endTime);
	RETURN disallow;
END //
DELIMITER ;

# f_getEndTime
# Input: startTime, serviceName
# Output: endTime
DROP FUNCTION IF EXISTS f_getEndTime;
DELIMITER //
CREATE FUNCTION f_getEndTime(startTime TIME, serviceName VARCHAR(50)) RETURNS TIME
BEGIN
	DECLARE endTime TIME;
    DECLARE timeRequired TIME;
    SET timeRequired = (SELECT time FROM services WHERE name = servicename);
    SET endTime = addtime(startTime,timeRequired);
    RETURN endTime;
END //
DELIMITER ;

# f_deleteAptCheck
# Input: employee_id, startTime, date
# Output: Bool
DROP FUNCTION IF EXISTS f_deleteAptCheck;
DELIMITER //
CREATE FUNCTION f_deleteAptCheck(employee_id INT, startTime TIME, date DATE) RETURNS Bool
BEGIN
	DECLARE exist Bool DEFAULT false;
    SET exist = (SELECT * FROM appointment WHERE appointment.employee_id = employee_id AND appointment.startTime = startTime AND appointment.date = date);
END //
DELIMITER ;

# f_getToday
# Input:
# Output: date
DROP FUNCTION IF EXISTS f_getToday;
DELIMITER //
CREATE FUNCTION f_getToday() RETURNS DATE
BEGIN
	RETURN DATE_FORMAT(sysdate(),'%Y-%m-%d');
END //
DELIMITER ;

-- Testing Functions
SELECT f_loginCheck('jayng','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
SELECT f_getEID('janed','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
SELECT f_getEmployeeType('jayng','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
SELECT f_appointmentCheck(1,'2017-05-04','09:00');
SELECT f_getEndTime('09:30','Highlight');