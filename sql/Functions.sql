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

SELECT f_loginCheck('jayng','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');