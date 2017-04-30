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

-- Testing Functions
SELECT f_loginCheck('jayng','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
SELECT f_getEID('janed','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');
SELECT f_getEmployeeType('jayng','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');