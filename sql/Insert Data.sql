DESCRIBE employees;
INSERT INTO employees VALUES (null, 'Jay Nguyen', '1992-01-18', '100-100-1000', null, null);
INSERT INTO employees VALUES (null, 'Man Vu', '1992-01-01', '101-101-1001', null, null);
INSERT INTO employees VALUES (null, 'John Doe', '1992-01-01', '102-102-1002', null, null);
INSERT INTO employees VALUES (null, 'Jane Doe', '1992-01-01', '103-103-1003', null, null);
-- TRUNCATE employees; -- Development, Delete All Rows + Reset Auto Increment

DESCRIBE users;
INSERT INTO users VALUES ('jayng','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',1,'1'); -- pw: 123456
INSERT INTO users VALUES ('manvu','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',1,'2'); -- pw: 123456
INSERT INTO users VALUES ('johnd','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',0,'3'); -- pw: 123456
INSERT INTO users VALUES ('janed','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',0,'4'); -- pw: 123456
-- TRUNCATE employees;

DESCRIBE customers;
INSERT INTO customers VALUES ('Customer A', '804-000-0001', 3);
INSERT INTO customers VALUES ('Customer B', '804-000-0002', 4);
INSERT INTO customers VALUES ('Customer C', '804-000-0003', 4);
INSERT INTO customers VALUES ('Customer D', '804-000-0001', 4);
-- TRUNCATE customers;

DESCRIBE employeePhones;
INSERT INTO employeePhones VALUES(1, '804-111-1111;804-111-2222;');
INSERT INTO employeePhones VALUES(2, '804-222-1111;804-222-2222;');
INSERT INTO employeePhones VALUES(3, '804-333-1111;804-333-2222;804-333-3333;');
INSERT INTO employeePhones VALUES(4, '804-444-1111;804-444-2222;804-444-3333;');
-- TRUNCATE employeePhones;

DESCRIBE employeeAddress;
INSERT INTO employeeAddress VALUES(1, '111 W Main St., Richmond VA');
INSERT INTO employeeAddress VALUES(2, '222 W Main St., Richmond VA');
INSERT INTO employeeAddress VALUES(3, '333 Cary St., Richmond VA');
INSERT INTO employeeAddress VALUES(4, '333 Cary St., Richmond VA');
-- TRUNCATE employeeAddress;

DESCRIBE services;
INSERT INTO services VALUES('Male Hair Cut',15,1);
INSERT INTO services VALUES('Female Hair Cut',25,2);
INSERT INTO services VALUES('Highlight',50,4);
INSERT INTO services VALUES('Single Color Dye',120,6);
INSERT INTO services VALUES('Shampoo + Blowdry',15,1);
-- TRUNCATE services;

DESCRIBE serviceDone;
INSERT INTO serviceDone VALUES(3,'Male Hair Cut',4);
INSERT INTO serviceDone VALUES(3,'Shampoo + Blowdry',4);
INSERT INTO serviceDone VALUES(4,'Female Hair Cut',8);
INSERT INTO serviceDone VALUES(4,'Highlight',2);
INSERT INTO serviceDone VALUES(4,'Single Color Dye',1);
-- TRUNCATE serviceDone;

DESCRIBE product;
INSERT INTO product VALUES(null, 'Shampoo A', 'Shampoo', 10, 15);
INSERT INTO product VALUES(null, 'Shampoo B', 'Shampoo', 20, 20);
INSERT INTO product VALUES(null, 'Dye A', 'Dye', 8, 30);
INSERT INTO product VALUES(null, 'Conditioner A', 'Conditioner', 20, 15);
-- TRUNCATE product;

DESCRIBE appointment;
INSERT INTO appointment VALUES(3, 0, 1, '2017-05-10', 'Male Hair Cut', 'Customer A');
INSERT INTO appointment VALUES(3, 3, 4, '2017-06-05', 'Male Hair Cut', 'Customer A');
INSERT INTO appointment VALUES(4, 0, 2, '2017-05-10', 'Female Hair Cut', 'Customer B');
INSERT INTO appointment VALUES(4, 3, 9, '2017-05-10', 'Single Color Dye', 'Customer D');
INSERT INTO appointment VALUES(4, 9, 13, '2017-05-10', 'Highlight', 'Customer C');
-- TRUNCATE appointment;

DESCRIBE orders;
INSERT INTO orders VALUES(null, '2017-04-30', 'Customer A', '804-000-0001', 3, 1, 1);
INSERT INTO orders VALUES(null, '2017-05-01', 'Customer B', '804-000-0002', 4, 2, 1);
INSERT INTO orders VALUES(null, '2017-05-02', 'Customer C', '804-000-0001', 4, 2, 1);
INSERT INTO orders VALUES(null, '2017-04-01', 'Customer D', '804-000-0001', 4, 2, 1);
-- TRUNCATE orders;